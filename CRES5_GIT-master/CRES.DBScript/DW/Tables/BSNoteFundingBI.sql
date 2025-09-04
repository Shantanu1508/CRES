CREATE TABLE [DW].[BSNoteFundingBI] (
    [NoteID]                 NVARCHAR (256)   NULL,
    [TransactionDate]        DATE             NULL,
    [WireConfirm]            BIT              NULL,
    [PurposeID]              INT              NULL,
    [PurposeBI]              NVARCHAR (256)   NULL,
    [Amount]                 DECIMAL (28, 15) NULL,
    [DrawFundingID]          NVARCHAR (256)   NULL,
    [Comments]               NVARCHAR (MAX)   NULL,
    [AuditAddUserId]         NVARCHAR (256)   NULL,
    [AuditAddDate]           DATETIME         NULL,
    [AuditUpdateUserId]      NVARCHAR (256)   NULL,
    [AuditUpdateDate]        DATETIME         NULL,
    [BSNoteFundingBI_AutoID] INT              IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_BSNoteFundingBI_AutoID] PRIMARY KEY CLUSTERED ([BSNoteFundingBI_AutoID] ASC)
);




GO
CREATE NONCLUSTERED INDEX [iBSNoteFundingBI_NoteID]
    ON [DW].[BSNoteFundingBI]([NoteID] ASC);

