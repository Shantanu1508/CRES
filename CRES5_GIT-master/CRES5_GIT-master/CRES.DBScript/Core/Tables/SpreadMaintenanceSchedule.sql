CREATE TABLE [Core].[SpreadMaintenanceSchedule] (
    [SpreadMaintenanceScheduleID]            Int IDENTITY (1, 1) NOT NULL,
	[PrepayScheduleID]            Int NOT NULL,	
	NoteID	Uniqueidentifier  null,
	Date	date  null,
	Spread	decimal(28,15)  null,
	CalcAfterPayoff	bit  null,
    [CreatedBy]          NVARCHAR (256)   NULL,
    [CreatedDate]        DATETIME         NULL,
    [UpdatedBy]          NVARCHAR (256)   NULL,
    [UpdatedDate]        DATETIME         NULL,   
   IsDeleted bit default(0)
    CONSTRAINT [PK_SpreadMaintenanceScheduleID] PRIMARY KEY CLUSTERED ([SpreadMaintenanceScheduleID] ASC),
	CONSTRAINT [FK_SpreadMaintenance_PrepayScheduleID] FOREIGN KEY (PrepayScheduleID) REFERENCES [Core].[PrepaySchedule] (PrepayScheduleID)
);