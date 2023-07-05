CREATE TABLE [CRE].[PeriodicInterestRateUsed] (
    [PeriodicInterestRateUsedID]            INT              IDENTITY (1, 1) NOT NULL,
    [PeriodicInterestRateUsedGUID]          UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [NoteID]                                UNIQUEIDENTIFIER NOT NULL,
    [Date]                                  DATETIME         NULL,
    [CouponSpread]                          DECIMAL (28, 15) NULL,
    [AllInCouponRate]                       DECIMAL (28, 15) NULL,
    [AllInPikRate]                          DECIMAL (28, 15) NULL,
    [LiborRate]                             DECIMAL (28, 15) NULL,
    [IndexFloor]                            DECIMAL (28, 15) NULL,
    [CouponRate]                            DECIMAL (28, 15) NULL,
    [AdditionalPIKinterestRatefromPIKTable] DECIMAL (28, 15) NULL,
    [AdditionalPIKSpreadfromPIKTable]       DECIMAL (28, 15) NULL,
    [PIKIndexFloorfromPIKTable]             DECIMAL (28, 15) NULL,
    [AnalysisID]                            UNIQUEIDENTIFIER NULL,
    [CreatedBy]                             NVARCHAR (256)   NULL,
    [CreatedDate]                           DATETIME         NULL,
    [UpdatedBy]                             NVARCHAR (256)   NULL,
    [UpdatedDate]                           DATETIME         NULL,
    CONSTRAINT [PK_PeriodicInterestRateUsedID] PRIMARY KEY CLUSTERED ([PeriodicInterestRateUsedID] ASC),
    CONSTRAINT [FK_PeriodicInterestRateUsed_Note_NoteID] FOREIGN KEY ([NoteID]) REFERENCES [CRE].[Note] ([NoteID])
);

