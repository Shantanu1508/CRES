CREATE TYPE [dbo].[TableTypeCashTransactions] AS TABLE (
	[Date] [datetime] NULL,
	[TransactionType] [nvarchar](255) NULL,
	[Transaction] decimal(28,15) NULL
);