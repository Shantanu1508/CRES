CREATE TABLE [CRE].[PrepaymentNoteAllocationSetup] (
   [PrepaymentNoteAllocationSetupID]    INT IDENTITY (1, 1) NOT NULL,
   [PrepaymentNoteAllocationSetupGUID]  UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
   [DealID]          UNIQUEIDENTIFIER NULL,
   [NoteID]          UNIQUEIDENTIFIER NULL,
   [GroupID]         INT NULL,
   [GroupPriority]   INT NULL,
   [Exclude]         INT NULL,
   [CreatedBy]       NVARCHAR (256)   NULL,
   [CreatedDate]     DATETIME         NULL,
   [UpdatedBy]       NVARCHAR (256)   NULL,
   [UpdatedDate]     DATETIME         NULL,

   CONSTRAINT [PK_PrepaymentNoteAllocationSetupID] PRIMARY KEY CLUSTERED ([PrepaymentNoteAllocationSetupID] ASC)
);