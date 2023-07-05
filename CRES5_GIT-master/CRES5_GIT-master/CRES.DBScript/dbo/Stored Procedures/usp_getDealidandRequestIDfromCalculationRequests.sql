  
CREATE PROCEDURE [dbo].[usp_getDealidandRequestIDfromCalculationRequests] 
    
AS    
BEGIN    

 SET NOCOUNT ON;    

 
 ---Exclude Completed and Failed

 --Select Distinct DealID,RequestID,AnalysisID from Core.CalculationRequests where [StatusID] not in (265,266) and RequestID is not null;

	Select Distinct c.DealID AS DealID,RequestID,AnalysisID ,c.CalcType
	from Core.CalculationRequests c
	INNER JOIN CRE.Deal d on d.DealID = c.DealID 
	where  AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
	AND d.BalanceAware = 1
	AND [StatusID] not in (265,266) 
	and RequestID is not null
	
	UNION

	-- all parent Notes with BalanceAware = 0 and RequestID IS NULL (calc not started) 

	SELECT c.NoteId  AS DealID,RequestID,AnalysisID   ,c.CalcType
	FROM Core.CalculationRequests c
	INNER JOIN CRE.Deal d on d.DealID = c.DealID 
	WHERE c.AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
	AND d.BalanceAware = 0
	AND [StatusID] not in (265,266,326) 
	and RequestID is not null

END 

 
