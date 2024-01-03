USE [msdb]
GO

/****** Object:  StoredProcedure [dbo].[RunJobOptionalCheckPrimary]    Script Date: 1/3/2024 10:37:31 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		RTG
-- Create date: 3/23/2022
-- Description:	Run a SQL Agent Job
-- Optional: Bit: 1/0 Check Primary Step (1 = skip check primary step)
-- Test Job: 3B4A4B59-292D-42BB-8BD0-475B40835C34 - JobMonitor_V3
-- =============================================
CREATE PROCEDURE [dbo].[RunJobOptionalCheckPrimary]( 
	-- Add the parameters for the stored procedure here
	@jobName nvarchar(128) = NULL,  -- Need the job name.
	@CheckPrimary bit = 0,  -- The job will skip the check Primary Step
	@Result varchar(35) out) -- Return the result code.
WITH EXECUTE AS 'CORP\SqlAgentSvc'
AS
BEGIN
	SET NOCOUNT ON;
	
	-- Job id please.
	DECLARE @targetJob_id uniqueidentifier
	SET @targetJob_id = (SELECT TOP 1 job_id FROM [msdb].[dbo].[sysjobs] WHERE [name] = @jobName)

	-- Does job have a Check Primary Step?
	DECLARE @CheckPrimaryExists bit = 0
	IF EXISTS(SELECT TOP 1 [job_id] FROM [msdb].[dbo].[sysjobsteps] where step_name like '%Check%' and job_id = @targetJob_id) 
	BEGIN
		set @CheckPrimaryExists = 1
	END
	
	DECLARE @targetStepId int = 1
	IF(@CheckPrimary = 1 and @CheckPrimaryExists =1)
	BEGIN 
		SET @targetStepId = 2
	END
	
	 -- Check to see if the job is running  
	 IF not EXISTS(SELECT 1 FROM msdb.dbo.sysjobs J JOIN msdb.dbo.sysjobactivity A ON A.job_id=J.job_id WHERE J.name=@jobName AND A.run_requested_date IS NOT NULL AND A.stop_execution_date IS NULL) 
	 -- lets run the job, first check just this step or all of them after too.
		 BEGIN
		 DECLARE @stepname nvarchar(128)
		 set @stepname= (SELECT TOP 1 [step_name] FROM [msdb].[dbo].[sysjobsteps] where step_id = @targetStepId and job_id=@targetJob_id)

					DECLARE @ResultRunJob int;EXEC @ResultRunJob = msdb.dbo.sp_start_job @job_name=@JobName,
					@step_name =@stepname;
					WAITFOR	DELAY '00:00:03'
					DECLARE @ResultRunJobOK int; SET @ResultRunJobOK = (SELECT @ResultRunJob )
						IF @ResultRunJobOK = 0
							BEGIN
								SET @Result = 'Job run success.' --1
							END
						ELSE
							BEGIN
								SET @Result = 'Job run failed.' --2		
							END
				END
     -- the job is running :(
	 ELSE 
	 BEGIN
	 	  SET @Result = 'Job is currently running.' --5	
	 END

	 RETURN SELECT @Result;

END
GO


