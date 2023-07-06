CREATE TABLE [CRE].[WFStatusMaster] (
    [WFStatusMasterID]         INT            IDENTITY (1, 1) NOT NULL,
    [StatusName]               NVARCHAR (256) NULL,
    [StatusDisplayName]        NVARCHAR (256) NULL,
    [CreatedBy]                NVARCHAR (256) NULL,
    [CreatedDate]              DATETIME       NULL,
    [UpdatedBy]                NVARCHAR (256) NULL,
    [UpdatedDate]              DATETIME       NULL,
    [DealFundingDisplayName]   NVARCHAR (256) NULL,
    [WFUnderReviewDisplayName] NVARCHAR (256) NULL,
    CONSTRAINT [PK_WFStatusMasterID] PRIMARY KEY CLUSTERED ([WFStatusMasterID] ASC)
);

