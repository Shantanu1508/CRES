CREATE TYPE [dbo].[TableTypeNoteFeeSchedule] AS TABLE (
    [ScheduleID]      UNIQUEIDENTIFIER,
    [AccountID]       UNIQUEIDENTIFIER,
    [EffectiveDate]   DATE            NULL,
	[StartDate]       DATE            NULL,
	[ScheduleEndDate]         DATE    NULL,
	[FeeName]         NVARCHAR (256)  NULL,
	[ValueTypeID]     INT             NULL ,
	[Value]             DECIMAL (28, 15) NULL,
	[FeeAmountOverride]  DECIMAL (28, 15) NULL,
	[BaseAmountOverride] DECIMAL (28, 15) NULL,
	[ApplyTrueUpFeatureID] INT           NULL,
	[IncludedLevelYield] DECIMAL (28, 15) NULL,
	[IncludedBasis]      DECIMAL (28, 15) NULL,
	[PercentageOfFeeToBeStripped] DECIMAL (28, 15),
    [IsDeleted]      BIT              DEFAULT ((0)) NULL
	);