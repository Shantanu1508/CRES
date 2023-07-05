CREATE TABLE [CRE].[FeeSchedulesConfig] (
    [FeeTypeNameID]                           INT              IDENTITY (1, 1) NOT NULL,
    [FeeTypeGuID]                             UNIQUEIDENTIFIER CONSTRAINT [DF__FeeSchedu__FeeTy__65C116E7] DEFAULT (newid()) NOT NULL,
    [FeeTypeNameText]                         NVARCHAR (256)   NULL,
    [FeePaymentFrequencyID]                   INT              NULL,
    [FeeCoveragePeriodID]                     INT              NULL,
    [FeeFunctionID]                           INT              NULL,
    [TotalCommitmentID]                       INT              NULL,
    [UnscheduledPaydownsID]                   INT              NULL,
    [BalloonPaymentID]                        INT              NULL,
    [LoanFundingsID]                          INT              NULL,
    [ScheduledPrincipalAmortizationPaymentID] INT              NULL,
    [CurrentLoanBalanceID]                    INT              NULL,
    [InterestPaymentID]                       INT              NULL,
    [FeeNameTransID]                          INT              NULL,
    [CreatedBy]                               NVARCHAR (256)   NULL,
    [CreatedDate]                             DATETIME         NULL,
    [UpdatedBy]                               NVARCHAR (256)   NULL,
    [UpdatedDate]                             DATETIME         NULL,
    [ExcludeFromCashflowDownload]             BIT              NULL,
    [IsActive]                                BIT              CONSTRAINT [DF__FeeSchedu__IsAct__62A57E71] DEFAULT ((1)) NULL,
    [InitialFundingID]                        INT              NULL,
	[M61AdjustedCommitmentID]                 INT              NULL
    CONSTRAINT [PK_FeeTypeNameID] PRIMARY KEY CLUSTERED ([FeeTypeNameID] ASC)
);

