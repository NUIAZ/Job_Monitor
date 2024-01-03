-- =============================================
-- Author:		RTG
-- Create date: 9/2019
-- Description:	Truncate Data in the Job_Job_Details table
-- =============================================
CREATE PROCEDURE [stg].[TRUNCATE_Details] 
	-- Add the parameters for the stored procedure here
AS
BEGIN

TRUNCATE Table [stg].[Details]

END