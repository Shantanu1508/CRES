--drop PROCEDURE [dbo].[usp_InsertUpdateInterestExpenseSchedule]    
--drop type TableTypeInterestExpenseSchedule
CREATE TYPE [dbo].[TableTypeInterestExpenseSchedule] AS TABLE (
	[InterestExpenseScheduleID]         INT,
	[EventID]							UNIQUEIDENTIFIER,
	[DebtAccountID]						UNIQUEIDENTIFIER,
	[AdditionalAccountID]				UNIQUEIDENTIFIER,
	[EffectiveDate]						DATE,
	[InitialInterestAccrualEndDate]     DATE,
	[PaymentDayOfMonth]                 INT,
	[PaymentDateBusinessDayLag]         INT,
	[DeterminationDateLeadDays]         INT,
	[DeterminationDateReferenceDayOftheMonth] INT,
	[FirstRateIndexResetDate]			DATE,
    [InitialIndexValueOverride]			Decimal(28,15),
	Recourse 				  decimal(28,15)   NULL
); 