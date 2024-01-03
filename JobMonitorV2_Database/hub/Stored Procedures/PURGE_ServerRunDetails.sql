-- =============================================
-- Author:		RTG
-- Create date: 9/2019
-- Description:	Purge Hub Run Details Log
-- =============================================
CREATE PROCEDURE [hub].[PURGE_ServerRunDetails] 
	-- Add the parameters for the stored procedure here
	@DaysToKeep int = 30
	
AS
BEGIN
	
	Delete from [hub].[ServerRunDetails] where [LastRun] < DATEADD(dd, -@DaysToKeep, GETDATE())

END