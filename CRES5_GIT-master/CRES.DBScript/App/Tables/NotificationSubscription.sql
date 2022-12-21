CREATE TABLE [App].[NotificationSubscription] (
    [NotificationSubscriptionID] UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [NotificationID]             UNIQUEIDENTIFIER NOT NULL,
    [UserID]                     UNIQUEIDENTIFIER NOT NULL,
    [CreatedBy]                  NVARCHAR (256)   NULL,
    [CreatedDate]                DATETIME         NULL,
    [UpdatedBy]                  NVARCHAR (256)   NULL,
    [UpdatedDate]                DATETIME         NULL,
    [Status]                     INT              NULL,
    [StartDate]                  DATETIME         NULL,
    [EndDate]                    DATETIME         NULL,
    CONSTRAINT [PK_NotificationSubscriptionID] PRIMARY KEY CLUSTERED ([NotificationSubscriptionID] ASC),
    CONSTRAINT [PK_NotificationSubscription_Notification_NotificationID] FOREIGN KEY ([NotificationID]) REFERENCES [App].[Notification] ([NotificationID]),
    CONSTRAINT [PK_NotificationSubscription_User_UserID] FOREIGN KEY ([UserID]) REFERENCES [App].[User] ([UserID])
);

