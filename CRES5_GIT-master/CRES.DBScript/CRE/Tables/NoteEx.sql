CREATE TABLE [CRE].[NoteEx] (
    [NoteExID]    UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [Note_NoteID] UNIQUEIDENTIFIER NOT NULL,
    [CreatedBy]   NVARCHAR (256)   NULL,
    [CreatedDate] DATETIME         NULL,
    [UpdatedBy]   NVARCHAR (256)   NULL,
    [UpdatedDate] DATETIME         NULL,
    CONSTRAINT [PK_NoteExID] PRIMARY KEY CLUSTERED ([NoteExID] ASC),
    CONSTRAINT [FK_NoteEx_Note_NoteID] FOREIGN KEY ([Note_NoteID]) REFERENCES [CRE].[Note] ([NoteID])
);

