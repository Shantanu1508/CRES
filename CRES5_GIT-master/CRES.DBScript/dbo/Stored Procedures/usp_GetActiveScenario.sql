
Create PROCEDURE [dbo].[usp_GetActiveScenario]  --'538910c2-7f90-42e1-b2b6-aba5c2481aea'
	@AnalysisID UNIQUEIDENTIFIER 
AS

 BEGIN
  	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    select 
ap.AnalysisParameterID	,
al.AnalysisID	,
ap.MaturityScenarioOverrideID,
ap.MaturityAdjustment,
l1.Name as MaturityScenarioOverrideText,
al.Name,
l2.Name as ExcludedForcastedPrePaymentText,
ap.ExcludedForcastedPrePayment,
ap.CalculationMode,
l3.name as CalculationModeText,
ap.UseActuals,
l4.name as UseActualsText,
isnull(ap.UseBusinessDayAdjustment,4) as UseBusinessDayAdjustment ,
isnull(lBusinessDay.Name,'N') as UseBusinessDayAdjustmentText,
ap.JsonTemplateMasterID as JsonTemplateMasterID
 from 
 Core.Analysis al
 left join Core.AnalysisParameter ap on al.AnalysisID = ap.AnalysisID
 LEFT Join Core.Lookup l1 on l1.LookupID=ap.MaturityScenarioOverrideID
 LEFT Join Core.Lookup l2 on l2.LookupID=ap.ExcludedForcastedPrePayment
 LEFT Join Core.Lookup l3 on l3.LookupID=ap.CalculationMode
 left join Core.Lookup l4  on l4.LookupID = ap.UseActuals
 LEFT Join Core.Lookup lBusinessDay on lBusinessDay.LookupID=ap.UseBusinessDayAdjustment and lBusinessDay.ParentID = 2
 where al.AnalysisID = @AnalysisID

 --al.StatusID=( select LookupID from  Core.Lookup where ParentID=2 and Name='Y')

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED	 
 END
