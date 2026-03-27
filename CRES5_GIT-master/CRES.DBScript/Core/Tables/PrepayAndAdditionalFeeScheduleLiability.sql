CREATE TABLE [Core].[PrepayAndAdditionalFeeScheduleLiability] (
    [PrepayAndAdditionalFeeScheduleLiabilityID]     UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [EventID]                              UNIQUEIDENTIFIER NOT NULL,
    [StartDate]                            DATE             NULL,
    [ValueTypeID]                          INT              NULL,
    [Value]                                DECIMAL (28, 12) NULL,
    [IncludedLevelYield]                   DECIMAL (28, 12) NULL,
    [IncludedBasis]                        DECIMAL (28, 12) NULL,
    [CreatedBy]                            NVARCHAR (256)   NULL,
    [CreatedDate]                          DATETIME         NULL,
    [UpdatedBy]                            NVARCHAR (256)   NULL,
    [UpdatedDate]                          DATETIME         NULL,
    [FeeName]                              NVARCHAR (256)   NULL,
    [EndDate]                              DATE             NULL,
    [FeeAmountOverride]                    DECIMAL (28, 12) NULL,
    [BaseAmountOverride]                   DECIMAL (28, 12) NULL,
    [ApplyTrueUpFeature]                   INT              NULL,
    [FeetobeStripped]                      DECIMAL (28, 12) NULL,
    [PrepayAndAdditionalFeeScheduleLiabilityAutoID] INT IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_PrepayAndAdditionalFeeScheduleLiabilityAutoID] PRIMARY KEY CLUSTERED ([PrepayAndAdditionalFeeScheduleLiabilityAutoID] ASC),
    CONSTRAINT [FK_PrepayAndAdditionalFeeScheduleLiability_EventID] FOREIGN KEY ([EventID]) REFERENCES [Core].[Event] ([EventID])
);


GO
ALTER TABLE [Core].[PrepayAndAdditionalFeeScheduleLiability] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON);
GO
