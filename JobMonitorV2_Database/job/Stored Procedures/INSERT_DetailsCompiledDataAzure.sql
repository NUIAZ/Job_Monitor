-- =============================================
-- Author:		RTG
-- Create date: 1/2020
-- Description:	Insert Job Details
-- =============================================
CREATE PROCEDURE [job].[INSERT_DetailsCompiledDataAzure] 
AS
BEGIN

--Synchronize the target table with refreshed data from source table
MERGE [job].[DetailsCompiledData] AS TARGET
USING [stg].[DetailsCompiledDataAzure] AS SOURCE 
ON (TARGET.[Job_id] = SOURCE.[Job_id]) 

--When records are matched, update the records if there is any change
WHEN MATCHED  

THEN UPDATE SET 
TARGET.[ServerName] = SOURCE.[ServerName] 
,TARGET.[JobName] = SOURCE.[JobName]
,TARGET.[Description] = SOURCE.[Description]
,TARGET.[Enabled] = SOURCE.[Enabled]
,TARGET.[DaysOfHistoryToRetain] = SOURCE.[DaysOfHistoryToRetain]
,TARGET.[AlertFactor] = SOURCE.[AlertFactor]
,TARGET.[IsBlacklisted] = SOURCE.[IsBlacklisted]
,TARGET.[NumberOfTimesRun] = SOURCE.[NumberOfTimesRun]
,TARGET.[NumberOfSuccessfulRuns] = SOURCE.[NumberOfSuccessfulRuns]
,TARGET.[PercentageOfRuns] = SOURCE.[PercentageOfRuns]
,TARGET.[StatusColor] = SOURCE.[StatusColor]
,TARGET.[JobStatus] = SOURCE.[JobStatus]
,TARGET.[Tier] = SOURCE.[Tier]

--When no records are matched, insert the incoming records from source table to target table
WHEN NOT MATCHED BY TARGET 
THEN INSERT ([Job_id],[ServerName],[JobName],[Description],[Enabled],[DaysOfHistoryToRetain], 
[AlertFactor],[IsBlacklisted] ,[NumberOfTimesRun],[NumberOfSuccessfulRuns],[PercentageOfRuns],[StatusColor],[JobStatus], [Tier] ) 
VALUES (SOURCE.[Job_id], SOURCE.[ServerName], SOURCE.[JobName], SOURCE.[Description], SOURCE.[Enabled], SOURCE.[DaysOfHistoryToRetain],
SOURCE.[AlertFactor],SOURCE.[IsBlacklisted], SOURCE.[NumberOfTimesRun],SOURCE.[NumberOfSuccessfulRuns], SOURCE.[PercentageOfRuns], SOURCE.[StatusColor], SOURCE.[JobStatus], SOURCE.[Tier] )

--use to clean up after delete of sql jobs in sql server - if you uncomment then it deltes after each server run... 
--WHEN NOT MATCHED BY SOURCE 
--THEN DELETE
; 

 UPDATE
    Table_A
SET
    Table_A.Tier = Table_B.Tier,
	Table_A.[DaysOfHistoryToRetain] = Table_B.[DaysOfHistoryToRetain],
	Table_A.[Description] = Table_B.[Description]

FROM
    [JobMonitorV2].[job].[DetailsCompiledData] AS Table_A
    INNER JOIN [JobMonitorV2].[job].[Details]  AS Table_B
        ON Table_A.Job_id = Table_B.Job_id

END