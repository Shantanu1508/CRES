CREATE TABLE [VAL].[NotesWeight] (
    [NotesWeightID]      INT              IDENTITY (1, 1) NOT NULL,
    [MarkedDateMasterID] INT              NULL,
    [PropertyType]       NVARCHAR (256)   NULL,
    [Header]             NVARCHAR (256)   NULL,
    [SortOrder]          INT              NULL,
    [Value]              DECIMAL (28, 15) NULL,
    [CreatedBy]          NVARCHAR (256)   NULL,
    [CreatedDate]        DATETIME         NULL,
    [UpdateBy]           NVARCHAR (256)   NULL,
    [UpdatedDate]        DATETIME         NULL,
    CONSTRAINT [PK_NotesWeight_NotesWeightID] PRIMARY KEY CLUSTERED ([NotesWeightID] ASC),
    CONSTRAINT [FK_NotesWeight_MarkedDateMasterID] FOREIGN KEY ([MarkedDateMasterID]) REFERENCES [VAL].[MarkedDateMaster] ([MarkedDateMasterID])
);

