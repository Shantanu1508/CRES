CREATE VIEW [dbo].[View_DropDateSampleData] AS

Select
dd.NoteID,
dd.DealName,
dd.NoteName,
dd.TotalInterest,
dd.ExpectedPaymentDueToBillingCutoffDate,
dd.Delta,
dd.MonthYear,
dd.RollingAdjustedVarianceFromPriorPeriod,
dd.TotalExpectedPayment,
n.ActualPayoffDate,
n.DayoftheMonth as DropDate,
ISNULL(Tr.Amount,0) as Calc_Interest

From [DW].[DropDateSampleData] dd
Inner Join DW.NoteBI n on n.crenoteid = dd.noteid
Outer Apply(
	Select t.crenoteid,SUM(t.Amount) Amount
	from DW.TransactionEntryBI t
	Where AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
	and [Type] in ('InterestPaid','PIKInterest','StubInterest')
	and t.CRENOteid = dd.Noteid
	and MONTH(t.Date) = MONTH(dd.MonthYear) and YEAR(t.Date) = YEAR(dd.MonthYear) 
	and t.AccountTypeID = 1
	group by t.crenoteid
)Tr



