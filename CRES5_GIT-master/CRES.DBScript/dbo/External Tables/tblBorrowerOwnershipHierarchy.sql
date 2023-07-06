CREATE EXTERNAL TABLE [dbo].[tblBorrowerOwnershipHierarchy] (
    [BorrowerOwnershipHierarchyId] INT NULL,
    [NoteId_F] INT NULL,
    [ParentBorrowerId_F] INT NOT NULL,
    [ChildBorrowerId_F] INT NULL,
    [OwnershipPct] FLOAT (53) NULL,
    [PrimarySponsorSW] BIT NULL
)
    WITH (
    DATA_SOURCE = [RemoteReferenceData]
    );

