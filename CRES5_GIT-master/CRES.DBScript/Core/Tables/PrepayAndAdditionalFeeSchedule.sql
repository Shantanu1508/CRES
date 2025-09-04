CREATE TABLE [Core].[PrepayAndAdditionalFeeSchedule] (
    [PrepayAndAdditionalFeeScheduleID]     UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [EventID]                              UNIQUEIDENTIFIER NOT NULL,
    [StartDate]                            DATE             NULL,
    [ValueTypeID]                          INT              NULL,
    [Value]                                DECIMAL (28, 12) NULL,
    [IncludedLevelYield]                   DECIMAL (28, 12) CONSTRAINT [DF__PrepayAnd__Inclu__56D3D912] DEFAULT ((0)) NULL,
    [IncludedBasis]                        DECIMAL (28, 12) CONSTRAINT [DF__PrepayAnd__Inclu__57C7FD4B] DEFAULT ((0)) NULL,
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
    [PrepayAndAdditionalFeeScheduleAutoID] INT              IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_PrepayAndAdditionalFeeScheduleAutoID] PRIMARY KEY CLUSTERED ([PrepayAndAdditionalFeeScheduleAutoID] ASC),
    CONSTRAINT [FK_PrepayAndAdditionalFeeSchedule_EventID] FOREIGN KEY ([EventID]) REFERENCES [Core].[Event] ([EventID])
);


GO
ALTER TABLE [Core].[PrepayAndAdditionalFeeSchedule] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON);




GO
CREATE NONCLUSTERED INDEX [nci_wi_PrepayAndAdditionalFeeSchedule_DF440AEC2A3AA92E3EAB37CB1B7F6811]
    ON [Core].[PrepayAndAdditionalFeeSchedule]([EventID] ASC, [StartDate] ASC)
    INCLUDE([ApplyTrueUpFeature], [BaseAmountOverride], [CreatedBy], [CreatedDate], [EndDate], [FeeAmountOverride], [FeeName], [FeetobeStripped], [IncludedBasis], [IncludedLevelYield], [UpdatedBy], [UpdatedDate], [Value], [ValueTypeID]);

