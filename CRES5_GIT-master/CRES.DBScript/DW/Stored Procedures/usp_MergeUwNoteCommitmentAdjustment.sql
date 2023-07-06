
CREATE PROCEDURE [DW].[usp_MergeUwNoteCommitmentAdjustment]
@BatchLogId int

AS
BEGIN

SET NOCOUNT ON

UPDATE [DW].BatchDetail
SET
BITableName = 'UwNoteCommitmentAdjustmentBI',
BIStartTime = GETDATE()
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_UwNoteCommitmentAdjustmentBI'

--===================================
Declare @BSNoteCommitmentAdjustment as Table(
	NoteCommitmentAdjustmentID int NULL,
	NoteId_F int NULL,
	AdjustmentDate datetime NULL,
	AdjustmentAmount decimal(28, 15) NULL,
	AdjustmentComment nvarchar(max) NULL,
	AuditAddDate datetime NULL,
	AuditAddUserId nvarchar(150) NULL,
	AuditUpdateDate datetime NULL,
	AuditUpdateUserId nvarchar(150) NULL,
	NoteCommitmentAdjustmentTypeCd_F nvarchar(256) NULL,
	SharedName nvarchar(max) NULL
)

Insert Into @BSNoteCommitmentAdjustment(
	NoteCommitmentAdjustmentID,
	NoteId_F,
	AdjustmentDate,
	AdjustmentAmount,
	AdjustmentComment,
	AuditAddDate,
	AuditAddUserId,
	AuditUpdateDate,
	AuditUpdateUserId,
	NoteCommitmentAdjustmentTypeCd_F,
	SharedName
)

EXEC sp_execute_remote @data_source_name  = N'RemoteReferenceData', 
@stmt = N'
Select 
NCA.NoteCommitmentAdjustmentID,
NCA.NoteId_F,
NCA.AdjustmentDate,
NCA.AdjustmentAmount,
CAST(NCA.AdjustmentComment as nvarchar(max)) as AdjustmentComment,
NCA.AuditAddDate,
NCA.AuditAddUserId,
NCA.AuditUpdateDate,
NCA.AuditUpdateUserId,
LNoteCommitmentAdjustmentTypeCd_F.NoteCommitmentAdjustmentTypeDesc as NoteCommitmentAdjustmentTypeCd_F
from tblNoteCommitmentAdjustment NCA
left join tblzCdNoteCommitmentAdjustmentType LNoteCommitmentAdjustmentTypeCd_F 
on LNoteCommitmentAdjustmentTypeCd_F.NoteCommitmentAdjustmentTypeCd = NCA.NoteCommitmentAdjustmentTypeCd_F
'
--===================================

Truncate table [DW].[UwNoteCommitmentAdjustmentBI];

INSERT INTO [DW].[UwNoteCommitmentAdjustmentBI](
	NoteCommitmentAdjustmentID,
	NoteId_F,
	AdjustmentDate,
	AdjustmentAmount,
	AdjustmentComment,
	AuditAddDate,
	AuditAddUserId,
	AuditUpdateDate,
	AuditUpdateUserId,
	NoteCommitmentAdjustmentTypeCd_F
)
SELECT 
	NoteCommitmentAdjustmentID,
	NoteId_F,
	AdjustmentDate,
	AdjustmentAmount,
	AdjustmentComment,
	AuditAddDate,
	AuditAddUserId,
	AuditUpdateDate,
	AuditUpdateUserId,
	NoteCommitmentAdjustmentTypeCd_F
FROM @BSNoteCommitmentAdjustment

DECLARE @RowCount int
SET @RowCount = @@ROWCOUNT

UPDATE [DW].BatchDetail
SET
BIEndTime = GETDATE(),
BIRecordCount = @RowCount
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_UwNoteCommitmentAdjustmentBI'

Print(char(9) +'usp_MergeUwNoteCommitmentAdjustment - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

END
