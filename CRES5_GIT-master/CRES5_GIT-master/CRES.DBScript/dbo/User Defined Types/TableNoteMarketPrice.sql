CREATE TYPE [dbo].[TableNoteMarketPrice] AS TABLE (
    [NoteID] NVARCHAR (256)   NULL,
    [Date]   DATETIME         NULL,
    [Value]  DECIMAL (28, 15) NULL);

