CREATE TYPE [dbo].[TableTypeFundingRepaymentSequence] AS TABLE (
    [NoteID]       UNIQUEIDENTIFIER NULL,
    [SequenceNo]   INT              NULL,
    [SequenceType] INT              NULL,
    [Value]        DECIMAL (28, 12) NULL);

