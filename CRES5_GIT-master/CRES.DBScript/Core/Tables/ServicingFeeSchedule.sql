CREATE TABLE [Core].[ServicingFeeSchedule] (
    [ServicingFeeScheduleID]     UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [EventId]                    UNIQUEIDENTIFIER NULL,
    [Date]                       DATE             NULL,
    [Value]                      DECIMAL (28, 12) NULL,
    [IsCapitalized]              INT              NULL,
    [CreatedBy]                  NVARCHAR (256)   NULL,
    [CreatedDate]                DATETIME         NULL,
    [UpdatedBy]                  NVARCHAR (256)   NULL,
    [UpdatedDate]                DATETIME         NULL,
    [ServicingFeeScheduleAutoID] INT              IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_ServicingFeeScheduleAutoID] PRIMARY KEY CLUSTERED ([ServicingFeeScheduleAutoID] ASC),
    CONSTRAINT [FK_ServicingFeeScheduleID_EventId] FOREIGN KEY ([EventId]) REFERENCES [Core].[Event] ([EventID])
);

