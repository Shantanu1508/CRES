CREATE TABLE [IO].[L_BackShopNoteFunding]
(
	[L_BackShopNoteFundingID]    INT IDENTITY (1, 1) NOT NULL,
	ControlID	nvarchar(256),
	NoteID_f	nvarchar(256),
	FundingDate	Date,
	FundingAmount	decimal(28,15),
	Comments	nvarchar(MAX),
	FundingPurposeCD_F	nvarchar(256),
	Applied	int,
	WireConfirm	int,
	FundingAdjustmentTypeCd_F nvarchar(256),
	ShardName nvarchar(256)

	CONSTRAINT [PK_L_BackShopNoteFundingID] PRIMARY KEY CLUSTERED ([L_BackShopNoteFundingID] ASC),
)
