-- =============================================
-- Author:		RTG
-- Create date: 2/2022
-- Description:	Update watchlist data
-- =============================================
CREATE PROCEDURE [job].[UPDATE_WatchList] 
	@jobName nvarchar(128), 
	@Threshold int,
	@AvgDuration int,
	@serverName varchar(128)
AS
BEGIN

UPDATE [job].[WatchList]
   SET
       [Threshold] = @Threshold,
       [AvgDuration] = @AvgDuration
 WHERE [ServerName] = @serverName and [Name]  = @jobName

END