-- =============================================
-- Author:		RTG
-- Create date: 11/2019
-- Description:	Purge logging Data
-- =============================================
CREATE PROCEDURE [job].[PURGE_LoggingTables] 
	-- Add the parameters for the stored procedure here
AS
BEGIN

DECLARE @SSISErrorsDays int = (SELECT [value] FROM [job].[Settings] WHERE [name] ='PURGE_SSIS_Errors')
DECLARE @PURGE_ServerDetailsDays int = (SELECT [value] FROM [job].[Settings] WHERE [name] = 'PURGE_ServerDetails')
DECLARE @PURGE_OnDemandDays int = (SELECT [value] FROM [job].[Settings] WHERE [name]= 'PURGE_OnDemand')
DECLARE @PURGE_ArchivedData int = (SELECT [value] FROM [job].[Settings] WHERE [name]= 'PURGE_ArchivedData')
--delete errors
  DELETE 
  FROM [hub].[SsisError]
  WHERE DateOfOccurance <= DATEADD(day, -@SSISErrorsDays, GETDATE())

  --delete log data
  DELETE
  FROM [hub].[ServerRunDetails]
  WHERE LastRun <= DATEADD(day, -@PURGE_ServerDetailsDays, GETDATE())

  --delete the on-demand history
  DELETE
  FROM [job].[OnDemand]
  WHERE [ModifiedByDate] <= DATEADD(day, -@PURGE_OnDemandDays, GETDATE())
	
	--delete the Orpahned data | this occurs when jobs/steps are deleted or renamed
  	Delete from [job].[Activity]
	WHERE [run_requested_date]  <= DATEADD(day, -@PURGE_ArchivedData, GETDATE())
	
	Delete from [job].[HistoricalData]
	WHERE msdb.dbo.agent_datetime(Run_date, Run_time) <= DATEADD(dd, -@PURGE_ArchivedData, GETDATE())

	Delete from [job].[Outcomes] 
	WHERE msdb.dbo.agent_datetime(Last_run_date, Last_run_time) <= DATEADD(dd, -@PURGE_ArchivedData, GETDATE())
END