-- =============================================
-- Author:		RTG
-- Create date: 09/23/2019
-- Description:	gather data and create a result set of job step details data for display
-- =============================================
CREATE PROCEDURE [job].[SELECT_StepDetails_cte] 
	@Job_id uniqueidentifier
AS
BEGIN
with jobDetails as (select ServerName, job_id, AlertFactor from [job].[Details] where job_id = @Job_id )

,stepDetailsData as (select job_id, StepID, Step_uid,StepName  from [job].[StepDetails] where job_id = @Job_id )

,outcomes as (select Job_id, Run_status, Row_Number() over (partition by Job_id order by msdb.dbo.agent_datetime(hd.Run_date, hd.Run_time)) as RowNbr
                from job.HistoricalData hd
				where Job_id = @Job_id
)
, lastOutcome as (select Job_id, case Run_status when 0 then 0 else 1 end Run_Status
                from outcomes
                where RowNbr = 1)

, summarized as (select hd.Job_id,  count(hd.Run_status) as RunCount, 
				sum(case hd.Run_Status when 0 then 0 else 1 end) as SuccessCount, convert(int,(sum(convert(real,case hd.Run_Status when 0 then 0 else 1 end)) / count(hd.Run_status) * 100)) as SuccessPct
                , coalesce(lo.Run_status, 1) as LastOutcome
                from job.HistoricalData hd
                left outer join lastOutcome lo on
                                lo.Job_id = hd.Job_id
                where hd.Step_name = '(Job outcome)'
                                and msdb.dbo.agent_datetime(hd.Run_date, hd.Run_time) >= dateadd(hour, -24, getdate())
                                and hd.Job_id = @Job_id
                group by hd.Job_id, lo.Run_status)

select jd.Job_id as [Job_id]
, (case when s.RunCount IS NULL then 0 ELSE RunCount END) as [NumberOfTimesRun]
, (case when s.SuccessCount IS NULL then 0 ELSE SuccessCount END) as [NumberOfSuccessfulRuns]
, (case when s.SuccessPct IS NULL then 0 ELSE  SuccessPct END) as [PercentageOfRuns]
, jd.ServerName as [ServerName]
,d.StepID
,d.StepName
,d.Step_uid
, (case when s.LastOutcome IS NULL then 0 ELSE s.LastOutcome END) as [StepStatus]
, case when s.RunCount IS NULL then 'Green' -- never ran, or history was purged - ok!
				when SuccessPct >= jd.AlertFactor and LastOutcome = 1 then 'Green' -- All good
                when SuccessPct >= jd.AlertFactor and LastOutcome = 0 then 'Orange' -- Worsening / Investigate
                when SuccessPct < jd.AlertFactor and LastOutcome = 0 then 'Red' -- Failed / Take Immediate Action
                when SuccessPct < jd.AlertFactor and LastOutcome = 1 then 'Yellow' -- Improving / No action required
                end as [StatusColor]
from jobDetails jd
left outer join stepDetailsData d on jd.Job_id = d.Job_id
left outer join summarized s on jd.Job_id = s.Job_id
order by ServerName, StepID 

END