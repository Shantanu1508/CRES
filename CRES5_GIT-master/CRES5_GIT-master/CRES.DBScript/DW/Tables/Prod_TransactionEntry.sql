CREATE TABLE [DW].[Prod_TransactionEntry] (
    [TransactionEntryID] UNIQUEIDENTIFIER NOT NULL,
    [NoteID]             UNIQUEIDENTIFIER NULL,
    [CRENoteID]          NVARCHAR (256)   NULL,
    [Date]               DATETIME         NULL,
    [Amount]             DECIMAL (28, 15) NULL,
    [Type]               NVARCHAR (128)   NULL,
    [CreatedBy]          NVARCHAR (256)   NULL,
    [CreatedDate]        DATETIME         NULL,
    [UpdatedBy]          NVARCHAR (256)   NULL,
    [UpdatedDate]        DATETIME         NULL,
    [AnalysisID]         UNIQUEIDENTIFIER NULL,
    [FeeName]            NVARCHAR (256)   NULL,
    [StrCreatedBy]       NVARCHAR (256)   NULL,
    [GeneratedBy]        NVARCHAR (256)   NULL,
    CONSTRAINT [PK_TransactionEntryIDProd] PRIMARY KEY CLUSTERED ([TransactionEntryID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [iProd_TransactionEntry_NoteID_Date_Type]
    ON [DW].[Prod_TransactionEntry]([NoteID] ASC, [Date] ASC, [Type] ASC);

