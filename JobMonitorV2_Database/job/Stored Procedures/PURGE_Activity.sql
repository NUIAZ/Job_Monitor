-- =============================================
-- Author:		RTG
-- Create date: 9/2019
-- Description:	Purge Job Activity Data
-- =============================================
CREATE PROCEDURE [job].[PURGE_Activity] 
	-- Add the parameters for the stored procedure here
	@job_id uniqueIdentifier, 
	@daysinTable int
AS
BEGIN

if(@daysInTable is null)
	BEGIN
		DECLARE @DaysToKeep int = (SELECT [value] FROM [job].[Settings] WHERE [name] ='PURGE_Activity')

		Delete from [job].[Activity]
	    WHERE [run_requested_date]  <= DATEADD(day, -@DaysToKeep, GETDATE())
		AND Job_id = @job_id
	END
ELSE
	BEGIN
		Delete from [job].[Activity]
		 WHERE [run_requested_date]  <= DATEADD(day, -@daysInTable, GETDATE())
		AND Job_id = @job_id
	END
END