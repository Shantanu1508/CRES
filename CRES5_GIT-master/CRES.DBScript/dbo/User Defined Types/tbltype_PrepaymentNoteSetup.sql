CREATE TYPE [dbo].[tbltype_PrepaymentNoteSetup] AS TABLE (
   [PrepaymentNoteSetupID]  INT NULL,
   [DealID]          UNIQUEIDENTIFIER NULL,
   [NoteID]          UNIQUEIDENTIFIER NULL,
   [AttributeName]   NVARCHAR (256)   NULL,
   [AttributeValue]  DECIMAL (28, 15) NULL,
   [IsDeleted]       INT              NULL
);