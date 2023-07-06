
CREATE PROCEDURE [dbo].[usp_ResetActiveToDefaultScenario]   

(
	@UserName varchar(256)
	)

AS

 BEGIN
  
 --select * from  Core.CalculationRequests

--update all to inactive
update Core.Analysis 
set StatusID =  (select LookupID from Core.Lookup where ParentID =2 and [name] ='N'),
UpdatedBy =@UserName,
UpdatedDate =GETDATE()
where AnalysisID != (select distinct(AnalysisID) from Core.Analysis where Name like '%Default%')


----update all default to active

update Core.Analysis 
set StatusID =  (select LookupID from Core.Lookup where ParentID =2 and [name] ='Y'),
UpdatedBy =@UserName,
UpdatedDate =GETDATE()
where AnalysisID= (select distinct(AnalysisID) from Core.Analysis where Name like '%Default%')



 
 
	 
 END
