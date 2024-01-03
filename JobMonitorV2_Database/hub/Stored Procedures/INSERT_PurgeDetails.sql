-- =============================================
-- Author:		RTG
-- Create date: 9/2019
-- Description:	Insert Hub Purge Run Details
-- =============================================
CREATE PROCEDURE [hub].[INSERT_PurgeDetails] 
	-- Add the parameters for the stored procedure here
	@jobName nvarchar(128),
	@ServerName nvarchar(128) 
AS
BEGIN

Declare @Information varchar(512)
Set @Information = 'Job Purge - Job Details Data Purged'

INSERT INTO [hub].[ServerRunDetails]
           ([ServerName]
           ,[JobName]
           ,[Information]
           ,[LastRun])
     VALUES
           (@ServerName
           ,@jobName
           ,@Information
           ,getdate())
END