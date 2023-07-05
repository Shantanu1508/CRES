CREATE TABLE [dbo].[Temp_Prod_DealFunding] (
    [DealFundingID]             UNIQUEIDENTIFIER NULL,
    [DealID]                    UNIQUEIDENTIFIER NULL,
    [Date]                      DATE             NULL,
    [Amount]                    DECIMAL (28, 15) NULL,
    [Comment]                   NVARCHAR (MAX)   NULL,
    [PurposeID]                 INT              NULL,
    [Applied]                   BIT              NULL,
    [Issaved]                   BIT              NULL,
    [CreatedBy]                 NVARCHAR (256)   NULL,
    [CreatedDate]               DATETIME         NULL,
    [UpdatedBy]                 NVARCHAR (256)   NULL,
    [UpdatedDate]               DATETIME         NULL,
    [DrawFundingId]             NVARCHAR (256)   NULL,
    [DealFundingRowno]          INT              NULL,
    [DeadLineDate]              DATE             NULL,
    [LegalDeal_DealFundingID]   UNIQUEIDENTIFIER NULL,
    [EquityAmount]              DECIMAL (28, 15) NULL,
    [RemainingFFCommitment]     DECIMAL (28, 15) NULL,
    [RemainingEquityCommitment] DECIMAL (28, 15) NULL,
    [SubPurposeType]            NVARCHAR (256)   NULL,
    [ShardName]                 NVARCHAR (256)   NULL
);

