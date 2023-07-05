CREATE View [dbo].[Analysis] AS

SELECT
AnalysisKey,
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
UpdatedDate
From [DW].[AnalysisBI]


