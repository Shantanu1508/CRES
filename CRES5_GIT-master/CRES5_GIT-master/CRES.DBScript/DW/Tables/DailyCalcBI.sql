CREATE TABLE [DW].[DailyCalcBI] (
    [DailyCalcID]  UNIQUEIDENTIFIER NOT NULL,
    [AccountID]    UNIQUEIDENTIFIER NULL,
    [CalcValueID]  INT              NULL,
    [Date]         DATE             NULL,
    [Amount]       DECIMAL (28, 15) NULL,
    [IsActual]     BIT              NULL,
    [CurrencyID]   INT              NULL,
    [CalcValueBI]  NVARCHAR (256)   NULL,
    [CurrencyBI]   NVARCHAR (256)   NULL,
    [ImportBIDate] DATETIME         NULL,
    [CreatedBy]    NVARCHAR (256)   NULL,
    [CreatedDate]  DATETIME         NULL,
    [UpdatedBy]    NVARCHAR (256)   NULL,
    [UpdatedDate]  DATETIME         NULL,
    CONSTRAINT [PK_DailyCalcID] PRIMARY KEY CLUSTERED ([DailyCalcID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [iDailyCalcBI_AccountID_Date]
    ON [DW].[DailyCalcBI]([AccountID] ASC, [Date] ASC);

