CREATE PROCEDURE [dbo].[usp_GetJournalEntryByJournalEntryMasterGuid]  
 @JournalEntryMasterGuid UNIQUEIDENTIFIER   
AS  
BEGIN  
    Select  
     jm.JournalEntryMasterGUID,  
     jm.JournalEntryMasterID,  
        jm.JournalEntryDate,  
        jm.Comment,  
        tem.AccountId,   
        tem.Date,   
        tem.Type,   
        tem.Amount,   
        tem.Comment as CommentDetail,  
  tem.UpdatedDate,  
  tem.UpdatedBy,  
  u.Login as UpdatedByText,
  tem.TransactionEntryID  
    FROM  
    [Cre].[JournalEntryMaster] as jm  
    Inner Join Cre.TransactionEntryManual tem ON jm.JournalEntryMasterID = tem.JournalEntryMasterId 
	inner join App.[User] u on jm.UpdatedBy = u.UserID
    where jm.JournalEntryMasterGUID = @JournalEntryMasterGuid   
END