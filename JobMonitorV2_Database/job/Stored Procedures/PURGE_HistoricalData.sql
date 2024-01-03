-- =============================================
-- Author:		RTG
-- Create date: 9/2019
-- Description:	Purge Historical Data
-- =============================================
CREATE PROCEDURE [job].[PURGE_HistoricalData] 
	-- Add the parameters for the stored procedure here
	@job_id uniqueIdentifier,
	@daysInTable int
AS
BEGIN

if(@daysInTable is null)
	BEGIN
		DECLARE @DaysToKeep int = (SELECT [value] FROM [job].[Settings] WHERE [name] ='PURGE_HistoricalData')

		Delete from [job].[HistoricalData]
		WHERE msdb.dbo.agent_datetime(Run_date, Run_time) <= DATEADD(dd, -@DaysToKeep, GETDATE())
		AND Job_id = @job_id
	END
ELSE
	BEGIN
		Delete from [job].[HistoricalData]
		WHERE msdb.dbo.agent_datetime(Run_date, Run_time) <= DATEADD(dd, -@daysInTable, GETDATE())
		AND Job_id = @job_id
	END
END