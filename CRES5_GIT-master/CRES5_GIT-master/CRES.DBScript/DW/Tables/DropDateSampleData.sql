CREATE TABLE [DW].[DropDateSampleData] (
    [NoteID]                                 NVARCHAR (256)   NULL,
    [DealName]                               NVARCHAR (256)   NULL,
    [NoteName]                               NVARCHAR (256)   NULL,
    [TotalInterest]                          DECIMAL (28, 15) NULL,
    [ExpectedPaymentDueToBillingCutoffDate]  DECIMAL (28, 15) NULL,
    [Delta]                                  DECIMAL (28, 15) NULL,
    [MonthYear]                              DATE             NULL,
    [RollingAdjustedVarianceFromPriorPeriod] DECIMAL (28, 15) NULL,
    [TotalExpectedPayment]                   DECIMAL (28, 15) NULL
);

