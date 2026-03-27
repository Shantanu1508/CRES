CREATE TYPE [dbo].[TableTypeLib_DealLibAdvRate] AS TABLE (
	[CREDealID] [nvarchar](255) NULL,
	[DealName] [nvarchar](255) NULL,
	[Equity] [nvarchar](255) NULL,
	[Facility] [nvarchar](255) NULL,
	[EffDate] [datetime] NULL,
	[AdvRateFacility] [float] NULL,
	[AdvRateEquity] [float] NULL
);