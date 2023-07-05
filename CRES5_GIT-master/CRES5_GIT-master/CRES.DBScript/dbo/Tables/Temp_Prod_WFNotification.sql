CREATE TABLE [dbo].[Temp_Prod_WFNotification] (
    [WFNotificationID]       INT              NOT NULL,
    [WFNotificationGuID]     UNIQUEIDENTIFIER NOT NULL,
    [WFNotificationMasterID] INT              NULL,
    [TaskID]                 UNIQUEIDENTIFIER NULL,
    [MessageHTML]            NVARCHAR (MAX)   NULL,
    [ScheduledDateTime]      DATETIME         NULL,
    [ActionType]             INT              NULL,
    [AdditionalText]         NVARCHAR (256)   NULL,
    [CreatedBy]              NVARCHAR (256)   NULL,
    [CreatedDate]            DATETIME         NULL,
    [UpdatedBy]              NVARCHAR (256)   NULL,
    [UpdatedDate]            DATETIME         NULL,
    [NotificationType]       NVARCHAR (256)   NULL,
    [MessageData]            NVARCHAR (MAX)   NULL,
    [ShardName]              NVARCHAR (256)   NULL
);

