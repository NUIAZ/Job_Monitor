USE [msdb]
GO

/****** Object:  StoredProcedure [dbo].[GetJobRunDuration]    Script Date: 1/3/2024 10:38:43 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		RTG
-- Create date: 1/31/2022
-- Description:	Get current run duration of job
-- =============================================
CREATE PROCEDURE [dbo].[GetJobRunDuration](@jobName varchar(128))
AS
BEGIN
SELECT
    ja.job_id,
    j.name AS job_name,
	(SELECT DATEDIFF(second, ja.start_execution_date, getdate())) AS 'duration',
    ja.start_execution_date,      
    ISNULL(last_executed_step_id,0)+1 AS current_executed_step_id,
    Js.step_name
	
FROM msdb.dbo.sysjobactivity ja 
LEFT JOIN msdb.dbo.sysjobhistory jh ON ja.job_history_id = jh.instance_id
JOIN msdb.dbo.sysjobs j ON ja.job_id = j.job_id
JOIN msdb.dbo.sysjobsteps js
    ON ja.job_id = js.job_id
    AND ISNULL(ja.last_executed_step_id,0)+1 = js.step_id
WHERE
  ja.session_id = (
    SELECT TOP 1 session_id FROM msdb.dbo.syssessions ORDER BY agent_start_date DESC
  )
AND j.name = @jobName
AND start_execution_date is not null
AND stop_execution_date is null;
END

GO


