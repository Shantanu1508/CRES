CREATE PROCEDURE [dbo].[usp_GetCalculationStatus] (  
--@tblCalcRequest TableTypeCalcRequest READONLY  
@isComplete int OUTPUT)  
as  
BEGIN  
     SET NOCOUNT ON;  
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED   
  
  
Declare @lookupidRunning int = 267;  
Declare @lookupidProcessing int = 292;  
Declare @lookupidFailed int = 265;  
Declare @lookupidDependents int = (SELECT LookupID from core.Lookup where Name='Dependents' and ParentID=40);  
  
IF ((SELECT COUNT(distinct NoteID) FROM Core.CalculationRequests  WHERE [StatusID] = @lookupidFailed and (ErrorMessage like '%deadlocked%' or ErrorMessage like '%Timeout Expired%')) != 0)  
BEGIN  
 ----Update Status to 'Processing' if note failure due to deadlocked or Timeout Expired------------  
 Update Core.CalculationRequests set [StatusID]=@lookupidProcessing   
 where NoteID in (SELECT distinct NoteID FROM Core.CalculationRequests  WHERE [StatusID] = @lookupidFailed and (ErrorMessage like '%deadlocked%' or ErrorMessage like '%Timeout Expired%') )  
END  
  
----------------------------------------------------------------------------  
  
--update status for dependents notes when calculation in finished  
IF( (Select COUNT(NoteID) from Core.CalculationRequests with(nolock)  WHERE [StatusID] in (@lookupidRunning,@lookupidProcessing)) =0)  
begin  
 Update Core.CalculationRequests set [StatusID]=@lookupidProcessing ,  StartTime = getdate()  
 where NoteID in (SELECT distinct NoteID FROM Core.CalculationRequests WHERE [StatusID] = @lookupidDependents)  
end  
  
     
--Declare @isComplete int=0;   
select @isComplete=COUNT(NoteId) from Core.CalculationRequests   
where StatusID = @lookupidProcessing  OR StatusID = @lookupidRunning  
and CalcType = 775  
  
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED   
    
END


