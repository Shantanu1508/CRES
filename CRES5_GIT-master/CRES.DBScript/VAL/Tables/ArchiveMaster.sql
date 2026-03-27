CREATE TABLE [VAL].[ArchiveMaster] (
    
	ArchiveMasterID    INT    IDENTITY (1, 1) NOT NULL,	
	MarkedDateMasterID	int,
	Isdeleted bit,

	CreatedBy	nvarchar(256),
	CreatedDate	Datetime,
	UpdatedBy	nvarchar(256),
	UpdatedDate	Datetime,

    CONSTRAINT [PK_ArchiveMasterID] PRIMARY KEY CLUSTERED ([ArchiveMasterID] ASC),
	CONSTRAINT [FK_ArchiveMaster_MarkedDateMasterID] FOREIGN KEY (MarkedDateMasterID) REFERENCES [VAL].[MarkedDateMaster] (MarkedDateMasterID) 
);





