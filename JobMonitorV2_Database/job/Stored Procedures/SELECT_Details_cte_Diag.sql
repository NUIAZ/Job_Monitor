-- =============================================
-- Author:		RTG
-- Create date: 10/2/2019
-- Description:	gather data and create a result set of job details data for display
-- =============================================
Create PROCEDURE [job].[SELECT_Details_cte_Diag] 
	@job_id uniqueidentifier
AS
BEGIN

--Run Count
with RunCount as (
select h.job_id, count(1) as NbrOfRuns
from [job].[HistoricalData] h
WHERE msdb.dbo.agent_datetime(h.run_date, h.run_time) >= dateadd(hour, -24, getdate())
  and h.run_status in (0,1)
  and h.step_id = 0 
group by h.job_id)

--Successful Run Count
, SuccessfulRuns as (
select h.job_id, count(1) as SuccessfulRuns
from [job].[HistoricalData] h
where h.step_id = 0
  and run_status = 1
  and msdb.dbo.agent_datetime(h.run_date, h.run_time) >= dateadd(hour, -24, getdate())
group by h.job_id)

--Job Name
,JobName as (select distinct job_id, JobName, ServerName, AlertFactor, [Description], DaysOfHistoryToRetain, [Enabled], [IsBlacklisted], [Tier] from [job].[Details] d )

-- get past the jobs that didnt run but yet need 
, AddItems as (
select (case when r.NbrOfRuns IS NULL then 0 else r.NbrOfRuns end) as NbrOfRuns , d.Job_id, d.JobName, d.ServerName, d.AlertFactor, d.[Description],d.DaysOfHistoryToRetain, d.[Enabled], d.[IsBlacklisted], d.Tier
from RunCount r
full outer join JobName d on d.Job_id = r.Job_id
)

-- Status of steps for last run
, LastRunStepStatus as (
select h.job_id
, count(1) as LRCount
, sum(case when run_status <> 0 then 0 else 1 end) as SummaryRunStatus
from [job].[HistoricalData] h
where msdb.dbo.agent_datetime(h.run_date, h.run_time) >= (select max(start_execution_date)
from [job].[Activity] where [job].[Activity].job_id = h.job_id)
  and h.step_id <> 0
  and h.run_status <> 2  -- exclude Retry
  and h.run_status <> 3  -- exclude cancel
  and h.run_status <> 4  -- exclude ck pri step
group by h.job_id)

-- Success Pct
, SuccessPct as (
select r.job_id
, r.NbrOfRuns
, s.SuccessfulRuns
, case when r.NbrOfRuns > 0 then
    (round(convert(real, s.SuccessfulRuns) / convert(real, r.NbrOfRuns),2) * 100)
                else 100 end as [Success Pct]
from RunCount r
join SuccessfulRuns s on s.job_id = r.job_id
)

, fixItems as (
select r.NbrOfRuns, r.Job_id, (case when sp.[Success Pct] IS NULL then 0 else sp.[Success Pct] end) as [Success Pct], (case when lrs.SummaryRunStatus IS NULL then 0 else lrs.SummaryRunStatus end) as SummaryRunStatus 
,r.ServerName, r.JobName, r.AlertFactor, r.[Description],r.DaysOfHistoryToRetain, r.[Enabled], r.[IsBlacklisted],r.Tier
,(case when sp.SuccessfulRuns IS NULL then 0 else sp.SuccessfulRuns end) as SuccessfulRuns
from AddItems r
full outer join SuccessPct sp on sp.Job_id = r.Job_id
full outer join LastRunStepStatus lrs on lrs.Job_id = r.Job_id
)

--Do the math and output
select r.job_id as [Job_id]
, r.[JobName] as [JobName] 
,r.IsBlacklisted as [IsBlacklisted]
,r.[Description] as [Description]
, r.NbrOfRuns as [NumberOfTimesRun]
, r.SuccessfulRuns as [NumberOfSuccessfulRuns]
, r.[Success Pct] as [PercentageOfRuns]
,r.ServerName as [ServerName]
,r.AlertFactor as [AlertFactor]
,r.DaysOfHistoryToRetain as [DaysOfHistoryToRetain]
,r.[Enabled] as [Enabled]
,r.[IsBlacklisted] as [IsBlacklisted]
,r.SummaryRunStatus
, case when r.Enabled = 0 then 'Grey' 
	when r.NbrOfRuns = 0 and r.SuccessfulRuns = 0 then 'Green'
	when r.[Success Pct] >= r.AlertFactor then
    case when r.SummaryRunStatus = 0 then 'Green' else 'Yellow' end
  else
    case when r.SummaryRunStatus = 0 then 'Orange' else 'Red' end
  end as [StatusColor]
, r.SummaryRunStatus as [JobStatus]
, r.Tier
from FixItems r
where r.job_id = @job_id

END