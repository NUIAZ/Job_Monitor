-- =============================================
-- Author:		RTG
-- Create date: 09/23/2019
-- Description:	Log SSIS package errors
-- =============================================
CREATE PROCEDURE [hub].[INSERT_SsisError] 
	@PackageId nvarchar(100),
    @PackageName nvarchar(200),
   @TaskName nvarchar(200),
   @ErrorCode int,
    @ErrorDescription nvarchar(max)
    
AS
BEGIN
INSERT INTO [hub].[SsisError]
           ([PackageId]
           ,[PackageName]
           ,[TaskName]
           ,[ErrorCode]
           ,[ErrorDescription]
           ,[DateOfOccurance])
     VALUES
           (@PackageId
           ,@PackageName
           ,@TaskName
           ,@ErrorCode
           ,@ErrorDescription
           ,getdate())

END