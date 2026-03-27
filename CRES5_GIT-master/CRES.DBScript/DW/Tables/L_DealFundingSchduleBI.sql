CREATE TABLE [DW].[L_DealFundingSchduleBI] (
    [DealFundingID]                 UNIQUEIDENTIFIER NOT NULL,
    [DealID]                        UNIQUEIDENTIFIER NOT NULL,
    [CREDealID]                     NVARCHAR (256)   NULL,
    [Date]                          DATE             NULL,
    [Amount]                        DECIMAL (28, 15) NULL,
    [Comment]                       NVARCHAR (MAX)   NULL,
    [PurposeID]                     INT              NULL,
    [PurposeBI]                     NVARCHAR (256)   NULL,
    [Applied]                       BIT              NULL,
    [DrawFundingId]                 NVARCHAR (256)   NULL,
    [CreatedBy]                     NVARCHAR (256)   NULL,
    [CreatedDate]                   DATETIME         NULL,
    [UpdatedBy]                     NVARCHAR (256)   NULL,
    [UpdatedDate]                   DATETIME         NULL,
    [Projected]                     NVARCHAR (100)   NULL,
    [GeneratedBy]                   INT              NULL,
    [GeneratedByBI]                 NVARCHAR (100)   NULL,
    [L_DealFundingSchduleBI_AutoID] INT              IDENTITY (1, 1) NOT NULL,

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
    WF_CurrentStatusDisplayName nvarchar(256)

    CONSTRAINT [PK_L_DealFundingSchduleBI_AutoID] PRIMARY KEY CLUSTERED ([L_DealFundingSchduleBI_AutoID] ASC)
);



