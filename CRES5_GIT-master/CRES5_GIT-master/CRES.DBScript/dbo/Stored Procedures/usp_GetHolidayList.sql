
CREATE PROCEDURE [dbo].[usp_GetHolidayList]	 
AS
 BEGIN
  
	select HoliDayDate,
	HoliDayTypeID as HoliDayTypeID, 
	CalendarName as HolidayTypeText         
	from App.HoliDays hd 
	left join app.HoliDaysMaster hdm on hdm.HolidayMasterID = hd.HoliDayTypeID



 -- left join Core.Lookup l1  on l1.LookupID = hd.HoliDayTypeID  
 -- l1.Name as HolidayTypeText
	 
 END


 