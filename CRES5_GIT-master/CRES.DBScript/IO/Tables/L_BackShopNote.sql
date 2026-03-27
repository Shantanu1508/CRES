CREATE TABLE [IO].[L_BackShopNote]
(
	[L_BackShopNoteID]    INT IDENTITY (1, 1) NOT NULL,
	ControlId	nvarchar(256),
	NoteId	nvarchar(256),
	NoteName	nvarchar(256),
	FundingDate	Date,
	TotalCommitment	decimal(28,15),
	TotalCurrentAdjustedCommitment	decimal(28,15),
	OrigLoanAmount	decimal(28,15),
	PaymentFreqCd_F	int,
	LienPosition	nvarchar(256),
	[Priority]	int,
	StatedMaturityDate date,
	LoanTerm int,
	OriginationFeePct decimal(28,15),
	FirstPIPaymentDate DateTime,
	ShardName nvarchar(256)

	CONSTRAINT [PK_L_BackShopNoteID] PRIMARY KEY CLUSTERED ([L_BackShopNoteID] ASC),
)
