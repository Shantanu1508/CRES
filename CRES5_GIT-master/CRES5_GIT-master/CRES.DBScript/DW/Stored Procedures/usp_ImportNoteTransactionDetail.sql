
CREATE PROCEDURE [DW].[usp_ImportNoteTransactionDetail]
	@BatchLogId int,@LastBatchStart datetime, @CurrentBatchStart datetime
AS
BEGIN
	SET NOCOUNT ON;

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 


	INSERT INTO [DW].BatchDetail (BatchLogId,LandingTableName,LandingStartTime)
	VALUES (@BatchLogId,'L_NoteTransactionDetailBI',GETDATE())

		DECLARE @id int,@RowCount int
	SET @id = (SELECT @@IDENTITY)


	Truncate table [DW].[L_NoteTransactionDetailBI]

	INSERT INTO [DW].[L_NoteTransactionDetailBI](
NoteTransactionDetailID,
NoteID,
CRENoteID,
TransactionDate,
Amount,
RelatedtoModeledPMTDate,
ServicingAmount,
CalculatedAmount,
Delta,
M61Value,
ServicerValue,
Ignore,
OverrideValue,
comments,
PostedDate,
ServicerMasterID,
ServicerMasterBI,
Deleted,
CreatedBy,
CreatedDate,
UpdatedBy,
UpdatedDate,
TransactionTypeText,
TranscationReconciliationID,
RemittanceDate,
Exception,
Adjustment,
ActualDelta,
NoteTransactionDetailAutoID,
OverrideReason,
OverrideReasonBI,
BerAddlint ,
InterestAdj,
AddlInterest,
TotalInterest,
BatchLogID
)
Select nt.NoteTransactionDetailID,
nt.NoteID,
n.CRENoteID,
nt.TransactionDate,
nt.Amount,
nt.RelatedtoModeledPMTDate,
nt.ServicingAmount,
nt.CalculatedAmount,
nt.Delta,
nt.M61Value,
nt.ServicerValue,
nt.Ignore,
nt.OverrideValue,
nt.comments,
nt.PostedDate,
nt.ServicerMasterID,
sm.servicername as ServicerMasterBI,
nt.Deleted,
nt.CreatedBy,
nt.CreatedDate,
nt.UpdatedBy,
nt.UpdatedDate,
nt.TransactionTypeText,
nt.TranscationReconciliationID,
nt.RemittanceDate,
nt.Exception,
nt.Adjustment,
nt.ActualDelta,
nt.NoteTransactionDetailAutoID,
nt.OverrideReason,
lor.name as OverrideReasonBI,
nt.BerAddlint ,
nt.InterestAdj,
nt.AddlInterest,
nt.TotalInterest,
tr.BatchLogID
From CRE.NoteTransactionDetail nt 
inner join cre.note n on n.noteid = nt.noteid
left join cre.servicermaster sm on sm.ServicerMasterID = nt.ServicerMasterID
left join core.lookup lor on lor.lookupid = nt.OverrideReason
left join cre.TranscationReconciliation tr on tr.TranscationID = nt.TranscationReconciliationID
WHERE nt.NoteID in 
(
	Select Distinct NoteID From(
		Select	NoteID,[NoteTransactionDetailAutoID],[CreatedDate],[UpdatedDate]	From cre.NoteTransactionDetail
		EXCEPT
		Select	NoteId,[NoteTransactionDetailAutoID],[CreatedDate],[UpdatedDate]	From DW.NoteTransactionDetailBI
	)a
)	
	

SET @RowCount = @@ROWCOUNT
	Print(char(9) +'usp_ImportNoteTransactionDetail - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

	UPDATE [DW].BatchDetail
	SET
	LandingEndTime = GETDATE(),
	LandingRecordCount = @RowCount
	WHERE BatchDetailId = @id

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END


