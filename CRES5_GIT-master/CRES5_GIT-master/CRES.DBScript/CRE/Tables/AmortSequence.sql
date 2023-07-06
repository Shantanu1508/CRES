CREATE TABLE [CRE].[AmortSequence] (
    [AmortSequenceID] UNIQUEIDENTIFIER CONSTRAINT [DF__AmortSequ__Amort__7ADC2F5E] DEFAULT (newid()) NOT NULL,
    [NoteID]          UNIQUEIDENTIFIER NOT NULL,
    [SequenceNo]      INT              NULL,
    [Value]           DECIMAL (28, 15) NULL,
    [ModuleType]      NVARCHAR (256)   NULL,
    [CreatedBy]       NVARCHAR (256)   NULL,
    [CreatedDate]     DATETIME         NULL,
    [UpdatedBy]       NVARCHAR (256)   NULL,
    [UpdatedDate]     DATETIME         NULL,
    AmortSequence_AutoID int IDENTITY(1,1)
    CONSTRAINT [FK_AmortSequence_NoteID] FOREIGN KEY ([NoteID]) REFERENCES [CRE].[Note] ([NoteID])
);

go
ALTER TABLE [CRE].[AmortSequence]
ADD CONSTRAINT PK_AmortSequence_AmortSequenceID PRIMARY KEY (AmortSequence_AutoID);