CREATE TYPE [dbo].[TableTypeLiabilityRateSpreadSchedule] AS TABLE (
	[AccountID]       UNIQUEIDENTIFIER,
	[AdditionalAccountID]       UNIQUEIDENTIFIER,
	[EffectiveDate]   DATE            ,	
	[Date]		DATE,
	ValueTypeID int, 
	[Value]  DECIMAL (28, 15) ,
	IntCalcMethodID int, 
	RateOrSpreadToBeStripped   DECIMAL (28, 15) NULL,
	IndexNameID   int,
	DeterminationDateHolidayList int,
	[IsDeleted]      BIT              DEFAULT ((0)) NULL

);



	