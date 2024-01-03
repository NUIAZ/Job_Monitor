USE [msdb]
GO

/****** Object:  StoredProcedure [dbo].[RunJobAtStep]    Script Date: 1/3/2024 10:37:51 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		RTG
-- Create date: 10/23/2019
-- Description:	Run a SQL Agent Job at a defined step
-- or all steps after a defined starting step.

-- Modified:    BRN 5/17/2022
--   added a test for the current sql agent session to the statement checking for running jobs  

-- Modified:    BRN 8/4/2022
--   added code to save the current success action job step, fail action, fail action job step
--   modified the "before execution" update job statement to set the fail action to "Quit with failure"
--   modified the "after execution" update job statement to also reset the 3 items above
--   added try/catch block

-- =============================================
CREATE PROCEDURE [dbo].[RunJobAtStep]( 
	-- Add the parameters for the stored procedure here
	@jobName nvarchar(128) = NULL,  -- Need the job name.
	@jobStep nvarchar(128) = NULL,  -- Need the starting step name.
	@ContinueAfterStep bit = 0,     -- The job will run a single steps on just continue on to all steps after this one?
	@Result varchar(35) out)            -- Return the result code.
WITH EXECUTE AS 'CORP\SqlAgentSvc'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	-- helpful return code matrix
	-- 0 default
	-- 1 job run success 
	-- 2 Job run failed 
	-- 3 Job run success running single step
	-- 4 job failed on running single step
	-- 5 job is currently running

    -- variables for try/catch
	declare @ERRORMESSAGE nvarchar(4000)
           ,@ERRORSEVERITY int
	       ,@ERRORSTATE int
	       ,@ERRORPROCEDURE nvarchar(128)
	       ,@ERRORLINE int
	       ,@ERRORNUMBER int
    
    BEGIN TRY

	-- Job id please.
	DECLARE @targetJob_id uniqueidentifier
	SET @targetJob_id = (SELECT TOP 1 job_id FROM [msdb].[dbo].[sysjobs] WHERE [name] = @jobName)

	--Step id please.
	DECLARE @targetStepId int 
	SET @targetStepId = (SELECT TOP 1 [step_id] FROM [msdb].[dbo].[sysjobsteps] WHERE [step_name] = @jobStep and job_id = @targetJob_id)

	 -- Check to see if the job is running  
	 IF not EXISTS(
                   -- BRN 5/17/2022 added a test for the current sql agent session to the statement 
                   SELECT 1
                     FROM msdb.dbo.sysjobs_view j
                          JOIN msdb.dbo.sysjobactivity a ON j.job_id = a.job_id
                          JOIN msdb.dbo.syssessions s ON s.session_id = a.session_id
                          -- Include a test for the current sql agent session
                          JOIN ( SELECT   MAX(s2.agent_start_date) AS max_agent_start_date
                                   FROM     msdb.dbo.syssessions s2
                               ) sess_max ON s.agent_start_date = sess_max.max_agent_start_date
                    WHERE J.name=@jobName 
                      AND A.run_requested_date IS NOT NULL AND A.stop_execution_date IS NULL
                  ) 
	 -- lets run the job, first check just this step or all of them after too.
		 BEGIN
			IF @ContinueAfterStep = 1 -- Run all steps after the starting step? YES!
				BEGIN
					DECLARE @ResultRunJob int;
					EXEC @ResultRunJob = msdb.dbo.sp_start_job @job_name=@JobName, @step_name = @jobStep;
					WAITFOR	DELAY '00:00:03'
					SET @Result = case @ResultRunJob 
					                when 0 then 'Job run success.' --1
									else 'Job run failed.' --2
								  end
				END
			ELSE -- Just run the single step please.
				BEGIN
					-- retrive the current @on_sucess_action for the job step.
					-- brn 8/4/2022 retrieve the @on_fail_action, @on_success_step_id, @on_fail_step_id values in order to reset the job step
					DECLARE @CurrentOnSuccessSetting tinyint, @CurrentOnSuccessStepID int, @CurrentOnFailureSetting tinyint ,@CurrentOnFailureStepID int; 
					SELECT @CurrentOnSuccessSetting = [on_success_action] ,@CurrentOnSuccessStepID = [on_success_step_id] 
					      ,@CurrentOnFailureSetting = [on_fail_action] ,@CurrentOnFailureStepID = [on_fail_step_id]
					  FROM [msdb].[dbo].[sysjobsteps] where job_id = @targetJob_id and step_id = @targetStepId;
					WAITFOR	DELAY '00:00:01'

					-- adjust the @on_success_action of the step so that after it runs it will not run anymore steps.
					-- brn 8/4/2022 adjust the @on_fail_action of the step to 'Quit with failure' so the job stops if a single job step fails
					EXEC msdb.dbo.sp_update_jobstep @job_id = @targetJob_id, @step_id = @targetStepId, @on_success_action = 1, @on_fail_action = 2;
					WAITFOR	DELAY '00:00:05'

					-- run the job step please.
					DECLARE @ResultRunJobOneStepOnly int; 
					EXEC @ResultRunJobOneStepOnly = msdb.dbo.sp_start_job @job_name=@JobName ,@step_name = @jobStep;
					WAITFOR	DELAY '00:00:03'
					IF @ResultRunJobOneStepOnly = 0
					BEGIN -- set the step action back to the original state please.
                        -- brn 8/4/2022 added three more parameters to the statement
						EXEC msdb.dbo.sp_update_jobstep @job_id = @targetJob_id, @step_id = @targetStepId, 
							                            @on_success_action = @CurrentOnSuccessSetting, @on_success_step_id = @CurrentOnSuccessStepID,
														@on_fail_action = @CurrentOnFailureSetting, @on_fail_step_id = @CurrentOnFailureStepID;
						WAITFOR	DELAY '00:00:05'
						SET @Result = 'Job run success running single step.' --3
						END
					ELSE -- set the step action back to the original state please.
					BEGIN
                        -- brn 8/4/2022 added three more parameters to the statement
						EXEC msdb.dbo.sp_update_jobstep @job_id = @targetJob_id, @step_id = @targetStepId, 
							                            @on_success_action = @CurrentOnSuccessSetting, @on_success_step_id = @CurrentOnSuccessStepID,
														@on_fail_action = @CurrentOnFailureSetting, @on_fail_step_id = @CurrentOnFailureStepID;
						WAITFOR	DELAY '00:00:05'
						SET @Result = 'Job failed on running single step.' --4
					END
				END
		 END
	 ELSE -- the job is running :(
	 BEGIN
	 	  SET @Result = 'Job is currently running.' --5	
	 END

		--[ @on_success_action = ] success_action The action to perform if the step succeeds.success_action is tinyint, with a default of NULL, and can be one of these values.
		--Value --Description (action)
		--1     --Quit with success.
		--2     --Quit with failure.
		--3     --Go to next step.
		--4     --Go to step success_step_id.

	end try
	begin catch

		select @ERRORMESSAGE = ERROR_MESSAGE(), @ERRORSEVERITY = ERROR_SEVERITY() ,@ERRORSTATE = ERROR_STATE() 
			  ,@ERRORPROCEDURE = ERROR_PROCEDURE() ,@ERRORLINE = ERROR_LINE() ,@ERRORNUMBER = ERROR_NUMBER()
		if (select @@TRANCOUNT) > 0 rollback
		raiserror(@ERRORMESSAGE ,@ERRORSEVERITY ,@ERRORSTATE)
        set @Result = 'Error encountered'
		return 1 -- non-0 value indicates this procedure encountered errors and failed
		
	end catch
END
return 0 -- 0 indicates this procedure completed successfully

GO


