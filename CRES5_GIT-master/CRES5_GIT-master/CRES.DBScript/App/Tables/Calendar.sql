CREATE TABLE [App].[Calendar] (
    [CalendarID]  INT            IDENTITY (1, 1) NOT NULL,
    [Date]        DATE           NOT NULL,
    [DayTypeID]   INT            NOT NULL,
    [CreatedBy]   NVARCHAR (256) NULL,
    [CreatedDate] DATETIME       NULL,
    [UpdatedBy]   NVARCHAR (256) NULL,
    [UpdatedDate] DATETIME       NULL,
    CONSTRAINT [PK_CalendarID] PRIMARY KEY CLUSTERED ([CalendarID] ASC)
);

