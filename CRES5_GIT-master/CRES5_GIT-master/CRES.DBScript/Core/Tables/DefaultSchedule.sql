CREATE TABLE [Core].[DefaultSchedule] (
    [DefaultScheduleID]     UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [EventId]               UNIQUEIDENTIFIER NOT NULL,
    [StartDate]             DATE             NULL,
    [EndDate]               DATE             NULL,
    [ValueTypeID]           INT              NULL,
    [Value]                 DECIMAL (28, 12) NULL,
    [CreatedBy]             NVARCHAR (256)   NULL,
    [CreatedDate]           DATETIME         NULL,
    [UpdatedBy]             NVARCHAR (256)   NULL,
    [UpdatedDate]           DATETIME         NULL,
    [DefaultScheduleAutoID] INT              IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_DefaultScheduleAutoID] PRIMARY KEY CLUSTERED ([DefaultScheduleAutoID] ASC),
    CONSTRAINT [FK_DefaultScheduleID_EventId] FOREIGN KEY ([EventId]) REFERENCES [Core].[Event] ([EventID])
);

