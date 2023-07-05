CREATE TYPE [dbo].[TableTypeWellsDataTap] AS TABLE (
    [NoteID]                           NVARCHAR (256)   NULL,
    [TransactionDate]                  DATETIME         NULL,
    [Balance_After_Funding_Transacton] DECIMAL (28, 15) NULL);

