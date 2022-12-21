
CREATE PROCEDURE [DW].[usp_ImportAnalysis]
	
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
	DECLARE @RowCount int

	Truncate table [DW].[AnalysisBI]

	INSERT INTO [DW].[AnalysisBI]
		(AnalysisKey,
		MaturityAdjustment,
		MaturityAdjustmentText,
		[Description],
		[Name],
		IndexScenarioOverride,
		CalculationMode,
		ExcludedForcastedPrePayment,
		CreatedBy,
		CreatedDate,
		UpdatedBy,
		UpdatedDate)
	SELECT
		al.AnalysisID,
		ap.MaturityAdjustment,
		l1.Name as MaturityAdjustmentText,
		al.Description,
		al.Name,
		im.IndexesName as IndexScenarioOverride,
		lCalculationMode.Name as CalculationMode,
		lCalculationMode.Name as ExcludedForcastedPrePayment,
		al.CreatedBy,
		al.CreatedDate,
		al.UpdatedBy,
		al.UpdatedDate
	FROM 
	Core.Analysis al
	left join Core.AnalysisParameter ap on al.AnalysisID = ap.AnalysisID
	LEFT Join Core.Lookup l1 on l1.LookupID=ap.MaturityScenarioOverrideID and ParentID = 52
	left join core.IndexesMaster im on im.IndexesMasterID = ap.IndexScenarioOverride
	LEFT Join Core.Lookup lCalculationMode on lCalculationMode.LookupID=ap.CalculationMode and lCalculationMode.ParentID = 79
	LEFT Join Core.Lookup lExcludedForcastedPrePayment on lExcludedForcastedPrePayment.LookupID=ap.ExcludedForcastedPrePayment and lExcludedForcastedPrePayment.ParentID = 2

	SET @RowCount = @@ROWCOUNT
	Print(char(9) +'usp_ImportAnalysis - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END
