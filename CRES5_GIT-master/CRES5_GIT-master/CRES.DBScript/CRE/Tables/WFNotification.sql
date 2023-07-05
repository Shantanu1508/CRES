CREATE TABLE [CRE].[WFNotification] (
    [WFNotificationID]       INT              IDENTITY (1, 1) NOT NULL,
    [WFNotificationGuID]     UNIQUEIDENTIFIER CONSTRAINT [DF__WFNotific__WFNot__08162EEB] DEFAULT (newid()) NOT NULL,
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
    [TaskTypeID] INT              NULL,
    CONSTRAINT [PK_WFNotificationID] PRIMARY KEY CLUSTERED ([WFNotificationID] ASC)
);

