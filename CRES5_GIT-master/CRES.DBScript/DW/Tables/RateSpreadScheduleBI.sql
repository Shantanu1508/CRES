CREATE TABLE [DW].[RateSpreadScheduleBI] (
    [RateSpreadScheduleID]        UNIQUEIDENTIFIER NOT NULL,
    [EventId]                     UNIQUEIDENTIFIER NOT NULL,
    [Date]                        DATE             NULL,
    [ValueTypeID]                 INT              NULL,
    [Value]                       DECIMAL (28, 12) NULL,
    [IntCalcMethodID]             INT              NULL,
    [CreatedBy]                   NVARCHAR (256)   NULL,
    [CreatedDate]                 DATETIME         NULL,
    [UpdatedBy]                   NVARCHAR (256)   NULL,
    [UpdatedDate]                 DATETIME         NULL,
    [RateOrSpreadToBeStripped]    DECIMAL (28, 15) NULL,
    [ValueTypeBI]                 NVARCHAR (256)   NULL,
    [IntCalcMethodBI]             NVARCHAR (256)   NULL,
    [CreDealId]                   NVARCHAR (256)   NULL,
    [DealName]                    NVARCHAR (256)   NULL,
    [CreNoteID]                   NVARCHAR (256)   NULL,
    [NoteName]                    NVARCHAR (256)   NULL,
    [RateSpreadScheduleAutoID]    INT              NULL,
    [ScheduleText]                NVARCHAR (256)   NULL,
    [IndexNameID]                 INT              NULL,
    [IndexNameBI]                 NVARCHAR (256)   NULL,
    [EffectiveStartDate]          DATE             NULL,
    [RateSpreadScheduleBI_AutoID] INT              IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_RateSpreadScheduleBI_AutoID] PRIMARY KEY CLUSTERED ([RateSpreadScheduleBI_AutoID] ASC)
);



