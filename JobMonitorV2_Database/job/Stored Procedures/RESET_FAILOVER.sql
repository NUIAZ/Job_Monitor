-- =============================================
-- Author:		FailOverReset
-- Create date: 7/2020
-- Description:	Reset all data due to job id reset or other unforseen data related items due to failover
-- =============================================
CREATE PROCEDURE [job].[RESET_FAILOVER] 
	
AS
BEGIN

DELETE FROM [job].[Details]
DELETE FROM [job].[DetailsCompiledData]

DELETE FROM [job].[StepDetails]
DELETE FROM [job].[StepDetailsCompiledData]

DELETE FROM [job].[Activity]
DELETE FROM [job].[HistoricalData]
DELETE FROM [job].[Outcomes]

END