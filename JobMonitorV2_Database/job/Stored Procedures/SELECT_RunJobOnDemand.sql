-- =============================================
-- Author:		RTG
-- Create date: 10/14/2019
-- Description:	Get data for Run job On Demand, 
-- then log the request. 
-- =============================================
CREATE PROCEDURE [job].[SELECT_RunJobOnDemand] 
	-- Add the parameters for the stored procedure here
	@ServerName nvarchar(128), @Job_id uniqueidentifier, @StepId int, @User varchar(100)
AS
BEGIN
 
  DECLARE @serverConn varchar(50) 
  SET @serverConn = (SELECT top 1 [ServerConn] FROM [hub].[ServerDetails] WHERE ServerName = @serverName)
 
  DECLARE @JobName as nvarchar(128)
  SET @JobName = (SELECT top 1 JobName FROM [job].[Details] WHERE Job_id = @Job_id)

  DECLARE @StepName as nvarchar(128)
  SET @StepName = (SELECT top 1 StepName FROM [job].[StepDetails] WHERE Job_id = @Job_id and StepID = @StepId)

  DECLARE @ConnectionString varchar(512)  
  --SET @ConnectionString = 'Data Source=' +  @serverConn + ';Initial Catalog=MSDB;Provider=SQLNCLI11.1;Integrated Security=SSPI;Auto Translate=False;'
  SET @ConnectionString = 'Server=' + @ServerName + '; Database=MSDB; User Id=kochjobmonitor; Password=immune;'

  --log attempt to start job
  INSERT INTO [job].[OnDemand]
           ([ServerName]
           ,[ServerConn]
           ,[ModifiedByDate]
           ,[ModifiedByUser]
           ,[Job_id]
           ,[JobName]
           ,[StepName]
           ,[StepID])
     VALUES
           (@ServerName
           ,@ServerConn
           ,GETDATE()
           ,@User 
           ,@Job_id
           ,(SELECT top 1 JobName from job.Details where Job_id = @Job_id)
           ,@StepName
           ,(SELECT top 1 StepID from job.StepDetails where Job_id = @Job_id and StepName = @Stepname))

SET NOCOUNT ON;
	SELECT @ConnectionString as connectionString, @jobName as jobName, @StepName as stepName
END