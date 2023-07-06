CREATE TABLE [CRE].[WFNotificationRecipient] (
    [WFNotificationRecipientID]   INT              IDENTITY (1, 1) NOT NULL,
    [WFNotificationRecipientGuID] UNIQUEIDENTIFIER CONSTRAINT [DF__WFNotific__WFNot__0AF29B96] DEFAULT (newid()) NOT NULL,
    [WFNotificationID]            INT              NULL,
    [UserID]                      UNIQUEIDENTIFIER NULL,
    [EmailID]                     NVARCHAR (256)   NULL,
    [RecipientType]               NVARCHAR (256)   NULL,
    [CreatedBy]                   NVARCHAR (256)   NULL,
    [CreatedDate]                 DATETIME         NULL,
    [UpdatedBy]                   NVARCHAR (256)   NULL,
    [UpdatedDate]                 DATETIME         NULL,
    CONSTRAINT [PK_WFNotificationRecipientID] PRIMARY KEY CLUSTERED ([WFNotificationRecipientID] ASC)
);

