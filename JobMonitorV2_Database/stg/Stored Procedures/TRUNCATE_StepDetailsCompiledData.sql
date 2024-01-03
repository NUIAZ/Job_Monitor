-- =============================================
-- Author:		RTG
-- Create date: 1/2020
-- Description:	Truncate Data in the StepDetailsCompiledData table
-- =============================================
CREATE PROCEDURE [stg].[TRUNCATE_StepDetailsCompiledData] 
	-- Add the parameters for the stored procedure here
AS
BEGIN

TRUNCATE Table [stg].[StepDetailsCompiledData]

END