CREATE TABLE [DW].[L_NoteFundingBI] (
    [NoteID]            NVARCHAR (256)   NULL,
    [TransactionDate]   DATE             NULL,
    [WireConfirm]       BIT              NULL,
    [PurposeID]         INT              NULL,
    [PurposeBI]         NVARCHAR (256)   NULL,
    [Amount]            DECIMAL (28, 15) NULL,
    [DrawFundingID]     NVARCHAR (256)   NULL,
    [Comments]          NVARCHAR (MAX)   NULL,
    [AuditAddUserId]    NVARCHAR (256)   NULL,
    [AuditAddDate]      DATETIME         NULL,
    [AuditUpdateUserId] NVARCHAR (256)   NULL,
    [AuditUpdateDate]   DATETIME         NULL
);


GO
CREATE NONCLUSTERED INDEX [iL_NoteFundingBI_NoteID]
    ON [DW].[L_NoteFundingBI]([NoteID] ASC);

