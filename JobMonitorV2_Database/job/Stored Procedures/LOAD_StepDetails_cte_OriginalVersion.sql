-- =============================================
-- Author:		RTG
-- Create date: 09/23/2019
-- Description:	gather data and create a result set of job step details data for display
-- =============================================
Create PROCEDURE [job].[LOAD_StepDetails_cte_OriginalVersion] 
	@Job_id uniqueidentifier
AS
--
-- Job step details for display in JobMonitorV2 application - contain basic data and 
-- Calculated data. 
-- ********************************************************************************

BEGIN

--Run Count
With RunCount as (
select h.Step_name, count(1) as NbrOfRuns
from [job].[HistoricalData] h
WHERE msdb.dbo.agent_datetime(h.run_date, h.run_time) >= dateadd(hour, -24, getdate())
  and h.Step_id <> 0  -- Exclude 'Outcome' step
  and h.Job_id = @Job_id
group by h.Step_name)

--Successful Run Count
, SuccessfulRuns as (
select sr.Step_name, count(1) as SuccessfulRuns
from [job].[HistoricalData] sr
where sr.Step_id <> 0
  and sr.Run_status = 1
  and msdb.dbo.agent_datetime(sr.run_date, sr.run_time) >= dateadd(hour, -24, getdate())
  and Job_id = @Job_id
group by sr.Step_name)

-- Success Pct
, SuccessPct as (
select r.Step_name
, r.NbrOfRuns
, sr.SuccessfulRuns
, case when r.NbrOfRuns > 0 then
    (round(convert(real, sr.SuccessfulRuns) / convert(real, r.NbrOfRuns), 2) *100)
                else 100 end as [Success Pct]
from RunCount r
join SuccessfulRuns sr on sr.Step_name = r.Step_name
)

, LastRunStepStatus as (
select h.Step_name
, count(*) as stepCount
, sum(case when h.run_status <> 0 then 0 else 1 end) as SummaryRunStatus
--, sum(h.run_status) as SummaryRunStatus
from [job].[HistoricalData] h
where msdb.dbo.agent_datetime(h.run_date, h.run_time) >= (select max(start_execution_date)
from [job].[Activity] where [job].[Activity].job_id = h.job_id)
  and h.step_id <> 0
  and h.run_status = 1
  and h.Job_id = @Job_id
group by h.Step_name)

,addItems as (SELECT distinct servername, StepID, Step_uid, StepName FROM [job].[StepDetails] where Job_id = @Job_id) 

, fixItems as (
select r.NbrOfRuns, r.Step_name, (case when sp.[Success Pct] IS NULL then 0 else sp.[Success Pct] end) as [Success Pct], 
(case when lrs.SummaryRunStatus IS NULL then 0 else lrs.SummaryRunStatus end) as SummaryRunStatus
,(case when sp.SuccessfulRuns IS NULL then 0 else sp.SuccessfulRuns end) as SuccessfulRuns
from RunCount r
full outer join SuccessPct sp on sp.Step_name = r.Step_name
left outer join LastRunStepStatus lrs on lrs.Step_name = r.Step_name 
)

insert into [stg].[StepDetailsCompiledData]
 ([Job_id]
  ,[StepName]
 ,[ServerName]
 ,[StepID]
 ,[Step_uid]
 ,[NumberOfTimesRun]
 ,[NumberOfSuccessfulRuns]
 ,[SuccessPct]
 ,[StatusColor]
 ,[StepStatus]
 )

select 
@Job_id
,case when r.Step_name is null then '(Job outcome)' else r.Step_name  end
,ai.ServerName
,ai.StepID
,ai.Step_uid
,r.NbrOfRuns
,r.SuccessfulRuns
,r.[Success Pct]
,case when r.[Success Pct] >= (select AlertFactor from job.Details where Job_id = @Job_id) then
    case when r.SummaryRunStatus = 0 then 'Green' else 'Yellow' end
  else
    case when r.SummaryRunStatus = 0 then 'Orange' else 'Red' end
  end
, r.SummaryRunStatus
from fixItems r
inner join addItems ai on ai.StepName = r.Step_name

END