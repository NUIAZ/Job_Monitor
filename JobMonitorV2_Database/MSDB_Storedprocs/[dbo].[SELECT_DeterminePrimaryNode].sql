USE [msdb]
GO

/****** Object:  StoredProcedure [dbo].[SELECT_DeterminePrimaryNode]    Script Date: 1/3/2024 10:37:22 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		RTG
-- Create date: 11/27/2019
-- Description:	Determine if the server is the primary node for display
-- =============================================
Create PROCEDURE [dbo].[SELECT_DeterminePrimaryNode] 
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
GO


