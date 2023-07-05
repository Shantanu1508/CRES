CREATE TABLE [CRE].[DealAmortSequence] (
    [DealAmortSequenceID] INT              IDENTITY (1, 1) NOT NULL,
    [NoteID]              UNIQUEIDENTIFIER NOT NULL,
    [SequenceNo]          INT              NULL,
    [SequenceType]        NVARCHAR (256)   NULL,
    [Value]               DECIMAL (28, 15) NULL,
    [ModuleType]          NVARCHAR (256)   NULL,
    [CreatedBy]           NVARCHAR (256)   NULL,
    [CreatedDate]         DATETIME         NULL,
    [UpdatedBy]           NVARCHAR (256)   NULL,
    [UpdatedDate]         DATETIME         NULL,
    CONSTRAINT [FK_DealAmortSequence_NoteID] FOREIGN KEY ([NoteID]) REFERENCES [CRE].[Note] ([NoteID])
);
go

ALTER TABLE [CRE].[DealAmortSequence]
ADD CONSTRAINT PK_DealAmortSequence_DealAmortSequenceID PRIMARY KEY (DealAmortSequenceID);
