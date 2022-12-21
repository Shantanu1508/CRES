CREATE TABLE [DW].[BatchLog] (
    [BatchLogId]     INT            IDENTITY (1, 1) NOT NULL,
    [BatchName]      NVARCHAR (50)  NULL,
    [BatchStartTime] DATETIME       NOT NULL,
    [BatchEndTime]   DATETIME       NULL,
    [StartedBy]      NVARCHAR (50)  NULL,
    [ErrorMessage]   NVARCHAR (MAX) NULL,
    [Status]         NVARCHAR (MAX) NULL,
    [LogText]        NVARCHAR (MAX) NULL,
    [Status2]        VARCHAR (500)  NULL,
    [LogType]        NVARCHAR (256) NULL,
    CONSTRAINT [PK_BatchLog] PRIMARY KEY CLUSTERED ([BatchLogId] ASC)
);

