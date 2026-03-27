CREATE TABLE [CRE].[XIRROutputDetailArchive] (
    [XIRROutputDetailArchiveID]    INT            IDENTITY (1, 1) NOT NULL,   
	[XIRRConfigID]    INT,
	[ArchiveDate] DATETIME       NOT NULL,	
	AnalysisID	UNIQUEIDENTIFIER,
	AccountID	UNIQUEIDENTIFIER,
	ObjectType	NVARCHAR (256)	,
	ObjectID	UNIQUEIDENTIFIER	,
	TransactionType	nvarchar(256),
	TransactionDate	Date,
	Amount	Decimal(28,15),	
	[CreatedBy]   NVARCHAR (256) NULL,
    [CreatedDate] DATETIME       NULL,
    [UpdatedBy]   NVARCHAR (256) NULL,
    [UpdatedDate] DATETIME       NULL,
    
    CONSTRAINT [PK_XIRROutputDetailArchiveID] PRIMARY KEY CLUSTERED ([XIRROutputDetailArchiveID] ASC),

);






