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
    GeneratedByBI NVARCHAR(100) NULL,

    Issaved							BIT              NULL,
    DealFundingRowno				INT              NULL,
    DeadLineDate					DATE             NULL,
    LegalDeal_DealFundingID			UNIQUEIDENTIFIER NULL,
    EquityAmount					DECIMAL (28, 15) NULL,
    RemainingFFCommitment			DECIMAL (28, 15) NULL,
    RemainingEquityCommitment		DECIMAL (28, 15) NULL,
    SubPurposeType					NVARCHAR (256)   NULL,
    DealFundingAutoID				INT              NULL,
    RequiredEquity					DECIMAL (28, 15) NULL,
    AdditionalEquity				DECIMAL (28, 15) NULL,

    AdjustmentType int,
    AdjustmentTypeBI nvarchar(256),
    WF_CurrentStatusDisplayName nvarchar(256),
    WatchlistStatus                      NVARCHAR (256)   NULL,
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

