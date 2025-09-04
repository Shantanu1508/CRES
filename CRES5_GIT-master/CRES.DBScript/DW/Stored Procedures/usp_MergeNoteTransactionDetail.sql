

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


--IF EXISTS(Select top 1 [NoteTransactionDetailAutoID] from [DW].[L_NoteTransactionDetailBI])
--BEGIN

--Delete from [DW].[NoteTransactionDetailBI] where NoteID in (Select Distinct NoteID from [DW].[L_NoteTransactionDetailBI])

Truncate table [DW].[NoteTransactionDetailBI] 
	
	
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
inner join core.account acc on acc.accountid = n.account_accountid
left join cre.servicermaster sm on sm.ServicerMasterID = nt.ServicerMasterID
left join core.lookup lor on lor.lookupid = nt.OverrideReason
left join cre.TranscationReconciliation tr on tr.TranscationID = nt.TranscationReconciliationID

where acc.isdeleted <> 1
--Select
--te.NoteTransactionDetailID,
--te.NoteID,
--te.CRENoteID,
--te.TransactionDate,
--te.Amount,
--te.RelatedtoModeledPMTDate,
--te.ServicingAmount,
--te.CalculatedAmount,
--te.Delta,
--te.M61Value,
--te.ServicerValue,
--te.Ignore,
--te.OverrideValue,
--te.comments,
--te.PostedDate,
--te.ServicerMasterID,
--te.ServicerMasterBI,
--te.Deleted,
--te.CreatedBy,
--te.CreatedDate,
--te.UpdatedBy,
--te.UpdatedDate,
--te.TransactionTypeText,
--te.TranscationReconciliationID,
--te.RemittanceDate,
--te.Exception,
--te.Adjustment,
--te.ActualDelta,
--te.NoteTransactionDetailAutoID,
--te.OverrideReason,
--te.OverrideReasonBI,
--te.BerAddlint ,
--te.InterestAdj,
--te.AddlInterest,
--te.TotalInterest,
--te.BatchLogID
--From DW.L_NoteTransactionDetailBI te



--END


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

