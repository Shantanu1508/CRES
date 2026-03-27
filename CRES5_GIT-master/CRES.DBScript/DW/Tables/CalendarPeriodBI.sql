CREATE TABLE [DW].[CalendarPeriodBI] (
    [Date]                    DATE         NOT NULL,
    [Period]                  VARCHAR (25) NOT NULL,
    [CalendarPeriodBI_AutoID] INT          IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_CalendarPeriodBI_AutoID] PRIMARY KEY CLUSTERED ([CalendarPeriodBI_AutoID] ASC)
);



