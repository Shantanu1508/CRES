CREATE TABLE [Core].[FinancingSchedule] (
    [FinancingScheduleID]     UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [EventId]                 UNIQUEIDENTIFIER NOT NULL,
    [Date]                    DATE             NULL,
    [ValueTypeID]             INT              NULL,
    [Value]                   DECIMAL (28, 12) NULL,
    [IndexTypeID]             INT              NULL,
    [IntCalcMethodID]         INT              NULL,
    [CurrencyCode]            INT              NULL,
    [CreatedBy]               NVARCHAR (256)   NULL,
    [CreatedDate]             DATETIME         NULL,
    [UpdatedBy]               NVARCHAR (256)   NULL,
    [UpdatedDate]             DATETIME         NULL,
    [FinancingScheduleAutoID] INT              IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_FinancingScheduleAutoID] PRIMARY KEY CLUSTERED ([FinancingScheduleAutoID] ASC),
    CONSTRAINT [FK_FinancingScheduleID_EventId] FOREIGN KEY ([EventId]) REFERENCES [Core].[Event] ([EventID])
);

