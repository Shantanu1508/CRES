
CREATE PROCEDURE [dbo].[usp_getDealidfromCalculationRequestsPrepayment]    
AS                
BEGIN                
            
 SET NOCOUNT ON;                


Declare @AnalysisID UNIQUEIDENTIFIER;
SET @AnalysisID = (Select AnalysisID from core.Analysis where [Name] = 'Prepayment Default')


Declare @tblCompletedDeal as Table (DealID UNIQUEIDENTIFIER);

INSERT INTO @tblCompletedDeal(DealID)
Select d.dealid ---,ISNULL(cnt,0) as cnt
from cre.deal d 
left join(
	select d.DealID,count(*) cnt
	from Core.CalculationRequests  cr
	Inner join cre.note n on n.Account_AccountID = cr.AccountId
	INNER JOIN CRE.Deal d on d.DealID = n.DealID
	where AnalysisID = @AnalysisID
	and cr.StatusID NOT IN (266,265,736)
	group by d.DealID
	--Having count(*) = 0
)z on z.dealid = d.dealid
where ISNULL(cnt,0) = 0
and d.dealid in (Select DealID from Core.CalculationRequests where analysisid = @AnalysisID)



     
IF OBJECT_ID('tempdb..#tmpCalcNote_prepayment') IS NOT NULL     
	DROP TABLE #tmpCalcNote_prepayment 
	
CREATE TABLE #tmpCalcNote_prepayment            
(            
	CalculationRequestID VARCHAR(8000)            
)            
            
Delete from #tmpCalcNote_prepayment        
         
INSERT INTO #tmpCalcNote_prepayment (CalculationRequestID)  
Select top 100 CalculationRequestID 
from(
	 Select  CalculationRequestID ,requesttime
	 from Core.CalculationRequests c            
	 INNER JOIN CRE.Deal d on d.DealID = c.DealID             
	 where  StatusId in (292) -- ,735            
	 AND AnalysisID = @AnalysisID      
	 AND c.RequestID IS NULL  
	 AND c.CalcType = 776       
	 and c.CalcEngineType  = 797     
	 
	 and d.dealid in (Select dealid from @tblCompletedDeal)
	 
)a
order by a.requesttime
   
        
UPDATE CORE.CalculationRequests SET StatusId = 735,StartTime = null,Endtime = null --, ErrorMessage = 'usp_getDealidfromCalculationRequests'            
WHERE CalculationRequestID IN (SELECT CalculationRequestID FROM #tmpCalcNote_prepayment)             
AND Calctype = 776       
and CalcEngineType  = 797   
AND AnalysisID = @AnalysisID     
            
            
Select Distinct c.DealID AS objectID, 283 AS objectTypeId ,AnalysisID,c.CalcType            
from Core.CalculationRequests c            
INNER JOIN CRE.Deal d on d.DealID = c.DealID             
where  c.CalculationRequestID IN (SELECT CalculationRequestID FROM #tmpCalcNote_prepayment)            
AND c.RequestID IS NULL 
AND c.CalcType = 776            
and c.CalcEngineType  = 797        
AND AnalysisID = @AnalysisID            
       
   
           
              
END