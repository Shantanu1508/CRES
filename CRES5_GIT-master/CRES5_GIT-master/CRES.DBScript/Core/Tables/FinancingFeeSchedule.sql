CREATE TABLE [Core].[FinancingFeeSchedule] (
    [FinancingFeeScheduleID]     UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [EventId]                    UNIQUEIDENTIFIER NOT NULL,
    [Date]                       DATE             NULL,
    [ValueTypeID]                INT              NULL,
    [Value]                      DECIMAL (28, 12) NULL,
    [CreatedBy]                  NVARCHAR (256)   NULL,
    [CreatedDate]                DATETIME         NULL,
    [UpdatedBy]                  NVARCHAR (256)   NULL,
    [UpdatedDate]                DATETIME         NULL,
    [FinancingFeeScheduleAutoID] INT              IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_FinancingFeeScheduleAutoID] PRIMARY KEY CLUSTERED ([FinancingFeeScheduleAutoID] ASC),
    CONSTRAINT [FK_FinancingFeeScheduleID_EventId] FOREIGN KEY ([EventId]) REFERENCES [Core].[Event] ([EventID])
);

