CREATE TABLE [Core].[PeriodCloseArchive] (
    [PeriodCloseArchiveID]            UNIQUEIDENTIFIER CONSTRAINT [DF__PeriodClo__Perio__5F141958] DEFAULT (newid()) NOT NULL,
    [PeriodID]                        UNIQUEIDENTIFIER NULL,
    [NoteID]                          UNIQUEIDENTIFIER NULL,
    [PeriodEndDate]                   DATE             NULL,
    [PVBasis]                         DECIMAL (28, 15) NULL,
    [DeferredFeeAccrual]              DECIMAL (28, 15) NULL,
    [DiscountPremiumAccrual]          DECIMAL (28, 15) NULL,
    [CapitalizedCostAccrual]          DECIMAL (28, 15) NULL,
    [AnalysisID]                      UNIQUEIDENTIFIER NULL,
    [CreatedBy]                       NVARCHAR (256)   NULL,
    [CreatedDate]                     DATETIME         NULL,
    [UpdatedBy]                       NVARCHAR (256)   NULL,
    [UpdatedDate]                     DATETIME         NULL,
    [EndingGAAPBookValue]             DECIMAL (28, 15) NULL,
    [IsDeleted]                       INT              CONSTRAINT [DF__PeriodClo__IsDel__60083D91] DEFAULT ((0)) NOT NULL,
    [InterestReceivedinCurrentPeriod] DECIMAL (28, 15) NULL,
    [CurrentPeriodInterestAccrual]    DECIMAL (28, 15) NULL,
    [AllInBasisValuation]             DECIMAL (28, 15) NULL,
    CONSTRAINT [PK_PeriodCloseArchiveID] PRIMARY KEY CLUSTERED ([PeriodCloseArchiveID] ASC)
);

