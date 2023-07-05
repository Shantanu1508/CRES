CREATE TABLE [DW].[FeeScheduleBI] (
    [dealid]             UNIQUEIDENTIFIER NULL,
    [NoteID]             UNIQUEIDENTIFIER NULL,
    [CREDealID]          NVARCHAR (256)   NULL,
    [crenoteid]          NVARCHAR (256)   NULL,
    [EffectiveDate]      DATE             NULL,
    [FeeName]            NVARCHAR (256)   NULL,
    [StartDate]          DATE             NULL,
    [EndDate]            DATE             NULL,
    [FeeType]            NVARCHAR (256)   NULL,
    [Value]              DECIMAL (28, 15) NULL,
    [FeeAmountOverride]  DECIMAL (28, 15) NULL,
    [BaseAmountOverride] DECIMAL (28, 15) NULL,
    [ApplyTrueUpFeature] NVARCHAR (256)   NULL,
    [IncludedLevelYield] DECIMAL (28, 15) NULL,
    [FeetobeStripped]    DECIMAL (28, 15) NULL
);


GO
CREATE NONCLUSTERED INDEX [iFeeScheduleBI_CREDealID]
    ON [DW].[FeeScheduleBI]([CREDealID] ASC);


GO
CREATE NONCLUSTERED INDEX [iFeeScheduleBI_crenoteid]
    ON [DW].[FeeScheduleBI]([crenoteid] ASC);

