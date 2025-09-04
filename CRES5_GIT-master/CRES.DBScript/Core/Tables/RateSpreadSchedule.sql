CREATE TABLE [Core].[RateSpreadSchedule] (
    [RateSpreadScheduleID]     UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [EventId]                  UNIQUEIDENTIFIER NOT NULL,
    [Date]                     DATE             NULL,
    [ValueTypeID]              INT              NULL,
    [Value]                    DECIMAL (28, 12) NULL,
    [IntCalcMethodID]          INT              NULL,
    [CreatedBy]                NVARCHAR (256)   NULL,
    [CreatedDate]              DATETIME         NULL,
    [UpdatedBy]                NVARCHAR (256)   NULL,
    [UpdatedDate]              DATETIME         NULL,
    [RateOrSpreadToBeStripped] DECIMAL (28, 15) NULL,
    [RateSpreadScheduleAutoID] INT              IDENTITY (1, 1) NOT NULL,
    [IndexNameID] INT NULL, 
    DeterminationDateHolidayList int null
    CONSTRAINT [PK_RateSpreadScheduleAutoID] PRIMARY KEY CLUSTERED ([RateSpreadScheduleAutoID] ASC),
    CONSTRAINT [FK_RateSpreadScheduleID_EventId] FOREIGN KEY ([EventId]) REFERENCES [Core].[Event] ([EventID])
);


GO
CREATE NONCLUSTERED INDEX [nci_wi_RateSpreadSchedule_694659CDEAA68CBB551EA5F398F033EC]
    ON [Core].[RateSpreadSchedule]([EventId] ASC)
    INCLUDE([CreatedBy], [CreatedDate], [Date], [IntCalcMethodID], [RateOrSpreadToBeStripped], [UpdatedBy], [UpdatedDate], [Value], [ValueTypeID]);


GO
CREATE NONCLUSTERED INDEX [IX_RateSpreadSchedule_Date]
    ON [Core].[RateSpreadSchedule]([Date] ASC)
    INCLUDE([EventId], [ValueTypeID], [Value]);


GO
CREATE NONCLUSTERED INDEX [IX_RateSpreadSchedule_ValueTypeID_Date]
    ON [Core].[RateSpreadSchedule]([ValueTypeID] ASC, [Date] ASC)
    INCLUDE([EventId], [Value]);


GO
ALTER TABLE [Core].[RateSpreadSchedule] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON);
GO