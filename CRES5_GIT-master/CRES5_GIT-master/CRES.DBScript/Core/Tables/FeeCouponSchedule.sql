CREATE TABLE [Core].[FeeCouponSchedule] (
    [FeeCouponScheduleID]     UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [EventId]                 UNIQUEIDENTIFIER NOT NULL,
    [Date]                    DATE             NOT NULL,
    [ValueTypeID]             INT              NOT NULL,
    [Value]                   DECIMAL (28, 12) NOT NULL,
    [PctIncludedInLevelYield] INT              NOT NULL,
    [PctIncludedInBasisCalc]  INT              NOT NULL,
    [CreatedBy]               NVARCHAR (256)   NULL,
    [CreatedDate]             DATETIME         NULL,
    [UpdatedBy]               NVARCHAR (256)   NULL,
    [UpdatedDate]             DATETIME         NULL,
    [FeeCouponScheduleAutoID] INT              IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_FeeCouponScheduleAutoID] PRIMARY KEY CLUSTERED ([FeeCouponScheduleAutoID] ASC),
    CONSTRAINT [FK_FeeCouponScheduleID_EventId] FOREIGN KEY ([EventId]) REFERENCES [Core].[Event] ([EventID])
);

