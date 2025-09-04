CREATE TABLE [DW].[L_UwNoteCommitmentAdjustmentBI] (
    [NoteCommitmentAdjustmentID]            INT              NULL,
    [NoteId_F]                              INT              NULL,
    [AdjustmentDate]                        DATETIME         NULL,
    [AdjustmentAmount]                      DECIMAL (28, 15) NULL,
    [AdjustmentComment]                     NVARCHAR (MAX)   NULL,
    [AuditAddDate]                          DATETIME         NULL,
    [AuditAddUserId]                        NVARCHAR (150)   NULL,
    [AuditUpdateDate]                       DATETIME         NULL,
    [AuditUpdateUserId]                     NVARCHAR (150)   NULL,
    [NoteCommitmentAdjustmentTypeCd_F]      NVARCHAR (256)   NULL,
    [L_UwNoteCommitmentAdjustmentBI_AutoID] INT              IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_L_UwNoteCommitmentAdjustmentBI_AutoID] PRIMARY KEY CLUSTERED ([L_UwNoteCommitmentAdjustmentBI_AutoID] ASC)
);



