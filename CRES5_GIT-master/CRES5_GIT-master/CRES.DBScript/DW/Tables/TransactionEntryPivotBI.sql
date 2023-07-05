CREATE TABLE [DW].[TransactionEntryPivotBI] (
    [NoteID]                        UNIQUEIDENTIFIER NULL,
    [AnalysisName]                  NVARCHAR (256)   NULL,
    [Crenoteid]                     NVARCHAR (256)   NULL,
    [Date]                          DATE             NULL,
    [FeeName]                       NVARCHAR (256)   NULL,
    [ScheduledPrincipalPaid]        DECIMAL (28, 15) NULL,
    [ExitFeeExcludedFromLevelYield] DECIMAL (28, 15) NULL,
    [Balloon]                       DECIMAL (28, 15) NULL,
    [Funding]                       DECIMAL (28, 15) NULL,
    [Repayment]                     DECIMAL (28, 15) NULL
);


GO
CREATE NONCLUSTERED INDEX [iTransactionEntryPivotBI_crenoteid]
    ON [DW].[TransactionEntryPivotBI]([Crenoteid] ASC);

