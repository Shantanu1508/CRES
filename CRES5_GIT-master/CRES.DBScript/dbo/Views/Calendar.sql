


CREATE VIEW [dbo].[Calendar] AS
SELECT 
[Date]
,[Month]
,[Quarter]
,[Year]
,[IsWeekend]
,[IsHoliday]
,[PriorMonthEnd]
,[PriorQuarterEnd]
,[PriorYearEnd]
,[DateSlicer]
,[MonthSlicer]
,[YearSlicer]
,[YTDSlicer]
,isholidayBI=  Case When H.HoliDayTypeID = 411  then 1 else 0 end
, DateSlicerBI = Case when Date = GetDate() THEN'Today'
					else Convert (varchar(10), Date) end 

,  PrioryearEndbi = DATEADD(dd, -1, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))
FROM [DW].[CalendarBI] C
left join App.HoliDays H On C.Date = H.HoliDayDate and HoliDayTypeID = 411


