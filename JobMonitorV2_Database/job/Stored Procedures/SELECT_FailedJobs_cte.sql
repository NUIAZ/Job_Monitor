-- =============================================
-- Author:		RTG
-- Create date: 7/2020
-- Description:	Selects failed jobs and lists data
-- =============================================
CREATE PROCEDURE [job].[SELECT_FailedJobs_cte]
AS
BEGIN



----Run Count
--with RunCount as (
--select h.job_id, count(1) as NbrOfRuns
--from [job].[HistoricalData] h
--WHERE msdb.dbo.agent_datetime(h.run_date, h.run_time) >= dateadd(hour, -24, getdate())
--  and h.run_status in (0,1)
--  and h.step_id = 0  
--group by h.job_id)

----Successful Run Count
--, SuccessfulRuns as (
--select h.job_id, count(1) as SuccessfulRuns
--from [job].[HistoricalData] h
--where h.step_id = 0
--  and run_status = 1
--  and msdb.dbo.agent_datetime(h.run_date, h.run_time) >= dateadd(hour, -24, getdate())
--group by h.job_id)

---- get past the jobs that didnt run but yet need 
--, AddItems as (
--select (case when r.NbrOfRuns IS NULL then 0 else r.NbrOfRuns end) as NbrOfRuns ,
--d.Job_id,d.Tier, d.JobName,d.Description, d.ServerName, d.Enabled, d.IsBlacklisted, d.AlertFactor, d.DaysOfHistoryToRetain
--from RunCount r
--full outer join [job].[Details] d on d.Job_id = r.Job_id
--)

--, AddMoreItems as (
--select a.Job_id, a.NbrOfRuns, dc.DataCenterName, a.ServerName, a.AlertFactor, a.Enabled, a.JobName, +
--a.Tier, a.IsBlacklisted, a.DaysOfHistoryToRetain, a.Description
--from AddItems a
--full outer join [hub].[ServerDetails] dc on dc.ServerName = a.ServerName
--)

---- Status of steps for last run
--, LastRunStepStatus as (
--select h.job_id
--, sum(case when run_status <> 0 then 0 else 1 end) as SummaryRunStatus
--from [job].[HistoricalData] h
--where msdb.dbo.agent_datetime(h.run_date, h.run_time) >= (select max(start_execution_date)
--from [job].[Activity] where [job].[Activity].job_id = h.job_id)
--  and h.step_id <> 0
--  and h.run_status <> 2  -- exclude Retry
--  and h.run_status <> 3  -- exclude cancel on non primary nodes
--  and h.run_status <> 4  -- exclude cancel on non primary nodes
--  group by h.job_id)

---- Success Pct
--, SuccessPct as (
--select r.job_id
--, r.NbrOfRuns
--, s.SuccessfulRuns
--, case when r.NbrOfRuns > 0 then
--  (round(convert(real, s.SuccessfulRuns) / convert(real, r.NbrOfRuns),2)* 100)
--                else 100 end as [Success Pct]
--from RunCount r
--join SuccessfulRuns s on s.job_id = r.job_id
--)

--, fixItems as (
--select r.NbrOfRuns, r.Job_id, (case when sp.[Success Pct] IS NULL then 0 else sp.[Success Pct] end) as [Success Pct], (case when lrs.SummaryRunStatus IS NULL then 0 else lrs.SummaryRunStatus end) as SummaryRunStatus 
--,r.ServerName, r.AlertFactor, r.DataCenterName, r.Enabled, r.JobName, r.Tier, r.IsBlacklisted, r.DaysOfHistoryToRetain, r.Description
--,(case when sp.SuccessfulRuns IS NULL then 0 else sp.SuccessfulRuns end) as SuccessfulRuns
--from AddMoreItems r
--full outer join SuccessPct sp on sp.Job_id = r.Job_id
--full outer join LastRunStepStatus lrs on lrs.Job_id = r.Job_id
--)

--, ResultsOutput as (
--select r.Job_id, r.ServerName as [Servername], r.[Success Pct] as 'PercentageOfRuns',r.JobName, r.Tier, r.AlertFactor, 
--r.Enabled, r.NbrOfRuns as 'NumberOfTimesRun', r.IsBlacklisted, r.DaysOfHistoryToRetain, r.Description
--,case when r.Enabled = 0 then 'Grey' 
--	when r.NbrOfRuns = 0 and r.SuccessfulRuns = 0 then 'Green'
--	when r.[Success Pct] >= r.AlertFactor then
--    case when r.SummaryRunStatus = 0 then 'Green' else 'Yellow' end
--  else
--    case when r.SummaryRunStatus = 0 then 'Orange' else 'Red' end
--  end as [StatusColor]
--, r.SummaryRunStatus as 'JobStatus'
--,r.SuccessfulRuns as 'NumberOfSuccessfulRuns'
--from fixItems r
--)

--select * from ResultsOutput
--where StatusColor ='Red'
--order by Servername



with jobDetails as (select Job_id, JobName,ServerName, AlertFactor, IsBlacklisted, Description, DaysOfHistoryToRetain, Enabled, Tier from [job].[Details]  )

,outcomes as (select Job_id, Run_status, Row_Number() over (partition by Job_id order by msdb.dbo.agent_datetime(hd.Run_date, hd.Run_time)) as RowNbr
                from job.HistoricalData hd
)
, lastOutcome as (select Job_id, case Run_status when 0 then 0 else 1 end Run_Status
                from outcomes
                where RowNbr = 1)

, summarized as (select hd.Job_id,  count(hd.Run_status) as RunCount, jd.JobName, jd.ServerName,
				sum(case hd.Run_Status when 0 then 0 else 1 end) as SuccessCount, convert(int,(sum(convert(real,case hd.Run_Status when 0 then 0 else 1 end)) / count(hd.Run_status) * 100)) as SuccessPct
                , coalesce(lo.Run_status, 1) as LastOutcome

                from job.HistoricalData hd
                left outer join [job].[Details] jd on 
                                jd.Job_id = hd.Job_id
                left outer join lastOutcome lo on
                                lo.Job_id = hd.Job_id
                where hd.Step_name = '(Job outcome)'
                                and msdb.dbo.agent_datetime(hd.Run_date, hd.Run_time) >= dateadd(hour, -24, getdate())
                group by hd.Job_id, lo.Run_status, jd.JobName, jd.ServerName, lo.Run_status)

	 
select jd.Job_id as [Job_id]
, jd.JobName as [JobName]
, jd.IsBlacklisted as [IsBlacklisted]
, jd.Description as [Description]
, (case when s.RunCount IS NULL then 0 ELSE RunCount END) as [NumberOfTimesRun]
, (case when s.SuccessCount IS NULL then 0 ELSE SuccessCount END) as [NumberOfSuccessfulRuns]
, (case when s.SuccessPct IS NULL then 0 ELSE  SuccessPct END) as [PercentageOfRuns]
, jd.ServerName as [ServerName]
, jd.AlertFactor as [AlertFactor]
, jd.DaysOfHistoryToRetain as [DaysOfHistoryToRetain]
, jd.Enabled as [Enabled]
, (case when s.LastOutcome IS NULL then 0 ELSE s.LastOutcome END) as [StepStatus]
, jd.tier as [Tier]
, case when s.RunCount IS NULL then 'Green' -- never ran, or history was purged - ok!
				when SuccessPct >= jd.AlertFactor and LastOutcome = 1 then 'Green' -- All good

				--added for tier 5 jobs that run once per day
				when SuccessPct = 0 and LastOutcome = 1 then 'Red' -- if it wasnt successful but ran ok last time for tier 5 apps

                when SuccessPct >= jd.AlertFactor and LastOutcome = 0 then 'Orange' -- Worsening / Investigate
                when SuccessPct < jd.AlertFactor and LastOutcome = 0 then 'Red' -- Failed / Take Immediate Action
                when SuccessPct < jd.AlertFactor and LastOutcome = 1 then 'Yellow' -- Improving / No action required
				when Enabled = 0 then 'Grey'
                end as [StatusColor]

from jobDetails jd 
left outer join summarized s on jd.Job_id = s.Job_id
where (case when s.RunCount IS NULL then 'Green' -- never ran, or history was purged - ok!
				when SuccessPct >= jd.AlertFactor and LastOutcome = 1 then 'Green' -- All good

				--added for tier 5 jobs that run once per day
				when SuccessPct = 0 and LastOutcome = 1 then 'Red' -- if it wasnt successful but ran ok last time for tier 5 apps

                when SuccessPct >= jd.AlertFactor and LastOutcome = 0 then 'Orange' -- Worsening / Investigate
                when SuccessPct < jd.AlertFactor and LastOutcome = 0 then 'Red' -- Failed / Take Immediate Action
                when SuccessPct < jd.AlertFactor and LastOutcome = 1 then 'Yellow' -- Improving / No action required
                end ) != 'Green'
order by ServerName

END