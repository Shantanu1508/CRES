CREATE TABLE [DW].[BatchDetail] (
    [BatchDetailId]        INT            IDENTITY (1, 1) NOT NULL,
    [BatchLogId]           INT            NOT NULL,
    [LastCreatedDate]      DATETIME       NULL,
    [LandingTableName]     NVARCHAR (50)  NOT NULL,
    [LandingRecordCount]   INT            NULL,
    [LandingCheckSumValue] BIGINT         NULL,
    [LandingStartTime]     DATETIME       NULL,
    [LandingEndTime]       DATETIME       NULL,
    [BatchErrorMessage]    NVARCHAR (MAX) NULL,
    [BITableName]          NVARCHAR (50)  NULL,
    [BIRecordCount]        INT            NULL,
    [BICheckSumValue]      BIGINT         NULL,
    [BIStartTime]          DATETIME       NULL,
    [BIEndTime]            DATETIME       NULL,
    [BIErrorMessage]       NVARCHAR (MAX) NULL,
    [CreatedBy]            NVARCHAR (256) NULL,
    [CreatedDate]          DATETIME       NULL,
    [UpdatedBy]            NVARCHAR (256) NULL,
    [UpdatedDate]          DATETIME       NULL,
    CONSTRAINT [PK_BatchDetailD] PRIMARY KEY CLUSTERED ([BatchDetailId] ASC),
    CONSTRAINT [FK_BatchLog_BatchLogID] FOREIGN KEY ([BatchLogId]) REFERENCES [DW].[BatchLog] ([BatchLogId])
);

