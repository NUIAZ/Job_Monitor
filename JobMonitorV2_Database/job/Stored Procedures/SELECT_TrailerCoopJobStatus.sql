-- =============================================
-- Author:		RTG
-- Create date: 6/25/2020
-- Description:	Provides status on Trailer Coop Jobs
-- =============================================
CREATE PROCEDURE [job].[SELECT_TrailerCoopJobStatus] 
AS
BEGIN

--count of red status color
SELECT count(*) FROM [job].[DetailsCompiledData]
  where (jobname like '%Trailer%' or jobname like '%azure%')
  and StatusColor = 'Red'

END