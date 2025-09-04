CREATE TABLE [DW].[L_BSNoteFundingBI] (
    [NoteID]                   NVARCHAR (256)   NULL,
    [TransactionDate]          DATE             NULL,
    [WireConfirm]              BIT              NULL,
    [PurposeID]                INT              NULL,
    [PurposeBI]                NVARCHAR (256)   NULL,
    [Amount]                   DECIMAL (28, 15) NULL,
    [DrawFundingID]            NVARCHAR (256)   NULL,
    [Comments]                 NVARCHAR (MAX)   NULL,
    [AuditAddUserId]           NVARCHAR (256)   NULL,
    [AuditAddDate]             DATETIME         NULL,
    [AuditUpdateUserId]        NVARCHAR (256)   NULL,
    [AuditUpdateDate]          DATETIME         NULL,
    [L_BSNoteFundingBI_AutoID] INT              IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_L_BSNoteFundingBI_AutoID] PRIMARY KEY CLUSTERED ([L_BSNoteFundingBI_AutoID] ASC)
);




GO
CREATE NONCLUSTERED INDEX [iL_BSNoteFundingBI_NoteID]
    ON [DW].[L_BSNoteFundingBI]([NoteID] ASC);

