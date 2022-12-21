CREATE TABLE [App].[UserNotification] (
    [UserNotificationID]         UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [NotificationSubscriptionID] UNIQUEIDENTIFIER NOT NULL,
    [CreatedBy]                  NVARCHAR (256)   NULL,
    [CreatedDate]                DATETIME         NULL,
    [UpdatedBy]                  NVARCHAR (256)   NULL,
    [UpdatedDate]                DATETIME         NULL,
    [ObjectId]                   UNIQUEIDENTIFIER NOT NULL,
    [ObjectTypeId]               INT              NOT NULL,
    [ViewedTime]                 DATETIME         NULL,
    [CleanTime]                  DATETIME         NULL,
    [GeneratedBy]                INT              NULL,
    CONSTRAINT [PK_UserNotificationID] PRIMARY KEY CLUSTERED ([UserNotificationID] ASC),
    CONSTRAINT [PK_UserNotification_NotificationSubscriptionID] FOREIGN KEY ([NotificationSubscriptionID]) REFERENCES [App].[NotificationSubscription] ([NotificationSubscriptionID])
);

