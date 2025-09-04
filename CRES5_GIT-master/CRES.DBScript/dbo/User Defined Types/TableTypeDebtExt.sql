--drop PROCEDURE [dbo].[usp_InsertUpdateDebtExt]    
--drop type TableTypeDebtExt
CREATE TYPE [dbo].[TableTypeDebtExt] AS TABLE (
	[DebtExtID]                               INT,
	[DebtAccountID]							  UNIQUEIDENTIFIER,
	[AdditionalAccountID]                     UNIQUEIDENTIFIER,
    [PayFrequency]							  INT ,  
	[AccrualEndDateBusinessDayLag]			  INT ,
    [AccrualFrequency]                        INT , 
	[DefaultIndexName]						  INT,
	[FinanacingSpreadRate]					  DECIMAL (28, 15),
	[IntCalcMethod]							  INT,
	[RoundingMethod]						  INT,
	[IndexRoundingRule]						  INT,
	[TargetAdvanceRate]						  DECIMAL (28, 15),  
	pmtdtaccper int  ,
    ResetIndexDaily  int  ,
	DeterminationDateHolidayList int
); 