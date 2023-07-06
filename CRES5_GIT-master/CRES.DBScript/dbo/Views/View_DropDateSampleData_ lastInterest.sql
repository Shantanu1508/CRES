CREATE VIEW [dbo].[View_DropDateSampleData_ lastInterest] AS

Select
DayoftheMonth,
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
--tr.Date
, ISNULL(StagAmount,0) StagAmount
, (ISNULL(Tr.Amount,0) - isnull(dd.TotalExpectedPayment,0)) Delta_Calculated_Vs_Actual
, Interest_after_before_Payoff = Case WHEN ActualPayoffDate is not Null and ActualPayoffDate > MonthYear THEN 'InterestAfterPayoff' 
		when ActualPayoffDate is not Null and ActualPayoffDate < MonthYear then 'InterestBeforePayoff'
		WHEN ActualPayoffDate is Null THEN 'Loan Active'
		End



From [DW].[DropDateSampleData] dd
Inner Join DW.NoteBI n on n.crenoteid = dd.noteid
Outer Apply(
	Select t.crenoteid
	,SUM(t.Amount) Amount
	--, MAx(t.Date) Date 
	from DW.TransactionEntryBI t
	Where AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
	and [Type] in ('InterestPaid','PIKInterest','StubInterest')
	and t.CRENOteid = dd.Noteid
	and MONTH(t.Date) = MONTH(dd.MonthYear) and YEAR(t.Date) = YEAR(dd.MonthYear) 
	and ABS(Datediff( d, isnull(ActualPayoffDate,'') , isnull(Date,'')) ) < 3
	--or isnull(Date,'') = isnull(FullyExtendedMaturityDate,''))
	
	group by t.crenoteid, Date
	Having Date = Max(Date)

)Tr
Outer Apply 
(

	Select t.crenoteid
	,SUM(t.Amount) StagAmount
	--, MAx(t.Date) Date 

	from DW.Staging_TransactionEntry t
	Where AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
	and [Type] in ('InterestPaid','PIKInterest','StubInterest')
	and t.CRENOteid = dd.Noteid
	and MONTH(t.Date) = MONTH(dd.MonthYear) and YEAR(t.Date) = YEAR(dd.MonthYear) 
	--and ((isnull(Date,'') = isnull(ActualPayoffDate,'') or isnull(Date,'') = isnull(FullyExtendedMaturityDate,'')))
	and ABS(Datediff( d, isnull(ActualPayoffDate,'') , isnull(Date,'')) ) < 3
	group by t.crenoteid, Date
		Having Date = Max(Date)

)StagTr
Where Month(ActualPayoffDate) =  MONTH(MonthYear)
--Where dd.Noteid = '1873'
--Where 
----(isnull(tr.Date,'') <> isnull(ActualPayoffDate,'') and isnull(Tr.Date,'') <> isnull(FullyExtendedMaturityDate,''))
----and (isnull(StagTr.Date,'') <> isnull(ActualPayoffDate,'') and isnull(StagTr.Date,'') <> isnull(FullyExtendedMaturityDate,''))
-- --dd.NoteID = '5293' 

