CREATE TABLE [Core].[GeneralSetupDetailsEquity] (
    [GeneralSetupDetailsEquityAutoID] INT              IDENTITY (1, 1) NOT NULL,
    [GeneralSetupDetailsEquityID]     UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [EventId]                         UNIQUEIDENTIFIER NOT NULL,
    [Commitment]                      DECIMAL (28, 15) NULL,
    [InitialMaturityDate]             DATE             NULL,
    [CreatedBy]                       NVARCHAR (256)   NULL,
    [CreatedDate]                     DATETIME         NULL,
    [UpdatedBy]                       NVARCHAR (256)   NULL,
    [UpdatedDate]                     DATETIME         NULL,
    CONSTRAINT [PK_GeneralSetupDetailsEquityAutoID] PRIMARY KEY CLUSTERED ([GeneralSetupDetailsEquityAutoID] ASC),
    CONSTRAINT [FK_GeneralSetupDetailsEquityID_EventId] FOREIGN KEY ([EventId]) REFERENCES [Core].[Event] ([EventID])
);


GO
ALTER TABLE [Core].[GeneralSetupDetailsEquity] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON);



