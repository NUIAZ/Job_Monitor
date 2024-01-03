-- =============================================
-- Author:		Ryan Gross
-- Create date: 9/2019
-- Description:	Select job details to purge
-- =============================================
CREATE PROCEDURE [hub].[SELECT_DetailsForPurge] 
AS
BEGIN

SELECT [Job_id]
      ,[ServerName]
      ,[JobName]
      ,[DaysOfHistoryToRetain]
  FROM [job].[Details]

END