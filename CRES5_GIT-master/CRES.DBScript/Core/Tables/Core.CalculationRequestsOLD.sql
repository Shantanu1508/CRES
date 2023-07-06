CREATE TABLE [Core].[Core.CalculationRequestsOLD] (
    [CalculationRequestID] UNIQUEIDENTIFIER CONSTRAINT [DF__Calculati__Calcu__27F8EE98] DEFAULT (newid()) NOT NULL,
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
    CONSTRAINT [PK_Core.CalculationRequests] PRIMARY KEY CLUSTERED ([CalculationRequestID] ASC)
);

