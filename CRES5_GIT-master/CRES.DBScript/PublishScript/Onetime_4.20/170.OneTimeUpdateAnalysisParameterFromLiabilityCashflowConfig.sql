Update AP Set
AP.OperationMode	= LCC.OperationMode	,
AP.EqDelayMonths	= LCC.EqDelayMonths	,
AP.FinDelayMonths	= LCC.FinDelayMonths	,
AP.MinEqBalForFinStart	= LCC.MinEqBalForFinStart	,
AP.SublineEqApplyMonths	= LCC.SublineEqApplyMonths	,
AP.SublineFinApplyMonths	= LCC.SublineFinApplyMonths	,
AP.DebtCallDaysOfTheMonth	= LCC.DebtCallDaysOfTheMonth	,
AP.CapitalCallDaysOfTheMonth= LCC.CapitalCallDaysOfTheMonth
FROM  [Core].[AnalysisParameter] AP, [CRE].[LiabilityCashflowConfig] LCC