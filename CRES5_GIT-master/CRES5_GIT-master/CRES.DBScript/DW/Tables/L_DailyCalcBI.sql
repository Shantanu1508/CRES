CREATE TABLE [DW].[L_DailyCalcBI] (
    [DailyCalcID] UNIQUEIDENTIFIER NULL,
    [AccountID]   UNIQUEIDENTIFIER NULL,
    [CalcValueID] INT              NULL,
    [Date]        DATE             NULL,
    [Amount]      DECIMAL (28, 15) NULL,
    [IsActual]    BIT              NULL,
    [CurrencyID]  INT              NULL,
    [CalcValueBI] NVARCHAR (256)   NULL,
    [CurrencyBI]  NVARCHAR (256)   NULL,
    [CreatedBy]   NVARCHAR (256)   NULL,
    [CreatedDate] DATETIME         NULL,
    [UpdatedBy]   NVARCHAR (256)   NULL,
    [UpdatedDate] DATETIME         NULL
);

