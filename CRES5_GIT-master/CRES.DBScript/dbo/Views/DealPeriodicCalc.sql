
CREATE View [dbo].[DealPeriodicCalc]
as
Select D.creDealID
, D.DealName
, Periodenddate
,Datename(month, Periodenddate) MonthBI, 
Year(Periodenddate)YearBI

, SUM(BeginningBalance)BeginningBalance
, [FinancingSourceBI] FinancingSource 
,[Status]from 
[DW].[NotePeriodicCalcBI]  NC
Inner join [DW].[NoteBI] N on NC.Noteid = N.Noteid
Inner join Dw.Dealbi D on D.dealid = N.Dealid
where AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
and D.Status = 323 

and Periodenddate = eomonth(Periodenddate,0)
group By d.creDealid, Month(Periodenddate), Year(Periodenddate)
, D.Dealname
, Periodenddate
, [FinancingSourceBI]
,Status



