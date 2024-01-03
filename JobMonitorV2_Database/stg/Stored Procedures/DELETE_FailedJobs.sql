-- =============================================
-- Author:		RTG
-- Create date: 1/22
-- Description:	Delete Data in the STG Job table
-- =============================================
CREATE PROCEDURE [stg].[DELETE_FailedJobs] 
	@serverName varchar(128)
AS
BEGIN

delete FROM [JobMonitorV2].[stg].[V3_FailedJobList]
  where [ServerName] =@serverName

END