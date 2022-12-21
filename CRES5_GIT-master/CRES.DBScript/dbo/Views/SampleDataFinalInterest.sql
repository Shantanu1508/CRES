Create View [dbo].SampleDataFinalInterest
as
Select D.NoteID, d.TotalExpectedPayment, ActualPayoffDate , D.MonthYear, countdays from [DW].[DropDateSampleData] D
inner Join (Select dd.NoteID
			, MAX(dd.MonthYear)MonthYear
			, MIN(ABS(DATEDIFF (d,ActualPayoffDate, dd.MonthYear))) countdays
			, ActualPayoffDate
				from [DW].[DropDateSampleData] dd
Inner Join DW.NoteBI n on n.crenoteid = dd.noteid

Where Actualpayoffdate <= '8/8/2019' and dd.Noteid = Dd.NoteID and dd.monthyear = dd.MonthYear
and TotalExpectedPayment <> 0
group By Dd.Noteid, ActualPayoffDate

)x
On D.noteid = x.noteid and d.monthyear = x.monthyear
