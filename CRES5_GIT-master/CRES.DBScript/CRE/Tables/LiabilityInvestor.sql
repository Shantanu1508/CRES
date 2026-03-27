

CREATE TABLE [CRE].[LiabilityInvestor] (
    [LiabilityInvestorID]               INT              IDENTITY (1, 1) NOT NULL,
    [LiabilityInvestorGUID]             UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,   
	AccountID UNIQUEIDENTIFIER,
	Investor	NVARCHAR (256)   NULL,
	EqDate	Date,
	Commitment	decimal(28,15),
	SLDate	Date,
	Concentration		decimal(28,15),
	ConCommit		decimal(28,15),
	SLAdvance	decimal(28,15) ,
	BorrowBase 	decimal(28,15)   
   
    CONSTRAINT [PK_LiabilityInvestorID] PRIMARY KEY CLUSTERED ([LiabilityInvestorID] ASC)
);
GO

