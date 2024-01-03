-- =============================================
-- Author:		RTG
-- Create date: 10/14/2019
-- Description:	Get data for Run job On Demand, 
-- then log the request. 
-- =============================================
CREATE PROCEDURE [job].[UPDATE_RunJobOnDemand] 
	-- Add the parameters for the stored procedure here
	@Job_id uniqueidentifier, @StepId int, @User varchar(100), @Result varchar(30)
AS
BEGIN

UPDATE [job].[OnDemand]
   SET 
       [Result] = @Result
 WHERE 
		[ModifiedByDate] =(SELECT MAX([ModifiedByDate]) FROM [job].[OnDemand] WHERE [Job_id] = @Job_id AND StepId = @StepId AND ModifiedByUser = @User);
END