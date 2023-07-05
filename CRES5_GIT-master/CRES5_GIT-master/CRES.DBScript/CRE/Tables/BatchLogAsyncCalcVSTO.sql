CREATE TABLE [CRE].[BatchLogAsyncCalcVSTO] (
    [BatchLogAsyncCalcVSTOID] INT            IDENTITY (1, 1) NOT NULL,
    [BatchName]               NVARCHAR (50)  NULL,
    [BatchStartTime]          DATETIME       NOT NULL,
    [BatchEndTime]            DATETIME       NULL,
    [StartedBy]               NVARCHAR (50)  NULL,
    [ErrorMessage]            NVARCHAR (MAX) NULL,
    [Status]                  NVARCHAR (50)  NULL,
    CONSTRAINT [PK_BatchLogAsyncCalcVSTO] PRIMARY KEY CLUSTERED ([BatchLogAsyncCalcVSTOID] ASC)
);

