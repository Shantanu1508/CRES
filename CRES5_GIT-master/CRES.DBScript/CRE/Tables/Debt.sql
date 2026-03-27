CREATE TABLE [CRE].[Debt] (
    [DebtID]                                  INT              IDENTITY (1, 1) NOT NULL,
    [DebtGUID]                                UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [AccountID]                               UNIQUEIDENTIFIER NULL,
    [CurrentCommitment]                       DECIMAL (28, 15) NULL,
    [MatchTerm]                               INT              NULL,
    [IsRevolving]                             INT              NULL,
    [FundingNoticeBD]                         INT              NULL,
    [EarliestFinancingArrival]                DATE             NULL,
    --[CurrentBalance]                          DECIMAL (28, 15) NULL,
    [OriginationDate]                         DATE             NULL,
    [OriginationFees]                         DECIMAL (28, 15) NULL,
    [RateType]                                INT              NULL,
    --[FinanacingSpreadRate]                    DECIMAL (28, 15) NULL,
    --[PaymentFrequency]                        INT              NULL,
    [DrawLag]                                 INT              NULL,
    [PaydownDelay]                            INT              NULL,
   -- [IntActMethod]                            INT              NULL,
   -- [DefaultIndexName]                        INT              NULL,
    --[InitialInterestAccrualEndDate]           DATE             NULL,
   -- [AccrualFrequency]                        INT              NULL,
    --[PaymentDayOfMonth]                       INT              NULL,
    --[PaymentDateBusinessDayLag]               INT              NULL,
    --[DeterminationDateLeadDays]               INT              NULL,
    --[DeterminationDateReferenceDayOftheMonth] INT              NULL,
   -- [Roundingmethod]                          INT              NULL,
   -- [IndexRoundingRule]                       INT              NULL,
    [CreatedBy]                               NVARCHAR (256)   NULL,
    [CreatedDate]                             DATETIME         NULL,
    [UpdatedBy]                               NVARCHAR (256)   NULL,
    [UpdatedDate]                             DATETIME         NULL,
    [InitialFundingDelay]                     INT              NULL,
    [MaxAdvanceRate]                          DECIMAL (28, 15) NULL,
    [TargetAdvanceRate]                       DECIMAL (28, 15) NULL,
    [FundDelay]                               INT              NULL,
    [FundingDay]                              INT              NULL,
    [PortfolioAccountID]                      UNIQUEIDENTIFIER NULL,
	[LiabilityBankerID]						  INT			   NULL,
	
    DebtNameClientSheet nvarchar(256),
    [AbbreviationName]						  NVARCHAR (256)   NULL,
	[LinkedFundID]							  UNIQUEIDENTIFIER NULL
    CONSTRAINT [PK_DebtID] PRIMARY KEY CLUSTERED ([DebtID] ASC),
    CONSTRAINT [PK_Debt_AccountID] FOREIGN KEY ([AccountID]) REFERENCES [Core].[Account] ([AccountID])
);


GO
ALTER TABLE [CRE].[Debt] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON);




GO




