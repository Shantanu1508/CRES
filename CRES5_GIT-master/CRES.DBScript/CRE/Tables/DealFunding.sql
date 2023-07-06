CREATE TABLE [CRE].[DealFunding] (
    [DealFundingID]             UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [DealID]                    UNIQUEIDENTIFIER NOT NULL,
    [Date]                      DATE             NULL,
    [Amount]                    DECIMAL (28, 15) NULL,
    [CreatedBy]                 NVARCHAR (256)   NULL,
    [CreatedDate]               DATETIME         NULL,
    [UpdatedBy]                 NVARCHAR (256)   NULL,
    [UpdatedDate]               DATETIME         NULL,
    [Comment]                   NVARCHAR (MAX)   NULL,
    [PurposeID]                 INT              NULL,
    [Applied]                   BIT              NULL,
    [DrawFundingId]             NVARCHAR (256)   NULL,
    [Issaved]                   BIT              CONSTRAINT [DF__DealFundi__Issav__446B1014] DEFAULT ((0)) NULL,
    [DealFundingRowno]          INT              NULL,
    [DeadLineDate]              DATE             NULL,
    [LegalDeal_DealFundingID]   UNIQUEIDENTIFIER NULL,
    [EquityAmount]              DECIMAL (28, 15) CONSTRAINT [DF__DealFundi__Equit__2610A626] DEFAULT ((0)) NULL,
    [RemainingFFCommitment]     DECIMAL (28, 15) CONSTRAINT [DF__DealFundi__Remai__2704CA5F] DEFAULT ((0)) NULL,
    [RemainingEquityCommitment] DECIMAL (28, 15) CONSTRAINT [DF__DealFundi__Remai__27F8EE98] DEFAULT ((0)) NULL,
    [SubPurposeType]            NVARCHAR (256)   NULL,
    [DealFundingAutoID]         INT              IDENTITY (1, 1) NOT NULL,
    [RequiredEquity]            DECIMAL (28, 15) NULL,
    [AdditionalEquity]          DECIMAL (28, 15) NULL,
    [GeneratedBy]            INT   NULL
    CONSTRAINT [PK_DealFundingID] PRIMARY KEY CLUSTERED ([DealFundingID] ASC),
    CONSTRAINT [FK_DealFunding_DealID] FOREIGN KEY ([DealID]) REFERENCES [CRE].[Deal] ([DealID])
);


GO
CREATE NONCLUSTERED INDEX [nci_wi_DealFunding_977CD0F97C42BCE9376394D680A3039F]
    ON [CRE].[DealFunding]([DealID] ASC)
    INCLUDE([Amount], [Applied], [Comment], [Date], [DealFundingRowno], [DrawFundingId], [EquityAmount], [Issaved], [PurposeID], [RemainingEquityCommitment], [RemainingFFCommitment], [SubPurposeType], [UpdatedDate]);


GO
CREATE NONCLUSTERED INDEX [IX_DealFunding_DealID]
    ON [CRE].[DealFunding]([DealID] ASC)
    INCLUDE([LegalDeal_DealFundingID]);

