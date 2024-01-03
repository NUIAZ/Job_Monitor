USE [msdb]
GO

/****** Object:  StoredProcedure [dbo].[GetFailedJobs_StepDetails]    Script Date: 1/3/2024 10:38:57 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		RTG
-- Create date: 11/30/2021
-- Description:	Get failed job steps in last XX hours
-- =============================================
CREATE PROCEDURE [dbo].[GetFailedJobs_StepDetails](@hours int, @jobId uniqueidentifier)
AS
BEGIN
SELECT [step_id],[step_name],[message] as 'Message',[run_status] as 'Status',[dbo].[udf_convert_int_time]([run_time]) as 'Time'
,[dbo].[agent_datetime]([run_date],[run_time]) as 'Date',[retries_attempted] as 'Retries'
from [dbo].[sysjobhistory] h
WHERE msdb.dbo.agent_datetime(h.run_date, h.run_time) >= dateadd(hour, -@hours, getdate())
 -- and h.Step_id <> 0  -- Exclude 'Outcome' step
  and h.Job_id = @jobId
  order by h.run_date,Time, step_id
END

--6008A2A1-EECD-4AC9-8FFB-2AB1BBD07D3A
GO


