--drop PROCEDURE usp_InsertUpdateLiabilityFundingScheduleAggregate
--DROP Type [dbo].[TableTypeLiabilityFundingScheduleAggregate] 

CREATE Type [dbo].[TableTypeLiabilityFundingScheduleAggregate] AS TABLE
(
	LiabilityFundingScheduleAggregateID    INT ,	
	[AccountID]	UNIQUEIDENTIFIER,
	TransactionDate	Date,
	TransactionAmount	decimal(28,15),
	TransactionTypes	nvarchar(256),
	Applied bit,
	Comments	nvarchar(256),
	EndingBalance decimal(28,15),
	[CalcType] int null,
	[ParentAccountID]	UNIQUEIDENTIFIER,
	[IsDeleted]      BIT              DEFAULT ((0)) NULL,
	[StatusID]  INT Null
);

