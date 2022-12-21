CREATE TABLE [DW].[CalendarBI] (
    [Date]            DATE         NOT NULL,
    [Month]           INT          NOT NULL,
    [Quarter]         INT          NULL,
    [Year]            INT          NOT NULL,
    [IsWeekend]       BIT          NULL,
    [IsHoliday]       BIT          NULL,
    [PriorMonthEnd]   DATE         NULL,
    [PriorQuarterEnd] DATE         NULL,
    [PriorYearEnd]    DATE         NULL,
    [DateSlicer]      VARCHAR (12) NULL,
    [MonthSlicer]     VARCHAR (12) NULL,
    [YearSlicer]      VARCHAR (12) NULL,
    [YTDSlicer]       VARCHAR (12) NULL,
    CONSTRAINT [PK_CalendarBI] PRIMARY KEY CLUSTERED ([Date] ASC)
);

