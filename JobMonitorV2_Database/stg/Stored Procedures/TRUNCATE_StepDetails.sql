-- =============================================
-- Author:		RTG
-- Create date: 9/2019
-- Description:	Truncate Data in the Job_StepDetails table
-- =============================================
CREATE PROCEDURE [stg].[TRUNCATE_StepDetails] 
	-- Add the parameters for the stored procedure here
AS
BEGIN

TRUNCATE Table [stg].[StepDetails]

END