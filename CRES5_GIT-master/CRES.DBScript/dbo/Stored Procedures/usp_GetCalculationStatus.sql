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
Declare @lookupidCalcSubmit int = 735;  

  
IF ((SELECT COUNT(distinct AccountId) FROM Core.CalculationRequests  WHERE [StatusID] = @lookupidFailed and CalcType = 775 and CalcEngineType  = 797 and (ErrorMessage like '%deadlocked%' or ErrorMessage like '%Timeout Expired%')) != 0)  
BEGIN  
 ----Update Status to 'Processing' if note failure due to deadlocked or Timeout Expired------------  
 Update Core.CalculationRequests set [StatusID]=@lookupidProcessing   
 where AccountId in (SELECT distinct AccountId FROM Core.CalculationRequests  WHERE [StatusID] = @lookupidFailed and CalcType = 775 and CalcEngineType  = 797 and (ErrorMessage like '%deadlocked%' or ErrorMessage like '%Timeout Expired%') )  
 and CalcType = 775 and CalcEngineType  = 797
END  
  
----------------------------------------------------------------------------  
  
----update status for dependents notes when calculation in finished  
--IF( (Select COUNT(NoteID) from Core.CalculationRequests with(nolock)  WHERE CalcType = 775 and CalcEngineType  = 797 and [StatusID] in (@lookupidRunning,@lookupidProcessing,@lookupidCalcSubmit)) =0)  
--begin  
--	--print('a')
--	 Update Core.CalculationRequests set [StatusID]=@lookupidProcessing ,  StartTime = getdate(),ErrorMessage = 'dev Dashboard'
--	 where NoteID in (SELECT distinct NoteID FROM Core.CalculationRequests WHERE [StatusID] = @lookupidDependents and CalcType = 775 and CalcEngineType  = 797)  	
--	 and CalcType = 775 and CalcEngineType  = 797
--end  
  
     
--Declare @isComplete int=0;   
select @isComplete=COUNT(AccountId) from Core.CalculationRequests   
where StatusID = @lookupidProcessing  OR StatusID = @lookupidRunning  OR StatusID = @lookupidCalcSubmit
and CalcType = 775 and CalcEngineType  = 797
  
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED   
    
END


