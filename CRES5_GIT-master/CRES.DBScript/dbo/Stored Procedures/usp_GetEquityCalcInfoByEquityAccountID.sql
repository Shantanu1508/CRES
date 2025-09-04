CREATE Procedure [dbo].[usp_GetEquityCalcInfoByEquityAccountID]
(    
 @EquityAccountID uniqueidentifier,    
 --@ScenarioId uniqueidentifier,    
 @UserID uniqueidentifier    
)    
as     
BEGIN    
 SET NOCOUNT ON;    
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 


	Select   
	cr.EndTime as DateTime,  
	--l.Name AS StatusName,  
	StatusName_New AS StatusName,  
	cr.ErrorMessage  
	from core.CalculationRequestsLiability cr  
	LEFT JOIN   Core.Lookup l ON l.LookupID = cr.StatusID   
	Left Join(
		Select  cr.AccountId,	
		STRING_AGG(l.Name,'_') AS StatusName,
		(CASE WHEN STRING_AGG(l.Name,'_') like '%Running%' THEN 'Running'
		 WHEN STRING_AGG(l.Name,'_') like '%Failed%' THEN 'Failed'
		 WHEN STRING_AGG(l.Name,'_') = 'Completed_Completed' THEN 'Completed'
		 ELSE 'Processing' END
		) as StatusName_New
		from core.CalculationRequestsLiability cr  
		LEFT JOIN   Core.Lookup l ON l.LookupID = cr.StatusID   
		where AccountId = @EquityAccountID
		group by cr.AccountId
	)tblStatus on tblStatus.AccountId = cr.AccountId
	where cr.AccountId = @EquityAccountID

END
--
--AnalysisID = @ScenarioId and