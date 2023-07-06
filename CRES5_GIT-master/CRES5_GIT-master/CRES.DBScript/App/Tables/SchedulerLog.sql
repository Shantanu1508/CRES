CREATE TABLE [App].[SchedulerLog] (
    [SchedulerLogID]    INT            IDENTITY (1, 1) NOT NULL,
    [SchedulerConfigID] INT            NULL,
    [Message]           NVARCHAR (MAX) NULL,
    [StartTime]         DATETIME       NULL,
    [EndTime]           DATETIME       NULL,
    [GeneratedBy]       NVARCHAR (256) NULL,
    [CreatedDate]       DATETIME       NULL,
    CONSTRAINT [PK_SchedulerLogID] PRIMARY KEY CLUSTERED ([SchedulerLogID] ASC)
);

