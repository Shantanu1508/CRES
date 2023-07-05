

CREATE PROCEDURE [dbo].[usp_GetTransactionEntryVSTOByBatchLogID] --13
 @BatchLogID int

AS  
BEGIN  
  
 SET NOCOUNT ON;  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
 
	Select 	
	CRENoteID	
	,Date	
	,Amount	
	,Type	
	,FeeName 
	,SizerScenario from CRE.TransactionEntryVSTO 
	where BatchDetailAsyncCalcVSTOId in (Select BatchDetailAsyncCalcVSTOId from [CRE].BatchDetailAsyncCalcVSTO where BatchLogAsyncCalcVSTOID = @BatchLogID)
	and  Amount <>0

 SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END  
