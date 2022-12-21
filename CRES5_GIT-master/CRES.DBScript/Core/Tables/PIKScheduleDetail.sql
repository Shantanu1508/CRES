CREATE TABLE [Core].[PIKScheduleDetail] (
    [PIKScheduleDetailID]     UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [EventId]                 UNIQUEIDENTIFIER NOT NULL,
    [Date]                    DATE             NULL,
    [Value]                   DECIMAL (28, 15) NULL,
    [CreatedBy]               NVARCHAR (256)   NULL,
    [CreatedDate]             DATETIME         NULL,
    [UpdatedBy]               NVARCHAR (256)   NULL,
    [UpdatedDate]             DATETIME         NULL,
    [PIKScheduleDetailAutoID] INT              IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_PIKScheduleDetailAutoID] PRIMARY KEY CLUSTERED ([PIKScheduleDetailAutoID] ASC),
    CONSTRAINT [FK_PIKScheduleDetail_EventId] FOREIGN KEY ([EventId]) REFERENCES [Core].[Event] ([EventID])
);

