CREATE TABLE [IO].[IN_UnderwritingStrippingSchedule] (
    [IN_UnderwritingStrippingScheduleID] UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [IN_UnderwritingEventID]             UNIQUEIDENTIFIER NOT NULL,
    [StartDate]                          DATE             NOT NULL,
    [ValueTypeID]                        INT              NOT NULL,
    [Value]                              DECIMAL (28, 12) NOT NULL,
    [CreatedBy]                          NVARCHAR (256)   NULL,
    [CreatedDate]                        DATETIME         NULL,
    [UpdatedBy]                          NVARCHAR (256)   NULL,
    [UpdatedDate]                        DATETIME         NULL,
    CONSTRAINT [PK_IN_UnderwritingStrippingScheduleID] PRIMARY KEY CLUSTERED ([IN_UnderwritingStrippingScheduleID] ASC),
    CONSTRAINT [FK_IN_UnderwritingStrippingSchedule_IN_UnderwritingEventID] FOREIGN KEY ([IN_UnderwritingEventID]) REFERENCES [IO].[IN_UnderwritingEvent] ([IN_UnderwritingEventID])
);

