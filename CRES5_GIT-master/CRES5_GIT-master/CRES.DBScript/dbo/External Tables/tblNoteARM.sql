CREATE EXTERNAL TABLE [dbo].[tblNoteARM] (
    [NoteId_F] INT NOT NULL,
    [DeterminationMethodDay] NVARCHAR (2) NULL
)
    WITH (
    DATA_SOURCE = [RemoteReferenceData],
    SCHEMA_NAME = N'dbo',
    OBJECT_NAME = N'tblNoteARM'
    );

