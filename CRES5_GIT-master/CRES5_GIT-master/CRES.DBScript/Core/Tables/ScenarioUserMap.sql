CREATE TABLE [Core].[ScenarioUserMap] (
    [ScenarioUserMapID] UNIQUEIDENTIFIER CONSTRAINT [DF__ScenarioU__Scena__558AAF1E] DEFAULT (newid()) NOT NULL,
    [AnalysisID]        UNIQUEIDENTIFIER NULL,
    [UserID]            UNIQUEIDENTIFIER NULL,
    [CreatedBy]         NVARCHAR (256)   NULL,
    [CreatedDate]       DATETIME         NULL,
    [UpdatedBy]         NVARCHAR (256)   NULL,
    [UpdatedDate]       DATETIME         NULL,
    CONSTRAINT [PK_ScenarioUserMapID] PRIMARY KEY CLUSTERED ([ScenarioUserMapID] ASC)
);

