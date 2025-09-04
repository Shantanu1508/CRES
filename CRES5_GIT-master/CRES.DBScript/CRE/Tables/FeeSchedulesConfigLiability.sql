CREATE TABLE [CRE].[FeeSchedulesConfigLiability] (
    [FeeTypeNameID]                           INT              IDENTITY (1, 1) NOT NULL,
    [FeeTypeGuID]                             UNIQUEIDENTIFIER  DEFAULT (newid()) NOT NULL,
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
    [IsActive]                                BIT              DEFAULT ((1)) NULL,
    [InitialFundingID]                        INT              NULL,
    [M61AdjustedCommitmentID]                 INT              NULL,
    [PIKFundingID]                            INT              NULL,
    [PIKPrincipalPaymentID]                   INT              NULL,
    [CurtailmentID]                           INT              NULL,
    [UpsizeAmountID]                          INT              NULL,
    [UnfundedCommitmentID]                    INT              NULL,
    CONSTRAINT [PK_FeeTypeNameIDLiability] PRIMARY KEY CLUSTERED ([FeeTypeNameID] ASC)
);


GO
ALTER TABLE [CRE].[FeeSchedulesConfigLiability] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON);




