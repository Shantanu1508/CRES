CREATE View [dbo].[LastEndingBal]
As

Select CreNoteid,MAX(Periodenddate)Periodenddate from DW.[NotePeriodicCalcBI]
where PeriodendDate = Eomonth (PeriodendDate,0) and Endingbalance <> 0
and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'

group by CRENoteid

