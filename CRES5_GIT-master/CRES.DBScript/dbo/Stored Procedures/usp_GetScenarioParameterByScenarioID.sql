-- [dbo].[usp_GetScenarioParameterByScenarioID] '37F2140C-B408-4982-9192-67FEF1CD1BFC' 
CREATE PROCEDURE [dbo].[usp_GetScenarioParameterByScenarioID] -- 'AED67736-F2A1-483C-8015-6BC14E4A50AC'
(
	@AnalysisID varchar(50),
	@UserID UNIQUEIDENTIFIER = NULL
)
AS

 BEGIN
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

   
	select 
	ap.AnalysisParameterID	,
	al.AnalysisID	,
	ap.MaturityScenarioOverrideID,
	ap.MaturityAdjustment,
	l1.Name as MaturityAdjustmentText,
	al.Description,
	al.Name,	
	ap.FunctionName,
	ap.IndexScenarioOverride,
	im.IndexesName as IndexScenarioOverrideText,
	ap.CalculationMode,
	lCalculationMode.Name as CalculationModeText,
	ap.ExcludedForcastedPrePayment,
	lExcludedForcastedPrePayment.Name as ExcludedForcastedPrePaymentText,
	ap.AutoCalculationFrequency as AutoCalcFreq,
	lAutoCalcFreq.Name as AutoCalcFreqText,
	ap.UseActuals,
	lUseActuals.Name as UseActualsText,
	ap.IncludeProjectedPrincipalWriteoff,
	lIncludeProjectedPrincipalWriteoff.Name as IncludeProjectedPrincipalWriteoffText,
	isnull(ap.UseBusinessDayAdjustment,4) as UseBusinessDayAdjustment ,
	isnull(lBusinessDay.Name,'N') as UseBusinessDayAdjustmentText,
	ap.JsonTemplateMasterID as JsonTemplateMasterID,
	ap.CalculationFrequency,
	lCalculationFrequency.Name as CalculationFrequencyText,
	ap.CalcEngineType,
	lCalcEngineType.Name as CalcEngineTypeText,
	ap.AllowCalcOverride,
	lAllowCalcOverride.Name as AllowCalcOverrideText,
	ap.AllowCalcAlongWithDefault,
	lAllowCalcAlongWithDefault.Name as AllowCalcAlongWithDefaultText,	
	ap.AccountingClose,
	lAccountingClose.Name as AccountingCloseText	,
	ap.CalculateLiability,
	lCalculateLiability.Name as CalculateLiabilityText
	,al.ScenarioStatus
	,lScenario.[Name] as ScenarioStatusText
	,ap.UseFinancingMaturityDateOverride
	,lUseFinancingMaturityDateOverride.Name as UseFinancingMaturityDateOverrideText
	,ap.UseMaturityAdjustmentMonths
	,lUseMaturityAdjustmentMonths.Name as UseMaturityAdjustmentMonthsText
	,ap.IncludeInDiscrepancy
	,lIncludeInDiscrepancy.Name as IncludeInDiscrepancyText
	,[dbo].[ufn_GetTimeByTimeZone](ap.LastCalculatedDate, @UserID) as LastCalculatedDate
	,ap.OperationMode	
	,ap.EqDelayMonths	
	,ap.FinDelayMonths	
	,ap.MinEqBalForFinStart	
	,ap.SublineEqApplyMonths	
	,ap.SublineFinApplyMonths	
	,ap.DebtCallDaysOfTheMonth	
	,ap.CapitalCallDaysOfTheMonth
	from 
	Core.Analysis al
	left join Core.AnalysisParameter ap on al.AnalysisID = ap.AnalysisID
	LEFT Join Core.Lookup l1 on l1.LookupID=ap.MaturityScenarioOverrideID and ParentID = 52
	left join core.IndexesMaster im on im.IndexesMasterID = ap.IndexScenarioOverride
	LEFT Join Core.Lookup lCalculationMode on lCalculationMode.LookupID=ap.CalculationMode and lCalculationMode.ParentID = 79
	LEFT Join Core.Lookup lExcludedForcastedPrePayment on lExcludedForcastedPrePayment.LookupID=ap.ExcludedForcastedPrePayment and lExcludedForcastedPrePayment.ParentID = 2
	LEFT Join Core.Lookup lAutoCalcFreq on lAutoCalcFreq.LookupID=ap.AutoCalculationFrequency and lAutoCalcFreq.ParentID = 98
	LEFT Join Core.Lookup lUseActuals on lUseActuals.LookupID=ap.UseActuals and lUseActuals.ParentID = 2
	LEFT Join Core.Lookup lBusinessDay on lBusinessDay.LookupID=ap.UseBusinessDayAdjustment and lBusinessDay.ParentID = 2
	LEFT Join Core.Lookup lCalculationFrequency on lCalculationFrequency.LookupID=ap.CalculationFrequency
	LEFT Join Core.Lookup lCalcEngineType on lCalcEngineType.LookupID=ap.CalcEngineType
	LEFT Join Core.Lookup lAllowCalcOverride on lAllowCalcOverride.LookupID=ap.AllowCalcOverride
	LEFT Join Core.Lookup lAllowCalcAlongWithDefault on lAllowCalcAlongWithDefault.LookupID=ap.AllowCalcAlongWithDefault
	LEFT Join Core.Lookup lAccountingClose on lAccountingClose.LookupID=ap.AccountingClose
	LEFT Join Core.Lookup lIncludeProjectedPrincipalWriteoff on lIncludeProjectedPrincipalWriteoff.LookupID=ap.IncludeProjectedPrincipalWriteoff and lIncludeProjectedPrincipalWriteoff.ParentID = 2
	LEFT Join Core.Lookup lCalculateLiability on lCalculateLiability.LookupID=ap.CalculateLiability and lCalculateLiability.ParentID = 2
	left join core.Lookup lScenario on lScenario.LookupID = al.ScenarioStatus AND lScenario.[Name]='Active'
	LEFT Join Core.Lookup lUseFinancingMaturityDateOverride on lUseFinancingMaturityDateOverride.LookupID=ap.UseFinancingMaturityDateOverride and lUseFinancingMaturityDateOverride.ParentID = 2
	LEFT Join Core.Lookup lUseMaturityAdjustmentMonths on lUseMaturityAdjustmentMonths.LookupID=ap.UseMaturityAdjustmentMonths and lUseMaturityAdjustmentMonths.ParentID = 2
	LEFT Join Core.Lookup lIncludeInDiscrepancy on lIncludeInDiscrepancy.LookupID=ap.IncludeInDiscrepancy and lIncludeInDiscrepancy.ParentID = 2
	where al.AnalysisID =@AnalysisID
	
SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
 
END

