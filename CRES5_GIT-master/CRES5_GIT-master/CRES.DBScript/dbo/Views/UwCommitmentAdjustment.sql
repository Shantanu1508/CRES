CREATE VIEW [dbo].[UwCommitmentAdjustment] AS
SELECT 
	NoteCommitmentAdjustmentID,
	Cast(NoteId_F AS Varchar(30))NoteId_F,
	AdjustmentDate,
	AdjustmentAmount,
	AdjustmentComment,
	AuditAddDate,
	AuditAddUserId,
	AuditUpdateDate,
	AuditUpdateUserId,
	NoteCommitmentAdjustmentTypeCd_F
FROM [DW].[UwNoteCommitmentAdjustmentBI]