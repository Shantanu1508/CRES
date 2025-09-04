CREATE TYPE [VAL].[tbltype_PricingGrid] AS TABLE (
    [MarkedDate]        DATE             NULL,
    [PropertyType]      NVARCHAR (256)   NULL,
    [DealType]          NVARCHAR (256)   NULL,
    [AnoteLTV]          DECIMAL (28, 15) NULL,
    [AnoteSpread]       DECIMAL (28, 15) NULL,
    [ABwholeLoanLTV]    DECIMAL (28, 15) NULL,
    [ABwholeLoanSpread] DECIMAL (28, 15) NULL,
    [EquityLTV]         DECIMAL (28, 15) NULL,
    [EquityYield]       DECIMAL (28, 15) NULL,
    [UserID]            NVARCHAR (256)   NULL);
GO

