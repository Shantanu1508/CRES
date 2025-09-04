

----Need to ask Rohit

--Update cre.NoteTransactionDetail SET cre.NoteTransactionDetail.TotalInterest = a.CalculatedAmount
--From(
--	Select NoteTransactionDetailID,CRENoteID, RelatedtoModeledPMTDate, TransactionTypeText, CalculatedAmount ,nt.TotalInterest as CashInterest ,nt.AddlInterest as  CapitalizedInterest 
--	from cre.NoteTransactionDetail Nt
--	left join cre.Note n on n.NoteID=nt.NoteID
--	left join core.account acc on acc.AccountID=n.Account_AccountID
--	Where TransactionTypeText='PIKInterestPaid' and acc.IsDeleted<>1 and (AddlInterest is NULL and TotalInterest is NULL)

--)a
--where cre.NoteTransactionDetail.NoteTransactionDetailID = a.NoteTransactionDetailID