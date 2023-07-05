CREATE TABLE [IO].[BatchDetail] (
    [BatchDetailD]                  UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [BatchLog_BatchLogID]           UNIQUEIDENTIFIER NOT NULL,
    [SourceTableName]               NVARCHAR (256)   NULL,
    [SourceRecordCount]             INT              NULL,
    [SourceCheckSumValue]           BIGINT           NULL,
    [SourceStartTime]               DATETIME         NULL,
    [SourceEndTime]                 DATETIME         NULL,
    [SourceErrorMessage]            TEXT             NULL,
    [DestinationTableName]          NVARCHAR (256)   NULL,
    [DestinationTableRecordCount]   INT              NULL,
    [DestinationTableCheckSumValue] BIGINT           NULL,
    [DestinationTableStartTime]     DATETIME         NULL,
    [DestinationTableEndTime]       DATETIME         NULL,
    [DestinationTableErrorMessage]  TEXT             NULL,
    [CreatedBy]                     NVARCHAR (256)   NULL,
    [CreatedDate]                   DATETIME         NULL,
    [UpdatedBy]                     NVARCHAR (256)   NULL,
    [UpdatedDate]                   DATETIME         NULL,
    CONSTRAINT [PK_BatchDetailD] PRIMARY KEY CLUSTERED ([BatchDetailD] ASC),
    CONSTRAINT [FK_BatchLog_BatchLog_BatchLogID] FOREIGN KEY ([BatchLog_BatchLogID]) REFERENCES [IO].[BatchLog] ([BatchLogID])
);

