CREATE TABLE [IO].[IN_UnderwritingRateSpreadSchedule] (
    [IN_UnderwritingRateSpreadScheduleID] UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [IN_UnderwritingEventID]              UNIQUEIDENTIFIER NOT NULL,
    [Date]                                DATE             NOT NULL,
    [ValueTypeID]                         INT              NOT NULL,
    [Value]                               DECIMAL (28, 12) NOT NULL,
    [IntCalcMethodID]                     INT              NOT NULL,
    [CreatedBy]                           NVARCHAR (256)   NULL,
    [CreatedDate]                         DATETIME         NULL,
    [UpdatedBy]                           NVARCHAR (256)   NULL,
    [UpdatedDate]                         DATETIME         NULL,
    CONSTRAINT [PK_IN_UnderwritingRateSpreadScheduleID] PRIMARY KEY CLUSTERED ([IN_UnderwritingRateSpreadScheduleID] ASC),
    CONSTRAINT [FK_IN_UnderwritingRateSpreadScheduleID_IN_UnderwritingEventID] FOREIGN KEY ([IN_UnderwritingEventID]) REFERENCES [IO].[IN_UnderwritingEvent] ([IN_UnderwritingEventID])
);

