
CREATE TABLE [CRE].[XIRROverride] (
    [XIRROverrideID]    INT IDENTITY (1, 1) NOT NULL,   
	[XIRRConfigID]		INT,
	[DealAccountID]		UNIQUEIDENTIFIER,	
	[XIRROverrideValue]	Decimal(28,15),
	[IsOverride]		BIT NULL,	
	[CreatedBy]			NVARCHAR (256) NULL,
    [CreatedDate]		DATETIME       NULL,
    [UpdatedBy]			NVARCHAR (256) NULL,
    [UpdatedDate]		DATETIME       NULL,
    CONSTRAINT [PK_XIRROverrideID] PRIMARY KEY CLUSTERED ([XIRROverrideID] ASC)
);