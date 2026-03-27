CREATE PROCEDURE [dbo].[usp_DeleteTransactionEntryByNoteID_V1]   ---'7375' ,'C10F3372-0FC2-4861-A9F5-148F1F80804F'
	 @NoteID nvarchar(256),  
	 @AnalysisID UNIQUEIDENTIFIER,
	 @MaxID nvarchar(256)
AS  
BEGIN  
   
	IF(@AnalysisID is not null)  
	BEGIN   
		Declare @L_AccountId UNIQUEIDENTIFIER; 
		Select @L_AccountId = n.Account_AccountId from CRE.Note n Inner join core.account acc on acc.accountid = n.account_accountid 
		where acc.isdeleted <> 1 and NoteID = @NoteID 
   
		Delete from [CRE].[TransactionEntry] where AnalysisID = @AnalysisID and AccountID = @L_AccountId and TransactionEntryAutoID <= CAST(@MaxID  as int)
	END  
  
END  
  
