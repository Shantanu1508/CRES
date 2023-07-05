
---[dbo].[usp_CreateNewBatchLogIDForVSTOAsyncCalc] 'vishal'

CREATE PROCEDURE [dbo].[usp_UpdateNoteStatusAndTimeVSTO]
 @BatchLogID int,
 @CRENoteID nvarchar(256),
 @BatchDetailAsyncCalcVSTOID int

AS  
BEGIN  
  
   	
SET NOCOUNT ON;  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

   
update   [CRE].BatchDetailAsyncCalcVSTO
set  [Status] ='Completed',
EndTime=getdate()
 where  CRENoteID =@CRENoteID and BatchLogAsyncCalcVSTOID= @BatchLogID and BatchDetailAsyncCalcVSTOID = @BatchDetailAsyncCalcVSTOID
    

SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END  


