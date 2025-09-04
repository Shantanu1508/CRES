CREATE TABLE [Core].[Analysis] (
    [AnalysisID]     UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [Name]           VARCHAR (256)    NULL,
    [StatusID]       INT              NULL,
    [Description]    VARCHAR (256)    NULL,
    [CreatedBy]      NVARCHAR (256)   NULL,
    [CreatedDate]    DATETIME         NULL,
    [UpdatedBy]      NVARCHAR (256)   NULL,
    [UpdatedDate]    DATETIME         NULL,
    [ScenarioColor]  NVARCHAR (256)   NULL,
    [isDeleted]      BIT              DEFAULT ((0)) NULL,
    [ScenarioStatus] INT              CONSTRAINT [DF__Analysis__Scenar__4C42D2B4] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_AnalysisID] PRIMARY KEY CLUSTERED ([AnalysisID] ASC)
);


GO
ALTER TABLE [Core].[Analysis] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON);
GO

