CREATE TABLE [CRE].[Equity] (
    [EquityID]                         INT              IDENTITY (1, 1) NOT NULL,
    [EquityGUID]                       UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [AccountID]                        UNIQUEIDENTIFIER NULL,
    [InvestorCapital]                  DECIMAL (28, 15) NULL,
    [CapitalReserveRequirement]        DECIMAL (28, 15) NULL,
    [ReserveRequirement]               DECIMAL (28, 15) NULL,
    [CommittedCapital]                 DECIMAL (28, 15) NULL,
    [CapitalReserve]                   DECIMAL (28, 15) NULL,
    [UncommittedCapital]               DECIMAL (28, 15) NULL,
    [CapitalCallNoticeBusinessDays]    INT              NULL,
    [EarliestEquityArrival]            DATE             NULL,
    [InceptionDate]                    DATE             NULL,
    [LastDatetoInvest]                 DATE             NULL,
    [FundBalanceexcludingReserves]     DECIMAL (28, 15) NULL,
    [LinkedShortTermBorrowingFacility] NVARCHAR (256)   NULL,
    [CreatedBy]                        NVARCHAR (256)   NULL,
    [CreatedDate]                      DATETIME         NULL,
    [UpdatedBy]                        NVARCHAR (256)   NULL,
    [UpdatedDate]                      DATETIME         NULL,
    [FundDelay]                        INT              NULL,
    [FundingDay]                       INT              NULL,
    [PortfolioAccountID]               UNIQUEIDENTIFIER NULL,
    AbbreviationName NVARCHAR (256)   NULL,
	[StructureID]  INT              NULL,
    CONSTRAINT [PK_EquityID] PRIMARY KEY CLUSTERED ([EquityID] ASC),
    CONSTRAINT [PK_Equity_AccountID] FOREIGN KEY ([AccountID]) REFERENCES [Core].[Account] ([AccountID])
);


GO
ALTER TABLE [CRE].[Equity] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON);




GO




