CREATE PROCEDURE [val].[usp_SendValuationDealsForReCalc]	 
  
AS
BEGIN

SET NOCOUNT ON;

	Declare @lookupidProcessing int = 292;   
	Declare @lookupidFailed int = 265;  
	Declare @NumberOfRetries int = (Select top 1 [Value] from app.appconfig where [Key] = 'NumberOfCalculationRetries_valuation');   
	

IF ((SELECT COUNT(distinct [DealID]) FROM val.valuationrequests  WHERE [StatusID] = @lookupidFailed and (ErrorMessage like '%The RPC server is unavailable%' or ErrorMessage like '%Invalid index%'or ErrorMessage like '%Retrieving the COM class factory for component%' or ErrorMessage like '%Forcefully failed - calculation got stucked%' or ErrorMessage like '%Access is denied%' or ErrorMessage like '%An existing connection was forcibly closed by the remote host%')) != 0)    
BEGIN 
  
 Update val.valuationrequests  
 set [StatusID]= @lookupidProcessing   
 ,NumberOfRetries = (NumberOfRetries + 1)  
 ,RequestTime = getdate()  
 ,StartTime = null  
 ,EndTime = null  
 ,ErrorMessage =null  
 ,VMMasterID =null  
 ,UpdatedDate = getdate()  
 where NumberOfRetries < @NumberOfRetries   
 and DealID in (
 SELECT distinct [DealID] FROM val.valuationrequests  
 WHERE [StatusID] = @lookupidFailed and 
 (
	 ErrorMessage like '%The RPC server is unavailable%'  or 
	 ErrorMessage like '%Invalid index%' or 
	 ErrorMessage like '%Forcefully failed - calculation got stucked%' or 
	 ErrorMessage like '%Access is denied%' or 
	 ErrorMessage like '%An existing connection was forcibly closed by the remote host%' or
	 ErrorMessage like  '%Retrieving the COM class factory for component%'
 ) )    
    
END  

 
	

END
GO
 
 


