CREATE TABLE [Core].[StrippingSchedule] (
    [StrippingScheduleID]     UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [EventID]                 UNIQUEIDENTIFIER NOT NULL,
    [StartDate]               DATE             NULL,
    [ValueTypeID]             INT              NULL,
    [Value]                   DECIMAL (28, 12) NULL,
    [IncludedLevelYield]      DECIMAL (28, 12) NULL,
    [IncludedBasis]           DECIMAL (28, 12) NULL,
    [CreatedBy]               NVARCHAR (256)   NULL,
    [CreatedDate]             DATETIME         NULL,
    [UpdatedBy]               NVARCHAR (256)   NULL,
    [UpdatedDate]             DATETIME         NULL,
    [StrippingScheduleAutoID] INT              IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_StrippingScheduleAutoID] PRIMARY KEY CLUSTERED ([StrippingScheduleAutoID] ASC),
    CONSTRAINT [FK_StrippingSchedule_EventID] FOREIGN KEY ([EventID]) REFERENCES [Core].[Event] ([EventID])
);

