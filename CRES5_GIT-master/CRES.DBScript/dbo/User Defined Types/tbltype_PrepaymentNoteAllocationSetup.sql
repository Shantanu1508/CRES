CREATE TYPE [dbo].[tbltype_PrepaymentNoteAllocationSetup] AS TABLE (
   [PrepaymentNoteAllocationSetupID] INT NULL,
   [DealID]          UNIQUEIDENTIFIER NULL,
   [NoteID]          UNIQUEIDENTIFIER NULL,
   [GroupID]         INT NULL,
   [GroupPriority]   INT NULL,
   [Exclude]         INT NULL
);