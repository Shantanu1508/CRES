
--[dbo].[usp_GetCalculationStatusByServerIndex] 10,0

CREATE PROCEDURE [dbo].[usp_GetCalculationStatusByServerIndex] (
--@tblCalcRequest TableTypeCalcRequest READONLY
@ServerIndex INT,
@isComplete int OUTPUT)
as
BEGIN
     SET NOCOUNT ON;
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

--Declare @lookupidRunning int = (SELECT LookupID from core.Lookup where Name='Running' and ParentID=40);
--Declare @lookupidProcessing int = (SELECT LookupID from core.Lookup where Name='Processing' and ParentID=40);
--Declare @lookupidFailed int = (SELECT LookupID from core.Lookup where Name='Failed' and ParentID=40);

Declare @lookupidRunning int = 267;
Declare @lookupidProcessing int = 292;
Declare @lookupidFailed int = 265;
Declare @lookupidDependents int = (SELECT LookupID from core.Lookup where Name='Dependents' and ParentID=40);
Declare @lookupidCalcSubmit int = 735;  


Declare @NumberOfRetries int = (Select top 1 [Value] from app.appconfig where [Key] = 'NumberOfCalculationRetries'); 


IF ((SELECT COUNT(distinct AccountId) FROM Core.CalculationRequests  WHERE [StatusID] = @lookupidFailed and CalcType = 775 and CalcEngineType  = 797 and (ErrorMessage like '%deadlocked%' or ErrorMessage like '%Timeout Expired%')) != 0)
BEGIN
	----Update Status to 'Processing' if note failure due to deadlocked or Timeout Expired------------
	Update Core.CalculationRequests set [StatusID]=@lookupidProcessing ,NumberOfRetries = (NumberOfRetries + 1)  --,ErrorMessage = 'usp_GetCalculationStatusByServerIndex 1'
	where AccountId in (SELECT distinct AccountId FROM Core.CalculationRequests  WHERE [StatusID] = @lookupidFailed and (ErrorMessage like '%deadlocked%' or ErrorMessage like '%Timeout Expired%') and CalcType = 775 and CalcEngineType  = 797)
	and NumberOfRetries < @NumberOfRetries
	and CalcType = 775
	and CalcEngineType  = 797
END

------------------------------------------------------------------------------

--update status for dependents notes when calculation in finished
IF( (Select COUNT(AccountId) from Core.CalculationRequests with(nolock)  WHERE [StatusID] in (@lookupidRunning,@lookupidProcessing,@lookupidCalcSubmit) and CalcType = 775  and CalcEngineType  = 797 ) =0)
begin
	Update Core.CalculationRequests set [StatusID]=@lookupidProcessing ,  StartTime = getdate()  ,ErrorMessage = 'usp_GetCalculationStatusByServerIndex'
	where AccountId in (SELECT distinct AccountId FROM Core.CalculationRequests WHERE [StatusID] = @lookupidDependents and CalcType = 775 and CalcEngineType  = 797)
	and CalcType = 775
	and CalcEngineType  = 797
end
	 	
--Declare @isComplete int=0; 
select @isComplete=COUNT(AccountId) from Core.CalculationRequests 
where StatusID = @lookupidProcessing  OR StatusID = @lookupidRunning oR StatusID = @lookupidCalcSubmit
and CalcType = 775
and CalcEngineType  = 797


--print(CAST(@isComplete as nvarchar(256)))

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
	
		
END
GO

