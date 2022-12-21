CREATE TABLE [IO].[Out_Note] (
    [Out_NoteID]  UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [BatchLogID]  UNIQUEIDENTIFIER NOT NULL,
    [CreatedBy]   NVARCHAR (256)   NULL,
    [CreatedDate] DATETIME         NULL,
    [UpdatedBy]   NVARCHAR (256)   NULL,
    [UpdatedDate] DATETIME         NULL,
    CONSTRAINT [PK_Out_NoteID] PRIMARY KEY CLUSTERED ([Out_NoteID] ASC)
);

