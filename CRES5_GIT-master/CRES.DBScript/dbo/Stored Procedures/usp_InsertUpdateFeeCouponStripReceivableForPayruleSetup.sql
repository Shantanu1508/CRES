  
--[dbo].[usp_InsertUpdateFeeCouponStripReceivableForPayruleSetup] '45c9cfd6-ad26-4edd-ace8-a2cd5249d3aa','Null','C10F3372-0FC2-4861-A9F5-148F1F80804F'  
  
 CREATE PROCEDURE [dbo].[usp_InsertUpdateFeeCouponStripReceivableForPayruleSetup] --'c1be5843-2618-4b8d-afff-0008a9113df6','B0E6697B-3534-4C09-BE0A-04473401AB93'  
 @SourceNoteID nvarchar(256),  
 @UpdatedBy nvarchar(256),  
 @AnalysisID uniqueidentifier  
      
 AS    
 Begin  
  
 --Delete data from FeeCouponStripReceivable for effective date= closing date  
Declare @InActive as nvarchar(256)=(select LookupID from core.lookup where name ='InActive' and ParentID=1);  
Declare @Active as nvarchar(256)=(select LookupID from core.lookup where name ='Active' and ParentID=1);  
  
  
--Variable's--------------------  
Declare @FeeCouponStripReceivable  int  =20;  
DECLARE @NoteId UNIQUEIDENTIFIER    
DECLARE @AccountId UNIQUEIDENTIFIER  
  
IF CURSOR_STATUS('global','CursorNoteFF')>=-1      
BEGIN      
DEALLOCATE CursorNoteFF      
END      
   
DECLARE CursorNoteFF CURSOR       
FOR      
(      
 select DISTINCT ReceiverNoteID as NoteID ,(SELECT TOP 1 n.Account_AccountID FROM CRE.Note n inner join Core.Account ac on n.Account_AccountID=ac.AccountID  WHERE NoteID = nf.ReceiverNoteID and ac.IsDeleted=0) AccountId   
 from [CRE].PayruleDistributions nf   
 --left join Core.CalculationRequests cr on cr.noteid=nf.ReceiverNoteID  
 where SourceNoteID= @SourceNoteID and amount <> 0   
 --and  cr.StatusID = (SELECT LookupID FROM Core.Lookup WHERE ParentId=40 AND NAME ='Dependents')   
 and nf.AnalysisID = @AnalysisID  
)  
OPEN CursorNoteFF       
FETCH NEXT FROM CursorNoteFF      
INTO @NoteId,@AccountId  
WHILE @@FETCH_STATUS = 0      
BEGIN   
  
 DECLARE @closingDate date = (Select isnull(ClosingDate,GETDATE()) from CRE.Note n WHERE n.NoteID = @NoteId)  
  
  
 Delete from core.[FeeCouponStripReceivable] where eventid in (Select eventid from core.Event WHERE  
 EventTypeID = @FeeCouponStripReceivable and AccountID in (Select Account_AccountID from CRE.NOte where noteid = @NoteId))  
 and AnalysisID = @AnalysisID  
  
  
 Declare @EventId UNIQUEIDENTIFIER ;  
  
 IF EXISTS(Select eventid from core.Event WHERE EventTypeID = @FeeCouponStripReceivable and AccountID in (Select Account_AccountID from CRE.NOte where noteid = @NoteId) and effectiveStartDate = @closingDate)  
 BEGIN  
    
  Delete from core.Event WHERE eventid in (  
   Select eventid from(  
   Select ROW_NUMBER() OVER(ORDER BY eventid) AS RowNumber ,eventid from core.Event WHERE EventTypeID = @FeeCouponStripReceivable and AccountID in (Select Account_AccountID from CRE.NOte where noteid = @NoteId) and effectiveStartDate = @closingDate  
   )a where RowNumber > 1  
  )  
  
  SET @EventId = (Select eventid from core.Event WHERE EventTypeID = @FeeCouponStripReceivable and AccountID in (Select Account_AccountID from CRE.NOte where noteid = @NoteId) and effectiveStartDate = @closingDate)  
 END  
 ELSE  
 BEGIN  
  Delete from core.Event WHERE EventTypeID = @FeeCouponStripReceivable and AccountID in (Select Account_AccountID from CRE.NOte where noteid = @NoteId)  
  
  
  DECLARE @eventidNew UNIQUEIDENTIFIER  
  DECLARE @tEventNew TABLE (tEventIDNew UNIQUEIDENTIFIER)  
  Delete from @tEventNew  
  
  INSERT INTO [Core].[Event](  
  [EffectiveStartDate],  
  [AccountID],  
  [Date],  
  [EventTypeID],  
  [EffectiveEndDate],  
  [SingleEventValue],  
  [CreatedBy],  
  [CreatedDate],  
  [UpdatedBy],  
  [UpdatedDate])  
  
  OUTPUT inserted.EventID INTO @tEventNew(tEventIDNew)  
  
  Select   
  @closingDate as [EffectiveStartDate],  
  @AccountId,  
  GETDATE() as [Date],  
  @FeeCouponStripReceivable as [EventTypeID],  
  NUll as [EffectiveEndDate],  
  NUll as [SingleEventValue],  
  @UpdatedBy,  
  getdate(),  
  @UpdatedBy,  
  getdate()  
        
  SELECT @eventidNew = tEventIDNew FROM @tEventNew;  
  
  
  SET @EventId  = @eventidNew;  
  
 END  
  
  
 print('ccc')  
  
 INSERT INTO core.[FeeCouponStripReceivable] (EventId, Date, Value, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate,SourceNoteId,StrippedAmount,RuleTypeID,FeeName,AnalysisID)      
 select   
 --@eventidNew,  
 @EventId,  
 pd.TransactionDate,  
 sum(pd.Amount),  
 @UpdatedBy,  
 GETDATE(),  
 @UpdatedBy,  
 GETDATE(),  
  
 pd.SourceNoteID,  
 pd.Amount,  
 pd.RuleID,  
 pd.FeeName,  
 @AnalysisID  
 from  CRE.PayruleDistributions pd  
 where   
 --SourceNoteID=@SourceNoteID and    
 ReceiverNoteID= @NoteId   
 and pd.SourceNoteID in (select SourceNoteID from CRE.PayruleDistributions  pd inner join cre.Note n on n.NoteID=pd.SourceNoteID and ReceiverNoteID =@NoteId inner join Core.Account ac on n.Account_AccountID=ac.AccountID where  ReceiverNoteID =@NoteId and 
ac.IsDeleted=0)  
   
 and pd.AnalysisID = @AnalysisID  
   
 Group by pd.ReceiverNoteID,TransactionDate,pd.SourceNoteID,  
 pd.Amount,  
 pd.RuleID,  
 pd.FeeName  
 ORDER BY pd.ReceiverNoteID,TransactionDate  
  
 --Delete zero values  
 Delete from core.[FeeCouponStripReceivable] where ISNULL(Value,0) = 0  
  
     
FETCH NEXT FROM CursorNoteFF      
INTO @NoteId,@AccountId  
  
  
  
 End  
  
 END  
