CREATE TABLE [IO].[IN_UnderwritingEvent] (
    [IN_UnderwritingEventID]   UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [IN_UnderwritingAccountID] UNIQUEIDENTIFIER NOT NULL,
    [Date]                     DATE             NULL,
    [EventTypeID]              INT              NULL,
    [EffectiveStartDate]       DATE             NULL,
    [EffectiveEndDate]         DATE             NULL,
    [SingleEventValue]         DECIMAL (28, 15) NULL,
    [CreatedBy]                NVARCHAR (256)   NULL,
    [CreatedDate]              DATETIME         NULL,
    [UpdatedBy]                NVARCHAR (256)   NULL,
    [UpdatedDate]              DATETIME         NULL,
    CONSTRAINT [PK_IN_UnderwritingEventID] PRIMARY KEY CLUSTERED ([IN_UnderwritingEventID] ASC),
    CONSTRAINT [FK_IN_Underwriting_IN_UnderwritingAccountID] FOREIGN KEY ([IN_UnderwritingAccountID]) REFERENCES [IO].[IN_UnderwritingAccount] ([IN_UnderwritingAccountID])
);

