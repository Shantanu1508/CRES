
CREATE PROCEDURE [DW].[usp_Calculations_CalendarPeriodBI]
AS
BEGIN
      SET NOCOUNT ON;
      
      TRUNCATE TABLE dw.CalendarPeriodBI

      INSERT INTO dw.CalendarPeriodBI
      SELECT CONVERT(DATE,GETDATE()),'Today'

      INSERT INTO dw.CalendarPeriodBI
      SELECT Date,'Last Business Day'
      FROM dw.CalendarBI
      WHERE Date = (SELECT [Date] from dw.CalendarBI WHERE DateSlicer = 'Last Close') 

      INSERT INTO dw.CalendarPeriodBI
      SELECT  [date],'This Month'
      FROM dw.CalendarBI
      WHERE [date] between dateadd(d,1, eomonth(getdate(),-1)) and eomonth(getdate(),0)
      ORDER BY Date DESC

      INSERT INTO dw.CalendarPeriodBI
      SELECT  [date],'This Quarter'
      FROM dw.CalendarBI
      WHERE [date] between DATEADD(qq, DATEDIFF(qq, 0, GETDATE()) , 0) and dateadd(dd,-1, DATEadd(qq, 1, DATEADD(qq, DATEDIFF(qq, 0, GETDATE()) , 0)))
      ORDER BY Date DESC

      INSERT INTO dw.CalendarPeriodBI
      SELECT  [date],'This Year'
      FROM dw.CalendarBI
      WHERE [date] between dateadd(d,1, eomonth(getdate(),-month(getdate()))) and eomonth(getdate(),12-month(getdate()) )
      ORDER BY Date DESC

      INSERT INTO dw.CalendarPeriodBI
      SELECT  [date],'Last Month'
      FROM dw.CalendarBI
      WHERE [date] between dateadd(d,1, eomonth(getdate(),-2)) and eomonth(getdate(),-1)
      ORDER BY Date DESC

      INSERT INTO dw.CalendarPeriodBI
      SELECT  [date],'Last Quarter'
      FROM dw.CalendarBI
      WHERE [date] between DATEADD(qq, DATEDIFF(qq, 0, GETDATE()) - 1, 0) and DATEADD(dd, -1, DATEADD(qq, DATEDIFF(qq, 0, GETDATE()), 0))
      ORDER BY Date DESC
      
      INSERT INTO dw.CalendarPeriodBI
      SELECT  [date],'Last Year'
      FROM dw.CalendarBI
      WHERE [date] between dateadd(d,1, eomonth(getdate(),-month(getdate())-12)) and eomonth(getdate(),-month(getdate()) )
      ORDER BY Date DESC
      
      INSERT INTO dw.CalendarPeriodBI
      SELECT  [date],'Next Month'
      FROM dw.CalendarBI
      WHERE [date] between dateadd(d,1, eomonth(getdate(),0)) and eomonth(getdate(),1)
      ORDER BY Date DESC

      INSERT INTO dw.CalendarPeriodBI
      SELECT  [date],'Next Quarter'
      FROM dw.CalendarBI
      WHERE [date] between dateadd(qq,1,DATEADD(qq, DATEDIFF(qq, 0, GETDATE()) , 0)) and dateadd(qq,2,DATEADD(dd, -1, DATEADD(qq, DATEDIFF(qq, 0, GETDATE()), 0)))
      ORDER BY Date DESC
      
      INSERT INTO dw.CalendarPeriodBI
      SELECT  [date],'Next Year'
      FROM dw.CalendarBI
      WHERE [date] between dateadd(d,1, eomonth(getdate(),12-month(getdate()))) and eomonth(getdate(),24-month(getdate()) )
      ORDER BY Date DESC

      INSERT INTO dw.CalendarPeriodBI
      SELECT  [date],'This Week'
      FROM dw.CalendarBI
      WHERE [date] between dateadd(ww,1, convert(date,getdate()-6-datepart(w,getdate()))) and dateadd(ww,1, convert(date,getdate()-datepart(w,getdate())))
      ORDER BY Date DESC

      INSERT INTO dw.CalendarPeriodBI
      SELECT  [date],'Last Week'
      FROM dw.CalendarBI
      WHERE [date] between dateadd(ww,0, convert(date,getdate()-6-datepart(w,getdate()))) and dateadd(ww,0, convert(date,getdate()-datepart(w,getdate())))
      ORDER BY Date DESC
      
      INSERT INTO dw.CalendarPeriodBI
      SELECT  [date],'Next Week'
      FROM dw.CalendarBI
      WHERE [date] between dateadd(ww,2, convert(date,getdate()-6-datepart(w,getdate()))) and dateadd(ww,2, convert(date,getdate()-datepart(w,getdate())))
      ORDER BY Date DESC
END


