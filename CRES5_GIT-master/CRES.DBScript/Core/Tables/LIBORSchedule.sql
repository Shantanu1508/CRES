CREATE TABLE [Core].[LIBORSchedule] (
    [LIBORScheduleID]     UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [EventId]             UNIQUEIDENTIFIER NOT NULL,
    [Date]                DATE             NULL,
    [Value]               DECIMAL (28, 15) NULL,
    [CreatedBy]           NVARCHAR (256)   NULL,
    [CreatedDate]         DATETIME         NULL,
    [UpdatedBy]           NVARCHAR (256)   NULL,
    [UpdatedDate]         DATETIME         NULL,
    [LIBORScheduleAutoID] INT              IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_LIBORScheduleAutoID] PRIMARY KEY CLUSTERED ([LIBORScheduleAutoID] ASC),
    CONSTRAINT [FK_LIBORSchedule_EventId] FOREIGN KEY ([EventId]) REFERENCES [Core].[Event] ([EventID])
);


GO
CREATE NONCLUSTERED INDEX [nci_wi_LIBORSchedule_49153A4557ABC4BDFBD8A6C2CA76226F]
    ON [Core].[LIBORSchedule]([Date] ASC)
    INCLUDE([EventId], [Value]);


GO
CREATE NONCLUSTERED INDEX [IX_LIBORSchedule_EventId]
    ON [Core].[LIBORSchedule]([EventId] ASC);

