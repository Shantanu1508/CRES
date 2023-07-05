CREATE TABLE [IO].[BatchLog] (
    [BatchLogID]      UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [BatchTypeID]     INT              NULL,
    [StartTime]       DATETIME         NULL,
    [EndTime]         DATETIME         NULL,
    [StartedByUserID] UNIQUEIDENTIFIER NULL,
    [ErrorMessage]    TEXT             NULL,
    [CreatedBy]       NVARCHAR (256)   NULL,
    [CreatedDate]     DATETIME         NULL,
    [UpdatedBy]       NVARCHAR (256)   NULL,
    [UpdatedDate]     DATETIME         NULL,
    CONSTRAINT [PK_BatchLogID] PRIMARY KEY CLUSTERED ([BatchLogID] ASC)
);

