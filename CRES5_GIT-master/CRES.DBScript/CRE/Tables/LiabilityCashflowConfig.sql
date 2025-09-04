
CREATE TABLE [CRE].[LiabilityCashflowConfig] (
    [CashflowConfigID]    INT            IDENTITY (1, 1) NOT NULL,
	OperationMode NVARCHAR (256)  NULL,
	EqDelayMonths INT            NULL,
	FinDelayMonths INT            NULL,
	MinEqBalForFinStart decimal(28,15)            NULL,
	SublineEqApplyMonths INT            NULL,
	SublineFinApplyMonths INT            NULL,
	DebtCallDaysOfTheMonth INT            NULL,
	CapitalCallDaysOfTheMonth INT            NULL,
	   
    [CalcAsOfDate] DATE NULL, 
	[AnalysisID]                UNIQUEIDENTIFIER NULL,
	RebalanceMethod int
    CONSTRAINT [PK_CashflowConfigID] PRIMARY KEY CLUSTERED ([CashflowConfigID] ASC)
);


GO




