CREATE TYPE [dbo].[TableTypeFundingRepaymentSequenceWriteOff] AS TABLE (
    [DealID]			UNIQUEIDENTIFIER NOT NULL,
    [NoteID]			UNIQUEIDENTIFIER NOT NULL,
    [PriorityOverride]	INT              NULL);