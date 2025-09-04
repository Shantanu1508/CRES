CREATE TABLE [Core].[GeneralSetupDetailsDebt] (
    [GeneralSetupDetailsDebtAutoID] INT              IDENTITY (1, 1) NOT NULL,
    [GeneralSetupDetailsDebtID]     UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [EventId]                       UNIQUEIDENTIFIER NOT NULL,
    [Commitment]                    DECIMAL (28, 15) NULL,
    [InitialMaturityDate]           DATE             NULL,
    [ExitFee]                       DECIMAL (28, 15) NULL,
    [ExtensionFees]                 DECIMAL (28, 15) NULL,
    [CreatedBy]                     NVARCHAR (256)   NULL,
    [CreatedDate]                   DATETIME         NULL,
    [UpdatedBy]                     NVARCHAR (256)   NULL,
    [UpdatedDate]                   DATETIME         NULL,
    CONSTRAINT [PK_GeneralSetupDetailsDebtAutoID] PRIMARY KEY CLUSTERED ([GeneralSetupDetailsDebtAutoID] ASC),
    CONSTRAINT [FK_GeneralSetupDetailsDebtID_EventId] FOREIGN KEY ([EventId]) REFERENCES [Core].[Event] ([EventID])
);


GO
ALTER TABLE [Core].[GeneralSetupDetailsDebt] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON);



