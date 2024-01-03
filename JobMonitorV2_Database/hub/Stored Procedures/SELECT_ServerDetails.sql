-- =============================================
-- Author:		Ryan Gross
-- Create date: 9/2019
-- Description:	Select Server details
-- =============================================
CREATE PROCEDURE [hub].[SELECT_ServerDetails] 
AS
BEGIN

SELECT[ServerName]
      ,[DataCenterName]
      ,[Active]
	   ,[ServerConn]
	   ,[ClusterFunctionServerCall]
	   ,IsCluster
  FROM [hub].[ServerDetails]

END