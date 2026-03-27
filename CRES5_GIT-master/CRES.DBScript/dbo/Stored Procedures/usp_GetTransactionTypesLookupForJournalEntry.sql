CREATE PROCEDURE [dbo].[usp_GetTransactionTypesLookupForJournalEntry] --'b0e6697b-3534-4c09-be0a-04473401ab93'  
 
AS    
BEGIN    
    
 SET NOCOUNT ON;    
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
     
    SELECT  
    tt.TransactionTypesID  
    ,tt.TransactionName    
    FROM CRE.TransactionTypes tt  
    where tt.TransactionCategory = 'Liability'
    order by tt.TransactionName asc 
  

 SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
END  