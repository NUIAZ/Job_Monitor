-- =============================================
-- Author:		RTG
-- Create date: 9/2019
-- Description:	Insert Job Outcomes
-- =============================================
CREATE PROCEDURE [job].[INSERT_Outcomes] 
AS
BEGIN

--Synchronize the target table with refreshed data from source table
MERGE [job].[Outcomes] AS TARGET
USING [stg].[Outcomes] AS SOURCE 
ON (
 TARGET.[job_id] = SOURCE.[job_id] 
AND TARGET.[serverName] = SOURCE.[serverName]
AND TARGET.[DatacenterName] = SOURCE.[DatacenterName]
AND TARGET.[last_run_date] = SOURCE.[last_run_date]
AND TARGET.[last_run_time] = SOURCE.[last_run_time]
AND TARGET.[DataCenterName] = SOURCE.[DataCenterName]
AND TARGET.[last_run_duration] = SOURCE.[last_run_duration]
AND TARGET.[last_run_outcome] =  SOURCE.[last_run_outcome]
AND TARGET.[last_outcome_message] = SOURCE.[last_outcome_message]
AND TARGET.[Active] = SOURCE.[Active])

WHEN MATCHED
AND TARGET.[ServerName] <> SOURCE.[ServerName] 
then update set
TARGET.[serverName] = SOURCE.[serverName]
,TARGET.[last_run_outcome] = SOURCE.[last_run_outcome]


--When no records are matched, insert the incoming records from source table to target table
WHEN NOT MATCHED BY TARGET 
THEN INSERT ([job_id],[Active],[serverName],[DataCenterName],[last_run_outcome],[last_outcome_message],[last_run_date],[last_run_time],[last_run_duration],[ModifiedByUser]) 
VALUES (SOURCE.[job_id],SOURCE.[Active], SOURCE.[serverName], SOURCE.[DataCenterName], SOURCE.[last_run_outcome], SOURCE.[last_outcome_message], SOURCE.[last_run_date],[last_run_time],[last_run_duration],'SSIS');

END