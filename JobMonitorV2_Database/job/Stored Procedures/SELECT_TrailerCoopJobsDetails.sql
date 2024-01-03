-- =============================================
-- Author:		RTG
-- Create date: 6/25/2020
-- Description:	get details on Trailer Coop Jobs
-- =============================================
CREATE PROCEDURE [job].[SELECT_TrailerCoopJobsDetails] 
AS
BEGIN

 --get all jobs used in trailer coop
SELECT * FROM [job].[DetailsCompiledData]
  where (jobname like '%Trailer%' or jobname like '%azure%')
  order by servername desc

END