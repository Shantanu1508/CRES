CREATE TABLE [App].[Notification] (
    [NotificationID]       UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [Name]                 VARCHAR (128)    NOT NULL,
    [NotificationProcName] VARCHAR (128)    NOT NULL,
    [StatusID]             INT              NULL,
    [CreatedBy]            NVARCHAR (256)   NULL,
    [CreatedDate]          DATETIME         NULL,
    [UpdatedBy]            NVARCHAR (256)   NULL,
    [UpdatedDate]          DATETIME         NULL,
    [Msg1]                 NVARCHAR (MAX)   NULL,
    [Msg2]                 NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_NotificationID] PRIMARY KEY CLUSTERED ([NotificationID] ASC)
);

