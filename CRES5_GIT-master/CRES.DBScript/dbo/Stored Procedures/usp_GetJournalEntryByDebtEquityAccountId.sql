CREATE PROCEDURE [dbo].[usp_GetJournalEntryByDebtEquityAccountId]
	@DebtEquityAccountId UNIQUEIDENTIFIER 
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
		(u.FirstName + ' ' + u.LastName) as UpdatedBy,
		tem.TransactionEntryID
    FROM
    [Cre].[JournalEntryMaster] as jm
    Inner Join Cre.TransactionEntryManual tem ON jm.JournalEntryMasterID = tem.JournalEntryMasterId
	Left join App.[User] u on u.UserID = tem.UpdatedBy
    where tem.AccountId = @DebtEquityAccountId
END

