CREATE TABLE [Core].[CalculationRequestsTest] (
    [CalculationRequestID] UNIQUEIDENTIFIER CONSTRAINT [DF__Calculati__Calcu__42F7C8EE] DEFAULT (newid()) NOT NULL,
    [NoteId]               UNIQUEIDENTIFIER NOT NULL,
    [RequestTime]          DATETIME         NULL,
    [StatusID]             INT              NULL,
    [UserName]             NVARCHAR (MAX)   NULL,
    [ApplicationID]        INT              NULL,
    [StartTime]            DATETIME         NULL,
    [EndTime]              DATETIME         NULL,
    [ServerName]           NVARCHAR (256)   NULL,
    [PriorityID]           INT              NULL,
    [ErrorMessage]         NVARCHAR (MAX)   NULL,
    [ErrorDetails]         NVARCHAR (MAX)   NULL,
    [ServerIndex]          INT              NULL,
    [AnalysisID]           UNIQUEIDENTIFIER NULL,
    [CalculationModeID]    INT              NULL
);

