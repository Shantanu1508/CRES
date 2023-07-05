CREATE TABLE [Core].[AnalysisParameter] (
    [AnalysisParameterID]         UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [AnalysisID]                  UNIQUEIDENTIFIER NOT NULL,
    [CreatedBy]                   NVARCHAR (256)   NULL,
    [CreatedDate]                 DATETIME         NULL,
    [UpdatedBy]                   NVARCHAR (256)   NULL,
    [UpdatedDate]                 DATETIME         NULL,
    [MaturityScenarioOverrideID]  INT              NULL,
    [MaturityAdjustment]          INT              NULL,
    [FunctionName]                NVARCHAR (256)   NULL,
    [IndexScenarioOverride]       INT              NULL,
    [CalculationMode]             INT              NULL,
    [ExcludedForcastedPrePayment] INT              NULL,
    [AutoCalculationFrequency]    INT              NULL,
    [NextExecuteTime]             DATETIME         NULL,
    [UseActuals]                  INT              NULL,
	[UseBusinessDayAdjustment]    INT              NULL,
    JsonTemplateMasterID          int              NULL,
    CONSTRAINT [PK_AnalysisParameterID] PRIMARY KEY CLUSTERED ([AnalysisParameterID] ASC),
    CONSTRAINT [FK_AnalysisParameter_AnalysisID] FOREIGN KEY ([AnalysisID]) REFERENCES [Core].[Analysis] ([AnalysisID])
);

