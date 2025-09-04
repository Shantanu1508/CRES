CREATE TYPE [dbo].TableTypeTransactionEntry_LiabilityLine_ForFeeAndInterest AS TABLE (
	[AnalysisID]      UNIQUEIDENTIFIER NULL,
    [LiabilityAccountID]	UNIQUEIDENTIFIER NULL,
	[Date]            DATE             NULL,
    [Amount]          DECIMAL (28, 15) NULL,
	[TransactionType] NVARCHAR (256)   NULL,   
    EndingBalance		DECIMAL (28, 15) NULL,
	[UserID]            NVARCHAR (256)   NULL
);
