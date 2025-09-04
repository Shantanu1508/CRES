CREATE View [dbo].TransactionActuals
As

Select 
Dealname
,T.CRENoteID
, T.Date DueDate_TR
, T.Remitdate RemitDate_TR
,  T.Amount
,ISNULL(TransactionDateByRule,Date) as CashFlow_Date_TR
,ServicingAmount
, CalculatedAmount
,TransactionTypeText as TransactionType
,T.Type
,Delta CalculateDelta
,Adjustment
,ActualDelta
,Exception 
comments
,ServicerMasterBI as SourceType
,Ignore
, ISNull(Type,TransactionTypeText) TypeBI
from dw.TransactionEntryBI T
Left Join Dw.NoteTransactionDetailBI N on T.NoteID = N.NoteID 
and T.Date =  N.RelatedtoModeledPMTDate 
and ISNULL(T.Type,'') = ISNULL(TransactionTypeText,'')
where AnalysisName = 'Default'
and T.Type 
in ('UnusedFeeExcludedFromLevelYield', 'FloatInterest', 'InterestPaid', 
'PrepaymentFeeExcludedFromLevelYield', 'OtherFeeExcludedFromLevelYield', 'StubInterest')
and T.AccountTypeID = 1
	
