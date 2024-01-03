
CREATE FUNCTION [dbo].[udf_IntToDateTime] (@RunDate INT, @RunTime INT) RETURNS DATETIME
BEGIN

/*************************************************************
Purpose:   Takes a pair of integers representing date and time
          in the form  YYYYMMDD and  HHMMSS
          and converts them to a date time string
          (using format 113 as this is familiar and convenient)
          
          This date time string is then converted to DATETIME datatype 
          and returned as the result.

Author:        ChillyDBA
History:   4 May 2010 - Initial Issue

***************************************************************/

   DECLARE @RunDateText    VARCHAR(16),
           @RunTimeText    VARCHAR(12),
           @OutputText     VARCHAR(20),
           @OutputDate     DATETIME

   SELECT  @RunDateText = '00000000' + CAST(@RunDate AS VARCHAR(16)),
           @RunTimeText = '000000' + CAST(@RunTime AS VARCHAR(12))

   SELECT  @RunDateText = RIGHT(@RunDateText ,8),
           @RunTimeText = RIGHT(@RunTimeText ,6)

   SELECT @OutputText = 
                   SUBSTRING(@RunDateText, 1, 4) + '-' +  
                   SUBSTRING(@RunDateText, 5, 2) + '-' +  
                   SUBSTRING(@RunDateText, 7, 2) + ' ' + 
                   SUBSTRING(@RunTimeText, 1, 2) + ':' +  
                   SUBSTRING(@RunTimeText, 3, 2) + ':' +  
                   SUBSTRING(@RunTimeText, 5, 2) 

   SELECT @OutputDate = CAST(@OutputText AS DATETIME)

   RETURN CONVERT(DATETIME, @OutputDate, 113)

END