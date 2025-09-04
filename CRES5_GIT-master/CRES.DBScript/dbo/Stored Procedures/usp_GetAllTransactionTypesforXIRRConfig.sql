CREATE PROCEDURE [dbo].[usp_GetAllTransactionTypesforXIRRConfig] 
 
AS    
BEGIN    
    
 SET NOCOUNT ON;    
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
     
    SELECT  
    tt.TransactionTypesID  
    ,tt.TransactionName    
	,tt.XIRRCategory
    FROM CRE.TransactionTypes tt  
	Where tt.[UsedInXIRR] = 3	
    order by tt.TransactionName asc 
  

 SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
END  