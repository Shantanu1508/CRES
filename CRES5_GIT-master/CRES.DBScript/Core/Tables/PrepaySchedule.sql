CREATE TABLE [Core].[PrepaySchedule] (
    [PrepayScheduleID]            Int IDENTITY (1, 1) NOT NULL,
	[EventDealID]            Int NOT NULL,
	---PrepayDate	Date null,
	CalcThru	Date null,
	PrepaymentMethod	int null,
	BaseAmountType	int null,
	SpreadCalcMethod	int null,
	GreaterOfSMOrBaseAmtTimeSpread	bit null,
	HasNoteLevelSMSchedule	bit null,
	Includefeesincredits	bit null,
    [CreatedBy]          NVARCHAR (256)   NULL,
    [CreatedDate]        DATETIME         NULL,
    [UpdatedBy]          NVARCHAR (256)   NULL,
    [UpdatedDate]        DATETIME         NULL,   
   
    CONSTRAINT [PK_PrepayScheduleID] PRIMARY KEY CLUSTERED ([PrepayScheduleID] ASC),
	CONSTRAINT [FK_PrepaySchedule_EventDealId] FOREIGN KEY ([EventDealID]) REFERENCES [Core].[EventDeal] ([EventDealID])
);
