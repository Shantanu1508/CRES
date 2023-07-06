-- Procedure  
    
    
    
                        
          
CREATE PROCEDURE [dbo].[usp_getDealidfromCalculationRequests]             
AS            
BEGIN            
        
 SET NOCOUNT ON;            
           
           
 update  Core.CalculationRequests  set StatusID =292 ,RequestTime = getdate() , ErrorMessage = 'RequestID missing'       
 where StatusID =735         
 --and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'         
 and CalculationRequestID in (             
  
  select CalculationRequestID         
  from Core.CalculationRequests         
  where StatusID =735 and RequestID is  null         
  and DATEDIFF(minute,RequestTime,getdate()) >= 30        
  --and DATEDIFF(hour,RequestTime,getdate()) >= 2        
  --and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'        
 )        
         
 --for running but not completed notes        
 update  Core.CalculationRequests  set StatusID =292 ,RequestTime = getdate() , RequestID = NULL, StartTime = Null , ErrorDetails = 'running but not completed'       
 where CalculationRequestID in         
 (        
  select CalculationRequestID         
  from Core.CalculationRequests         
  where StatusID =267  --and RequestID is  null         
  and DATEDIFF(minute,StartTime,getdate()) >= 50         
 )        
           
 ---Exclude Completed and Failed        
 --Select Distinct DealID from Core.CalculationRequests where AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'        
           
 CREATE TABLE #tmpCalcNote        
 (        
  CalculationRequestID VARCHAR(8000)        
 )        
        
 Delete from #tmpCalcNote    
     
 INSERT INTO #tmpCalcNote (CalculationRequestID)        
 -- all Deals with BalanceAware = 1 and RequestID IS NULL (calc not started)        
 Select  Distinct TOP 100 CalculationRequestID        
 from Core.CalculationRequests c        
 INNER JOIN CRE.Deal d on d.DealID = c.DealID         
 where  StatusId in (292) -- ,735        
 --AND AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'        
 AND c.RequestID IS NULL         
 AND d.BalanceAware = 1        
 AND c.CalcType <> 776       
      
 UNION        
    
 -- all parent Notes with BalanceAware = 0 and RequestID IS NULL (calc not started)         
 SELECT  TOP 100 CalculationRequestID        
 FROM Core.CalculationRequests c        
 INNER JOIN CRE.Deal d on d.DealID = c.DealID         
 WHERE StatusId in ( 292) --,735        
 --AND c.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'        
 AND c.RequestID IS NULL         
 AND d.BalanceAware = 0        
 AND c.CalcType <> 776        
        
 -----        
 UPDATE CORE.CalculationRequests SET StatusId = 735,StartTime = null,Endtime = null , ErrorMessage = 'usp_getDealidfromCalculationRequests'        
 WHERE CalculationRequestID IN (SELECT CalculationRequestID FROM #tmpCalcNote)         
 AND Calctype <> 776        
 --------        
        
 Select Distinct c.DealID AS objectID, 283 AS objectTypeId ,AnalysisID,c.CalcType        
 from Core.CalculationRequests c        
 INNER JOIN CRE.Deal d on d.DealID = c.DealID         
 where  c.CalculationRequestID IN (SELECT CalculationRequestID FROM #tmpCalcNote)        
 --AND StatusId in (292) -- ,735        
 --AND AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'        
 AND c.RequestID IS NULL         
 AND d.BalanceAware = 1         
 AND c.CalcType <> 776        
     
 UNION        
     
 -- all parent Notes with BalanceAware = 0 and RequestID IS NULL (calc not started)         
 SELECT c.NoteId as objectID, 182 AS objectTypeId  ,AnalysisID,c.CalcType        
 FROM Core.CalculationRequests c        
 INNER JOIN CRE.Deal d on d.DealID = c.DealID         
 WHERE  c.CalculationRequestID IN (SELECT CalculationRequestID FROM #tmpCalcNote)        
 -- AND StatusId in ( 292) --,735        
 --AND c.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'        
 AND c.RequestID IS NULL         
 AND d.BalanceAware = 0        
 AND c.CalcType <> 776        
   
   

  
 DROP TABLE #tmpCalcNote;        
        
 /*        
        
    -- all Deals with BalanceAware = 1 and RequestID IS NULL (calc not started)        
 Select Distinct c.DealID AS objectID, 283 AS objectTypeId ,AnalysisID,c.CalcType        
 from Core.CalculationRequests c        
 INNER JOIN CRE.Deal d on d.DealID = c.DealID         
 where  StatusId in (292) -- ,735        
  --AND AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'        
 AND c.RequestID IS NULL         
 AND d.BalanceAware = 1        
 UNION        
 -- all parent Notes with BalanceAware = 0 and RequestID IS NULL (calc not started)         
        
 SELECT c.NoteId as objectID, 182 AS objectTypeId  ,AnalysisID,c.CalcType        
 FROM Core.CalculationRequests c        
 INNER JOIN CRE.Deal d on d.DealID = c.DealID         
 WHERE StatusId in ( 292) --,735        
 --AND c.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'        
 AND c.RequestID IS NULL         
 AND d.BalanceAware = 0        
        
        
        
        
 -- update statusid as submit calc: CalcSubmit = 735         
         
 UPDATE CORE.CalculationRequests SET StatusId = 735,StartTime = null,Endtime = null        
 WHERE StatusId = 292         
  --AND AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'        
 */        
        
         
        
END   