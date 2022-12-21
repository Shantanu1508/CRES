CREATE EXTERNAL TABLE [dbo].[tblNoteExp] (
    [NoteExpId] INT NULL,
    [NoteId_F] INT NOT NULL,
    [ServicerLoanNumber] NVARCHAR (20) NULL
)
    WITH (
    DATA_SOURCE = [RemoteReferenceData]
    );

