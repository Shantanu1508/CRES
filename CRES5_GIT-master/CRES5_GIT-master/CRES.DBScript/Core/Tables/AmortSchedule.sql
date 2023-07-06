CREATE TABLE [Core].[AmortSchedule] (
    [AmortScheduleID]        UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [EventId]                UNIQUEIDENTIFIER NOT NULL,
    [Date]                   DATE             NULL,
    [Value]                  DECIMAL (28, 15) NULL,
    [CreatedBy]              NVARCHAR (256)   NULL,
    [CreatedDate]            DATETIME         NULL,
    [UpdatedBy]              NVARCHAR (256)   NULL,
    [UpdatedDate]            DATETIME         NULL,
    [DealAmortScheduleRowno] INT              NULL,
    [AmortScheduleAutoID]    INT              IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_AmortScheduleAutoID] PRIMARY KEY CLUSTERED ([AmortScheduleAutoID] ASC),
    CONSTRAINT [FK_AmortSchedule_EventId] FOREIGN KEY ([EventId]) REFERENCES [Core].[Event] ([EventID])
);


GO
CREATE NONCLUSTERED INDEX [IX_AmortSchedule_Date]
    ON [Core].[AmortSchedule]([Date] ASC)
    INCLUDE([EventId], [Value], [DealAmortScheduleRowno]);

