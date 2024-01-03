-- =============================================
-- Author:		RTG
-- Create date: 9/2019
-- Description:	Insert Hub Server Run Details
-- =============================================
CREATE PROCEDURE [hub].[INSERT_ServerRunDetails] 
	-- Add the parameters for the stored procedure here
	@ServerName varchar(50), 
	@DataCenterName varchar(50),
    @Active bit
AS
BEGIN

Declare @Information varchar(512)
Set @Information = 'Active Server - Job Details Data Loaded into Stage'

if @active = 0
BEGIN
Set @Information = 'INACTIVE server - No Job Details Data Loaded'
END

INSERT INTO [hub].[ServerRunDetails]
           ([ServerName]
           ,[DataCenterName]
           ,[Information]
           ,[LastRun])
     VALUES
           (@ServerName
           ,@DataCenterName
           ,@Information
           ,getdate())

END