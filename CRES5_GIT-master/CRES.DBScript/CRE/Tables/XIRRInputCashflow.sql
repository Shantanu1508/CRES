CREATE TABLE [CRE].[XIRRInputCashflow] (
    [XIRRInputCashflowID]    INT            IDENTITY (1, 1) NOT NULL,   
	[XIRRConfigID]    INT,		
	DealAccountID UNIQUEIDENTIFIER,
	NoteAccountID UNIQUEIDENTIFIER,
	TransactionType	nvarchar(256),
	TransactionDate	Date,	
	Amount	Decimal(28,15),		
	RemitDate	Date,	
	AnalysisID UNIQUEIDENTIFIER,
	ReturnName	NVARCHAR (256)	,
	ChildReturnName	NVARCHAR (256)	,
	[XIRRReturnGroupID]    INT,
	[CreatedBy]   NVARCHAR (256) NULL,
    [CreatedDate] DATETIME       NULL,
    [UpdatedBy]   NVARCHAR (256) NULL,
    [UpdatedDate] DATETIME       NULL,
	LoanStatus [nvarchar](256) NULL,
	MSA nvarchar(256),
	VintageYear nvarchar(256),
	TransactionDateByRule Date,

	XIRRReturnGroupID_ColumnTotal nvarchar(256),
	XIRRReturnGroupID_RowTotal nvarchar(256),
	XIRRReturnGroupID_OverallTotal nvarchar(256),
	XIRRReturnGroupID_OverallColumnTotal nvarchar(256),
	XIRRReturnGroupID_GroupTotal  nvarchar(256),


	SpreadPercentage  Decimal(28,15),	
	[OriginalIndex]   Decimal(28,15),	
	[IndexValue]  	  Decimal(28,15),	
	[EffectiveRate]   Decimal(28,15),	
	[FeeName]		  nvarchar(256)	

    CONSTRAINT [PK_XIRRInputCashflowID] PRIMARY KEY CLUSTERED ([XIRRInputCashflowID] ASC),
	CONSTRAINT [FK_XIRRInputCashflow_XIRRConfigID] FOREIGN KEY (XIRRConfigID) REFERENCES [CRE].[XIRRConfig] (XIRRConfigID)
);