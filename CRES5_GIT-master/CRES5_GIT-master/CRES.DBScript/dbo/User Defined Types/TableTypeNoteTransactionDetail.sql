CREATE TYPE [dbo].[TableTypeNoteTransactionDetail] AS TABLE (
    [TransactionTypeText]     NVARCHAR (256)   NULL,
    [TransactionDate]         DATE             NULL,
    [TransactionAmount]       DECIMAL (28, 15) NULL,
    [RelatedtoModeledPMTDate] DATE             NULL);

