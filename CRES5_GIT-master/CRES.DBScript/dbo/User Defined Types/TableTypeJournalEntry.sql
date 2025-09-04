CREATE TYPE [dbo].[TableTypeJournalEntry] AS TABLE (
    [JournalEntryMasterId]  INT NULL,
    [DebtEquityAccountID] UNIQUEIDENTIFIER NULL,
    [TransactionDate]     DATE NULL,
	[TransactionTypeText] Nvarchar(MAX) NULL,
	[TransactionAmount]   Decimal(28,15) NULL,
    [Comment]             Nvarchar(256),
	[TransactionEntryID]  INT NULL
	);

