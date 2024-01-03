-- =============================================
-- Author:		RTG
-- Create date: 7/2020
-- Description:	Upload a PDF
-- =============================================
CREATE PROCEDURE [job].UPDATE_FirstAid 
	-- Add the parameters for the stored procedure here
	-- test values 
			--file name = jobMedkit_Template.pdf
			--jobname = zzz_TestJob
	@jobName nvarchar(128), 
	@firstAideFileName varchar(100)
AS
BEGIN

declare @sql nvarchar(max) ='DECLARE @pdf VARBINARY(MAX)

SELECT @pdf = BulkColumn FROM OPENROWSET(BULK N''\\ILDWHSQL01\Deployed\JobMonitorV2\PDF\' + @firstAideFileName + ''', SINGLE_BLOB) AS Document;

SELECT @pdf, DATALENGTH(@pdf)

UPDATE [job].[Details]
SET  [FirstAidDoc]=@pdf
 WHERE JobName = ''' + @jobName + ''''

 print @sql

 EXEC SP_EXECUTESQL  @sql
       

END