--[dbo].[usp_GetTransactionEntryMaxIDByNoteID_V1] '7375' ,'C10F3372-0FC2-4861-A9F5-148F1F80804F'

CREATE PROCEDURE [dbo].[usp_GetTransactionEntryMaxIDByNoteID_V1]   ---'7375' ,'C10F3372-0FC2-4861-A9F5-148F1F80804F'
	 @creNoteID nvarchar(256),  
	 @AnalysisID UNIQUEIDENTIFIER	
AS  
BEGIN  
   
 IF(@AnalysisID is not null)  
 BEGIN  
    

	--declare @noteid UNIQUEIDENTIFIER;
	
	--set @noteid=( Select n.noteid  FROM cre.note n 
	--inner join core.account acc on acc.accountid = n.account_accountid
	--WHERE n.creNoteID =@creNoteID  and acc.isdeleted <>1
	--)

	--Select NoteId,MAX(TransactionEntryAutoID)  as TranEntryAutoID 
	--from [CRE].[TransactionEntry] where AnalysisID = @AnalysisID and noteid = @noteid  
	--group by noteid



	declare @noteid UNIQUEIDENTIFIER;
	declare @accountid UNIQUEIDENTIFIER;
	declare @MAX_TranEntryAutoID	int;

	 
	Select @noteid = n.noteid  ,@accountid = n.Account_AccountID
	FROM cre.note n 
	inner join core.account acc on acc.accountid = n.account_accountid
	WHERE n.creNoteID = @creNoteID  and acc.isdeleted <>1

	 

	SET @MAX_TranEntryAutoID = (
		Select MAX(TransactionEntryAutoID)  as TranEntryAutoID 
		from [CRE].[TransactionEntry] tr
		Inner Join core.account acc on acc.accountid = tr.accountid
		Inner join cre.note n on n.account_accountid = acc.AccountID
		where AnalysisID = @AnalysisID and n.noteid = @noteid  
		group by n.noteid
	)

	Select @noteid as NoteId,@accountid as AccountID,ISNULL(@MAX_TranEntryAutoID,0) as TranEntryAutoID


	
 END  
  
END  
  
  

 