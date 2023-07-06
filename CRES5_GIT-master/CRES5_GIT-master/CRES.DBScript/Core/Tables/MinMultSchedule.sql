
CREATE TABLE [Core].[MinMultSchedule] (
    [MinMultScheduleID]            Int IDENTITY (1, 1) NOT NULL,
	[PrepayScheduleID]            Int NOT NULL,
	[Date]	date	null,
	MinMultAmount	decimal(28,15)	null,
    [CreatedBy]          NVARCHAR (256)   NULL,
    [CreatedDate]        DATETIME         NULL,
    [UpdatedBy]          NVARCHAR (256)   NULL,
    [UpdatedDate]        DATETIME         NULL,   
    IsDeleted bit default(0)
   
    CONSTRAINT [PK_MinMultScheduleID] PRIMARY KEY CLUSTERED ([MinMultScheduleID] ASC),
	CONSTRAINT [FK_MinMultSchedule_PrepayScheduleID] FOREIGN KEY (PrepayScheduleID) REFERENCES [Core].[PrepaySchedule] (PrepayScheduleID)
);