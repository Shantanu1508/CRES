CREATE TYPE [dbo].[TableTypeLib_Equity] AS TABLE (
	[EquityName] [nvarchar](255) NULL,
	[EquityType] [nvarchar](255) NULL,
	[Status] [nvarchar](255) NULL,
	[Currency] [nvarchar](255) NULL,
	[InvestorCapital] [money] NULL,
	[CapitalReserveRequirement] [float] NULL,
	[ReserveRequirement] [money] NULL,
	[CapitalCallNoticeBusinessDays] [float] NULL,
	[InceptionDate] [nvarchar](255) NULL,
	[LastDatetoInvest] [nvarchar](255) NULL,
	[LinkedShortTermBorrowingFacility] [nvarchar](255) NULL,
	[Commitment] [nvarchar](255) NULL,
	[InitialMaturityDate] [nvarchar](255) NULL
);