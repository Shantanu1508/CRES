CREATE TABLE [App].[TaskActivity] (
    [TaskActivityID] UNIQUEIDENTIFIER CONSTRAINT [DF__TaskActiv__TaskA__7BE56230] DEFAULT (newid()) NOT NULL,
    [TaskID]         UNIQUEIDENTIFIER NULL,
    [ActivityDate]   DATETIME         NULL,
    [ActivityType]   INT              NULL,
    [Displaymessage] NVARCHAR (MAX)   NULL,
    [CreatedBy]      NVARCHAR (256)   NULL,
    [CreatedDate]    DATETIME         NULL,
    [UpdatedBy]      NVARCHAR (256)   NULL,
    [UpdatedDate]    DATETIME         NULL,
    CONSTRAINT [PK_TaskActivityID] PRIMARY KEY CLUSTERED ([TaskActivityID] ASC)
);

