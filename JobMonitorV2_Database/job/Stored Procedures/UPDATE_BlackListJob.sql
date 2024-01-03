-- =============================================
-- Author:		RTG
-- Create date: 10/18/2019
-- Description:	Update a job to indicate its blacklisted.
-- =============================================
CREATE PROCEDURE [job].[UPDATE_BlackListJob]
	-- Add the parameters for the stored procedure here
	@Job_id uniqueidentifier
AS
BEGIN
	
	UPDATE [job].[Details]
    SET [IsBlacklisted] = 1
 WHERE [Job_id] = @Job_id

 	UPDATE [job].[DetailsCompiledData]
    SET [IsBlacklisted] = 1
 WHERE [Job_id] = @Job_id

END