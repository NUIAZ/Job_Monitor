-- =============================================
-- Author:		RTG
-- Create date: 9/2019
-- Description:	Insert Hub Server Run Outcomes
-- =============================================
CREATE PROCEDURE [hub].[INSERT_ServerRunOutcomes] 
	-- Add the parameters for the stored procedure here
	@ServerName varchar(50), 
	@DataCenterName varchar(50),
    @Active bit
AS
BEGIN

Declare @Information varchar(512)
Set @Information = 'Active Server - Server Outcome Data Loaded into Stage'

if @active = 0
BEGIN
Set @Information = 'INACTIVE server - No Server Outcome Data Loaded'
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