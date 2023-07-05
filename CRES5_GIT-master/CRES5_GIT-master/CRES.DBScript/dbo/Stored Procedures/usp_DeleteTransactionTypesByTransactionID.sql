
-- [dbo].[usp_DeleteTransactionTypesByTransactionID] '2','B0E6697B-3534-4C09-BE0A-04473401AB93'

CREATE PROCEDURE [dbo].[usp_DeleteTransactionTypesByTransactionID]   
	@TransactioTypeID int,
	@UserID uniqueidentifier
AS  
BEGIN    
  
SET NOCOUNT ON;  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

	DELETE FROM CRE.TransactionTypes WHERE TransactionTypesID =@TransactioTypeID

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
END
