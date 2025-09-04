CREATE TYPE [val].[tbltype_NoteMatrixData] AS TABLE
(
	MarkedDate Date,
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
	UserID	nvarchar(256)
)

