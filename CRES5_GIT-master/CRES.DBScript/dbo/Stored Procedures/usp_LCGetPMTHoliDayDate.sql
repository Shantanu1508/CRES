
CREATE PROCEDURE [dbo].[usp_LCGetPMTHoliDayDate] 
 

AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 


	select CONVERT(NVARCHAR(256),[HoliDayDate],101)   as 'PMT Date'			
	from App.HoliDays hd
	Inner join App.HolidaysMaster l1 on l1.HolidayMasterID = hd.HolidayTypeID
	where l1.CalendarName = 'US'


	---OLD
--select  CONVERT(NVARCHAR(256),[HoliDayDate],101)   as  'PMT Date'					
--from App.HoliDays hd
--inner join Core.Lookup l1  on l1.LookupID = hd.HoliDayTypeID  and name='PMT Date'
  


	SET TRANSACTION ISOLATION LEVEL READ COMMITTED

END
