


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
lCalculationMode.[Name] as  CalculationModeText ,
(Select [Value] from [App].[AppConfig] where [Key] ='AllowDebugInCalc') AllowDebugInCalc
from Core.Analysis an
left join core.AnalysisParameter ap on ap.AnalysisID = an.AnalysisID
left join core.Lookup lCalculationMode on lCalculationMode.LookupID = ap.CalculationMode
where isnull(an.isDeleted,0)=0
ORDER BY CASE WHEN an.[Name] = 'Default' THEN 'a'
ELSE an.[Name] END ASC

--ORDER BY an.UpdatedDate DESC

    SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END      

