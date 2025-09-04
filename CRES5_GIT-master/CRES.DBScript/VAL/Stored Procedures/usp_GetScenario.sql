CREATE PROCEDURE [val].[usp_GetScenario] 
 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for procedure here
	 select an.[Name] from Core.Analysis an left join core.Lookup lScenario 
	 on lScenario.LookupID = an.ScenarioStatus AND lScenario.[Name]='Active'
	 where an.isDeleted=0 order by an.CreatedDate asc

END
GO

