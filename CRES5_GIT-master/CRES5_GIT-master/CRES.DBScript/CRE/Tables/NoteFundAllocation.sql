CREATE TABLE [CRE].[NoteFundAllocation] (
    [NoteFundAllocationID] INT              IDENTITY (1, 1) NOT NULL,
    [NoteID]               UNIQUEIDENTIFIER NULL,
    [FundID]               INT              NULL,
    [PctAllocation]        DECIMAL (28, 15) NULL,
    [CreatedBy]            NVARCHAR (256)   NULL,
    [CreatedDate]          DATETIME         NULL,
    [UpdatedBy]            NVARCHAR (256)   NULL,
    [UpdatedDate]          DATETIME         NULL,
    CONSTRAINT [PK_NoteFundAllocationID] PRIMARY KEY CLUSTERED ([NoteFundAllocationID] ASC),
    CONSTRAINT [FK_NoteFundAllocation_FundID] FOREIGN KEY ([FundID]) REFERENCES [CRE].[Fund] ([FundID])
);

