--drop PROCEDURE usp_InsertUpdateLiabilityFundingSchedule
--DROP Type [dbo].[TableTypeLiabilityFundingSchedule] 
CREATE Type [dbo].[TableTypeLiabilityFundingSchedule] AS TABLE
(
	[LiabilityFundingScheduleID]    INT ,
	LiabilityNoteAccountID	UNIQUEIDENTIFIER,
	TransactionDate	Date,
	TransactionAmount	decimal(28,15),
	GeneratedBy	Int,
	Applied	bit,
	Comments	nvarchar(256),
	AssetAccountID	nvarchar(256),
	AssetTransactionDate	Date,
	AssetTransactionAmount	decimal(28,15),
	TransactionAdvanceRate	decimal(28,15),
	CumulativeAdvanceRate	decimal(28,15),
	AssetTransactionComment	nvarchar(256),
	RowNo	int,
	GeneratedByUserID nvarchar(256),
	TransactionTypes nvarchar(256),
	AccountID UNIQUEIDENTIFIER,
	EndingBalance		decimal(28,15),
	CalcType int null,
	[IsDeleted]      BIT              DEFAULT ((0)) NULL,
	[StatusID]  INT Null
);

