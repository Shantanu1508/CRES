CREATE TABLE [DW].[AnalysisBI] (
    [AnalysisKey]                 UNIQUEIDENTIFIER NOT NULL,
    [MaturityAdjustment]          INT              NULL,
    [MaturityAdjustmentText]      NVARCHAR (256)   NULL,
    [Description]                 VARCHAR (256)    NULL,
    [Name]                        VARCHAR (256)    NULL,
    [IndexScenarioOverride]       VARCHAR (256)    NULL,
    [CalculationMode]             VARCHAR (256)    NULL,
    [ExcludedForcastedPrePayment] VARCHAR (256)    NULL,
    [CreatedBy]                   NVARCHAR (256)   NULL,
    [CreatedDate]                 DATETIME         NULL,
    [UpdatedBy]                   NVARCHAR (256)   NULL,
    [UpdatedDate]                 DATETIME         NULL,
    [AnalysisBI_AutoID]           INT              IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_AnalysisBI_AutoID] PRIMARY KEY CLUSTERED ([AnalysisBI_AutoID] ASC)
);




GO
CREATE NONCLUSTERED INDEX [iAnalysisKey]
    ON [DW].[AnalysisBI]([AnalysisKey] ASC);

