
CREATE PROCEDURE [dbo].[usp_GetScenarioParameterForVSTO] 
(
@Scenariotext nvarchar(256)
)

AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

		select a.AnalysisParameterID,
			   a.AnalysisID,
			   a.MaturityScenarioOverrideID,
			   l.name as MaturityScenarioOverrideText,
			   a.MaturityAdjustment,
			   a.FunctionName,	
			   a.IndexScenarioOverride,	
			   l1.Name as IndexScenarioOverrideText,
			   a.CalculationMode,	
			   l2.Name as CalculationModeText,
			   a.ExcludedForcastedPrePayment,
			   l3.Name as ExcludedForcastedPrePaymentText,	
			   a.AutoCalculationFrequency,
			   l4.Name as AutoCalcFreqText,
			   ap.StatusID,
			   l5.Name as StatusText,
			   a.UseActuals,
			   l6.Name as UseActualsText,
			   isnull(a.UseBusinessDayAdjustment,4) as UseBusinessDayAdjustment ,
	           isnull(lBusinessDay.Name,'N') as UseBusinessDayAdjustmentText

		from [Core].[AnalysisParameter] a
		inner join core.analysis ap on ap.analysisid = a.analysisid
		left join core.lookup l on l.Lookupid = a.MaturityScenarioOverrideID
		left join core.lookup l1 on l1.Lookupid = a.IndexScenarioOverride
		left join core.lookup l2 on l2.Lookupid = a.CalculationMode
		left join core.lookup l3 on l3.Lookupid = a.ExcludedForcastedPrePayment
		left join core.lookup l4 on l4.Lookupid =  a.AutoCalculationFrequency
		left join core.lookup l5 on l5.Lookupid = ap.StatusID
		left join core.lookup l6 on l6.Lookupid = a.UseActuals
		LEFT Join Core.Lookup lBusinessDay on lBusinessDay.LookupID=a.UseBusinessDayAdjustment and lBusinessDay.ParentID = 2
		where ap.name = @Scenariotext

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END

