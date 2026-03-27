CREATE TYPE [dbo].[TableTypeDailyGAAPBasisComponents] AS TABLE (
    [NoteID]                            UNIQUEIDENTIFIER NULL,
    [Date]                              DATETIME         NULL,
    [AccumAmortofDeferredFees]          DECIMAL (28, 15) NULL,
    [AccumulatedAmortofDiscountPremium] DECIMAL (28, 15) NULL,
    [AccumulatedAmortofCapitalizedCost] DECIMAL (28, 15) NULL,
	EndingBalance                       DECIMAL (28, 15) NULL,
	GrossDeferredFees                   DECIMAL (28, 15) NULL,
	CleanCost                           DECIMAL (28, 15) NULL,
	CurrentPeriodInterestAccrual          DECIMAL (28, 15) NULL,
	CurrentPeriodPIKInterestAccrual          DECIMAL (28, 15) NULL,
	InterestSuspenseAccountBalance          DECIMAL (28, 15) NULL,
    [AnalysisID]                        UNIQUEIDENTIFIER NULL
	);

