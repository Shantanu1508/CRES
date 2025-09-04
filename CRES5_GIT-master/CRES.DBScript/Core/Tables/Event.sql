CREATE TABLE [Core].[Event] (
    [EventID]            UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [AccountID]          UNIQUEIDENTIFIER NOT NULL,
    [Date]               DATE             NULL,
    [EventTypeID]        INT              NULL,
    [EffectiveStartDate] DATE             NULL,
    [EffectiveEndDate]   DATE             NULL,
    [SingleEventValue]   DECIMAL (28, 15) NULL,
    [CreatedBy]          NVARCHAR (256)   NULL,
    [CreatedDate]        DATETIME         NULL,
    [UpdatedBy]          NVARCHAR (256)   NULL,
    [UpdatedDate]        DATETIME         NULL,
    [StatusID]           INT              NULL,
    [EventAutoID]        INT              IDENTITY (1, 1) NOT NULL,
	[AdditionalAccountID]  UNIQUEIDENTIFIER  NULL,
    CONSTRAINT [PK_EventID] PRIMARY KEY CLUSTERED ([EventID] ASC),
    CONSTRAINT [FK_Event_AccountID] FOREIGN KEY ([AccountID]) REFERENCES [Core].[Account] ([AccountID])
);





GO
CREATE NONCLUSTERED INDEX [nci_wi_Event_05D74B0EA9468E96FE8B4D9D460647A5]
    ON [Core].[Event]([AccountID] ASC, [StatusID] ASC)
    INCLUDE([CreatedBy], [CreatedDate], [Date], [EffectiveEndDate], [EffectiveStartDate], [EventTypeID], [SingleEventValue], [UpdatedBy], [UpdatedDate]);


GO
CREATE NONCLUSTERED INDEX [nci_wi_Event_DC9968695D853BBEDC4AC400FF1A292A]
    ON [Core].[Event]([EventTypeID] ASC, [AccountID] ASC, [StatusID] ASC, [EffectiveStartDate] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Event_EventTypeID]
    ON [Core].[Event]([EventTypeID] ASC)
    INCLUDE([AccountID], [Date], [EffectiveStartDate], [EffectiveEndDate], [SingleEventValue], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [StatusID], [EventAutoID]);


GO
CREATE NONCLUSTERED INDEX [IX_Event_EventTypeID_EventAutoID]
    ON [Core].[Event]([EventTypeID] ASC, [EventAutoID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Event_StatusID]
    ON [Core].[Event]([StatusID] ASC)
    INCLUDE([AccountID], [EventTypeID], [EffectiveStartDate]);

GO
ALTER TABLE [Core].[Event] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON);
GO