CREATE TABLE [DW].[Staging_IntegartionCashFlowBI] (
    [Scenario]                                     NVARCHAR (256)   NULL,
    [AnalysisID]                                   UNIQUEIDENTIFIER NULL,
    [NoteKey]                                      UNIQUEIDENTIFIER NULL,
    [NoteID]                                       NVARCHAR (256)   NULL,
    [PeriodEndDate]                                DATE             NULL,
    [In_EndingGAAPBookValue]                       DECIMAL (28, 15) NULL,
    [In_TotalAmortAccrualForPeriod]                DECIMAL (28, 15) NULL,
    [In_AccumulatedAmort]                          DECIMAL (28, 15) NULL,
    [In_DiscountPremiumAccrual]                    DECIMAL (28, 15) NULL,
    [In_AccumaltedDiscountPremium]                 DECIMAL (28, 15) NULL,
    [In_CapitalizedCostAccrual]                    DECIMAL (28, 15) NULL,
    [In_AccumalatedCapitalizedCost]                DECIMAL (28, 15) NULL,
    [In_CurrentPeriodInterestAccrualPeriodEnddate] DECIMAL (28, 15) NULL,
    [St_EndingGAAPBookValue]                       DECIMAL (28, 15) NULL,
    [St_TotalAmortAccrualForPeriod]                DECIMAL (28, 15) NULL,
    [St_AccumulatedAmort]                          DECIMAL (28, 15) NULL,
    [St_DiscountPremiumAccrual]                    DECIMAL (28, 15) NULL,
    [St_AccumaltedDiscountPremium]                 DECIMAL (28, 15) NULL,
    [St_CapitalizedCostAccrual]                    DECIMAL (28, 15) NULL,
    [St_AccumalatedCapitalizedCost]                DECIMAL (28, 15) NULL,
    [St_CurrentPeriodInterestAccrualPeriodEnddate] DECIMAL (28, 15) NULL
);

