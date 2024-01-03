-- =============================================
-- Author:		Ryan Gross
-- Create date: 10/4/2019
-- Description:	Create a display for servers in job monitors
-- =============================================
CREATE PROCEDURE [job].[SELECT_ServerDisplay_cte_diag]
AS
	
BEGIN


with outcomes as (
                select Job_id, Run_status
                , Row_Number() over (partition by Job_id 
                                order by msdb.dbo.agent_datetime(hd.Run_date, hd.Run_time))
                                as RowNbr
                from job.HistoricalData hd
                --order by Job_id, RowNbr
                --where Job_id = @jobID
)
, lastOutcome as (
                select Job_id
                , case Run_status              
                                when 0 then 0
                                else 1 end Run_Status
                from outcomes
                where RowNbr = 1)
, summarized as (
                select hd.Job_id
                , jd.JobName
                , jd.ServerName
				
                , count(hd.Run_status) as RunCount
                , sum(case hd.Run_Status
                                when 0 then 0
                                else 1 end) as SuccessCount
                , convert(int,(sum(convert(real,case hd.Run_Status
                                when 0 then 0
                                else 1 end))
                                / count(hd.Run_status) * 100)) as SuccessPct
                , jd.AlertFactor
                , coalesce(lo.Run_status, 1) as LastOutcome

                from job.HistoricalData hd
                left outer join [job].[DetailsCompiledData] jd on 
                                jd.Job_id = hd.Job_id
                left outer join lastOutcome lo on
                                lo.Job_id = hd.Job_id
                where hd.Step_name = '(Job outcome)'
                                and msdb.dbo.agent_datetime(hd.Run_date, hd.Run_time) >= dateadd(year, -1, getdate())
                                --and hd.Job_id = @jobID
                group by hd.Job_id, jd.JobName, jd.ServerName
                                , jd.AlertFactor, lo.Run_status)


, jobDetails as (
select Job_id 
	  ,Enabled
	  ,Description
	  ,DaysOfHistoryToRetain
	  ,Tier
	  ,IsBlacklisted
from [job].[DetailsCompiledData] d
)

, ResultsOutput as (select summarized.Job_id as [Job_id]
, summarized.JobName as [JobName]
, d.IsBlacklisted as [IsBlacklisted]
, d.Description as [Description]
, RunCount as [NumberOfTimesRun]
, SuccessCount as [NumberOfSuccessfulRuns]
, SuccessPct as [PercentageOfRuns]
, summarized.ServerName as [ServerName]
, summarized.AlertFactor as [AlertFactor]
, d.DaysOfHistoryToRetain as [DaysOfHistoryToRetain]
, d.Enabled as [Enabled]
--, LastOutcome
, case when SuccessPct >= summarized.AlertFactor and LastOutcome = 1 then 'Green' -- All good
                when SuccessPct >= summarized.AlertFactor and LastOutcome = 0 then 'Orange' -- Worsening / Investigate
                when SuccessPct < summarized.AlertFactor and LastOutcome = 0 then 'Red' -- Failed / Take Immediate Action
                when SuccessPct < summarized.AlertFactor and LastOutcome = 1 then 'Yellow' -- Improving / No action required
                end as [StatusColor]
from summarized 
 join [job].[DetailsCompiledData] d on summarized.Job_id = d.Job_id
)


--debug to see all jobs
select * from ResultsOutput order by Servername

--count how many are not green 
--,GreenCount as (
--select r.ServerName, count(r.[StatusColor])  as GreenCount 
--from ResultsOutput r 
--where r.[StatusColor] != 'Green' 
--and  r.[StatusColor] != 'Grey' 
--group by r.ServerName
--)

--select sd.PK_ID, sd.DataCenterName, sd.ServerName, sd.Active ,rc.GreenCount, 
--case when sd.DataCenterName != 'AZURE' and sd.Active = 0 then 'Grey' 
--	 when  (case when rc.GreenCount IS NULL then 0 else rc.GreenCount end) = 0  then 'Green' 
--	 else 'Red' end as [StatusColor]
--,case when sd.IsCluster = 1 then 'Yes' else 'No' end as [IsCluster]
--,case when sd.IsPrimary = 1 then 'Yes' else 'No' end as [IsPrimaryNode]
--from [hub].[ServerDetails] sd
--left outer join GreenCount rc on rc.Servername = sd.Servername
--order by  sd.ServerName asc

END