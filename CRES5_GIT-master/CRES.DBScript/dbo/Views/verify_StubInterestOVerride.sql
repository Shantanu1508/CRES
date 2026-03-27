-- View
CREATE view [dbo].verify_StubInterestOVerride
as

Select 
N.Noteid
, CreNoteid
, N.Dealid
, Min(T.Date) Date
, Type
, FirstPaymentDate
, DealName
,[FirstRateIndexResetDate]
,[InitialIndexValueOverride]
, Sum(X.Amount) LIBOR
, AnalysisID

 from [CRE].[TransactionEntry] T
Outer apply (
	Select (Date)Date, (Amount)Amount from [CRE].[TransactionEntry]  T1
	Where T.AccountID =  T1.AccountID and T.AnalysisID = T1.AnalysisID and T.Date = T1.Date
	and Type = 'LIBORPercentage'
)X
Inner Join Cre.Note N on N.Account_AccountID = T.AccountID
Inner join cre.deal D on D.DealID = N.DealID
Where Type = (Case when exists (Select NoteID from TransactionEntry


				Where Type = 'StubInterest') Then 'StubInterest' Else 'InterestPaid'End

				)





Group By N.Noteid
, CreNoteid
, N.Dealid
, DealName
,FirstPaymentDate
,[FirstRateIndexResetDate]
,[InitialIndexValueOverride]
, T.AnalysisID
,Type

