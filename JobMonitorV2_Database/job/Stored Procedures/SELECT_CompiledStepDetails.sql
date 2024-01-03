-- =============================================
-- Author:		RTG
-- Create date: 1/2/2020
-- Description:	job step details data for display
-- =============================================
CREATE PROCEDURE [job].[SELECT_CompiledStepDetails] 
		@Job_id uniqueidentifier
AS
BEGIN

SELECT [Job_id]
      ,[ServerName]
      ,[StepName]
      ,[StepID]
      ,[Step_uid]
      ,[NumberOfTimesRun]
      ,[NumberOfSuccessfulRuns]
      ,[SuccessPct]
      ,[StatusColor]
      ,[StepStatus]
      ,[PK_ID]
  FROM [job].[StepDetailsCompiledData]
  where [Job_id] = @Job_id
  order by [StepID] 
END