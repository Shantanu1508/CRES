CREATE TYPE [dbo].[TableTypeAmortSequence] AS TABLE (
    [NoteID]       UNIQUEIDENTIFIER NULL,
    [SequenceNo]   INT              NULL,
    [SequenceType] NVARCHAR (256)   NULL,
    [Value]        DECIMAL (28, 12) NULL);

