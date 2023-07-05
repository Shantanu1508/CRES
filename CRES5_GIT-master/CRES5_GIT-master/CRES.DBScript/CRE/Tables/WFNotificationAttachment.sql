CREATE TABLE [CRE].[WFNotificationAttachment] (
    [WFNotificationAttachmentID]   INT              IDENTITY (1, 1) NOT NULL,
    [WFNotificationAttachmentGuID] UNIQUEIDENTIFIER CONSTRAINT [DF__WFNotific__WFNot__0DCF0841] DEFAULT (newid()) NOT NULL,
    [FileName]                     NVARCHAR (256)   NULL,
    [AzureBlobLink]                NVARCHAR (500)   NULL,
    [CreatedBy]                    NVARCHAR (256)   NULL,
    [CreatedDate]                  DATETIME         NULL,
    [UpdatedBy]                    NVARCHAR (256)   NULL,
    [UpdatedDate]                  DATETIME         NULL,
    CONSTRAINT [PK_WFNotificationAttachmentID] PRIMARY KEY CLUSTERED ([WFNotificationAttachmentID] ASC)
);

