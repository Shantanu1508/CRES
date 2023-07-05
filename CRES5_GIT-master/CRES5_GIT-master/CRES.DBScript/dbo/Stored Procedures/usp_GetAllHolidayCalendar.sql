

--  [dbo].[usp_GetAllHolidayCalendar]   'B0E6697B-3534-4C09-BE0A-04473401AB93'
CREATE PROCEDURE [dbo].[usp_GetAllHolidayCalendar] 
(
	@UserID UNIQUEIDENTIFIER
)
AS
BEGIN
 SET NOCOUNT ON;
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  

   SELECT  CalendarName,hm.HolidayMasterID,CAST(h.HoliDayDate as Date) HoliDayDate
   from [App].[HoliDaysMaster] hm
   left join [App].[HoliDays] h on h.HolidayTypeID= hm.HolidayMasterID
   order by holidaydate asc
	
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
