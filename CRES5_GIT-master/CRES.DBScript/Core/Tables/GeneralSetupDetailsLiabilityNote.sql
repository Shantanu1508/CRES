CREATE TABLE [Core].[GeneralSetupDetailsLiabilityNote] (
    [GeneralSetupDetailsLiabilityAutoID] INT              IDENTITY (1, 1) NOT NULL,
    [GeneralSetupDetailsLiabilityID]     UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [EventId]                            UNIQUEIDENTIFIER NOT NULL,
    [PaydownAdvanceRate]                 DECIMAL (28, 15) NULL,
    [FundingAdvanceRate]                 DECIMAL (28, 15) NULL,
    [TargetAdvanceRate]                  DECIMAL (28, 15) NULL,
    [MaturityDate]                       DATE             NULL,
    [CreatedBy]                          NVARCHAR (256)   NULL,
    [CreatedDate]                        DATETIME         NULL,
    [UpdatedBy]                          NVARCHAR (256)   NULL,
    [UpdatedDate]                        DATETIME         NULL,
	[PledgeDate]						 DATE             NULL,
	[LiabilitySourceID]					 Int              NULL,
    CONSTRAINT [PK_GeneralSetupDetailsLiabilityAutoID] PRIMARY KEY CLUSTERED ([GeneralSetupDetailsLiabilityAutoID] ASC),
    CONSTRAINT [FK_GeneralSetupDetailsLiabilityID_EventId] FOREIGN KEY ([EventId]) REFERENCES [Core].[Event] ([EventID])
);


GO
ALTER TABLE [Core].[GeneralSetupDetailsLiabilityNote] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON);



