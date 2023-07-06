CREATE TABLE [IO].[OUT_NoteTransactions] (
    [OUT_NoteTransactionsID] UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [BatchLogID]             UNIQUEIDENTIFIER NOT NULL,
    [CreatedBy]              NVARCHAR (256)   NULL,
    [CreatedDate]            DATETIME         NULL,
    [UpdatedBy]              NVARCHAR (256)   NULL,
    [UpdatedDate]            DATETIME         NULL,
    CONSTRAINT [PK_OUT_NoteTransactionsID] PRIMARY KEY CLUSTERED ([OUT_NoteTransactionsID] ASC)
);

