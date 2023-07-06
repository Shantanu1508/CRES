-- [dbo].[usp_GetScenarioParameterByScenarioID] '37F2140C-B408-4982-9192-67FEF1CD1BFC' 
Create PROCEDURE [dbo].[usp_GetScenarioParameterByScenarioID] -- 'AED67736-F2A1-483C-8015-6BC14E4A50AC'
(
	@AnalysisID varchar(50)
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
	isnull(ap.UseBusinessDayAdjustment,4) as UseBusinessDayAdjustment ,
	isnull(lBusinessDay.Name,'N') as UseBusinessDayAdjustmentText,
	ap.JsonTemplateMasterID as JsonTemplateMasterID
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
	where al.AnalysisID =@AnalysisID
	
SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
 
END
