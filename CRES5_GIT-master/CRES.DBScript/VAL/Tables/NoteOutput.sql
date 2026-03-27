CREATE TABLE [VAL].[NoteOutput] (    
	NoteOutputID    INT    IDENTITY (1, 1) NOT NULL,	
	MarkedDateMasterID    INT ,
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

    CONSTRAINT [PK_NoteOutput_NoteOutputID] PRIMARY KEY CLUSTERED ([NoteOutputID] ASC),
	CONSTRAINT [FK_NoteOutput_MarkedDateMasterID] FOREIGN KEY (MarkedDateMasterID) REFERENCES [VAL].[MarkedDateMaster] (MarkedDateMasterID) 
);





