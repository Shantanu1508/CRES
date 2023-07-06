CREATE TABLE [App].[TaskDefaultConfig] (
    [TaskDefaultConfigID] UNIQUEIDENTIFIER CONSTRAINT [DF__TaskDefau__TaskD__7EC1CEDB] DEFAULT (newid()) NOT NULL,
    [TaskTypeID]          INT              NOT NULL,
    [UserId]              UNIQUEIDENTIFIER NULL,
    [CreatedBy]           NVARCHAR (256)   NULL,
    [CreatedDate]         DATETIME         NULL,
    [UpdatedBy]           NVARCHAR (256)   NULL,
    [UpdatedDate]         DATETIME         NULL,
    CONSTRAINT [PK_TaskDefaultConfigID] PRIMARY KEY CLUSTERED ([TaskDefaultConfigID] ASC)
);

