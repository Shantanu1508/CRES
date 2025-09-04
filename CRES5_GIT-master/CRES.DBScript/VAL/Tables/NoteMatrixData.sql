CREATE TABLE [VAL].[NoteMatrixData] (
    
	NoteMatrixDataID    INT    IDENTITY (1, 1) NOT NULL,
	MarkedDateMasterID    INT ,

	NoteMatrixSheetName	nvarchar(256),
	DealID	nvarchar(256),
	DealGroupID	nvarchar(256),
	NoteID	nvarchar(256),
	DealName	nvarchar(256),
	NoteName nvarchar(256),
	Commitment decimal(28,15),
	InitialFunding Date,
	CurrentMaturity_Date Date,
	OriginationFee decimal(28,15),
	ExtensionFee1	decimal(28,15),
	ExtensionFee2	decimal(28,15),
	ExtensionFee3	decimal(28,15),
	ExitFee	decimal(28,15),
	ProductType nvarchar(256),
	AcoreOrig decimal(28,15),
	
	CreatedBy	nvarchar(256),
	CreatedDate	Datetime,
	UpdatedBy	nvarchar(256),
	UpdatedDate	Datetime,

    CONSTRAINT [PK_NoteMatrixDataID] PRIMARY KEY CLUSTERED ([NoteMatrixDataID] ASC)    ,
	CONSTRAINT [FK_NoteMatrixData_MarkedDateMasterID] FOREIGN KEY (MarkedDateMasterID) REFERENCES [VAL].[MarkedDateMaster] (MarkedDateMasterID) 
);





