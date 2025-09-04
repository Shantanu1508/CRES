CREATE TABLE [CRE].[LiabilityFundingScheduleAggregate] (
	[LiabilityFundingScheduleAggregateID]    INT            IDENTITY (1, 1) NOT NULL, 	
	[LiabilityFundingScheduleAggregateGUID] UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
	[AccountID]	UNIQUEIDENTIFIER,
	TransactionDate	Date,
	TransactionAmount	decimal(28,15),
	TransactionTypes	nvarchar(256),
	Applied bit,
	Comments	nvarchar(256),
	[CreatedBy]   NVARCHAR (256) NULL,
	[CreatedDate] DATETIME       NULL,
	[UpdatedBy]   NVARCHAR (256) NULL,
	[UpdatedDate] DATETIME       NULL,  
	EndingBalance decimal(28,15),
	ParentAccountID UNIQUEIDENTIFIER,
	CalcType	INT NULL,
	[OriginalAmount] Decimal(28,15) NULL,
	[Status]  INT NULL
	
	CONSTRAINT [PK_LiabilityFundingScheduleAggregateID] PRIMARY KEY CLUSTERED ([LiabilityFundingScheduleAggregateID] ASC),
	CONSTRAINT [PK_LiabilityFundingScheduleAggregate_AccountID] FOREIGN KEY ([AccountID]) REFERENCES [Core].[Account] (AccountID)
);


GO




