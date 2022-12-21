CREATE TABLE [Core].[PrepayAdjustment] (
    [PrepayAdjustmentID]            Int IDENTITY (1, 1) NOT NULL,
	[PrepayScheduleID]            Int NOT NULL,
	Date	date null,
	PrepayAdjAmt	decimal(28,15) null,
	Comment	nvarchar(max) null,   
    [CreatedBy]          NVARCHAR (256)   NULL,
    [CreatedDate]        DATETIME         NULL,
    [UpdatedBy]          NVARCHAR (256)   NULL,
    [UpdatedDate]        DATETIME         NULL,   
   
    CONSTRAINT [PK_PrepayAdjustmentID] PRIMARY KEY CLUSTERED ([PrepayAdjustmentID] ASC),
	CONSTRAINT [FK_PrepayAdjustment_PrepayScheduleID] FOREIGN KEY (PrepayScheduleID) REFERENCES [Core].[PrepaySchedule] (PrepayScheduleID)
);

