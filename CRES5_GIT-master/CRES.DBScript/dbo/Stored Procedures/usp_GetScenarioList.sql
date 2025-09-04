

 
CREATE PROCEDURE [dbo].[usp_GetScenarioList]
	
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED   
     	 select an.[Name] from Core.Analysis an left join core.Lookup lScenario on lScenario.LookupID = an.ScenarioStatus WHERE lScenario.[Name]='Active'
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END

