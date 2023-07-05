CREATE TABLE [Core].[BalanceTransactionSchedule] (
    [BalanceTransactionScheduleID]     UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [EventId]                          UNIQUEIDENTIFIER NOT NULL,
    [Date]                             DATE             NULL,
    [Value]                            DECIMAL (28, 15) NULL,
    [CreatedBy]                        NVARCHAR (256)   NULL,
    [CreatedDate]                      DATETIME         NULL,
    [UpdatedBy]                        NVARCHAR (256)   NULL,
    [UpdatedDate]                      DATETIME         NULL,
    [BalanceTransactionScheduleAutoID] INT              IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_BalanceTransactionScheduleAutoID] PRIMARY KEY CLUSTERED ([BalanceTransactionScheduleAutoID] ASC),
    CONSTRAINT [FK_BalanceTransactionSchedule_EventId] FOREIGN KEY ([EventId]) REFERENCES [Core].[Event] ([EventID])
);

