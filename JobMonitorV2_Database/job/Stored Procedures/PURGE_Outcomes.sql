-- =============================================
-- Author:		RTG
-- Create date: 9/2019
-- Description:	Purge Job Outcomes Data
-- =============================================
CREATE PROCEDURE [job].[PURGE_Outcomes] 
	-- Add the parameters for the stored procedure here
	@job_id uniqueIdentifier,
	@daysInTable int
AS
BEGIN

if(@daysInTable is null)
	BEGIN
		DECLARE @DaysToKeep int = (SELECT [value] FROM [job].[Settings] WHERE [name] ='PURGE_Outcomes')
		
		Delete from [job].[Outcomes]  
		where [ComputedDate] is null

		Delete from [job].[Outcomes] 
		WHERE msdb.dbo.agent_datetime(Last_run_date, Last_run_time) <= DATEADD(dd, -@DaysToKeep, GETDATE())
		AND Job_id = @job_id
	END
ELSE
	BEGIN
		Delete from [job].[Outcomes]  
		where [ComputedDate] is null

		Delete from [job].[Outcomes] 
		WHERE msdb.dbo.agent_datetime(Last_run_date, Last_run_time) <= DATEADD(dd, -@daysInTable, GETDATE())
		AND Job_id = @job_id
	END
END