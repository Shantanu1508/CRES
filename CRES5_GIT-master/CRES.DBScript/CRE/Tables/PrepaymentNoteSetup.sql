CREATE TABLE [CRE].[PrepaymentNoteSetup] (
   [PrepaymentNoteSetupID]    INT IDENTITY (1, 1) NOT NULL,
   [PrepaymentNoteSetupGUID]  UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
   [DealID]          UNIQUEIDENTIFIER NULL,
   [NoteID]          UNIQUEIDENTIFIER NULL,
   [AttributeName]   NVARCHAR (256)   NULL,
   [AttributeValue]  DECIMAL (28, 15) NULL,
   [CreatedBy]       NVARCHAR (256)   NULL,
   [CreatedDate]     DATETIME         NULL,
   [UpdatedBy]       NVARCHAR (256)   NULL,
   [UpdatedDate]     DATETIME         NULL,
   [IsDeleted]       INT              NULL

   CONSTRAINT [PK_PrepaymentNoteSetupID] PRIMARY KEY CLUSTERED ([PrepaymentNoteSetupID] ASC)
);