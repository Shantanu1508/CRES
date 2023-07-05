

CREATE PROCEDURE [DW].[usp_MergeNoteTransactionDetail]
@BatchLogId int
AS
BEGIN

SET NOCOUNT ON


SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 


UPDATE [DW].BatchDetail
	SET
	BITableName = 'NoteTransactionDetailBI',
	BIStartTime = GETDATE()
	WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_NoteTransactionDetailBI'


IF EXISTS(Select top 1 [NoteTransactionDetailAutoID] from [DW].[L_NoteTransactionDetailBI])
BEGIN

Delete from [DW].[NoteTransactionDetailBI] where NoteID in (Select Distinct NoteID from [DW].[L_NoteTransactionDetailBI])
	
	
INSERT INTO [DW].[NoteTransactionDetailBI]
(NoteTransactionDetailID,
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

Select
te.NoteTransactionDetailID,
te.NoteID,
te.CRENoteID,
te.TransactionDate,
te.Amount,
te.RelatedtoModeledPMTDate,
te.ServicingAmount,
te.CalculatedAmount,
te.Delta,
te.M61Value,
te.ServicerValue,
te.Ignore,
te.OverrideValue,
te.comments,
te.PostedDate,
te.ServicerMasterID,
te.ServicerMasterBI,
te.Deleted,
te.CreatedBy,
te.CreatedDate,
te.UpdatedBy,
te.UpdatedDate,
te.TransactionTypeText,
te.TranscationReconciliationID,
te.RemittanceDate,
te.Exception,
te.Adjustment,
te.ActualDelta,
te.NoteTransactionDetailAutoID,
te.OverrideReason,
te.OverrideReasonBI,
te.BerAddlint ,
te.InterestAdj,
te.AddlInterest,
te.TotalInterest,
te.BatchLogID
From DW.L_NoteTransactionDetailBI te



END


	DECLARE @RowCount int
	SET @RowCount = @@ROWCOUNT



	UPDATE [DW].BatchDetail
	SET
	BIEndTime = GETDATE(),
	BIRecordCount = @RowCount
	WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_NoteTransactionDetailBI'

	Print(char(9) +'usp_MergeNoteTransactionDetail - ROWCOUNT = '+cast(@RowCount  as varchar(100)));



SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END

