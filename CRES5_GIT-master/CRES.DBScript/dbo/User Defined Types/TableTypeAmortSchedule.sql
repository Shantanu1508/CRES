CREATE TYPE [dbo].[TableTypeAmortSchedule] AS TABLE (
    [NoteID]                 UNIQUEIDENTIFIER NULL,
    [Value]                  DECIMAL (28, 12) NULL,
    [Date]                   DATE             NULL,
    [AccountId]              NVARCHAR (MAX)   NULL,
    [DealAmortScheduleRowno] INT              NULL);

