
CREATE PROCEDURE [dbo].[usp_getDealidfromCalculationRequests]                 
AS                
BEGIN                
            
 SET NOCOUNT ON;                
               

update cre.deal set BalanceAware = 0 where BalanceAware is null

update  Core.CalculationRequests  set StatusID =292  --, ErrorMessage = 'RequestID missing'       ---RequestTime = getdate() ,    
where StatusID =735             
--and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'             
and CalculationRequestID in ( 
	select CalculationRequestID             
	from Core.CalculationRequests             
	where StatusID =735 and RequestID is  null             
	and DATEDIFF(minute,RequestTime,getdate()) >= 30            
	--and DATEDIFF(hour,RequestTime,getdate()) >= 2            
	--and AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'    
	and CalcEngineType  = 798          
)            
       

--=====update status for dependents notes when calculation in finished====
Declare @AnalysisID UNIQUEIDENTIFIER
 
IF CURSOR_STATUS('global','CursorDeal')>=-1
BEGIN
	DEALLOCATE CursorDeal
END

DECLARE CursorDeal CURSOR 
for
(
	Select Distinct AnalysisID from Core.CalculationRequests where requesttime >= Dateadd(hour,-24,getdate()) 
)
OPEN CursorDeal 
FETCH NEXT FROM CursorDeal
INTO @AnalysisID
WHILE @@FETCH_STATUS = 0
BEGIN
	Declare @lookupidRunning int = 267;
	Declare @lookupidProcessing int = 292;
	Declare @lookupidFailed int = 265;
	Declare @lookupidDependents int = 326;
	Declare @lookupidCalcSubmit int = 735;  

	IF( (Select COUNT(AccountId) from Core.CalculationRequests with(nolock)  WHERE [StatusID] in (@lookupidRunning,@lookupidProcessing,@lookupidCalcSubmit) and CalcType = 775  and CalcEngineType  = 798 and AnalysisID = @AnalysisID) =0)
	BEGIN
		IF Exists(SELECT distinct AccountId FROM Core.CalculationRequests WHERE [StatusID] = @lookupidDependents and CalcType = 775 and CalcEngineType  = 798 and AnalysisID = @AnalysisID)
		BEGIN				
			Update Core.CalculationRequests set [StatusID]=@lookupidProcessing ,  StartTime = getdate()  ,ErrorMessage = '',requesttime = getdate(),requestID = null
			where AccountId in (SELECT distinct AccountId FROM Core.CalculationRequests WHERE [StatusID] = @lookupidDependents and CalcType = 775 and CalcEngineType  = 798 and AnalysisID = @AnalysisID)
			and CalcType = 775
			and CalcEngineType  = 798
			and AnalysisID = @AnalysisID
		END

	END	
					 
FETCH NEXT FROM CursorDeal
INTO @AnalysisID
END
CLOSE CursorDeal   
DEALLOCATE CursorDeal
--===========================================	 	
		
		      
 ----for running but not completed notes            
 --update  Core.CalculationRequests  set StatusID =292 ,RequestID = NULL, StartTime = Null , ErrorDetails = 'running but not completed' ,NumberOfRetries = (ISNULL(NumberOfRetries,0) + 1)    ---RequestTime = getdate() ,       
 --where CalculationRequestID in             
 --(            
 -- select CalculationRequestID             
 -- from Core.CalculationRequests             
 -- where StatusID =267  --and RequestID is  null             
 -- --and DATEDIFF(minute,StartTime,getdate()) >= 50        
 -- and DATEDIFF(hour,StartTime,getdate()) >= 5     
 --  and CalcEngineType  = 798            
 --)            


               
 ---Exclude Completed and Failed            
 --Select Distinct DealID from Core.CalculationRequests where AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'            
               
 CREATE TABLE #tmpCalcNote            
 (            
  CalculationRequestID VARCHAR(8000)            
 )            
            
 Delete from #tmpCalcNote        
         
 INSERT INTO #tmpCalcNote (CalculationRequestID)   
          
-- all Deals with BalanceAware = 1 and RequestID IS NULL (calc not started)            
Select top 100 CalculationRequestID 
from(
	 Select  CalculationRequestID ,requesttime
	 from Core.CalculationRequests c            
	 INNER JOIN CRE.Deal d on d.DealID = c.DealID             
	 where  StatusId in (292) -- ,735            
	 --AND AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'            
	 AND c.RequestID IS NULL             
	 AND d.BalanceAware = 1            
	 AND c.CalcType <> 776       
	 and c.CalcEngineType  = 798        
          
	 UNION            
        
	 -- all parent Notes with BalanceAware = 0 and RequestID IS NULL (calc not started)             
	SELECT  CalculationRequestID ,requesttime
	FROM Core.CalculationRequests c            
	INNER JOIN CRE.Deal d on d.DealID = c.DealID             
	WHERE StatusId in ( 292) --,735            
	--AND c.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'            
	AND c.RequestID IS NULL             
	AND d.BalanceAware = 0            
	AND c.CalcType <> 776       
	and c.CalcEngineType  = 798             
   
)a
order by a.requesttime
   

            
-----            
UPDATE CORE.CalculationRequests SET StatusId = 735,StartTime = null,Endtime = null --, ErrorMessage = 'usp_getDealidfromCalculationRequests'            
WHERE CalculationRequestID IN (SELECT CalculationRequestID FROM #tmpCalcNote)             
AND Calctype <> 776       
and CalcEngineType  = 798       
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
  and c.CalcEngineType  = 798        
         
 UNION            
         
 -- all parent Notes with BalanceAware = 0 and RequestID IS NULL (calc not started)             
 SELECT n.NoteId as objectID, 182 AS objectTypeId  ,AnalysisID,c.CalcType            
 FROM Core.CalculationRequests c   
 Inner Join cre.note n on n.Account_AccountID = c.AccountId
 INNER JOIN CRE.Deal d on d.DealID = c.DealID             
 WHERE  c.CalculationRequestID IN (SELECT CalculationRequestID FROM #tmpCalcNote)            
 --AND StatusId in ( 292) --,735            
 --AND c.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'            
 AND c.RequestID IS NULL             
 AND d.BalanceAware = 0            
 AND c.CalcType <> 776        
  and c.CalcEngineType  = 798            
       
      
 DROP TABLE #tmpCalcNote;            
              
END