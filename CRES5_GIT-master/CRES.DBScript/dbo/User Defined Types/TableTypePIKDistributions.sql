CREATE TYPE [dbo].[TableTypePIKDistributions] AS TABLE (
    [SourceNoteID]    UNIQUEIDENTIFIER NULL,
    [ReceiverNoteID]  UNIQUEIDENTIFIER NULL,
    [TransactionDate] DATETIME         NULL,
    [Amount]          DECIMAL (28, 15) NULL);

