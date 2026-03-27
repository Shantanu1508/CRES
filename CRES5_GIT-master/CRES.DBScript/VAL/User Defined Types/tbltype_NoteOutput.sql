CREATE TYPE [val].[tbltype_NoteOutput] AS TABLE
(
	MarkedDate date
	,NoteID	nvarchar(256)
	,DealID	nvarchar(256)
	,CalculationStatus	nvarchar(256)	
	,LastCalculatedOn	datetime
	,NoteMarkPriceClean	decimal(28,15)	 
	,NoteGAAPPriceClean	decimal(28,15)	 
	,NoteMarkClean	decimal(28,15)	 
	,NoteUPB	decimal(28,15)	 
	,NoteCommitment	decimal(28,15)	 
	,NoteBasisDirty	decimal(28,15)	 
	,NoteYieldatGAAPBasis	decimal(28,15)	 
	,NoteMarkYield	decimal(28,15)	 
	,CalculatedNoteAccruedRate	decimal(28,15)	 
	,NoteGAAPDMIndex	decimal(28,15)	 
	,NoteMarkDMgtrFLRIndex	decimal(28,15)	 
	,NoteDurationonCommitment	decimal(28,15)	 	
	,UserID	nvarchar(256)	
)

