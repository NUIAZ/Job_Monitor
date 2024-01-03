USE [msdb]
GO

    
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


     fdsafdasf
-- =============================================
-- Author:		RTG
-- Create date: 11/30/2021
-- Description:	Get failed jobs in last 24 hours
-- =============================================
CREATE PROCEDURE [dbo].[GetFailedJobs]
AS
BEGIN
SELECT 
       sjh.[job_id]
	  ,sj.name
      ,[step_id]
      ,[step_name]
      ,[message]
      ,[run_status]
      ,CONVERT (date,convert(char(8),sjh.run_date)) as 'Date'
	  ,dbo.udf_convert_int_time(sjh.run_time) AS 'Time' 
      ,[run_duration]
      ,[retries_attempted]
      ,[server]
  FROM [msdb].[dbo].[sysjobhistory] sjh
  join msdb.dbo.sysjobs sj on sj.job_id = sjh.job_id
  where 
  CONVERT (datetime,convert(char(8),sjh.run_date)) > dateadd(hour,-24,getdate()) 
  and run_status != 1
  order by sjh.job_id, Time desc
END
GO

  
