CREATE TABLE [App].[HoliDays] (
    [HoliDayDate]     DATE           NOT NULL,    
    [CreatedBy]       NVARCHAR (256) NULL,
    [CreatedDate]     Datetime         NULL,
    [HolidayAutoID]   INT            IDENTITY (1, 1) NOT NULL,
    [UpdatedBy]       NVARCHAR (256) NULL,
    [UpdatedDate]     Datetime           NULL,
    [HoliDayTypeID]   INT            NULL,
);



