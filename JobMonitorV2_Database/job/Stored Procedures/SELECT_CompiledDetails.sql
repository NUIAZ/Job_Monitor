-- =============================================
-- Author:		RTG
-- Create date: 1/2/2020
-- Description:	job details data for display
-- =============================================
CREATE PROCEDURE [job].[SELECT_CompiledDetails] 
	@serverName nvarchar(128) 
AS
BEGIN

SELECT [Job_id]
      ,[ServerName]
      ,[JobName]
      ,[Description]
      ,[Enabled]
      ,[DaysOfHistoryToRetain]
      ,[AlertFactor]
      ,[IsBlacklisted]
      ,[NumberOfTimesRun]
      ,[NumberOfSuccessfulRuns]
      ,[PercentageOfRuns]
      ,[StatusColor]
      ,[JobStatus]
	  ,[Tier]
  FROM [job].[DetailsCompiledData]
  where [ServerName] = @serverName
  order by [JobName]
END