-- =============================================
-- Author:		RTG
-- Create date: 9/2019
-- Description:	Insert Job Step Details Data
-- =============================================
CREATE PROCEDURE [job].[INSERT_StepDetails] 
AS
BEGIN

--Synchronize the target table with refreshed data from source table
MERGE [job].[StepDetails] AS TARGET
USING [stg].[StepDetails] AS SOURCE 
ON (
TARGET.[stepid] = SOURCE.[stepid] 
AND TARGET.[Job_id] = SOURCE.[JobID] 
AND TARGET.[stepname] = SOURCE.[stepname] 
AND TARGET.[serverName] = SOURCE.[server]
)

WHEN MATCHED
then update set
TARGET.[Step_uid] = SOURCE.[Step_uid]
,TARGET.[database_name] = SOURCE.[database_name]
,TARGET.[subsystem] = SOURCE.[subsystem]
, TARGET.[flags] = SOURCE.[flags]
, TARGET.[additional_parameters] = SOURCE.[additional_parameters]
, TARGET.[cmdexec_success_code] = SOURCE.[cmdexec_success_code]
, TARGET.[on_success_action] = SOURCE.[on_success_action]
, TARGET.[on_success_step_id] = SOURCE.[on_success_step_id]
, TARGET.[on_fail_action] = SOURCE.[on_fail_action]
, TARGET.[on_fail_step_id] = SOURCE.[on_fail_step_id]
, TARGET.[database_user_name] = SOURCE.[database_user_name]
, TARGET.[retry_attempts] = SOURCE.[retry_attempts]
, TARGET.[retry_interval] = SOURCE.[retry_interval]
, TARGET.[os_run_priority] = SOURCE.[os_run_priority]
, TARGET.[output_file_name] = SOURCE.[output_file_name]
, TARGET.[last_run_outcome] = SOURCE.[last_run_outcome]
, TARGET.[last_run_duration] = SOURCE.[last_run_duration]
, TARGET.[last_run_retries] = SOURCE.[last_run_retries]
, TARGET.[last_run_date] = SOURCE.[last_run_date]
, TARGET.[last_run_time] = SOURCE.[last_run_time]
, TARGET.[proxy_id] = SOURCE.[proxy_id]
,TARGET.[ModifiedByUser] = 'Update'
,TARGET.[ModifiedByDate] = getdate()

--When no records are matched, insert the incoming records from source table to target table
WHEN NOT MATCHED BY TARGET 
THEN INSERT ([Job_id],[StepID],[StepName],[subsystem],[flags],[additional_parameters],[cmdexec_success_code],[on_success_action],[on_success_step_id],[on_fail_action],[on_fail_step_id],[serverName],[database_name],[database_user_name],[retry_attempts],[retry_interval],[os_run_priority],[output_file_name],[last_run_outcome],[last_run_duration],[last_run_retries],[last_run_date],[last_run_time],[proxy_id],[step_uid],[ModifiedByUser],[ModifiedByDate]) 
VALUES (SOURCE.[JobID],SOURCE.[StepID],SOURCE.[StepName],SOURCE.[subsystem],SOURCE.[flags],SOURCE.[additional_parameters],SOURCE.[cmdexec_success_code],SOURCE.[on_success_action],SOURCE.[on_success_step_id],SOURCE.[on_fail_action],SOURCE.[on_fail_step_id],SOURCE.[server],SOURCE.[database_name],SOURCE.[database_user_name],SOURCE.[retry_attempts],SOURCE.[retry_interval],SOURCE.[os_run_priority],SOURCE.[output_file_name],SOURCE.[last_run_outcome],SOURCE.[last_run_duration],SOURCE.[last_run_retries],SOURCE.[last_run_date],SOURCE.[last_run_time],SOURCE.[proxy_id],SOURCE.[step_uid],'SSIS',getdate())

--use to clean up sql jobs
--WHEN NOT MATCHED BY SOURCE 
--THEN DELETE
;
END