CREATE TABLE [dbo].[Lib_11Trans](	
	[Deal ID] [nvarchar](255) NULL,
	[Deal Name] [nvarchar](255) NULL,
	[Note ID] [nvarchar](255) NULL,
	[Note Name] [nvarchar](255) NULL,
	[Description] [nvarchar](255) NULL,
	[Date] [datetime] NULL,
	[Owned] [nvarchar](255) NULL,
	[Transaction Type] [nvarchar](255) NULL,
	[Financing Facility] [nvarchar](255) NULL,
	[Transaction] [float] NULL,
	[Unallocated Subline] [float] NULL,
	[Unallocated Equity] [float] NULL,
	[Subline Balance] [float] NULL,
	[Equity Balance] [float] NULL,
	EquityName nvarchar(256),
) ON [PRIMARY]
GO