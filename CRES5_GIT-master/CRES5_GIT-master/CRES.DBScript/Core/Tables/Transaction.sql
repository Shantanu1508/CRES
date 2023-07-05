CREATE TABLE [Core].[Transaction] (
    [TransactionID]     UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [PeriodID]          UNIQUEIDENTIFIER NULL,
    [RegisterID]        UNIQUEIDENTIFIER NOT NULL,
    [TransactionTypeID] INT              NULL,
    [Date]              DATE             NULL,
    [Amount]            DECIMAL (28, 15) NULL,
    [IsActual]          BIT              NULL,
    [CurrencyID]        INT              NULL,
    [CreatedBy]         NVARCHAR (256)   NULL,
    [CreatedDate]       DATETIME         NULL,
    [UpdatedBy]         NVARCHAR (256)   NULL,
    [UpdatedDate]       DATETIME         NULL,
    CONSTRAINT [PK_TransactionID] PRIMARY KEY CLUSTERED ([TransactionID] ASC),
    CONSTRAINT [FK_Transaction_RegisterID] FOREIGN KEY ([RegisterID]) REFERENCES [Core].[Register] ([RegisterID])
);

