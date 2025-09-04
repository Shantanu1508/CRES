CREATE TABLE [CRE].[DebtExt] (
    [DebtExtID]                               INT              IDENTITY (1, 1) NOT NULL,
    [DebtExtGUID]                             UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
	[DebtAccountID]							  UNIQUEIDENTIFIER NOT NULL,
	[AdditionalAccountID]                     UNIQUEIDENTIFIER NOT NULL,
    [PaymentFrequency]                        INT              NULL,
    --[InitialInterestAccrualEndDate]           DATE             NULL,
	[AccrualEndDateBusinessDayLag]			  INT              NULL,
    [AccrualFrequency]                        INT              NULL,
    --[PaymentDayOfMonth]                       INT              NULL,
    --[PaymentDateBusinessDayLag]               INT              NULL,
    --[DeterminationDateLeadDays]               INT              NULL,
    --[DeterminationDateReferenceDayOftheMonth] INT              NULL,
    [CreatedBy]                               NVARCHAR (256)   NULL,
    [CreatedDate]                             DATETIME         NULL,
    [UpdatedBy]                               NVARCHAR (256)   NULL,
    [UpdatedDate]                             DATETIME         NULL,
	[Roundingmethod]                          INT              NULL,
    [IndexRoundingRule]                       INT              NULL,
	[FinanacingSpreadRate]                    DECIMAL (28, 15) NULL,
	[IntActMethod]                            INT              NULL,
    [DefaultIndexName]                        INT              NULL,
	[TargetAdvanceRate]                       DECIMAL (28, 15) NULL,
 --   InitialIndexValueOverride decimal(28,15),
	--[FirstRateIndexResetDate]           DATE             NULL,
	pmtdtaccper int null,
    ResetIndexDaily  int null,
    DeterminationDateHolidayList int
    CONSTRAINT [PK_DebtExtID] PRIMARY KEY CLUSTERED ([DebtExtID] ASC)
);


GO
ALTER TABLE [CRE].[DebtExt] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON);
GO