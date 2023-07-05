CREATE TABLE [CRE].[DealProjectedPayOffAccounting] (
	DealProjectedPayOffAccountingID     INT              IDENTITY (1, 1) NOT NULL,
	DealID	UNIQUEIDENTIFIER null,	
	AsOfDate Date null,
	CumulativeProbability decimal(28,15) null,
	[CreatedBy]                 NVARCHAR (256)   NULL,
    [CreatedDate]               DATETIME         NULL,
    [UpdatedBy]                 NVARCHAR (256)   NULL,
    [UpdatedDate]               DATETIME         NULL,
	CONSTRAINT [PK_DealProjectedPayOffAccountingID] PRIMARY KEY CLUSTERED (DealProjectedPayOffAccountingID ASC)
);