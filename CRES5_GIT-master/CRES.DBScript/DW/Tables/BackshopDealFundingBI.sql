CREATE TABLE [DW].[BackshopDealFundingBI] (
    [ControlID]                    NVARCHAR (100)   NULL,
    [DealName]                     NVARCHAR (256)   NULL,
    [FundingDate]                  DATETIME         NULL,
    [FundingAmount]                DECIMAL (28, 15) NULL,
    [BackshopDealFundingBI_AutoID] INT              IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_BackshopDealFundingBI_AutoID] PRIMARY KEY CLUSTERED ([BackshopDealFundingBI_AutoID] ASC)
);



