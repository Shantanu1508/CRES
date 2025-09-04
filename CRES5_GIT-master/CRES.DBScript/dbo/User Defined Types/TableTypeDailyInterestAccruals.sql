--drop PROCEDURE [dbo].[usp_InsertDailyInterestAccruals] 
--drop PROCEDURE usp_InsertDailyInterestAccruals_V1
--drop TYPE [dbo].[TableTypeDailyInterestAccruals]

CREATE TYPE [dbo].[TableTypeDailyInterestAccruals] AS TABLE (
    [NoteID]               UNIQUEIDENTIFIER NULL,
    [Date]                 DATE             NULL,
    [DailyInterestAccrual] DECIMAL (28, 15) NULL,
    [EndingBalance]        DECIMAL (28, 15) NULL,
    [AnalysisID]           UNIQUEIDENTIFIER NULL,
	SpreadOrRate  DECIMAL (28, 15) NULL,
	IndexRate  DECIMAL (28, 15) NULL,
	AllInCouponRate DECIMAL (28, 15) NULL,
	AllInPikRate DECIMAL (28, 15) NULL,
	PikSpreadOrRate DECIMAL (28, 15) NULL,
	PIKIndexRate DECIMAL (28, 15) NULL
	);

	
	