CREATE TABLE [CRE].[WFTemplateRecipient] (
    [WFTemplateRecipientID]   INT              IDENTITY (1, 1) NOT NULL,
    [WFTemplateRecipientGuID] UNIQUEIDENTIFIER CONSTRAINT [DF__WFTemplat__WFTem__10AB74EC] DEFAULT (newid()) NOT NULL,
    [WFTemplateID]            INT              NULL,
    [UserID]                  UNIQUEIDENTIFIER NULL,
    [EmailID]                 NVARCHAR (250)   NULL,
    [RecipientType]           NVARCHAR (250)   NULL,
    [CreatedBy]               NVARCHAR (256)   NULL,
    [CreatedDate]             DATETIME         NULL,
    [UpdatedBy]               NVARCHAR (256)   NULL,
    [UpdatedDate]             DATETIME         NULL,
    CONSTRAINT [PK_WFTemplateRecipientID] PRIMARY KEY CLUSTERED ([WFTemplateRecipientID] ASC)
);

