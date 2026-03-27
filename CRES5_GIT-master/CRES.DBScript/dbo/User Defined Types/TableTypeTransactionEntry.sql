--drop PROCEDURE usp_InsertTransactionEntry
--drop TYPE [dbo].[TableTypeTransactionEntry]
CREATE TYPE [dbo].[TableTypeTransactionEntry] AS TABLE (
    [TransactionType] NVARCHAR (256)   NULL,
    [Date]            DATE             NULL,
    [Amount]          DECIMAL (28, 15) NULL,
    [AnalysisID]      UNIQUEIDENTIFIER NULL,
    [FeeName]         NVARCHAR (256)   NULL,
    [FeeTypeName]     NVARCHAR (256)   NULL,
    [Comment]         NVARCHAR (MAX)   NULL,
	[PaymentDateNotAdjustedforWorkingDay] DATETIME         NULL,
    PurposeType NVARCHAR (256)   NULL,    
    TransactionDateByRule   DATE             NULL,	
    TransactionDateServicingLog DATE             NULL,
    RemittanceDate  DATE             NULL,
	[AdjustmentType]  NVARCHAR (256)   NULL,
	AllInCouponRate decimal(28,15),
	IndexDeterminationDate DATE NULL,
    BalloonRepayAmount decimal(28,15),
	IndexValue decimal(28,15),
	SpreadValue	 decimal(28,15),
	OriginalIndex decimal(28,15),
	LiborPercentage decimal(28,15)
    );