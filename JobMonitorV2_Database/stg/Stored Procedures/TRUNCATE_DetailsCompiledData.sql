-- =============================================
-- Author:		RTG
-- Create date: 1/2020
-- Description:	Truncate Data in the DetailsCompiledData table
-- =============================================
CREATE PROCEDURE [stg].[TRUNCATE_DetailsCompiledData] 
	-- Add the parameters for the stored procedure here
AS
BEGIN

TRUNCATE Table [stg].[DetailsCompiledData]

END