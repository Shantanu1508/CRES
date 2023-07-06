CREATE TABLE [CRE].[WFTemplate] (
    [WFTemplateID]     INT              IDENTITY (1, 1) NOT NULL,
    [WFTemplateGuID]   UNIQUEIDENTIFIER CONSTRAINT [DF__WFTemplat__WFTem__025D5595] DEFAULT (newid()) NOT NULL,
    [TemplateFileName] NVARCHAR (256)   NULL,
    [CreatedBy]        NVARCHAR (256)   NULL,
    [CreatedDate]      DATETIME         NULL,
    [UpdatedBy]        NVARCHAR (256)   NULL,
    [UpdatedDate]      DATETIME         NULL,
    CONSTRAINT [PK_WFTemplateID] PRIMARY KEY CLUSTERED ([WFTemplateID] ASC)
);

