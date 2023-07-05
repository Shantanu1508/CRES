CREATE TABLE [Core].[FundingScheduleLog] (
    [LogDate]              DATETIME         NULL,
    [EffectiveDate]        DATETIME         NULL,
    [NoteID]               UNIQUEIDENTIFIER NOT NULL,
    [FundingScheduleLogID] INT              IDENTITY (1, 1) NOT NULL,
    [FundingScheduleID]    UNIQUEIDENTIFIER NOT NULL,
    [EventId]              UNIQUEIDENTIFIER NOT NULL,
    [Date]                 DATE             NULL,
    [Value]                DECIMAL (28, 15) NULL,
    [CreatedBy]            NVARCHAR (256)   NULL,
    [CreatedDate]          DATETIME         NULL,
    [UpdatedBy]            NVARCHAR (256)   NULL,
    [UpdatedDate]          DATETIME         NULL,
    [PurposeID]            INT              NULL,
    [Applied]              BIT              NULL,
    [DrawFundingId]        NVARCHAR (256)   NULL,
    [Comments]             NVARCHAR (MAX)   NULL,
    [Issaved]              BIT              CONSTRAINT [DF__FundingSc__Issav__52C41C63] DEFAULT ((0)) NULL,
    [DealFundingRowno]     INT              NULL,
    [DealFundingID]        UNIQUEIDENTIFIER NULL,
    [WF_CurrentStatus]     NVARCHAR (256)   NULL
);

go
ALTER TABLE [Core].[FundingScheduleLog]
ADD CONSTRAINT PK_FundingScheduleLog_FundingScheduleLogID PRIMARY KEY ([FundingScheduleLogID]);