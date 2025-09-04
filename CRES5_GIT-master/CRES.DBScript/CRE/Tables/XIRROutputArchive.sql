CREATE TABLE [CRE].[XIRROutputArchive] (
    [XIRROutputArchiveID]    INT            IDENTITY (1, 1) NOT NULL,   
	[XIRRConfigID]    INT,
	[ArchiveDate] DATETIME       NOT NULL,
	ObjectType	NVARCHAR (256),
	ObjectID	UNIQUEIDENTIFIER,
	[ReturnName]	NVARCHAR (256),
	XIRRValue	Decimal(28,15),
	[AnalysisID]	UNIQUEIDENTIFIER,	
	[Tags]	NVARCHAR (MAX),
	[CreatedBy]   NVARCHAR (256) NULL,
    [CreatedDate] DATETIME       NULL,
    [UpdatedBy]   NVARCHAR (256) NULL,
    [UpdatedDate] DATETIME       NULL,
	 Comments NVARCHAR (MAX),
    CONSTRAINT [PK_XIRROutputArchiveID] PRIMARY KEY CLUSTERED ([XIRROutputArchiveID] ASC)
);






