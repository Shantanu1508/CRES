CREATE TABLE [HBOT].[APIAnalysisLog] (
    [APIAnalysisLogID] INT            IDENTITY (1, 1) NOT NULL,
    [StartTime]        DATETIME       NULL,
    [EndTime]          DATETIME       NULL,
    [IntentName]       NVARCHAR (256) NULL,
    [CreatedBy]        NVARCHAR (256) NULL,
    CONSTRAINT [PK_APIAnalysisLogID] PRIMARY KEY CLUSTERED ([APIAnalysisLogID] ASC)
);

