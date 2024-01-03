-- =============================================
-- Author:		RTG
-- Create date: 6/2020
-- Description:	get Job Details job ids SSIS usage
-- =============================================
CREATE PROCEDURE [job].[SELECT_DetailsJobIds] 
(
@tier int,
@serverName nvarchar(128)
)
AS
BEGIN
SELECT [Job_id]
  FROM [job].[Details]
  where ServerName = @serverName
  AND tier = @tier
END