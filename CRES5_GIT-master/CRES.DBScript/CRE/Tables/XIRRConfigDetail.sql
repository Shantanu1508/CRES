CREATE TABLE [CRE].[XIRRConfigDetail] (
    [XIRRConfigDetailID]    INT            IDENTITY (1, 1) NOT NULL,    
	[XIRRConfigDetailGUID]    UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    
	[XIRRConfigID]    INT,
	[ObjectType]	NVARCHAR (100) NULL,
	[ObjectID]    INT,

	[CreatedBy]   NVARCHAR (256) NULL,
    [CreatedDate] DATETIME       NULL,
    [UpdatedBy]   NVARCHAR (256) NULL,
    [UpdatedDate] DATETIME       NULL,
  
    CONSTRAINT [PK_XIRRConfigDetailID] PRIMARY KEY CLUSTERED ([XIRRConfigDetailID] ASC),
	CONSTRAINT [FK_XIRRConfig_XIRRConfigID] FOREIGN KEY (XIRRConfigID) REFERENCES [CRE].[XIRRConfig] (XIRRConfigID)
);





