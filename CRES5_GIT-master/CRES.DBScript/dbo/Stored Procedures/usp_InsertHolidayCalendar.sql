CREATE PROCEDURE [dbo].[usp_InsertHolidayCalendar]
	(
	 @CalendarName nvarchar(256),
	 @UserID UNIQUEIDENTIFIER
	)

AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO App.HoliDaysMaster(CalendarName,CreatedBy,CreatedDate)
	VALUES(@CalendarName,@UserID,getdate())

END


