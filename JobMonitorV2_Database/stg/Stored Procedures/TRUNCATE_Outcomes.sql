-- =============================================
-- Author:		RTG
-- Create date: 9/2019
-- Description:	Truncate Data in the Outcomes Stage table
-- =============================================
CREATE PROCEDURE [stg].[TRUNCATE_Outcomes] 
	-- Add the parameters for the stored procedure here
AS
BEGIN

TRUNCATE Table [stg].[Outcomes]

END