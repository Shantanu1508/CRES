CREATE TABLE [CRE].[AMNoteEx] (
    [AMNoteExID]  UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [Note_NoteID] UNIQUEIDENTIFIER NOT NULL,
    [User_UserID] UNIQUEIDENTIFIER NOT NULL,
    [CreatedBy]   NVARCHAR (256)   NULL,
    [CreatedDate] DATETIME         NULL,
    [UpdatedBy]   NVARCHAR (256)   NULL,
    [UpdatedDate] DATETIME         NULL,
    CONSTRAINT [PK_AMNoteExID] PRIMARY KEY CLUSTERED ([AMNoteExID] ASC),
    CONSTRAINT [FK_AMNoteEx_Note_NoteID] FOREIGN KEY ([Note_NoteID]) REFERENCES [CRE].[Note] ([NoteID]),
    CONSTRAINT [FK_AMNoteEx_User_UserId] FOREIGN KEY ([User_UserID]) REFERENCES [App].[User] ([UserID])
);

