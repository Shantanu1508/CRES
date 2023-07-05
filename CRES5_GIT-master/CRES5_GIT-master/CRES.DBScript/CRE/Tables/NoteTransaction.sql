CREATE TABLE [CRE].[NoteTransaction] (
    [NoteTransactionID] UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [Note_NoteID]       UNIQUEIDENTIFIER NOT NULL,
    [CreatedBy]         NVARCHAR (256)   NULL,
    [CreatedDate]       DATETIME         NULL,
    [UpdatedBy]         NVARCHAR (256)   NULL,
    [UpdatedDate]       DATETIME         NULL,
    CONSTRAINT [PK_NoteTransactionID] PRIMARY KEY CLUSTERED ([NoteTransactionID] ASC),
    CONSTRAINT [FK_NoteTransaction_Note_NoteID] FOREIGN KEY ([Note_NoteID]) REFERENCES [CRE].[Note] ([NoteID])
);

