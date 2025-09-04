--Drop Procedure [dbo].[usp_InsertUpdateDealLevelLiabilityFunding];
--Drop Type [dbo].[TableTypeDealLevelLiabilityFundingSchedule];

CREATE Type [dbo].[TableTypeDealLevelLiabilityFundingSchedule] AS TABLE
(
    LiabilityFundingScheduleDealID int,
	AccountID UNIQUEIDENTIFIER,
	DealAccountID  UNIQUEIDENTIFIER,
	TransactionDate	 Date,
	TransactionAmount  decimal(28,15),
	Applied	 bit,
	Comments  nvarchar(256),
	GeneratedByUserID  nvarchar(256),
	TransactionTypes  nvarchar(256),
	EndingBalance  decimal(28,15),
	[IsDeleted]      BIT              DEFAULT ((0)) NULL,
	[StatusID]  INT Null
);
