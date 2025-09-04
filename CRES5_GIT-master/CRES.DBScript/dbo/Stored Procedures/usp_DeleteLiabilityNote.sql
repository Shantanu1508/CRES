-- Procedure
CREATE PROCEDURE [dbo].[usp_DeleteLiabilityNote]   
	@liabilityNoteAccountId uniqueidentifier
AS  
BEGIN    
  
SET NOCOUNT ON;  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

	delete from [CRE].[TransactionEntryLiability] where LiabilityNoteAccountID = @liabilityNoteAccountId
 
    delete from [Core].[GeneralSetupDetailsLiabilityNote] where eventid in (
	 select eventid from core.Event where eventtypeid = 841 and accountid in (Select accountid from cre.liabilitynote where accountid = @liabilityNoteAccountId)
    )
 
    delete from [Core].RateSpreadSchedule where eventid in (
	 select eventid from core.Event where eventtypeid = 14 and accountid in (Select accountid from cre.liabilitynote where accountid = @liabilityNoteAccountId)
    )
 
    delete from core.Event where eventtypeid in (14, 841) and accountid = @liabilityNoteAccountId
 
    delete from cre.LiabilityNoteAssetMapping where LiabilityNoteAccountId = @liabilityNoteAccountId
 
    delete from cre.liabilitynote where AccountID = @liabilityNoteAccountId

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
END