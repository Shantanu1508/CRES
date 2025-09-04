CREATE TABLE [Core].[Indexes] (
    [IndexesId]       UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [Date]            DATE             NULL,
    [IndexType]       INT              NULL,
    [Value]           DECIMAL (28, 15) NULL,
    [CreatedBy]       NVARCHAR (256)   NULL,
    [CreatedDate]     DATETIME         NULL,
    [UpdatedBy]       NVARCHAR (256)   NULL,
    [UpdatedDate]     DATETIME         NULL,
    [AnalysisID]      UNIQUEIDENTIFIER NULL,
    [IndexesMasterID] INT              NULL,
    [IndexesIntId]    INT              IDENTITY (1, 1) NOT NULL,
    ---[Status] INT               DEFAULT ((1)) NULL,
    CONSTRAINT [PK_IndexesId] PRIMARY KEY CLUSTERED ([IndexesId] ASC),
    CONSTRAINT [FK_Indexes_ScenarioID] FOREIGN KEY ([AnalysisID]) REFERENCES [Core].[Analysis] ([AnalysisID])
);


GO
CREATE NONCLUSTERED INDEX [nci_wi_Indexes_93F6B2AE7B6B8C426E53D65F7ABDC562]
    ON [Core].[Indexes]([IndexesMasterID] ASC, [IndexType] ASC, [Date] ASC)
    INCLUDE([CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [Value]);

GO
ALTER TABLE [Core].[Indexes] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON);
GO
