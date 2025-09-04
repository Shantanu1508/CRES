CREATE TABLE [CRE].[XIRROutput] (
    [XIRROutputID]    INT            IDENTITY (1, 1) NOT NULL,   
	[XIRRConfigID]    INT,
	
	ObjectType	NVARCHAR (256),
	ObjectID	UNIQUEIDENTIFIER,
	[ReturnName]	NVARCHAR (256),
	XIRRValue	Decimal(28,15),
	[AnalysisID]	UNIQUEIDENTIFIER,	
	[CreatedBy]   NVARCHAR (256) NULL,
    [CreatedDate] DATETIME       NULL,
    [UpdatedBy]   NVARCHAR (256) NULL,
    [UpdatedDate] DATETIME       NULL,
	[Tags]	NVARCHAR (MAX),
	[Comments]    NVARCHAR (MAX) NULL
  
    CONSTRAINT [PK_XIRROutputID] PRIMARY KEY CLUSTERED ([XIRROutputID] ASC),
	CONSTRAINT [FK_XIRROutput_XIRRConfigID] FOREIGN KEY (XIRRConfigID) REFERENCES [CRE].[XIRRConfig] (XIRRConfigID)
);





