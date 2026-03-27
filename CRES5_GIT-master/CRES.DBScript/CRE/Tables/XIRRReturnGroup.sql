CREATE TABLE [CRE].[XIRRReturnGroup] (
   [XIRRReturnGroupID] [int] IDENTITY(1,1) NOT NULL,
	[XIRRConfigID] [int] NULL,
	[Type] [nvarchar](256) NULL,
	[ReturnName] [nvarchar](256) NULL,
	[ChildReturnName] [nvarchar](256) NULL,
	[Group1] [int] NULL,
	[Group2] [int] NULL,
	
	[AnalysisID] [uniqueidentifier] NULL,
	[CreatedBy] [nvarchar](256) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[UpdatedDate] [datetime] NULL,
	LoanStatus [nvarchar](256) NULL,
	FileName_Input nvarchar(256),

    CONSTRAINT [PK_XIRRReturnGroupID] PRIMARY KEY CLUSTERED ([XIRRReturnGroupID] ASC),
	CONSTRAINT [FK_XIRRReturnGroup_XIRRConfigID] FOREIGN KEY (XIRRConfigID) REFERENCES [CRE].[XIRRConfig] (XIRRConfigID)
);