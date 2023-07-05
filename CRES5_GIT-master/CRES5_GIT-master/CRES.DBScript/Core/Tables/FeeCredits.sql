
CREATE TABLE [Core].[FeeCredits] (
    [FeeCreditsID]            Int IDENTITY (1, 1) NOT NULL,
	[PrepayScheduleID]            Int NOT NULL,
	FeeType	int null,
	FeeCreditOverride	decimal(28,15)	null,
    UseActualFees bit null,
    [CreatedBy]          NVARCHAR (256)   NULL,
    [CreatedDate]        DATETIME         NULL,
    [UpdatedBy]          NVARCHAR (256)   NULL,
    [UpdatedDate]        DATETIME         NULL, 
    IsDeleted bit default(0)
   
    CONSTRAINT [PK_FeeCreditsID] PRIMARY KEY CLUSTERED ([FeeCreditsID] ASC),
	CONSTRAINT [FK_FeeCredits_PrepayScheduleID] FOREIGN KEY (PrepayScheduleID) REFERENCES [Core].[PrepaySchedule] (PrepayScheduleID)
);
