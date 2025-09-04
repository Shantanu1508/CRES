
Print('Update Cash and Capitalized interest as 0 if OverrideValue = 0 and comments = ''PMT Not Received'' ')
go

--Update cre.notetransactiondetail set AddlInterest = 0,TotalInterest = 0
--Where NoteTransactionDetailID in (
--	Select nt.NoteTransactionDetailID ---,n.crenoteid, nt.OverrideValue,nt.comments,nt.AddlInterest,nt.TotalInterest
--	from cre.notetransactiondetail nt
--	Inner join cre.note n on n.noteid = nt.noteid
--	where OverrideValue = 0 and nt.comments = 'PMT Not Received'
--)



--Update cre.notetransactiondetail set AddlInterest = 0,TotalInterest = 0
--Where NoteTransactionDetailID in (
--	Select nt.NoteTransactionDetailID,l.name as OverrideReason,nt.OverrideReason,nt.comments,n.crenoteid, nt.OverrideValue,nt.comments,nt.AddlInterest,nt.TotalInterest,M61Value,ServicerValue
--	from cre.notetransactiondetail nt
--	Inner join cre.note n on n.noteid = nt.noteid
--	Inner join core.Account acc on acc.AccountID = n.Account_AccountID
--	Left Join core.Lookup l on l.LookupID = nt.OverrideReason
--	where acc.IsDeleted <> 1
--	and OverrideValue = 0 
--	and l.name = 'PMT Not Received'
--	and (nt.AddlInterest <> 0 or nt.TotalInterest <> 0)
--)
