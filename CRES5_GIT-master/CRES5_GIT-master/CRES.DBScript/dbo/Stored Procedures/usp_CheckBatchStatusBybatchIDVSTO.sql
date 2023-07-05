---[dbo].[usp_CheckBatchStatusBybatchIDVSTO] 14  
  
CREATE PROCEDURE [dbo].[usp_CheckBatchStatusBybatchIDVSTO] --36  
    @BatchLogID int   
AS    
BEGIN    
    
SET NOCOUNT ON;    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
  
Declare @ret_Status nvarchar(50);  
  
Declare @TotalCnt int;  
Declare @CompletedCnt int;  

 
SET @TotalCnt = (Select COUNT(BatchLogAsyncCalcVSTOID) from [CRE].BatchDetailAsyncCalcVSTO where BatchLogAsyncCalcVSTOID = @BatchLogID and [Status] is not null)  
SET @CompletedCnt = (Select COUNT(BatchLogAsyncCalcVSTOID) from [CRE].BatchDetailAsyncCalcVSTO where BatchLogAsyncCalcVSTOID = @BatchLogID and [Status] in ('Completed','Failed' )and [Status] is not null)  
  
IF (@TotalCnt = 0)  
 SET @TotalCnt = 1  
  
IF (@CompletedCnt = @TotalCnt)  
BEGIN  
 SET  @ret_Status = 'Completed'  
END  
ELSE  
BEGIN  
 SET  @ret_Status = 'Not Completed'  
END  
   
Select @ret_Status as [Status],(@CompletedCnt * 100)/@TotalCnt as [Percentage]  
  
  
--Declare @ret_Status nvarchar(50);  
--Declare @ActualCnt int;  
--Declare @CompletedCnt int;  
  
--SET @ActualCnt = (Select COUNT(BatchLogAsyncCalcVSTOID) from [CRE].BatchDetailAsyncCalcVSTO where BatchLogAsyncCalcVSTOID = @BatchLogID)  
--SET @CompletedCnt = (Select COUNT(BatchLogAsyncCalcVSTOID) from [CRE].BatchDetailAsyncCalcVSTO where BatchLogAsyncCalcVSTOID = @BatchLogID and [Status] = 'Completed')  
  
  
--IF (@ActualCnt = @CompletedCnt)  
--BEGIN  
-- SET  @ret_Status = 'Completed'  
--END  
--ELSE  
--BEGIN  
-- SET  @ret_Status = 'Not Completed'  
--END  
   
--Select @ret_Status as [Status]  
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
END    
