-- =============================================
-- Author:		RTG
-- Create date: 9/2019
-- Description:	Insert Job Details
-- =============================================
CREATE PROCEDURE [job].[INSERT_Details] 
AS
BEGIN

--Synchronize the target table with refreshed data from source table
MERGE [job].[Details] AS TARGET
USING [stg].[Details] AS SOURCE 
ON (TARGET.[Job_id] = SOURCE.[JobID]) 

--When records are matched, update the records if there is any change
WHEN MATCHED  

THEN UPDATE SET 
TARGET.[ServerName] = SOURCE.[ServerName] 
,TARGET.[JobName] = SOURCE.[JobName]
,TARGET.[Description] = SOURCE.[Description]
,TARGET.[Date_Created] = SOURCE.[Date_Created]
,TARGET.[Date_modified] = SOURCE.[Date_modified]
,TARGET.[Enabled] = SOURCE.[Enabled]
,TARGET.[Version_number] = SOURCE.[Version_number]
,TARGET.[Category_id] = SOURCE.[Category_id]
,TARGET.[StartStep_id] = SOURCE.[StartStep_id]
,TARGET.[ModifiedByDate] = getdate() 

--When records are not matched, insert the incoming records from source table to target table
-- exclude certain types of jobs listed
WHEN NOT MATCHED BY TARGET 
and SOURCE.[JobName] NOT LIKE '%_NLU%' -- NLU = No Longer Used
and SOURCE.[JobName] NOT IN (SELECT [JobName] FROM [job].[prereqlist])-- prerequsite job 
and SOURCE.[JobName] NOT IN (SELECT [JobName] FROM [job].[ExcludeList])

THEN 

INSERT ([Job_id],[ServerName],[JobName],[Description],[Date_Created],[Date_modified],[Enabled],[Version_number],[Category_id],[StartStep_id],[DaysOfHistoryToRetain],[ModifiedByUser]) 
VALUES (SOURCE.[JobID], SOURCE.[ServerName], SOURCE.[JobName], SOURCE.[Description], SOURCE.[Date_Created], SOURCE.[Date_modified], SOURCE.[Enabled], SOURCE.[Version_number]
, SOURCE.[Category_id], SOURCE.[StartStep_id], 4,'SSIS')

--use to clean up sql jobs
WHEN NOT MATCHED BY SOURCE 
THEN DELETE
;

END