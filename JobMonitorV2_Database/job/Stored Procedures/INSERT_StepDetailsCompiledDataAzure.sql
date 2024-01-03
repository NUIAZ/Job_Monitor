-- =============================================
-- Author:		RTG
-- Create date: 1/2020
-- Description:	Insert Job Step Details Data
-- =============================================
CREATE PROCEDURE [job].[INSERT_StepDetailsCompiledDataAzure] 
AS
BEGIN

--Synchronize the target table with refreshed data from source table
MERGE [job].[StepDetailsCompiledData] AS TARGET
USING [stg].[StepDetailsCompiledDataAzure] AS SOURCE 
ON (
TARGET.[stepid] = SOURCE.[stepid] 
AND TARGET.[Job_id] = SOURCE.[Job_id] 
AND TARGET.[serverName] = SOURCE.[serverName]
AND TARGET.[stepname] = SOURCE.[stepname] 
)

WHEN MATCHED
then update set
TARGET.[NumberOfTimesRun] = SOURCE.[NumberOfTimesRun]
,TARGET.[NumberOfSuccessfulRuns] = SOURCE.[NumberOfSuccessfulRuns]
,TARGET.[SuccessPct] = SOURCE.[SuccessPct]
,TARGET.[StatusColor] = SOURCE.[StatusColor]
,TARGET.[StepStatus] = SOURCE.[StepStatus]
,TARGET.[step_uid] = SOURCE.[step_uid]

--When no records are matched, insert the incoming records from source table to target table
WHEN NOT MATCHED BY TARGET 
THEN INSERT ([Job_id],[StepID],[StepName],[serverName],[step_uid], [NumberOfTimesRun], [NumberOfSuccessfulRuns], [SuccessPct], [StatusColor],[StepStatus] ) 
VALUES (SOURCE.[Job_id],SOURCE.[StepID],SOURCE.[StepName],SOURCE.[serverName] ,SOURCE.[step_uid],SOURCE.[NumberOfTimesRun], SOURCE.[NumberOfSuccessfulRuns], SOURCE.[SuccessPct], SOURCE.[StatusColor], SOURCE.[StepStatus]);

END