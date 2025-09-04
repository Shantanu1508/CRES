CREATE TYPE [dbo].[TableTypeDebtFeeSchedule] AS TABLE (
    [AccountID]       UNIQUEIDENTIFIER,
	[AdditionalAccountID]       UNIQUEIDENTIFIER,
    [EffectiveDate]   DATE            ,
	[FeeName]         NVARCHAR (256)   ,
	[StartDate]       DATE             ,
	[EndDate]         DATE             ,
	[ValueTypeID]     INT              ,
	[Fee]             DECIMAL (28, 15) ,
	[FeeAmountOverride]  DECIMAL (28, 15),
	[BaseAmountOverride] DECIMAL (28, 15),
	[ApplyTrueUpFeatureID] INT           ,
	[IncludedLevelYield] DECIMAL (28, 15),
	[PercentageOfFeeToBeStripped] DECIMAL (28, 15),
	[IsDeleted]      BIT              DEFAULT ((0)) NULL
	);