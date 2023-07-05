CREATE TABLE [CRE].[WFNotificationConfig] (
    [WFNotificationConfigID]   INT              IDENTITY (1, 1) NOT NULL,
    [WFNotificationConfigGuID] UNIQUEIDENTIFIER CONSTRAINT [DF__WFNotific__WFNot__0539C240] DEFAULT (newid()) NOT NULL,
    [Name]                     NVARCHAR (256)   NULL,
    [CanChangeReplyTo]         BIT              NULL,
    [CanChangeRecipientList]   BIT              NULL,
    [CanChangeHeader]          BIT              NULL,
    [CanChangeBody]            BIT              NULL,
    [CanChangeFooter]          BIT              NULL,
    [CanChangeSchedule]        BIT              NULL,
    [CreatedBy]                NVARCHAR (256)   NULL,
    [CreatedDate]              DATETIME         NULL,
    [UpdatedBy]                NVARCHAR (256)   NULL,
    [UpdatedDate]              DATETIME         NULL,
    CONSTRAINT [PK_WFNotificationConfigID] PRIMARY KEY CLUSTERED ([WFNotificationConfigID] ASC)
);

