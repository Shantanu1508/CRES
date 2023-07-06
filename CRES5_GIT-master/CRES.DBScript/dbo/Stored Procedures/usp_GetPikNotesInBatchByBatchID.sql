-- Procedure


CREATE PROCEDURE [dbo].[usp_GetPikNotesInBatchByBatchID]  --'3419','b0e6697b-3534-4c09-be0a-04473401ab93'
(
@BatchLogID int
 
)
AS
BEGIN

	 select distinct noteid from [IO].[L_M61AddinLanding] where TransactionTypeID in (
 select TransactionTypesID  from cre.transactiontypes where TransactionName ='PIKPrincipalPaid')
 and Status ='Imported' and BatchLogGenericID =@BatchLogID

END
	


 
