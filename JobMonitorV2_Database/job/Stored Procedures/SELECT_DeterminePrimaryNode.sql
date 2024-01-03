-- =============================================
-- Author:		RTG
-- Create date: 11/27/2019
-- Description:	Determine if the server is the primary node for display
-- =============================================
CREATE PROCEDURE [job].[SELECT_DeterminePrimaryNode] 
	@isCluster int,
	@clusterFunctionServerCall varchar(50)
AS
BEGIN
-- determine the primary node
DECLARE @result as int

IF @isCluster = 1
BEGIN
	SET @Result = (select [DBATools].[dbo].Koch_HALitmusTest(@clusterFunctionServerCall))
END
ELSE
BEGIN
	SET @result = 0
END

SELECT @result as IsPrimary
END