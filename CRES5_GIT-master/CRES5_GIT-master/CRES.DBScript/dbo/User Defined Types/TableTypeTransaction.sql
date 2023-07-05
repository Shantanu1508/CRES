CREATE TYPE [dbo].[TableTypeTransaction] AS TABLE (
    [PeriodID]        UNIQUEIDENTIFIER NULL,
    [RegisterID]      UNIQUEIDENTIFIER NULL,
    [TransactionType] NVARCHAR (256)   NULL,
    [Date]            DATE             NULL,
    [Amount]          DECIMAL (28, 15) NULL,
    [IsActual]        BIT              NULL,
    [CurrencyID]      INT              NULL);

