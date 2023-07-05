CREATE TABLE [IO].[IN_UnderwritingFundingSchedule] (
    [IN_UnderwritingFundingScheduleID] UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [IN_UnderwritingEventID]           UNIQUEIDENTIFIER NOT NULL,
    [Date]                             DATE             NULL,
    [Value]                            DECIMAL (28, 15) NULL,
    [CreatedBy]                        NVARCHAR (256)   NULL,
    [CreatedDate]                      DATETIME         NULL,
    [UpdatedBy]                        NVARCHAR (256)   NULL,
    [UpdatedDate]                      DATETIME         NULL,
    CONSTRAINT [PK_IN_UnderwritingFundingScheduleID] PRIMARY KEY CLUSTERED ([IN_UnderwritingFundingScheduleID] ASC),
    CONSTRAINT [FK_IN_UnderwritingFundingSchedule_IN_UnderwritingEventID] FOREIGN KEY ([IN_UnderwritingEventID]) REFERENCES [IO].[IN_UnderwritingEvent] ([IN_UnderwritingEventID])
);

