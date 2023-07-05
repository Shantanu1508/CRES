
CREATE TYPE [dbo].[tblSpreadMaintenanceSchedule] AS TABLE (
SpreadMaintenanceScheduleId	int null,
NoteID	Uniqueidentifier null,
Date	date,
Spread	decimal(28,15),
CalcAfterPayoff	bit
);