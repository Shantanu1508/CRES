CREATE TABLE [DW].[UwNoteCommitmentAdjustmentBI] (
    [NoteCommitmentAdjustmentID]       INT              NULL,
    [NoteId_F]                         INT              NULL,
    [AdjustmentDate]                   DATETIME         NULL,
    [AdjustmentAmount]                 DECIMAL (28, 15) NULL,
    [AdjustmentComment]                NVARCHAR (MAX)   NULL,
    [AuditAddDate]                     DATETIME         NULL,
    [AuditAddUserId]                   NVARCHAR (150)   NULL,
    [AuditUpdateDate]                  DATETIME         NULL,
    [AuditUpdateUserId]                NVARCHAR (150)   NULL,
    [NoteCommitmentAdjustmentTypeCd_F] NVARCHAR (256)   NULL
);


GO
CREATE NONCLUSTERED INDEX [iUwNoteCommitmentAdjustmentBI_NoteCommitmentAdjustmentID]
    ON [DW].[UwNoteCommitmentAdjustmentBI]([NoteCommitmentAdjustmentID] ASC);


GO
CREATE NONCLUSTERED INDEX [iUwNoteCommitmentAdjustmentBI_Noteid_F]
    ON [DW].[UwNoteCommitmentAdjustmentBI]([NoteId_F] ASC);


GO
CREATE NONCLUSTERED INDEX [iUwNoteCommitmentAdjustmentBI_Noteid_F_AdjustmentDate]
    ON [DW].[UwNoteCommitmentAdjustmentBI]([NoteId_F] ASC, [AdjustmentDate] ASC);

