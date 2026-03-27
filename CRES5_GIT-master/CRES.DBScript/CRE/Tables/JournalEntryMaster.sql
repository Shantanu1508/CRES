CREATE TABLE [CRE].[JournalEntryMaster] (
	[JournalEntryMasterID] INT IDENTITY (1, 1) NOT NULL, 	
	JournalEntryDate Date,
	Comment	nvarchar(256),

	[CreatedBy]   NVARCHAR (256) NULL,
	[CreatedDate] DATETIME       NULL,
	[UpdatedBy]   NVARCHAR (256) NULL,
	[UpdatedDate] DATETIME       NULL,
	[JournalEntryMasterGUID]  UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL, 
	CONSTRAINT [PK_JournalEntryMasterID] PRIMARY KEY CLUSTERED ([JournalEntryMasterID] ASC)
);

GO




