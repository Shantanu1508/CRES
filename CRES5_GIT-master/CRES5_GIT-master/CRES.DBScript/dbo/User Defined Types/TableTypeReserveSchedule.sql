CREATE TYPE [dbo].[TableTypeReserveSchedule] AS TABLE (
	[DealReserveScheduleID]   INT NULL,
    [DealReserveScheduleGUID] UNIQUEIDENTIFIER,

	DealID uniqueidentifier null,
	Date Date null,
	Amount DECIMAL (28, 15) null,
	PurposeID int null,
	Comment NVARCHAR (256) null,
	Applied bit null,
	isDeleted bit null,

	ReserveAccountID int,
	CREReserveAccountID NVARCHAR (256),	
	ReserveScheduleAmount DECIMAL (28, 15),
	RNO int null
);
