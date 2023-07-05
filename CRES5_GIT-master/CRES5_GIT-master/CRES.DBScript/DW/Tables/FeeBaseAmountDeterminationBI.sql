CREATE TABLE [DW].[FeeBaseAmountDeterminationBI] (
    [FeeTypeName]                           NVARCHAR (256) NULL,
    [FeePaymentFrequency]                   NVARCHAR (256) NULL,
    [FeeCoveragePeriod]                     NVARCHAR (256) NULL,
    [FeeFunction]                           NVARCHAR (256) NULL,
    [TotalCommitment]                       NVARCHAR (256) NULL,
    [UnscheduledPaydowns]                   NVARCHAR (256) NULL,
    [BalloonPayment]                        NVARCHAR (256) NULL,
    [LoanFundings]                          NVARCHAR (256) NULL,
    [ScheduledPrincipalAmortizationPayment] NVARCHAR (256) NULL,
    [CurrentLoanBalance]                    NVARCHAR (256) NULL,
    [InterestPayment]                       NVARCHAR (256) NULL,
    [FeeNameTrans]                          NVARCHAR (256) NULL
);


GO
CREATE NONCLUSTERED INDEX [iFeeBaseAmountDeterminationBI_FeeTypeName]
    ON [DW].[FeeBaseAmountDeterminationBI]([FeeTypeName] ASC);

