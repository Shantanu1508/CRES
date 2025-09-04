
CREATE TABLE [CRE].[XIRROutputDealLevel] (
    [XIRROutputDealLevelID]    INT            IDENTITY (1, 1) NOT NULL,   
	[XIRRConfigID]    INT,
	XIRRReturnGroupID	int	,	
	[DealAccountID]	UNIQUEIDENTIFIER,	
	XIRRValue	Decimal(28,15),
	[AnalysisID]	UNIQUEIDENTIFIER,	
	[CreatedBy]   NVARCHAR (256) NULL,
    [CreatedDate] DATETIME       NULL,
    [UpdatedBy]   NVARCHAR (256) NULL,
    [UpdatedDate] DATETIME       NULL,
	[OutputType]   NVARCHAR (100) NULL,
	WholeLoanInvestment decimal(28,15) NULL,
	SubordinateDebtInvestment decimal(28,15) NULL,
	SeniorDebtInvestment decimal(28,15) NULL,
	OutstandingBalance decimal(28,15) NULL,
	CapitalInvested decimal(28,15) NULL,
	ProjCapitalInvested decimal(28,15) NULL,
	RealizedProceeds decimal(28,15) NULL,
	UnrealizedProceeds decimal(28,15) NULL,
	TotalProceeds decimal(28,15) NULL,
	WholeLoanSpread decimal(28,15) NULL,
	SubDebtSpread decimal(28,15) NULL,
	SeniorDebtSpread decimal(28,15) NULL,
	CutoffDateOverride Date NULL,
	MultipleCalculation decimal(28,15) NULL,
    CONSTRAINT [PK_XIRROutputDealLevelID] PRIMARY KEY CLUSTERED ([XIRROutputDealLevelID] ASC),
	CONSTRAINT [FK_XIRROutputDealLevel_XIRRConfigID] FOREIGN KEY (XIRRConfigID) REFERENCES [CRE].[XIRRConfig] (XIRRConfigID)
);





