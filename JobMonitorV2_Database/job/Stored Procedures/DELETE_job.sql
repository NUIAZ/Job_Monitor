-- =============================================
-- Author:		FailOverReset
-- Create date: 7/2020
-- Description:	delete a job, add to exclusion list
-- =============================================
CREATE PROCEDURE [job].[DELETE_job] 
	(
		@JobName nvarchar(128),
		@addToExclusionList bit = 0
	)
AS
BEGIN

declare @job_id uniqueidentifier = (SELECT [Job_id] FROM [JobMonitorV2].[job].[Details] where [JobName] = @JobName)

DELETE FROM [job].[Details] where job_id = @job_id
DELETE FROM [job].[DetailsCompiledData] where job_id = @job_id

DELETE FROM [job].[StepDetails] where job_id = @job_id
DELETE FROM [job].[StepDetailsCompiledData] where job_id = @job_id

DELETE FROM [job].[Activity] where job_id = @job_id
DELETE FROM [job].[HistoricalData] where job_id = @job_id
DELETE FROM [job].[Outcomes] where job_id = @job_id

if(@addToExclusionList = 1)
BEGIN
	INSERT INTO [job].[ExcludeList]
           (
            [JobName]
           ,[Description]
           )
     VALUES
           (@JobName
           ,'Delete by user'
           )
END
END