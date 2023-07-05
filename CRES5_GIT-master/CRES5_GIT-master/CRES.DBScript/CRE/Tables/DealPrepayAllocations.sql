CREATE TABLE [CRE].[DealPrepayAllocations] (
	[DealPrepayAllocationsID]            Int IDENTITY (1, 1) NOT NULL,	
	[DealID]          UNIQUEIDENTIFIER  NOT NULL,   
	[NoteID]          UNIQUEIDENTIFIER  NOT NULL,    
	PrepayDate	Date null,
	MinmultDue	decimal(28,15) null,	
	[CreatedBy]          NVARCHAR (256)   NULL,
	[CreatedDate]        DATETIME         NULL,
	[UpdatedBy]          NVARCHAR (256)   NULL,
	[UpdatedDate]        DATETIME         NULL,   
   
	CONSTRAINT [PK_DealPrepayAllocationsID] PRIMARY KEY CLUSTERED ([DealPrepayAllocationsID] ASC)
);

