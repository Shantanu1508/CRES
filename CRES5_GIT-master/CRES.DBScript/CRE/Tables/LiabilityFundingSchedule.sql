CREATE TABLE [CRE].[LiabilityFundingSchedule] (
	[LiabilityFundingScheduleID]    INT            IDENTITY (1, 1) NOT NULL, 	
	[LiabilityFundingScheduleGUID] UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
	[LiabilityNoteAccountID]	UNIQUEIDENTIFIER,
	TransactionDate	Date,
	TransactionAmount	decimal(28,15),
	GeneratedBy	Int,
	[Applied]	bit,
	Comments	nvarchar(256),
	AssetAccountID	UNIQUEIDENTIFIER,
	AssetTransactionDate	Date,
	AssetTransactionAmount	decimal(28,15),
	TransactionAdvanceRate	decimal(28,15),
	CumulativeAdvanceRate	decimal(28,15),
	AssetTransactionComment	nvarchar(256),
	RowNo	int,
	[CreatedBy]   NVARCHAR (256) NULL,
	[CreatedDate] DATETIME       NULL,
	[UpdatedBy]   NVARCHAR (256) NULL,
	[UpdatedDate] DATETIME       NULL,
    [GeneratedByUserID]           NVARCHAR (256)   NULL,
    [Description]	nvarchar(max),   
    [AccountID]	UNIQUEIDENTIFIER,
    TransactionTypes	NVARCHAR (256) null,
    EndingBalance	  decimal(28,15),
	CalcType INT NULL,
	[OriginalAmount] Decimal(28,15) NULL,
	[Status]  INT NULL

	CONSTRAINT [PK_LiabilityFundingScheduleID] PRIMARY KEY CLUSTERED ([LiabilityFundingScheduleID] ASC),
	CONSTRAINT [PK_LiabilityFundingSchedule_LiabilityNoteAccountID] FOREIGN KEY ([LiabilityNoteAccountID]) REFERENCES [Core].[Account] (AccountID)
);


GO




