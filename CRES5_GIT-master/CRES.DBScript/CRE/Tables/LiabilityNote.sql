CREATE TABLE [CRE].[LiabilityNote] (
    [LiabilityNoteAutoID]     INT              IDENTITY (1, 1) NOT NULL,
    [LiabilityNoteGUID]       UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [AccountID]               UNIQUEIDENTIFIER NULL,
    [DealAccountID]           UNIQUEIDENTIFIER NULL,
    [LiabilityNoteID]         NVARCHAR (256)   NULL,
    [LiabilityTypeID]         UNIQUEIDENTIFIER NULL,
    [AssetAccountID]          UNIQUEIDENTIFIER NULL,
    --[PledgeDate]              DATE             NULL,
    [CurrentAdvanceRate]      DECIMAL (28, 15) NULL,
    [TargetAdvanceRate]       DECIMAL (28, 15) NULL,
    [CurrentBalance]          DECIMAL (28, 15) NULL,
    [UndrawnCapacity]         DECIMAL (28, 15) NULL,
    [CreatedBy]               NVARCHAR (256)   NULL,
    [CreatedDate]             DATETIME         NULL,
    [UpdatedBy]               NVARCHAR (256)   NULL,
    [UpdatedDate]             DATETIME         NULL,
    [TempBalanceAsofCalcDate] DECIMAL (28, 15) NULL,
    [ThirdPartyOwnership]     DECIMAL (28, 15) NULL,
	[PaymentFrequency]                        INT              NULL,
    --[InitialInterestAccrualEndDate]           DATE             NULL,
	[AccrualEndDateBusinessDayLag]			  INT              NULL,
    [AccrualFrequency]                        INT              NULL,
    --[PaymentDayOfMonth]                       INT              NULL,
    --[PaymentDateBusinessDayLag]               INT              NULL,
    --[DeterminationDateLeadDays]               INT              NULL,
    --[DeterminationDateReferenceDayOftheMonth] INT              NULL,
	[Roundingmethod]                          INT              NULL,
    [IndexRoundingRule]                       INT              NULL,
	[FinanacingSpreadRate]                    DECIMAL (28, 15) NULL,
	[IntActMethod]                            INT              NULL,
    [DefaultIndexName]                        INT              NULL,
    UseNoteLevelOverride bit null,
    --InitialIndexValueOverride decimal(28,15),
	[DebtEquityTypeID]                        INT              NULL,
	--[FirstRateIndexResetDate]           DATE             NULL,
    --LiabilitySource int null,
	pmtdtaccper int null,
    ResetIndexDaily  int null,
	[ActiveLiabilityNote]					INT NULL

    CONSTRAINT [PK_LiabilityNoteAutoID] PRIMARY KEY CLUSTERED ([LiabilityNoteAutoID] ASC),
    CONSTRAINT [PK_LiabilityNote_AccountID] FOREIGN KEY ([AccountID]) REFERENCES [Core].[Account] ([AccountID])
);


GO
ALTER TABLE [CRE].[LiabilityNote] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON);




GO




