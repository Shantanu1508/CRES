
CREATE PROCEDURE [dbo].[usp_UpdateScenarioToInactive]  --'538910c2-7f90-42e1-b2b6-aba5c2481aea'
	(
	@AnalysisID varchar(50)
	)
AS

 BEGIN
  
update  Core.Analysis

set StatusID =  (select LookupID from Core.Lookup where ParentID =2 and [name] ='N')
where  AnalysisID !=@AnalysisID

 
	 
 END
