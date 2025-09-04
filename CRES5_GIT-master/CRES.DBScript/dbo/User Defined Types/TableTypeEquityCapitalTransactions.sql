CREATE TYPE [dbo].[TableTypeEquityCapitalTransactions] AS TABLE (
	[EquityName] [nvarchar](255) NULL,
	[Description] [nvarchar](255) NULL,
	[CRENoteID] [nvarchar](255) NULL,
	[TransactionDate] [datetime] NULL,
	[TransactionAmount] decimal(28,15) NULL,
	[Confirmed] [bit] NOT NULL,
	[Comments] [nvarchar](255) NULL,
	[AssetIDDealorNoteID] [nvarchar](255) NULL,
	[Source] [nvarchar](255) NULL,
	[EndingBalance] decimal(28,15) NULL
);