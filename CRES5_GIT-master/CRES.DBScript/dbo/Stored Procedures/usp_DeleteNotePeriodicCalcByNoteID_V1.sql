CREATE PROCEDURE [dbo].[usp_DeleteNotePeriodicCalcByNoteID_V1]   ---'7375' ,'C10F3372-0FC2-4861-A9F5-148F1F80804F'
	 @creNoteID nvarchar(256),  
	 @AnalysisID UNIQUEIDENTIFIER	
AS  
BEGIN  
   
 IF(@AnalysisID is not null)  
 BEGIN  
    

	declare @noteid UNIQUEIDENTIFIER;
	declare @Accountid UNIQUEIDENTIFIER;
	
	 
	Select @noteid = n.noteid,@Accountid = n.Account_AccountID  
	FROM cre.note n 
	inner join core.account acc on acc.accountid = n.account_accountid
	WHERE n.creNoteID =@creNoteID  and acc.isdeleted <>1
	

  Delete from CRE.NotePeriodicCalc where AnalysisID = @AnalysisID and AccountID = @Accountid --noteid  =@noteid  
  
  Select @noteid  as NoteID,@Accountid as Accountid
   
 END  
  
END  
  
  

 