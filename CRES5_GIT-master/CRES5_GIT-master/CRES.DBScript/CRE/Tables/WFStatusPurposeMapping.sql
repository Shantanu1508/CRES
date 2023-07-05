CREATE TABLE [CRE].[WFStatusPurposeMapping] (
    [WFStatusPurposeMappingID] INT            IDENTITY (1, 1) NOT NULL,
    [WFStatusMasterID]         INT            NULL,
    [PurposeTypeId]            INT            NULL,
    [OrderIndex]               INT            NULL,
    [IsEnable]                 BIT            CONSTRAINT [DF__WFStatusP__IsEna__408F9238] DEFAULT ((0)) NOT NULL,
    [CreatedBy]                NVARCHAR (256) NULL,
    [CreatedDate]              DATETIME       NULL,
    [UpdatedBy]                NVARCHAR (256) NULL,
    [UpdatedDate]              DATETIME       NULL,
    CONSTRAINT [PK_WFStatusPurposeMappingID] PRIMARY KEY CLUSTERED ([WFStatusPurposeMappingID] ASC)
);

