CREATE TYPE [dbo].[TableTypeServicingTransaction] AS TABLE (
    [NoteID]           NVARCHAR (256)   NULL,
    [TransactionType]  NVARCHAR (256)   NULL,
    [TransactionDate]  DATE             NULL,
    [DateDue]          DATE             NULL,
    [PrincipalPayment] DECIMAL (28, 15) NULL,
    [InterestPayment]  DECIMAL (28, 15) NULL);

