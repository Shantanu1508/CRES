CREATE TABLE [Core].[FundingSchedule] (
    [FundingScheduleID]     UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [EventId]               UNIQUEIDENTIFIER NOT NULL,
    [Date]                  DATE             NULL,
    [Value]                 DECIMAL (28, 15) NULL,
    [CreatedBy]             NVARCHAR (256)   NULL,
    [CreatedDate]           DATETIME         NULL,
    [UpdatedBy]             NVARCHAR (256)   NULL,
    [UpdatedDate]           DATETIME         NULL,
    [PurposeID]             INT              NULL,
    [Applied]               BIT              NULL,
    [DrawFundingId]         NVARCHAR (256)   NULL,
    [Comments]              NVARCHAR (MAX)   NULL,
    [Issaved]               BIT              CONSTRAINT [DF__FundingSc__Issav__63E3BB6D] DEFAULT ((0)) NULL,
    [DealFundingRowno]      INT              NULL,
    [DealFundingID]         UNIQUEIDENTIFIER NULL,
    [WF_CurrentStatus]      NVARCHAR (256)   NULL,
    [FundingScheduleAutoID] INT              IDENTITY (1, 1) NOT NULL,
    [GeneratedBy]  INT   NULL
    CONSTRAINT [PK_FundingScheduleAutoID] PRIMARY KEY CLUSTERED ([FundingScheduleAutoID] ASC),
    CONSTRAINT [FK_FundingSchedule_EventId] FOREIGN KEY ([EventId]) REFERENCES [Core].[Event] ([EventID])
);


GO
CREATE NONCLUSTERED INDEX [nci_wi_FundingSchedule_23D4364CEC12F6105DC940E248B5E71E]
    ON [Core].[FundingSchedule]([EventId] ASC, [DealFundingID] ASC)
    INCLUDE([Applied], [Comments], [CreatedBy], [CreatedDate], [Date], [DealFundingRowno], [DrawFundingId], [Issaved], [PurposeID], [UpdatedBy], [UpdatedDate], [Value]);

