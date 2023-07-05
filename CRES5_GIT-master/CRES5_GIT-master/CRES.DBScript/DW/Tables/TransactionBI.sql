CREATE TABLE [DW].[TransactionBI] (
    [TransactionID]     UNIQUEIDENTIFIER NOT NULL,
    [PeriodID]          UNIQUEIDENTIFIER NULL,
    [RegisterID]        UNIQUEIDENTIFIER NULL,
    [TransactionTypeID] INT              NULL,
    [Date]              DATE             NULL,
    [Amount]            DECIMAL (28, 15) NULL,
    [IsActual]          BIT              NULL,
    [CurrencyID]        INT              NULL,
    [AccountID]         UNIQUEIDENTIFIER NULL,
    [AnalysisID]        UNIQUEIDENTIFIER NULL,
    [Name]              VARCHAR (256)    NULL,
    [StatusID]          INT              NULL,
    [TransactionTypeBI] NVARCHAR (256)   NULL,
    [CurrencyBI]        NVARCHAR (256)   NULL,
    [StatusBI]          NVARCHAR (256)   NULL,
    [ImportBIDate]      DATETIME         NULL,
    [CreatedBy]         NVARCHAR (256)   NULL,
    [CreatedDate]       DATETIME         NULL,
    [UpdatedBy]         NVARCHAR (256)   NULL,
    [UpdatedDate]       DATETIME         NULL,
    CONSTRAINT [PK_TransactionID] PRIMARY KEY CLUSTERED ([TransactionID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [iNotePeriodicCalcBI_NoteID_PeriodEndDate]
    ON [DW].[TransactionBI]([AccountID] ASC, [Date] ASC);

