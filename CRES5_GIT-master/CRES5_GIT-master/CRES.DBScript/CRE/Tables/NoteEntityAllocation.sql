CREATE TABLE [CRE].[NoteEntityAllocation] (
    [NoteEntityAllocationID] INT              IDENTITY (1, 1) NOT NULL,
    [EntityID]               INT              NULL,
    [NoteID]                 UNIQUEIDENTIFIER NULL,
    [PctAllocation]          DECIMAL (28, 15) NULL,
    [CreatedBy]              NVARCHAR (256)   NULL,
    [CreatedDate]            DATETIME         NULL,
    [UpdatedBy]              NVARCHAR (256)   NULL,
    [UpdatedDate]            DATETIME         NULL,
    CONSTRAINT [PK_NoteEntityAllocationID] PRIMARY KEY CLUSTERED ([NoteEntityAllocationID] ASC),
    CONSTRAINT [FK_NoteEntityAllocation_EntityID] FOREIGN KEY ([EntityID]) REFERENCES [CRE].[Entity] ([EntityID])
);

