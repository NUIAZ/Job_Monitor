-- =============================================
-- Author:		RTG
-- Create date: 7/2020
-- Description:	Selects PreReq jobs and lists data
-- =============================================
CREATE PROCEDURE [job].[SELECT_PreReqJobs_cte]
AS
BEGIN

with jobDetails as (select Job_id, JobName,ServerName, AlertFactor, IsBlacklisted, Description, DaysOfHistoryToRetain, Enabled, Tier from [job].[Details] where tier =999 )

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
                when SuccessPct >= jd.AlertFactor and LastOutcome = 0 then 'Orange' -- Worsening / Investigate
                when SuccessPct < jd.AlertFactor and LastOutcome = 0 then 'Red' -- Failed / Take Immediate Action
                when SuccessPct < jd.AlertFactor and LastOutcome = 1 then 'Yellow' -- Improving / No action required
				when Enabled = 0 then 'Grey'
                end as [StatusColor]

from jobDetails jd 
left outer join summarized s on jd.Job_id = s.Job_id

END