CREATE TABLE [DW].[TransactionByEntityBI] (
    [TransactionByEntityBI_AutoID] INT              IDENTITY (1, 1) NOT NULL,
    [TransactionEntryAutoID]       INT              NULL,
    [TransactionEntryID]           UNIQUEIDENTIFIER NOT NULL,
    [NoteID]                       UNIQUEIDENTIFIER NULL,
    [CRENoteID]                    NVARCHAR (256)   NULL,
    [EntityName]                   NVARCHAR (256)   NULL,
    [PctAllocation]                DECIMAL (28, 15) NULL,
    [Date]                         DATETIME         NULL,
    [Amount]                       DECIMAL (28, 15) NULL,
    [Type]                         NVARCHAR (128)   NULL,
    [CreatedBy]                    NVARCHAR (256)   NULL,
    [CreatedDate]                  DATETIME         NULL,
    [UpdatedBy]                    NVARCHAR (256)   NULL,
    [UpdatedDate]                  DATETIME         NULL,
    [FeeName]                      NVARCHAR (256)   NULL,
    [AnalysisID]                   UNIQUEIDENTIFIER NULL,
    [AnalysisName]                 NVARCHAR (256)   NULL,
    CONSTRAINT [PK_TransactionByEntityBI_TransactionByEntityBI_AutoID] PRIMARY KEY CLUSTERED ([TransactionByEntityBI_AutoID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [iTransactionByEntityBI_CRENoteID]
    ON [DW].[TransactionByEntityBI]([CRENoteID] ASC);


GO
CREATE NONCLUSTERED INDEX [iTransactionByEntityBI_NoteID_Date_Type_EntityName]
    ON [DW].[TransactionByEntityBI]([NoteID] ASC, [Date] ASC, [Type] ASC, [EntityName] ASC);


GO
CREATE NONCLUSTERED INDEX [iTransactionByEntityBI_TransactionEntryAutoID]
    ON [DW].[TransactionByEntityBI]([TransactionEntryAutoID] ASC);

