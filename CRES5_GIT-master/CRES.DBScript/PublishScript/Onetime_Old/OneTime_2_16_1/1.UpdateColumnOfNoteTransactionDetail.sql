
Update cre.NoteTransactionDetail set cre.NoteTransactionDetail.AddlInterest = a.AddlInterest, cre.NoteTransactionDetail.TotalInterest = a.TotalInterest
From(
	Select nt.NoteTransactionDetailID,nt.NoteID,nt.TranscationReconciliationID ,tr.[AddlInterest] ,tr. [TotalInterest]
	from cre.NoteTransactionDetail nt									 
	left join cre.TranscationReconciliation tr on tr.TranscationID = nt.TranscationReconciliationID
)a
where a.NoteTransactionDetailID = cre.NoteTransactionDetail.NoteTransactionDetailID


go

Update [DW].[NoteTransactionDetailBI] set [DW].[NoteTransactionDetailBI].AddlInterest = a.AddlInterest, [DW].[NoteTransactionDetailBI].TotalInterest = a.TotalInterest
From(
	Select nt.NoteTransactionDetailID,nt.NoteID,nt.TranscationReconciliationID ,tr.[AddlInterest] ,tr. [TotalInterest]
	from cre.NoteTransactionDetail nt									 
	left join cre.TranscationReconciliation tr on tr.TranscationID = nt.TranscationReconciliationID
)a
where a.NoteTransactionDetailID = [DW].[NoteTransactionDetailBI].NoteTransactionDetailID