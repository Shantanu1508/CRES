CREATE TABLE [CRE].[NoteAttributesbyDate] (
    [NoteID]      NVARCHAR (256)   NULL,
    [Date]        DATETIME         NULL,
    [Value]       DECIMAL (28, 15) NULL,
    [ValueTypeID] INT              NULL,
    [CreatedBy]   NVARCHAR (256)   NULL,
    [CreatedDate] DATETIME         DEFAULT (getdate()) NULL,
    [UpdatedBy]   NVARCHAR (256)   NULL,
    [UpdatedDate] DATETIME         DEFAULT (getdate()) NULL,
    [GeneratedBy] INT              NULL,
    NoteAttributesbyDateID int IDENTITY(1,1)
);

go
ALTER TABLE [CRE].[NoteAttributesbyDate]
ADD CONSTRAINT PK_NoteAttributesbyDate_NoteAttributesbyDateID PRIMARY KEY ([NoteAttributesbyDateID]);

