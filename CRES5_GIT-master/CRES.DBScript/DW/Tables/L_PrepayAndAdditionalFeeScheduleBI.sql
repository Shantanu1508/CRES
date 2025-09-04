CREATE TABLE [DW].[L_PrepayAndAdditionalFeeScheduleBI] (
    [PrepayAndAdditionalFeeScheduleID]          UNIQUEIDENTIFIER NOT NULL,   
    [L_PrepayAndAdditionalFeeScheduleBI_AutoID] INT              IDENTITY (1, 1) NOT NULL,
	DealID	UNIQUEIDENtiFIER,
	NoteID	UNIQUEIDENtiFIER,
	DealName	nvarchar(256) null,
	CREDealID	nvarchar(256) null,
	CRENoteID	nvarchar(256) null,
	NoteName	nvarchar(256) null,
	EffectiveDate	Date null,
	StartDate	Date null,
	EndDate	Date null,
	Value	Decimal(28,15) null,
	IncludedLevelYield	Decimal(28,15) null,
	ValueTypeID	int null,
	ValueTypeText	nvarchar(256) null,
	FeeName	nvarchar(256) null,
	FeeAmountOverride	Decimal(28,15) null,
	BaseAmountOverride	Decimal(28,15) null,
	ApplyTrueUpFeature	int null,
	ApplyTrueUpFeatureText	nvarchar(256) null,
	FeetobeStripped	Decimal(28,15) null,
	FinancingSourceName	nvarchar(256) null,
	ScheduleText	nvarchar(256) null,

	[CreatedBy]                     NVARCHAR (256)   NULL,
    [CreatedDate]                   DATETIME         NULL,
    [UpdatedBy]                     NVARCHAR (256)   NULL,
    [UpdatedDate]                   DATETIME         NULL,
    CONSTRAINT [PK_L_PrepayAndAdditionalFeeScheduleBI_AutoID] PRIMARY KEY CLUSTERED ([L_PrepayAndAdditionalFeeScheduleBI_AutoID] ASC)
);



