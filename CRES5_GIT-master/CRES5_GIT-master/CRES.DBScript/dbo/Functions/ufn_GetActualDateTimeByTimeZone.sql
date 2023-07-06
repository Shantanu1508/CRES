-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
Create FUNCTION [dbo].[ufn_GetActualDateTimeByTimeZone] 
(
	@Date Datetime,
	@TimeZone nvarchar(256)
)
RETURNS  Datetime
AS
BEGIN

  
   RETURN CONVERT(datetimeoffset, getdate()) AT TIME ZONE @TimeZone


END
