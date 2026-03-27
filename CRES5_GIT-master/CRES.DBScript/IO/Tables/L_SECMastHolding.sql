CREATE TABLE [IO].[L_SECMastHolding] (    

	SECMastHoldingID    INT    IDENTITY (1, 1) NOT NULL,
	Ticker	nvarchar(256)	 ,
	LoanID	nvarchar(256)	 ,	
	Description	nvarchar(256)	 ,
	FinancingSource	nvarchar(256)	 ,	
	NoteName	nvarchar(256)	 ,	
	Priority	int	 ,	
	OriginationDate	Date	 ,	
	FullyExtendedMaturityDate	Date	 ,
	PaymentDay	int	 ,
	InterestRate	decimal(28,15)	 ,
	InitialFunding	decimal(28,15)	 ,
	OriginalAmountofLoan	decimal(28,15)	 ,
	AdjustedCommitment	decimal(28,15)	 ,
	AmountofLoanOutstanding	decimal(28,15)	 ,	
	IndexFloor	decimal(28,15)	 ,	
	CreatedBy	nvarchar(256),
	CreatedDate	Datetime,
	UpdateBy	nvarchar(256),
	UpdatedDate	Datetime

    CONSTRAINT [PK_L_SECMastHolding_SECMastHoldingID] PRIMARY KEY CLUSTERED ([SECMastHoldingID] ASC)
);





