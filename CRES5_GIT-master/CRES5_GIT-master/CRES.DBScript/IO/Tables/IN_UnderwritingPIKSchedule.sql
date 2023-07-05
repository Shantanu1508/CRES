CREATE TABLE [IO].[IN_UnderwritingPIKSchedule] (
    [IN_UnderwritingPIKScheduleID] UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [IN_UnderwritingEventID]       UNIQUEIDENTIFIER NOT NULL,
    [AdditionalIntRate]            DECIMAL (28, 15) NOT NULL,
    [StartDate]                    DATE             NOT NULL,
    [EndDate]                      DATE             NOT NULL,
    [CreatedBy]                    NVARCHAR (256)   NULL,
    [CreatedDate]                  DATETIME         NULL,
    [UpdatedBy]                    NVARCHAR (256)   NULL,
    [UpdatedDate]                  DATETIME         NULL,
    CONSTRAINT [PK_IN_UnderwritingPIKScheduleID] PRIMARY KEY CLUSTERED ([IN_UnderwritingPIKScheduleID] ASC),
    CONSTRAINT [FK_IN_UnderwritingPIKSchedule_IN_UnderwritingEventID] FOREIGN KEY ([IN_UnderwritingEventID]) REFERENCES [IO].[IN_UnderwritingEvent] ([IN_UnderwritingEventID])
);

