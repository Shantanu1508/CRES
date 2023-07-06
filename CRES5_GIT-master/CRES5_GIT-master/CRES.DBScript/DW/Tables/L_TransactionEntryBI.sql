CREATE TABLE [DW].[L_TransactionEntryBI] (
    [TransactionEntryID]          UNIQUEIDENTIFIER NULL,
    [NoteID]                      UNIQUEIDENTIFIER NOT NULL,
    [Date]                        DATETIME         NULL,
    [Amount]                      DECIMAL (28, 15) NULL,
    [Type]                        NVARCHAR (MAX)   NULL,
    [CreatedBy]                   NVARCHAR (256)   NULL,
    [CreatedDate]                 DATETIME         NULL,
    [UpdatedBy]                   NVARCHAR (256)   NULL,
    [UpdatedDate]                 DATETIME         NULL,
    [TransactionEntryAutoID]      INT              NOT NULL,
    [AnalysisID]                  UNIQUEIDENTIFIER NULL,
    [AnalysisName]                NVARCHAR (256)   NULL,
    [FeeName]                     NVARCHAR (256)   NULL,
    [TransactionDateByRule]       DATE             NULL,
    [TransactionDateServicingLog] DATE             NULL,
    [RemitDate]                   DATE             NULL,
    [PaymentDateNotAdjustedforWorkingDay]                        DATETIME         NULL,
    [PurposeType] NVARCHAR(256) NULL, 
     [Cash_NonCash] NVARCHAR(256) NULL
);

