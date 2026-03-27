
CREATE TABLE [Core].[CalculationRequestsLiability] (
    [CalculationRequestID] UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
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
    [NumberOfRetries]      INT              DEFAULT ((1)) NULL,
    [DealID]               UNIQUEIDENTIFIER NULL,
    [RequestID]            NVARCHAR (256)   NULL,
    [CalcType]             INT              NULL,
    [CalcEngineType]       INT              NULL,
    [jsonpicktime]         DATETIME         NULL,
    [RequestID_Time]       DATETIME         NULL,
    [ActualCompletionTime] DATETIME         NULL,
    [AccountId]            UNIQUEIDENTIFIER NULL,
    [UseActuals]           int              NULL,
    [RequestFrom]          Nvarchar(256)    NULL,
    CONSTRAINT [PK_CalculationRequestsLiability] PRIMARY KEY CLUSTERED ([CalculationRequestID] ASC)
);





GO
CREATE NONCLUSTERED INDEX [IX_CalculationRequests_CalcBatch]
    ON [Core].[CalculationRequestsLiability]([CalcBatch] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_CalculationRequestsLiability_StatusID_PriorityID]
    ON [Core].[CalculationRequestsLiability]([StatusID] ASC, [PriorityID] ASC)
    INCLUDE([RequestTime]);

    GO
CREATE NONCLUSTERED INDEX [nci_wi_CalculationRequestsLiability_544B98748F2B64520F6B556014288438]
    ON [Core].[CalculationRequestsLiability]([StatusID] ASC, [ServerIndex] ASC) 
    INCLUDE([AccountID], [StartTime]);


GO
CREATE NONCLUSTERED INDEX [nci_wi_CalculationRequestsLiability_52101B57D283EEB38580F0ABBE5ABCA0]
    ON [Core].[CalculationRequestsLiability]([StatusID] ASC)  
    INCLUDE([AccountID]);
