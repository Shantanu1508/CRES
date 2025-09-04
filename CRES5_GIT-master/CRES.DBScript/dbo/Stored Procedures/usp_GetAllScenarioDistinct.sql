CREATE PROCEDURE [dbo].[usp_GetAllScenarioDistinct]    
    @UserID nvarchar(256)      
AS  
BEGIN  
 SET NOCOUNT ON;  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
    
select   
an.AnalysisID,  
an.[Name],     
an.ScenarioColor,  
an.[Description]  ,  
CalculationMode,  
ap.CalcEngineType,
lCalculationMode.[Name] as  CalculationModeText ,  
(Select [Value] from [App].[AppConfig] where [Key] ='AllowDebugInCalc') AllowDebugInCalc,
an.ScenarioStatus,
lScenario.[Name] as ScenarioStatusText
from Core.Analysis an  
left join core.AnalysisParameter ap on ap.AnalysisID = an.AnalysisID  
left join core.Lookup lCalculationMode on lCalculationMode.LookupID = ap.CalculationMode  
left join core.Lookup lScenario on lScenario.LookupID = an.ScenarioStatus 
where isnull(an.isDeleted,0)=0  AND lScenario.[Name]='Active'
ORDER BY CASE WHEN an.[Name] = 'Default' THEN 'a'  
ELSE an.[Name] END ASC  
  
--ORDER BY an.UpdatedDate DESC  
  
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END  