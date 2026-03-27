CREATE TYPE [dbo].[TableTypeLib_11Trans] AS TABLE (	
	[DealID] [nvarchar](255) NULL,
	[DealName] [nvarchar](255) NULL,
	[NoteID] [nvarchar](255) NULL,
	[NoteName] [nvarchar](255) NULL,
	[Description] [nvarchar](255) NULL,
	[Date] [datetime] NULL,
	[Owned] [nvarchar](255) NULL,
	[TransactionType] [nvarchar](255) NULL,
	[FinancingFacility] [nvarchar](255) NULL,
	[Transaction] [float] NULL,
	[UnallocatedSubline] [float] NULL,
	[UnallocatedEquity] [float] NULL,
	[SublineBalance] [float] NULL,
	[EquityBalance] [float] NULL
);