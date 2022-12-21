CREATE TABLE [CRE].[WFNotificationMaster] (
    [WFNotificationMasterID]   INT              IDENTITY (1, 1) NOT NULL,
    [WFNotificationMasterGuID] UNIQUEIDENTIFIER CONSTRAINT [DF__WFNotific__WFNot__7E8CC4B1] DEFAULT (newid()) NOT NULL,
    [Name]                     NVARCHAR (250)   NULL,
    [WFNotificationConfigID]   INT              NULL,
    [TemplateID]               INT              NULL,
    [IsEnable]                 BIT              CONSTRAINT [DF__WFNotific__IsEna__7F80E8EA] DEFAULT ((1)) NOT NULL,
    [CreatedBy]                NVARCHAR (250)   NULL,
    [CreatedDate]              DATETIME         NULL,
    [UpdatedBy]                NVARCHAR (250)   NULL,
    [UpdatedDate]              DATETIME         NULL,
    CONSTRAINT [PK_WFNotificationMasterID] PRIMARY KEY CLUSTERED ([WFNotificationMasterID] ASC)
);

