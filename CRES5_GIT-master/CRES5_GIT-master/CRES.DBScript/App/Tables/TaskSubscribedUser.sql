CREATE TABLE [App].[TaskSubscribedUser] (
    [TaskSubscribedUserID] UNIQUEIDENTIFIER CONSTRAINT [DF__TaskSubsc__TaskS__019E3B86] DEFAULT (newid()) NOT NULL,
    [TaskID]               UNIQUEIDENTIFIER NULL,
    [UserId]               UNIQUEIDENTIFIER NULL,
    [CreatedBy]            NVARCHAR (256)   NULL,
    [CreatedDate]          DATETIME         NULL,
    [UpdatedBy]            NVARCHAR (256)   NULL,
    [UpdatedDate]          DATETIME         NULL,
    CONSTRAINT [PK_TaskSubscribedUserID] PRIMARY KEY CLUSTERED ([TaskSubscribedUserID] ASC)
);

