CREATE TABLE [VAL].[NoteOutputArchive] (    
	NoteOutputArchiveID    INT    IDENTITY (1, 1) NOT NULL,	
	ArchiveMasterID    INT,

	NoteID	UNIQUEIDENTIFIER	,
	DealID	UNIQUEIDENTIFIER	,
	CalculationStatus	nvarchar(256)	,
	LastCalculatedOn	datetime	,	
	NoteMarkPriceClean	decimal(28,15)	 ,
	NoteGAAPPriceClean	decimal(28,15)	 ,
	NoteMarkClean	decimal(28,15)	 ,
	NoteUPB	decimal(28,15)	 ,
	NoteCommitment	decimal(28,15)	 ,
	NoteBasisDirty	decimal(28,15)	 ,
	NoteYieldatGAAPBasis	decimal(28,15)	 ,
	NoteMarkYield	decimal(28,15)	 ,
	CalculatedNoteAccruedRate	decimal(28,15)	 ,
	NoteGAAPDMIndex	decimal(28,15)	 ,
	NoteMarkDMgtrFLRIndex	decimal(28,15)	 ,
	NoteDurationonCommitment	decimal(28,15)	 ,
	CreatedBy	nvarchar(256),
	CreatedDate	Datetime,
	UpdateBy	nvarchar(256),
	UpdatedDate	Datetime

    CONSTRAINT [PK_NoteOutputArchive_NoteOutputArchiveID] PRIMARY KEY CLUSTERED ([NoteOutputArchiveID] ASC),
	CONSTRAINT [PK_NoteOutputArchive_ArchiveMasterID] FOREIGN KEY (ArchiveMasterID) REFERENCES [VAL].[ArchiveMaster] (ArchiveMasterID) 
);





