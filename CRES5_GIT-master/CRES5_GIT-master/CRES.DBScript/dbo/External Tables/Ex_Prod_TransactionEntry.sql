CREATE EXTERNAL TABLE [dbo].[Ex_Prod_TransactionEntry] (
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
    [GeneratedBy] NVARCHAR (256) NULL,
    [TransactionDateByRule] DATE NULL,
    [TransactionDateServicingLog] DATE NULL,
    [RemitDate] DATE NULL
)
    WITH (
    DATA_SOURCE = [RemoteReferenceCRESProduction],
    SCHEMA_NAME = N'CRE',
    OBJECT_NAME = N'TransactionEntry'
    );

