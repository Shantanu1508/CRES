



CREATE PROCEDURE [dbo].[usp_GetScenarioUserMapByUserID] --'3bbeac70-f8a0-49ee-906d-1e4d40cd16e7'
(
	@UserID  nvarchar(256) 
)
  
AS
BEGIN
  SET NOCOUNT ON;  


IF exists(Select [AnalysisID] from core.ScenarioUserMap where UserID = @UserID)
BEGIN
	Select su.[ScenarioUserMapID]
		,su.[AnalysisID]
		,su.[UserID]
		,su.[CreatedBy]
		,su.[CreatedDate]
		,su.[UpdatedBy]
		,su.[UpdatedDate] 
		,an.ScenarioColor
		,ap.CalculationMode
		,lCalculationMode.[Name] as  CalculationModeText 
		,an.Name as ScenarioName
		from [Core].[ScenarioUserMap] su
		left join core.Analysis an on an.AnalysisID =su.AnalysisID
		left join core.AnalysisParameter ap on ap.AnalysisID = an.AnalysisID
		left join core.Lookup lCalculationMode on lCalculationMode.LookupID = ap.CalculationMode
		where UserID = @UserID
END
ELSE
BEGIN
	--Set default scenario
	Select newid() as [ScenarioUserMapID]
		,an.[AnalysisID]
		,Cast(@UserID as uniqueidentifier) as [UserID]
		,an.[CreatedBy]
		,an.[CreatedDate]
		,an.[UpdatedBy]
		,an.[UpdatedDate] 
		,an.ScenarioColor
		,ap.CalculationMode
		,lCalculationMode.[Name] as  CalculationModeText 
		,an.Name as ScenarioName
		from [Core].Analysis an
		left join core.AnalysisParameter ap on ap.AnalysisID = an.AnalysisID
		left join core.Lookup lCalculationMode on lCalculationMode.LookupID = ap.CalculationMode
		where an.[Name] = 'Default'
END


			
END


