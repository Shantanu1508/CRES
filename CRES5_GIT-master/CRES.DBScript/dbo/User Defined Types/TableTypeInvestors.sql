CREATE TYPE [dbo].[TableTypeInvestors] AS TABLE (
	[Investor] [nvarchar](255) NULL,
	[EqDate] [datetime] NULL,
	[Commitment] decimal(28,15) NULL,
	[SLDate] [datetime] NULL,
	[Concentration] decimal(28,15) NULL,
	[ConCommit] decimal(28,15) NULL,
	[SLAdvance] decimal(28,15) NULL,
	[BorrowBase] decimal(28,15) NULL
);