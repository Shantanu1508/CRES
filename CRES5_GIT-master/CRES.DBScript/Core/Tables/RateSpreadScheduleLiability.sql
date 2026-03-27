CREATE TABLE [Core].[RateSpreadScheduleLiability] (
    [RateSpreadScheduleLiabilityID]     UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
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
    [RateSpreadScheduleLiabilityAutoID] INT IDENTITY (1, 1) NOT NULL,
    [IndexNameID] INT NULL, 
    DeterminationDateHolidayList int null
    CONSTRAINT [PK_RateSpreadScheduleLiabilityAutoID] PRIMARY KEY CLUSTERED ([RateSpreadScheduleLiabilityAutoID] ASC),
    CONSTRAINT [FK_RateSpreadScheduleLiabilityID_EventId] FOREIGN KEY ([EventId]) REFERENCES [Core].[Event] ([EventID])
);


GO
ALTER TABLE [Core].[RateSpreadScheduleLiability] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON);
GO
