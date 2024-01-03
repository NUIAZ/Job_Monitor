-- =============================================
-- Author:		RTG
-- Create date: 9/2019
-- Description:	Insert Job Activity
-- =============================================
CREATE PROCEDURE [job].[INSERT_Activity_Tier5] 
AS
BEGIN

--Synchronize the target table with refreshed data from source table
MERGE [job].[Activity] AS TARGET
USING [stg].[Activity_Tier5] AS SOURCE 
ON (
 TARGET.[job_id] = SOURCE.[job_id] 
  AND TARGET.[ServerName] = SOURCE.[ServerName]
 AND TARGET.[DataCenterName]= SOURCE.[DataCenterName]
 AND TARGET.[run_requested_date] = SOURCE.[run_requested_date]
 AND TARGET.[run_requested_source]= SOURCE.[run_requested_source]
 AND TARGET.[queued_date] = SOURCE.[queued_date]
 AND TARGET.[start_execution_date] = SOURCE.[start_execution_date]
 AND TARGET.[last_executed_step_id] = SOURCE.[last_executed_step_id]
 AND TARGET.[last_executed_step_date] = SOURCE.[last_executed_step_date]
 AND TARGET.[stop_execution_date] = SOURCE.[stop_execution_date]
 AND TARGET.[job_history_id] = SOURCE.[job_history_id])

--When no records are matched, insert the incoming records from source table to target table
WHEN NOT MATCHED BY TARGET 
THEN INSERT ([job_id],[ServerName],[DataCenterName],[run_requested_date],[run_requested_source],[queued_date],[start_execution_date],[last_executed_step_id],[last_executed_step_date],[stop_execution_date],[job_history_id],[next_scheduled_run_date],[ModifiedByUser],[ModifiedByDate]) 
VALUES (SOURCE.[job_id],SOURCE.[ServerName],SOURCE.[DataCenterName],SOURCE.[run_requested_date],SOURCE.[run_requested_source],SOURCE.[queued_date],SOURCE.[start_execution_date],SOURCE.[last_executed_step_id],SOURCE.[last_executed_step_date],SOURCE.[stop_execution_date],SOURCE.[job_history_id],SOURCE.[next_scheduled_run_date],'SSIS',getdate());

END