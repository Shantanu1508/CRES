

CREATE PROCEDURE [dbo].[usp_DeleteDealWithNote] --'16-0502'
	@CreDealID varchar(256)
as
Begin


Declare @LookupIdForNote int = (Select lookupid from core.Lookup where name = 'Note');
Declare @LookupIdForDeal int= (Select lookupid from core.Lookup where name = 'Deal');
Declare @LookupIdForProperty int= (Select lookupid from core.Lookup where name = 'Property');

Declare @dealid UNIQUEIDENTIFIER;
SET @dealid = (Select DealID from CRE.DEAL where credealid = @CreDealID)

--============================================================================
Declare @noteid UNIQUEIDENTIFIER 
Declare @accountid UNIQUEIDENTIFIER

IF CURSOR_STATUS('global','CursorDeleteNote')>=-1
BEGIN
	DEALLOCATE CursorDeleteNote
END

DECLARE CursorDeleteNote CURSOR 
for
(
	Select noteid,account_accountid from CRE.note where dealid IN (Select DealID from CRE.DEAL where credealid = @CreDealID)
)


OPEN CursorDeleteNote 

FETCH NEXT FROM CursorDeleteNote
INTO @noteid,@accountid

WHILE @@FETCH_STATUS = 0
BEGIN

-----------------------------------------

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
Delete from  [CRE].[ServicerDropDateSetup] where NoteID = @noteid
Delete from CORE.Exceptions where ObjectID = @noteid



Delete from Core.CalculationRequests  where AccountId = @accountid

Delete from CRE.FundingRepaymentSequence where NoteID = @noteid


Delete from CRE.NoteTransactionDetail where NoteID = @noteid

Delete from CRE.NotePeriodicCalc where   AccountID = @accountid
Delete from CRE.OutputNPVdata where   NoteID = @noteid

Delete from CRE.TransactionEntry where Accountid =@accountid -- NoteID=@noteid


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

-----------------------------------------



					 
FETCH NEXT FROM CursorDeleteNote
INTO @noteid,@accountid
END
CLOSE CursorDeleteNote   
DEALLOCATE CursorDeleteNote


-----Delete deal---
Delete from [CRE].[Property] where [Deal_DealID] IN (Select DealID from CRE.DEAL where credealid = @CreDealID)
Delete from [CRE].DealFunding where dealid IN (Select DealID from CRE.DEAL where credealid = @CreDealID)
Delete from [CRE].[PayruleSetup] where dealid IN (Select DealID from CRE.DEAL where credealid = @CreDealID)
Delete from [CRE].[Deal] where dealid IN (Select DealID from CRE.DEAL where credealid = @CreDealID)


Delete from [App].[SearchItem] where Object_ObjectAutoID in (Select ObjectAutoID from [App].[Object] where ObjectID not in (Select Propertyid from CRE.[Property]) AND  ObjectTypeID = @LookupIdForProperty)
Delete from [App].[Object] where ObjectID not in (Select Propertyid from CRE.[Property]) AND  ObjectTypeID = @LookupIdForProperty

Delete from [App].[SearchItem] where Object_ObjectAutoID in (Select ObjectAutoID from [App].[Object] where ObjectID not in (Select NoteID from CRE.note) AND  ObjectTypeID = @LookupIdForNote)
Delete from [App].[Object] where ObjectID not in (Select NoteID from CRE.note) AND  ObjectTypeID = @LookupIdForNote

Delete from [App].[SearchItem] where Object_ObjectAutoID in (Select ObjectAutoID from [App].[Object] where ObjectID not in (Select DealID from CRE.Deal) AND  ObjectTypeID = @LookupIdForDeal)
Delete from [App].[Object] where ObjectID not in (Select DealID from CRE.Deal) AND  ObjectTypeID = @LookupIdForDeal


END
