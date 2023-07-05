


CREATE PROCEDURE [DW].[usp_Calculations_CalendarBI]
AS
BEGIN
	SET NOCOUNT ON;

	declare @lastClose as Date
	
	/* Updating Date Slicer */
	UPDATE [DW].CalendarBI
	SET DateSlicer = CONVERT(VARCHAR,[DATE])
	WHERE DateSlicer in ('Today','Last Close')

	UPDATE [DW].CalendarBI
	SET DateSlicer = 'Today'
	WHERE [DAte] = CONVERT(DATE,GETDATE())

	set @lastClose = (SELECT MAX([Date]) FROM [DW].CalendarBI WHERE Date < CONVERT(DATE,GETDATE()) and IsWeekend = 0 and IsHoliday = 0)

	UPDATE [DW].CalendarBI
	set DateSlicer = 'Last Close' 
	where [Date] = @lastClose

	/* Updating Month Slicer*/

	IF DAY(GETDATE()) = 1
	BEGIN 
		UPDATE [DW].CalendarBI
		SET MonthSlicer = CASE WHEN [Month] < 10 THEN '0' + CONVERT(VARCHAR,[Month]) ELSE CONVERT(VARCHAR,[Month]) END
		WHERE MonthSlicer = 'Current'

		UPDATE [DW].CalendarBI
		SET MonthSlicer = 'Current'
		WHERE [Year] = YEAR(GETDATE()) and [Month] = MONTH(GETDATE())

	END

	/* Updating Year Slicer */
	
	IF (day(GETDATE()) = 1 and month(GETDATE()) = 1)
	BEGIN	
		UPDATE [DW].CalendarBI
		set YearSlicer = CONVERT(VARCHAR,[Year])
		where YearSlicer = 'Current'

		UPDATE [DW].CalendarBI
		set YearSlicer = 'Current'
		where [Year] = YEAR(GETDATE())

	END

	/* Updating YTD Slicer */

	UPDATE [DW].CalendarBI
	SET YTDSlicer = CASE WHEN [Month] < MONTH(GETDATE()) OR ([Month] = MONTH(GETDATE()) AND DAY([Date]) <= DAY(GETDATE())) 
						THEN 'YTD'
						ELSE CONVERT(VARCHAR,[Date],101) END




	
END					 
