CREATE TABLE [Core].[CashFlowDownloadRequests] (
	[CashFlowDownloadRequestsID] Int IDENTITY(1,1) NOT NULL,
    [CashFlowDownloadRequestsGUID] UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
	
	[AnalysisID]           UNIQUEIDENTIFIER NULL,
    [RequestTime]          DATETIME         NULL,
	[StartTime]            DATETIME         NULL,
    [EndTime]              DATETIME         NULL,
    [StatusText]            NVARCHAR (256)   NULL,
    [PriorityID]           INT              NULL,
    [ErrorMessage]         NVARCHAR (MAX)   NULL,
    [CreatedBy]                 NVARCHAR (256)   NULL,
    [CreatedDate]               DATETIME         NULL,
    [UpdatedBy]                 NVARCHAR (256)   NULL,
    [UpdatedDate]               DATETIME         NULL,
    CONSTRAINT [PK_CoreCashFlowDownloadRequests] PRIMARY KEY CLUSTERED ([CashFlowDownloadRequestsID] ASC)
);



