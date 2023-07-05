CREATE TABLE [CRE].[FinancingSourceMaster] (
    [FinancingSourceMasterID] INT            IDENTITY (1, 1) NOT NULL,
    [FinancingSourceName]     NVARCHAR (256) NULL,
    [FinancingSourceCode]     NVARCHAR (256) NULL,
    [ParentClient]            NVARCHAR (256) NULL,
    [SortOrder]               SMALLINT       NULL,
    [CreatedBy]               NVARCHAR (256) NULL,
    [CreatedDate]             DATETIME       NULL,
    [UpdatedBy]               NVARCHAR (256) NULL,
    [UpdatedDate]             DATETIME       NULL,
    [IsThirdParty]            BIT            DEFAULT ((0)) NOT NULL,
    FinancingSourceGroup        NVARCHAR (256) NULL
    CONSTRAINT [PK_FinancingSourceMasterID] PRIMARY KEY CLUSTERED ([FinancingSourceMasterID] ASC)
);

