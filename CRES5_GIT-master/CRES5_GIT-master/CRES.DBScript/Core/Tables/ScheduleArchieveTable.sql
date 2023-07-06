CREATE TABLE [Core].[ScheduleArchieveTable] (
    [ScheduleArchieveTableid] UNIQUEIDENTIFIER CONSTRAINT [DF__ScheduleA__Sched__6ABAD62E] DEFAULT (newid()) NOT NULL,
    [EventId]                 UNIQUEIDENTIFIER NULL,
    [Date]                    DATE             NULL,
    [ValueTypeID]             INT              NULL,
    [Value]                   DECIMAL (28, 12) NULL,
    [IntCalcMethodID]         INT              NULL,
    [StartDate]               DATE             NULL,
    [IncludedLevelYield]      DECIMAL (28, 12) NULL,
    [IncludedBasis]           DECIMAL (28, 12) NULL,
    [EventTypeID]             INT              NULL,
    [CreatedBy]               NVARCHAR (256)   NULL,
    [CreatedDate]             DATE             NULL,
    [UpdatedBy]               NVARCHAR (256)   NULL,
    [UpdatedDate]             DATE             NULL,
    [ArchieveBy]              NVARCHAR (256)   NULL,
    [ArchieveDate]            DATE             NULL
);

