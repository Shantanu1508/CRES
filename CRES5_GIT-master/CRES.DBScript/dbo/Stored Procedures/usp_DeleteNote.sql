-- Procedure

CREATE PROCEDURE [dbo].[usp_DeleteNote] --'4311'  
 @CreNoteID varchar(256)  
as  
Begin  
  
  
Declare @LookupIdForNote int = (Select lookupid from core.Lookup where name = 'Note');  
  
Declare @noteid UNIQUEIDENTIFIER;  
Declare @L_AccountId UNIQUEIDENTIFIER;  

Select @noteid = Noteid,@L_AccountId = Account_AccountId from CRE.Note where CRENoteID = @CreNoteID 
  
  
IF OBJECT_ID('tempdb..#tbleventId') IS NOT NULL         
DROP TABLE #tbleventId  
CREATE TABLE #tbleventId  
(  
 eventid uniqueidentifier,  
 eventTypeid int  
)    
INSERT INTO #tbleventId(eventid,eventTypeid)   
Select EventID,eventTypeid from core.Event e  
inner join core.Account acc on e.AccountID = acc.AccountID  
Inner join cre.Note n on acc.AccountID = n.Account_AccountID  
where n.NoteID = @noteid  
  
  
Delete from [CRE].[DependentCalcRequest] where  ParentNoteID = @noteid  
Delete from CRE.PayruleDistributions where SourceNoteID = @noteid  
  
  
Delete from Core.CalculationRequests  where AccountID = @L_AccountId

Delete from CRE.FundingRepaymentSequence where NoteID = @noteid   


Delete from CRE.NoteTransactionDetail where NoteID = @noteid  

Delete from CRE.TransactionEntry where AccountID = @L_AccountId -- Noteid = @noteid
  
Delete from CRE.NotePeriodicCalc where   AccountID = @L_AccountId  
Delete from CRE.OutputNPVdata where   NoteID = @noteid  
  
Delete from CRE.Note  where NoteID = @noteid  
  
Delete From   CORE.BalanceTransactionSchedule  where eventid in (Select eventid  from #tbleventId where eventtypeid  =5)  
Delete From   CORE.DefaultSchedule  where eventid in (Select eventid  from #tbleventId where eventtypeid  =6)  
Delete From   CORE.FeeCouponSchedule  where eventid in (Select eventid  from #tbleventId where eventtypeid  =7)  
Delete From   CORE.FinancingFeeSchedule  where eventid in (Select eventid  from #tbleventId where eventtypeid  =8)  
Delete From   CORE.FinancingSchedule  where eventid in (Select eventid  from #tbleventId where eventtypeid  =9)  
Delete From   CORE.FundingSchedule  where eventid in (Select eventid  from #tbleventId where eventtypeid  =10)  
Delete From   CORE.Maturity  where eventid in (Select eventid  from #tbleventId where eventtypeid  =11)  
Delete From   CORE.PIKSchedule  where eventid in (Select eventid  from #tbleventId where eventtypeid  =12)  
Delete From   CORE.PrepayAndAdditionalFeeSchedule            where eventid in (Select eventid  from #tbleventId where eventtypeid  =13)  
Delete From   CORE.RateSpreadSchedule  where eventid in (Select eventid  from #tbleventId where eventtypeid  =14)  
Delete From   CORE.ServicingFeeSchedule  where eventid in (Select eventid  from #tbleventId where eventtypeid  =15)  
Delete From   CORE.StrippingSchedule  where eventid in (Select eventid  from #tbleventId where eventtypeid  =16)  
Delete From   CORE.PIKScheduleDetail  where eventid in (Select eventid  from #tbleventId where eventtypeid  =17)  
Delete From   CORE.LIBORSchedule  where eventid in (Select eventid  from #tbleventId where eventtypeid  =18)  
Delete From   CORE.AmortSchedule  where eventid in (Select eventid  from #tbleventId where eventtypeid  =19)  
Delete From   CORE.FeeCouponStripReceivable  where eventid in (Select eventid  from #tbleventId where eventtypeid  =20)  
  
  
Delete from Core.Event where eventid in (  
Select EventID from core.Event e  
inner join core.Account acc on e.AccountID = acc.AccountID  
Inner join cre.Note n on acc.AccountID = n.Account_AccountID  
where n.NoteID = @noteid)  
  
  
Delete from CORE.[transaction] where RegisterID in (Select RegisterID from core.Register where AccountID in (Select Account_AccountID from cre.Note where NoteID = @noteid))  
Delete from core.Register where AccountID in (Select Account_AccountID from cre.Note where NoteID = @noteid)  
  
Delete from Core.Account where AccountID in (Select Account_AccountID from cre.Note where NoteID = @noteid)  
  
  
Delete from [App].[SearchItem] where Object_ObjectAutoID in (Select ObjectAutoID from [App].[Object] where ObjectID not in (Select NoteID from CRE.note) AND  ObjectTypeID = @LookupIdForNote)  
Delete from [App].[Object] where ObjectID not in (Select NoteID from CRE.note) AND  ObjectTypeID = @LookupIdForNote  
  
  
END  

