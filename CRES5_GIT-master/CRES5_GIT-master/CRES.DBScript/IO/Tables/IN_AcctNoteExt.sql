CREATE TABLE [IO].[IN_AcctNoteExt] (
    [ControlId]             NVARCHAR (10)  NOT NULL,
    [NoteId_F]              INT            NULL,
    [NoteExtensionId]       INT            NULL,
    [ExtStatedMaturityDate] DATE           NULL,
    [ExecutedSw]            INT            NULL,
    [ShardName]             NVARCHAR (MAX) NULL
);

