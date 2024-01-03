-- =============================================
-- Author:		RTG
-- Create date: 9/2019
-- Description:	Insert Job History Data
-- =============================================
CREATE PROCEDURE [job].[INSERT_HistoricalData_Tier6] 
AS
BEGIN

--Synchronize the target table with refreshed data from source table
MERGE [job].[HistoricalData] AS TARGET
USING [stg].[HistoricalData_Tier6] AS SOURCE 
ON (
TARGET.[Job_id] = SOURCE.[JobID]
AND TARGET.[step_id] = SOURCE.[step_id] 
AND TARGET.[step_name] = SOURCE.[step_name] 
AND TARGET.[run_date] = SOURCE.[run_date]
AND TARGET.[sql_message_id] = SOURCE.[sql_message_id]
AND TARGET.[sql_severity] = SOURCE.[sql_severity]
AND TARGET.[run_time] = SOURCE.[run_time]
AND TARGET.[message] = SOURCE.[message]
AND TARGET.[run_status] = SOURCE.[run_status]
AND TARGET.[run_duration] = SOURCE.[run_duration]
AND TARGET.[operator_id_emailed] = SOURCE.[operator_id_emailed]
AND TARGET.[operator_id_netsent] = SOURCE.[operator_id_netsent]
AND TARGET.[operator_id_paged] = SOURCE.[operator_id_paged]
AND TARGET.[retries_attempted] = SOURCE.[retries_attempted]
AND TARGET.[serverName] = SOURCE.[serverName]
)

--When no records are matched, insert the incoming records from source table to target table
WHEN NOT MATCHED BY TARGET 
THEN INSERT ([Job_id],[step_id],[step_name],[sql_message_id],[sql_severity],[message],[run_status],[run_date],[run_time],[run_duration],[operator_id_emailed],[operator_id_netsent],[operator_id_paged],[retries_attempted],[serverName],[ModifiedByUser],[ModifiedByDate]) 
VALUES (SOURCE.[JobID], SOURCE.[step_id],SOURCE.[step_name],SOURCE.[sql_message_id],SOURCE.[sql_severity],SOURCE.[message],SOURCE.[run_status],SOURCE.[run_date],SOURCE.[run_time],SOURCE.[run_duration],SOURCE.[operator_id_emailed],SOURCE.[operator_id_netsent],SOURCE.[operator_id_paged],SOURCE.[retries_attempted],SOURCE.[serverName],'SSIS', getdate());

END