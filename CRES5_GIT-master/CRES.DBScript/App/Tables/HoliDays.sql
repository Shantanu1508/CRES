CREATE TABLE [App].[HoliDays] (
    [HoliDayDate]   DATE           NOT NULL,
    [CreatedBy]     NVARCHAR (256) NULL,
    [CreatedDate]   DATETIME       NULL,
    [HolidayAutoID] INT            IDENTITY (1, 1) NOT NULL,
    [UpdatedBy]     NVARCHAR (256) NULL,
    [UpdatedDate]   DATETIME       NULL,
    [HolidayTypeID] INT            NULL,
	[isSoftHoliday] INT            NULL

    CONSTRAINT [PK_HolidayAutoID] PRIMARY KEY CLUSTERED (HolidayAutoID ASC)
);
GO
go
ALTER TABLE App.Holidays ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON)

