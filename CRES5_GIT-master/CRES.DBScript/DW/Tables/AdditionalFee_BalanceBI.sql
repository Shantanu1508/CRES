CREATE TABLE [DW].[AdditionalFee_BalanceBI] (
    [DealKey]                UNIQUEIDENTIFIER NULL,
    [DealID]                 NVARCHAR (256)   NULL,
    [NoteId]                 NVARCHAR (256)   NULL,
    [EffectiveDate]          DATE             NULL,
    [FeeName]                NVARCHAR (256)   NULL,
    [StartDate]              DATE             NULL,
    [EndDate]                DATE             NULL,
    [FeeType]                NVARCHAR (256)   NULL,
    [Value]                  DECIMAL (28, 15) NULL,
    [FeeAmountOverride]      DECIMAL (28, 15) NULL,
    [BaseAmountOverride]     DECIMAL (28, 15) NULL,
    [ApplyTrueUpFeature]     NVARCHAR (256)   NULL,
    [IncludedLevelYield]     DECIMAL (28, 15) NULL,
    [FeetobeStripped]        DECIMAL (28, 15) NULL,
    [EndingBalance]          DECIMAL (28, 15) NULL,
    [Amount]                 DECIMAL (28, 15) NULL,
    [EstimatedEndingBalance] DECIMAL (28, 15) NULL
);


GO
CREATE NONCLUSTERED INDEX [iAdditionalFee_BalanceBI_DealID]
    ON [DW].[AdditionalFee_BalanceBI]([DealID] ASC);


GO
CREATE NONCLUSTERED INDEX [iAdditionalFee_BalanceBI_Noteid]
    ON [DW].[AdditionalFee_BalanceBI]([NoteId] ASC);

