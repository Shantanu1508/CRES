CREATE TABLE [DW].[TransactionEntryBI_Realized] (
    [TransactionEntryID]          UNIQUEIDENTIFIER NOT NULL,
    [NoteID]                      UNIQUEIDENTIFIER NULL,
    [CRENoteID]                   NVARCHAR (256)   NULL,
    [Date]                        DATETIME         NULL,
    [Amount]                      DECIMAL (28, 15) NULL,
    [Type]                        NVARCHAR (128)   NULL,
    [CreatedBy]                   NVARCHAR (256)   NULL,
    [CreatedDate]                 DATETIME         NULL,
    [UpdatedBy]                   NVARCHAR (256)   NULL,
    [UpdatedDate]                 DATETIME         NULL,
    [TransactionEntryAutoID]      INT              NOT NULL,
    [AnalysisID]                  UNIQUEIDENTIFIER NULL,
    [AnalysisName]                NVARCHAR (256)   NULL,
    [FeeName]                     NVARCHAR (256)   NULL,
    [DealName]                    NVARCHAR (256)   NULL,
    [CreDealID]                   NVARCHAR (256)   NULL,
    [TransactionDateByRule]       DATE             NULL,
    [TransactionDateServicingLog] DATE             NULL,
    [RemitDate]                   DATE             NULL,
	ClientBI					  NVARCHAR (256)   NULL,
	NoteName					  NVARCHAR (256)   NULL
    CONSTRAINT [PK_TransactionEntryBI_Realized] PRIMARY KEY CLUSTERED ([TransactionEntryAutoID] ASC)
);