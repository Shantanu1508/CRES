
CREATE PROCEDURE [dbo].[usp_LCGetIndexHoliDayDate] 
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		
	select CONVERT(NVARCHAR(256),[HoliDayDate],101)   as 'Index Date'				
	from App.HoliDays hd
	Inner join App.HolidaysMaster l1 on l1.HolidayMasterID = hd.HolidayTypeID
	where l1.CalendarName = 'UK'


	--inner join Core.Lookup l1  on l1.LookupID = hd.HoliDayTypeID  and name='Index Date'



	SET TRANSACTION ISOLATION LEVEL READ COMMITTED

END
