CREATE View  [dbo].[CalendarBI]  
as  
Select 
c.[Date]
,c.[Month]
,c.[Quarter]
,c.[Year]
,c.IsWeekend
,c.IsHoliday
,c.PriorMonthEnd
,c.PriorQuarterEnd
,c.PriorYearEnd
,c.DateSlicer
,c.MonthSlicer
,c.YearSlicer
,c.YTDSlicer
,H.HoliDayDate
,H.HoliDayTypeID
,c.isholidayBI
,c.DateSlicerBI  
from [dbo].[Calendar] C  
Inner join App.HoliDays H On C.Date = H.HoliDayDate and HoliDayTypeID = 411