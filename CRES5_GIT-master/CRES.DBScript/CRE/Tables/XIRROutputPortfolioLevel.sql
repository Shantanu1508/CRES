
CREATE TABLE [CRE].[XIRROutputPortfolioLevel] (
    [XIRROutputPortfolioLevelID]    INT            IDENTITY (1, 1) NOT NULL,   
	[XIRRConfigID]    INT,
	XIRRReturnGroupID	int	,	
	XIRRValue	Decimal(28,15),
	[AnalysisID]	UNIQUEIDENTIFIER,	
	[CreatedBy]   NVARCHAR (256) NULL,
    [CreatedDate] DATETIME       NULL,
    [UpdatedBy]   NVARCHAR (256) NULL,
    [UpdatedDate] DATETIME       NULL,
	
    CONSTRAINT [PK_XIRROutputPortfolioLevelID] PRIMARY KEY CLUSTERED ([XIRROutputPortfolioLevelID] ASC),
	CONSTRAINT [FK_XIRROutputPortfolioLevel_XIRRConfigID] FOREIGN KEY (XIRRConfigID) REFERENCES [CRE].[XIRRConfig] (XIRRConfigID)
);





