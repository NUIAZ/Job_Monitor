-- =============================================
-- Author:		RTG
-- Create date: 12/2021
-- Description:	Purge failed Job Data
-- =============================================
CREATE PROCEDURE [job].[PURGE_FailedJobData] 
	-- Add the parameters for the stored procedure here
	@daysinTable int
AS
BEGIN

if(@daysInTable is null)
	BEGIN
		DECLARE @DaysToKeep int = (SELECT [value] FROM [job].[Settings] WHERE [name] ='PURGE_FailedJobs')

		Delete from [dbo].[V3_FailedJobList]
	    WHERE [Date]  <= DATEADD(day, -@DaysToKeep, GETDATE())

		Delete from [hub].[ServerRunDetails]
	    WHERE [LastRun]  <= DATEADD(day, -@DaysToKeep, GETDATE())

	END
ELSE
	BEGIN
		 Delete from [dbo].[V3_FailedJobList]
		 WHERE [Date]  <= DATEADD(day, -@daysInTable, GETDATE())

		 Delete from [hub].[ServerRunDetails]
		 WHERE [LastRun] <= DATEADD(day, -@daysInTable, GETDATE())
	END
END