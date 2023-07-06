CREATE TABLE [Core].[DailyCalc] (
    [DailyCalcID] UNIQUEIDENTIFIER CONSTRAINT [DF__DailyCalc__Daily__373B3228] DEFAULT (newid()) NOT NULL,
    [AccountID]   UNIQUEIDENTIFIER NULL,
    [CalcValueID] INT              NULL,
    [Date]        DATE             NULL,
    [Amount]      DECIMAL (28, 15) NULL,
    [IsActual]    BIT              NULL,
    [CurrencyID]  INT              NULL,
    [CreatedBy]   NVARCHAR (256)   NULL,
    [CreatedDate] DATETIME         NULL,
    [UpdatedBy]   NVARCHAR (256)   NULL,
    [UpdatedDate] DATETIME         NULL,
    CONSTRAINT [PK_DailyCalcID] PRIMARY KEY CLUSTERED ([DailyCalcID] ASC),
    CONSTRAINT [FK_DailyCalc_AccountID] FOREIGN KEY ([AccountID]) REFERENCES [Core].[Account] ([AccountID])
);

