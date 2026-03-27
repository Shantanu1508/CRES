CREATE TABLE [dbo].[Lib_Equity](
	[Equity Name] [nvarchar](255) NULL,
	[Equity Type] [nvarchar](255) NULL,
	[Status] [nvarchar](255) NULL,
	[Currency] [nvarchar](255) NULL,
	[Investor Capital ] [money] NULL,
	[Capital Reserve Requirement] [float] NULL,
	[Reserve Requirement] [money] NULL,
	[Capital Call Notice Business Days ] [float] NULL,
	[Inception Date ] [nvarchar](255) NULL,
	[Last Date to Invest ] [nvarchar](255) NULL,
	[Linked Short Term Borrowing Facility ] [nvarchar](255) NULL,
	[Commitment ] [nvarchar](255) NULL,
	[Initial Maturity Date] [nvarchar](255) NULL
) ON [PRIMARY]
GO