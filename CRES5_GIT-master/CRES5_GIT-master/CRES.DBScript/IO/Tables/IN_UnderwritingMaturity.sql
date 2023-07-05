CREATE TABLE [IO].[IN_UnderwritingMaturity] (
    [IN_UnderwritingMaturityID] UNIQUEIDENTIFIER CONSTRAINT [DF__IN_Underw__IN_Un__640DD89F] DEFAULT (newid()) NOT NULL,
    [IN_UnderwritingEventId]    UNIQUEIDENTIFIER NOT NULL,
    [SelectedMaturityDate]      DATE             NULL,
    [CreatedBy]                 NVARCHAR (256)   NULL,
    [CreatedDate]               DATETIME         NULL,
    [UpdatedBy]                 NVARCHAR (256)   NULL,
    [UpdatedDate]               DATETIME         NULL,
    CONSTRAINT [PK_IN_UnderwritingMaturityID] PRIMARY KEY CLUSTERED ([IN_UnderwritingMaturityID] ASC),
    CONSTRAINT [FK_IN_UnderwritingMaturityID_IN_UnderwritingEventID] FOREIGN KEY ([IN_UnderwritingEventId]) REFERENCES [IO].[IN_UnderwritingEvent] ([IN_UnderwritingEventID])
);

