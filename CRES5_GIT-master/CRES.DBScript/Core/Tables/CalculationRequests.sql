CREATE TABLE [Core].[CalculationRequests] (
    [CalculationRequestID] UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
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
    [CalculationModeID]    INT              NULL,
    [CalcBatch]            UNIQUEIDENTIFIER NULL,
    [NumberOfRetries]      INT              CONSTRAINT [DF__Calculati__Numbe__2B9540A9] DEFAULT ((1)) NULL,
    [DealID] UNIQUEIDENTIFIER  NULL,
    [RequestID] nvarchar(256)  NULL,
    CalcType int null
    CONSTRAINT [PK_CoreCalculationRequests] PRIMARY KEY CLUSTERED ([CalculationRequestID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [nci_wi_CalculationRequests_544B98748F2B64520F6B556014288438]
    ON [Core].[CalculationRequests]([StatusID] ASC, [ServerIndex] ASC)
    INCLUDE([NoteId], [StartTime]);


GO
CREATE NONCLUSTERED INDEX [nci_wi_CalculationRequests_52101B57D283EEB38580F0ABBE5ABCA0]
    ON [Core].[CalculationRequests]([StatusID] ASC)
    INCLUDE([NoteId]);


GO
CREATE NONCLUSTERED INDEX [IX_CalculationRequests_CalcBatch]
    ON [Core].[CalculationRequests]([CalcBatch] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_CalculationRequests_StatusID_PriorityID]
    ON [Core].[CalculationRequests]([StatusID] ASC, [PriorityID] ASC)
    INCLUDE([RequestTime]);

