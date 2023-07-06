CREATE TABLE [App].[UserNotificationArchive] (
    [ArchiveId]                  INT              IDENTITY (1, 1) NOT NULL,
    [UserNotificationID]         UNIQUEIDENTIFIER NOT NULL,
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
    CONSTRAINT [PK_ArchiveId] PRIMARY KEY CLUSTERED ([ArchiveId] ASC)
);


GO
CREATE NONCLUSTERED INDEX [nci_wi_UserNotificationArchive_969F9A1AB0F1BA24235EB019100FA378]
    ON [App].[UserNotificationArchive]([CleanTime] ASC, [NotificationSubscriptionID] ASC, [ViewedTime] ASC);

