-- =============================================
-- Author:		RTG
-- Create date: 9/2019
-- Description:	Insert Job failed
-- =============================================
CREATE PROCEDURE [stg].[INSERT_FailedJob] 

(@Job_Id uniqueidentifier,
@Name nvarchar(128),
@Step_Id int,
@Step_Name varchar(128),
@Date date,
@Time datetime,
@Run_Duration int,
@Retries_Attempted int,
@Message varchar(max),
@ServerName nvarchar(128))
AS
BEGIN

INSERT INTO [stg].[V3_FailedJobList]
           ([Job_Id]
           ,[Name]
           ,[Step_Id]
           ,[Step_Name]
           ,[Date]
           ,[Time]
           ,[Run_Duration]
           ,[Retries_Attempted]
           ,[Message]
           ,[ServerName])
     VALUES
           (@Job_Id
           ,@Name
           ,@Step_Id
           ,@Step_Name
           ,@Date
           ,@Time
           ,@Run_Duration
           ,@Retries_Attempted
           ,@Message
           ,@ServerName)
END