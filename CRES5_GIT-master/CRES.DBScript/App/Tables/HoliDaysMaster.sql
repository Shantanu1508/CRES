CREATE TABLE [App].[HoliDaysMaster] (
    [HolidayMasterID]  INT            IDENTITY (1, 1) NOT NULL,
    [CalendarName]   nvarchar(256)  NULL,
    [CreatedBy]   NVARCHAR (256) NULL,
    [CreatedDate] DATETIME       NULL,
    [UpdatedBy]   NVARCHAR (256) NULL,
    [UpdatedDate] DATETIME       NULL,
    CONSTRAINT [PK_HolidayMasterID] PRIMARY KEY CLUSTERED ([HolidayMasterID] ASC)
);
go
ALTER TABLE App.HolidaysMaster ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON)


