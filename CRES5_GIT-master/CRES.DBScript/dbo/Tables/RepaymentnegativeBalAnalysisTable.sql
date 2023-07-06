CREATE TABLE [dbo].[RepaymentnegativeBalAnalysisTable] (
    [creDealID]             VARCHAR (100)    NULL,
    [DealName]              VARCHAR (100)    NULL,
    [creNoteid]             VARCHAR (100)    NULL,
    [HasScheduledPrincipal] VARCHAR (100)    NULL,
    [SmallVsHighBal]        VARCHAR (100)    NULL,
    [UserRuleYvsUseRuleN]   VARCHAR (100)    NULL,
    [FF_Vs_FullyFunded]     VARCHAR (100)    NULL,
    [Date]                  DATE             NULL,
    [endingbalance]         DECIMAL (28, 15) NULL,
    [ScheduledPrincipal]    DECIMAL (28, 15) NULL,
    [Delta]                 DECIMAL (28, 15) NULL
);

