CREATE TABLE [App].[TaskComments] (
    [TaskCommentsID] UNIQUEIDENTIFIER CONSTRAINT [DF__TaskComme__TaskC__753864A1] DEFAULT (newid()) NOT NULL,
    [TaskID]         UNIQUEIDENTIFIER NOT NULL,
    [Comments]       NVARCHAR (MAX)   NULL,
    [CreatedBy]      NVARCHAR (256)   NULL,
    [CreatedDate]    DATETIME         NULL,
    [UpdatedBy]      NVARCHAR (256)   NULL,
    [UpdatedDate]    DATETIME         NULL,
    CONSTRAINT [PK_TaskCommentsID] PRIMARY KEY CLUSTERED ([TaskCommentsID] ASC),
    CONSTRAINT [FK_Task_TaskID] FOREIGN KEY ([TaskID]) REFERENCES [App].[Task] ([TaskID])
);

