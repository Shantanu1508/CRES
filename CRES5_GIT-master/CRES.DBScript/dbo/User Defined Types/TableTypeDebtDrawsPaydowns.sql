CREATE TYPE [dbo].[TableTypeDebtDrawsPaydowns] AS TABLE (
	[LiabilityName] [nvarchar](255) NULL,
	[Description] [nvarchar](255) NULL,
	[CRENoteID] [nvarchar](255) NULL,
	[TransactionDate] [datetime] NULL,
	[TransactionAmount] decimal(28,15) NULL,
	[Confirmed] [bit] NOT NULL,
	[Comments] [nvarchar](255) NULL,
	[AssetIDDealorNoteID] [nvarchar](255) NULL
);