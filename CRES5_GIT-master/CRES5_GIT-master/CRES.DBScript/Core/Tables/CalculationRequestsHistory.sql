CREATE TABLE [Core].[CalculationRequestsHistory] (
	CalculationRequestsHistoryID int IDENTITY (1, 1) NOT NULL,
	BatchID int NULL,
	BatchDate Datetime,
    [CalculationRequestID] UNIQUEIDENTIFIER NULL,
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
    [NumberOfRetries]      INT              NULL,
    [DealID] UNIQUEIDENTIFIER  NULL,
    [RequestID] nvarchar(256)  NULL,
    CalcType int null

    CONSTRAINT [PK_CalculationRequestsHistory] PRIMARY KEY CLUSTERED (CalculationRequestsHistoryID ASC)
);


