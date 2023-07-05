CREATE TABLE [CRE].[NotePeriodic] (
    [NotePeriodicID] UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [Note_NoteID]    UNIQUEIDENTIFIER NOT NULL,
    [CreatedBy]      NVARCHAR (256)   NULL,
    [CreatedDate]    DATETIME         NULL,
    [UpdatedBy]      NVARCHAR (256)   NULL,
    [UpdatedDate]    DATETIME         NULL,
    CONSTRAINT [PK_NotePeriodicID] PRIMARY KEY CLUSTERED ([NotePeriodicID] ASC),
    CONSTRAINT [FK_NotePeriodic_Note_NoteID] FOREIGN KEY ([Note_NoteID]) REFERENCES [CRE].[Note] ([NoteID])
);

