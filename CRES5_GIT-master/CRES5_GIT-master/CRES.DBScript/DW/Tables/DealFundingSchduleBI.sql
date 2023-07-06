CREATE TABLE [DW].[DealFundingSchduleBI] (
    [DealFundingID] UNIQUEIDENTIFIER NOT NULL,
    [DealID]        UNIQUEIDENTIFIER NOT NULL,
    [CREDealID]     NVARCHAR (256)   NULL,
    [Date]          DATE             NULL,
    [Amount]        DECIMAL (28, 15) NULL,
    [Comment]       NVARCHAR (MAX)   NULL,
    [PurposeID]     INT              NULL,
    [PurposeBI]     NVARCHAR (256)   NULL,
    [Applied]       BIT              NULL,
    [DrawFundingId] NVARCHAR (256)   NULL,
    [CreatedBy]     NVARCHAR (256)   NULL,
    [CreatedDate]   DATETIME         NULL,
    [UpdatedBy]     NVARCHAR (256)   NULL,
    [UpdatedDate]   DATETIME         NULL,
    [Projected] NVARCHAR(100) NULL,
     GeneratedBy int null,
    GeneratedByBI NVARCHAR(100) NULL
    CONSTRAINT [PK_DealFundingID] PRIMARY KEY CLUSTERED ([DealFundingID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [iDealFundingSchduleBI_DealID]
    ON [DW].[DealFundingSchduleBI]([DealID] ASC);


GO
CREATE NONCLUSTERED INDEX [iDealFundingSchduleBI_CREDealID]
    ON [DW].[DealFundingSchduleBI]([CREDealID] ASC);


GO
CREATE NONCLUSTERED INDEX [iDealFundingSchduleBI_CREDealID_Date]
    ON [DW].[DealFundingSchduleBI]([CREDealID] ASC, [Date] ASC);

