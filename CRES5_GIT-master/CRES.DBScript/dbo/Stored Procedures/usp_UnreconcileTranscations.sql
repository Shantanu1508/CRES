--drop PROCEDURE [dbo].[usp_UnreconcileTranscations]
Create PROCEDURE [dbo].[usp_UnreconcileTranscations]
@TmpTrans TableTypeTranscationRecon READONLY,
@CreatedBy nvarchar(256)

AS
BEGIN


	Update cre.TranscationReconciliation
    SET 	
	PostedDate = null,
	M61Value = null,
	ServicerValue = null,
	Ignore = null,
	UpdatedBy=@CreatedBy	
    from @TmpTrans tr
    Where cre.TranscationReconciliation.Transcationid = tr.Transcationid



	--Delete Unrec records from servicinglog	
	Declare @InterestLookupId int = (Select lookupid from core.Lookup where  name = 'Interest Received' and parentid=39)
	Declare @PrincipalLookupId int = (Select lookupid from core.Lookup where  name = 'Principal Received' and parentid=39)

	Delete from cre.NotetransactionDetail where NoteTransactionDetailID in 
	(
		Select ntd.NoteTransactionDetailID
		from cre.NotetransactionDetail ntd
		inner join cre.note n on n.NoteID = ntd.NoteID
		inner join(
			Select  
			tr.DealId,
			tr.Noteid,
			tr.DateDue,
			tr.TransactionType,
			tr.Transcationid as TranscationReconciliationID
			from cre.TranscationReconciliation tr where tr.Transcationid in (Select Transcationid from @TmpTrans)
		)a on a.DealId = n.DealID and a.NoteID = ntd.NoteID and a.TranscationReconciliationID = ntd.TranscationReconciliationID
		where Orig_ServicerMasterID is null
	)

	--and a.DateDue = ntd.RelatedtoModeledPMTDate and a.TransactionType = ntd.TransactionTypeText 
	Delete from CRE.[TransactionReconciliationDetail]  where Transactionid in (
select distinct Transcationid from @TmpTrans 
)

update cre.TranscationReconciliation set Deleted=1 where cre.TranscationReconciliation.ServcerMasterID=8 and  cre.TranscationReconciliation.Transcationid in (
select distinct Transcationid from @TmpTrans 
)
	---===========================================
	---Only the transaction reconciled from manual transaction file should go away and the transaction from batch upload should continue to stay.

	Update cre.NotetransactionDetail set 
	cre.NotetransactionDetail.ServicingAmount = 0 ,
	cre.NotetransactionDetail.Delta = 0 ,
	cre.NotetransactionDetail.M61Value = 0 ,
	cre.NotetransactionDetail.ServicerValue = 0 ,
	cre.NotetransactionDetail.Ignore = 0 ,
	cre.NotetransactionDetail.OverrideValue = 0 ,
	cre.NotetransactionDetail.comments = NULL ,
	cre.NotetransactionDetail.PostedDate = NULL ,
	cre.NotetransactionDetail.ServicerMasterID = b.Orig_ServicerMasterID ,
	cre.NotetransactionDetail.Deleted = 0 ,
	cre.NotetransactionDetail.TranscationReconciliationID = NULL ,
	cre.NotetransactionDetail.Exception = NULL ,
	cre.NotetransactionDetail.Adjustment = 0 ,
	cre.NotetransactionDetail.ActualDelta = 0 ,
	cre.NotetransactionDetail.OverrideReason = NULL ,
	cre.NotetransactionDetail.BerAddlint = NULL ,
	cre.NotetransactionDetail.TransactionEntryAmount = NULL ,
	cre.NotetransactionDetail.InterestAdj = 0 ,
	cre.NotetransactionDetail.AddlInterest = 0 ,
	cre.NotetransactionDetail.TotalInterest = 0 ,
	cre.NotetransactionDetail.TransactionDate = b.RelatedtoModeledPMTDate ,
	cre.NotetransactionDetail.RemittanceDate = b.RelatedtoModeledPMTDate 
	From (
		
		Select ntd.NoteTransactionDetailID,ntd.Orig_ServicerMasterID,ntd.RelatedtoModeledPMTDate
		from cre.NotetransactionDetail ntd
		inner join cre.note n on n.NoteID = ntd.NoteID
		inner join(
			Select  
			tr.DealId,
			tr.Noteid,
			tr.DateDue,
			tr.TransactionType,
			tr.Transcationid as TranscationReconciliationID
			from cre.TranscationReconciliation tr where tr.Transcationid in (Select Transcationid from @TmpTrans)
		)a on a.DealId = n.DealID and a.NoteID = ntd.NoteID and a.DateDue = ntd.RelatedtoModeledPMTDate and a.TransactionType = ntd.TransactionTypeText and a.TranscationReconciliationID = ntd.TranscationReconciliationID
		where Orig_ServicerMasterID is not null

	)b
	where cre.NotetransactionDetail.NoteTransactionDetailID = b.NoteTransactionDetailID
	---===========================================




	--Recalc note
	declare @TableTypeCalculationRequests TableTypeCalculationRequests
	
	insert into @TableTypeCalculationRequests(NoteId,StatusText,UserName,PriorityText,AnalysisID,CalcType)
	Select NoteId,'Processing',@CreatedBy,'Batch',an.AnalysisID ,775
	From Cre.Note,core.Analysis an
	where NoteID in  (Select Distinct NoteID from @TmpTrans where Ignore <> 1)
	and an.name = 'Default'
	
	exec [dbo].[usp_QueueNotesForCalculation] @TableTypeCalculationRequests,@CreatedBy,@CreatedBy, NULL, NULL, 'UnreconcileTranscations'
	
END
GO

