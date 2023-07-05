CREATE TABLE [IO].[IN_UnderwritingDeal] (
    [IN_UnderwritingDealID] UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [ClientDealID]          NVARCHAR (256)   NULL,
    [DealName]              NVARCHAR (256)   NULL,
    [StatusID]              INT              NULL,
    [CreatedBy]             NVARCHAR (256)   NULL,
    [CreatedDate]           DATETIME         NULL,
    [UpdatedBy]             NVARCHAR (256)   NULL,
    [UpdatedDate]           DATETIME         NULL,
    [AssetManager]          NVARCHAR (256)   NULL,
    [DealCity]              NVARCHAR (256)   NULL,
    [DealState]             NVARCHAR (256)   NULL,
    [DealPropertyType]      NVARCHAR (256)   NULL,
    [TotalCommitment]       DECIMAL (28, 15) NULL,
    [FullyExtMaturityDate]  DATE             NULL,
    CONSTRAINT [PK_IN_UnderwritingDealID] PRIMARY KEY CLUSTERED ([IN_UnderwritingDealID] ASC)
);

