CREATE TABLE [CRE].[LiabilityFundingScheduleDeal] (
	[LiabilityFundingScheduleDealID]    INT  IDENTITY (1, 1) NOT NULL, 	
	[LiabilityFundingScheduleDealGUID] UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
	[AccountID]	UNIQUEIDENTIFIER,
	[DealAccountID] UNIQUEIDENTIFIER,
	[TransactionDate]	Date,
	[TransactionAmount] decimal(28,15),
	[TransactionTypes]	NVARCHAR (256) null,
    [EndingBalance]	  decimal(28,15),
	[GeneratedByUserID]  NVARCHAR (256)   NULL,
	[Applied]	bit,
	[Comments]	nvarchar(256),
	[CreatedBy]   NVARCHAR (256) NULL,
	[CreatedDate] DATETIME       NULL,
	[UpdatedBy]   NVARCHAR (256) NULL,
	[UpdatedDate] DATETIME       NULL,
	[OriginalAmount] Decimal(28,15) NULL,
	[Status]  INT NULL

	CONSTRAINT [PK_LiabilityFundingScheduleDealID] PRIMARY KEY CLUSTERED ([LiabilityFundingScheduleDealID] ASC)
);


GO