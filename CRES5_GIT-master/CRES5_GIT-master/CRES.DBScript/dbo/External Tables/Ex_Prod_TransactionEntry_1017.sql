CREATE EXTERNAL TABLE [dbo].[Ex_Prod_TransactionEntry_1017] (
    [TransactionEntryID] UNIQUEIDENTIFIER NOT NULL,
    [NoteID] UNIQUEIDENTIFIER NULL,
    [Date] DATETIME NULL,
    [Amount] DECIMAL (28, 15) NULL,
    [Type] NVARCHAR (MAX) NULL,
    [CreatedBy] NVARCHAR (256) NULL,
    [CreatedDate] DATETIME NULL,
    [UpdatedBy] NVARCHAR (256) NULL,
    [UpdatedDate] DATETIME NULL,
    [AnalysisID] UNIQUEIDENTIFIER NULL,
    [FeeName] NVARCHAR (256) NULL,
    [StrCreatedBy] NVARCHAR (256) NULL,
    [GeneratedBy] NVARCHAR (256) NULL
)
    WITH (
    DATA_SOURCE = [RemoteReferenceCRESProductionBK_Temp],
    SCHEMA_NAME = N'CRE',
    OBJECT_NAME = N'TransactionEntry'
    );

