-- =============================================
-- Author:		RTG
-- Create date: 12/2021
-- Description:	Merge Failed Jobs Data
-- =============================================
CREATE PROCEDURE [job].[MERGE_FailedJob_Data] 
AS
BEGIN

--Synchronize the target table with refreshed data from source table
MERGE [dbo].[V3_FailedJobList] AS TARGET
USING [stg].[V3_FailedJobList] AS SOURCE 
ON (
TARGET.[Job_id] = SOURCE.[Job_Id]
AND TARGET.[Name] = SOURCE.[Name]
AND TARGET.[Step_Id] = SOURCE.[Step_Id] 
AND TARGET.[Step_Name] = SOURCE.[Step_Name]
AND TARGET.[Date] = SOURCE.[Date]
AND TARGET.[Time] = SOURCE.[Time]
AND TARGET.[Run_Duration] = SOURCE.[Run_Duration]
AND TARGET.[Retries_Attempted] = SOURCE.[Retries_Attempted]
AND TARGET.[Message] = SOURCE.[Message]
AND TARGET.[ServerName] = SOURCE.[ServerName]
)
--When no records are matched, insert the incoming records from source table to target table
WHEN NOT MATCHED BY TARGET 
THEN INSERT ([Job_Id],[Name],[Step_Id],[Step_Name],[Date],[Time],[Run_Duration],[Retries_Attempted],[Message],[ServerName])
VALUES (SOURCE.[Job_Id],SOURCE.[Name],SOURCE.[Step_Id],SOURCE.[Step_Name],SOURCE.[Date],SOURCE.[Time],SOURCE.[Run_Duration],SOURCE.[Retries_Attempted],SOURCE.[Message],SOURCE.[ServerName]);

END