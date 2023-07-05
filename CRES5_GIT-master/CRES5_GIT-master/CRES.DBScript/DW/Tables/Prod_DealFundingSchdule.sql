CREATE TABLE [DW].[Prod_DealFundingSchdule] (
    [DealFundingID] UNIQUEIDENTIFIER NOT NULL,
    [DealID]        UNIQUEIDENTIFIER NOT NULL,
    [CREDealID]     NVARCHAR (256)   NULL,
    [Date]          DATE             NULL,
    [Amount]        DECIMAL (28, 15) NULL,
    [Comment]       NVARCHAR (MAX)   NULL,
    [PurposeBI]     NVARCHAR (256)   NULL,
    [WireConfirm]   BIT              NULL,
    [DrawFundingId] NVARCHAR (256)   NULL,
    [CreatedBy]     NVARCHAR (256)   NULL,
    [CreatedDate]   DATETIME         NULL,
    [UpdatedBy]     NVARCHAR (256)   NULL,
    [UpdatedDate]   DATETIME         NULL,
    CONSTRAINT [PK_Prod_DealFundingSchdule_DealFundingID] PRIMARY KEY CLUSTERED ([DealFundingID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [iProd_DealFundingSchdule_CREDealID]
    ON [DW].[Prod_DealFundingSchdule]([CREDealID] ASC);


GO
CREATE NONCLUSTERED INDEX [iProd_DealFundingSchdule_CREDealID_Date]
    ON [DW].[Prod_DealFundingSchdule]([CREDealID] ASC, [Date] ASC);


GO
CREATE NONCLUSTERED INDEX [iProd_DealFundingSchdule_DealID]
    ON [DW].[Prod_DealFundingSchdule]([DealID] ASC);

