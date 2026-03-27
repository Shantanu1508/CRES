-- Procedure
-- Procedure
---[dbo].[usp_DeleteDealFromDataBaseByCreDealID] '22-3282'

CREATE PROCEDURE [dbo].[usp_DeleteDealFromDataBaseByCreDealID] 
(
	@CreDealID nvarchar(256)
)  
AS
BEGIN
SET NOCOUNT ON;  

IF((SELECT DB_NAME()) = 'CRES4_Acore')
BEGIN
	Print('Not allowed to delete in production')
	return;
END

IF(@CreDealID <> '')
BEGIN
	
	Declare @dealid UNIQUEIDENTIFIER;
	Declare @dealAccountid UNIQUEIDENTIFIER;

	  
	Select @dealid = DealID ,@dealAccountid = AccountID
	from CRE.DEAL where credealid = @CreDealID
	

	IF EXISTS(Select DealID from CRE.DEAL where credealid = @CreDealID)
	BEGIN
		----Delete Note----
		--collect notes ids of deal
		Declare @tblNoteIds as table(noteid UNIQUEIDENTIFIER,accountid UNIQUEIDENTIFIER)
		INSERT INTO @tblNoteIds
		Select n.noteid ,acc.accountid
		from cre.note n
		Inner Join core.account acc on acc.accountid = n.account_accountid
		inner join cre.deal d on d.dealid =  n.dealid
		where d.dealid = @dealid

		--collect eventid for that deal
		IF OBJECT_ID('tempdb..#tbleventId') IS NOT NULL       
		DROP TABLE #tbleventId
		CREATE TABLE #tbleventId
		(
			eventid uniqueidentifier,
			eventTypeid int
		)  
		INSERT INTO #tbleventId(eventid,eventTypeid) 
		Select EventID,eventTypeid 
		from core.Event e
		inner join core.Account acc on e.AccountID = acc.AccountID
		Inner join cre.Note n on acc.AccountID = n.Account_AccountID
		inner join cre.deal d on d.dealid =  n.dealid
		where d.dealid = @dealid
	

		Delete from [CRE].[DependentCalcRequest] where  ParentNoteID in (Select noteid from @tblNoteIds)
		Delete from CRE.PayruleDistributions where SourceNoteID in (Select noteid from @tblNoteIds)
		Delete from Core.CalculationRequests  where AccountId in (Select accountid from @tblNoteIds)
		Delete from CRE.FundingRepaymentSequence where NoteID in (Select noteid from @tblNoteIds)
		Delete from CRE.NoteTransactionDetail where NoteID in (Select noteid from @tblNoteIds)
		Delete from CRE.NotePeriodicCalc where   AccountID in (Select accountid from @tblNoteIds)
		Delete from CRE.OutputNPVdata where   NoteID in (Select noteid from @tblNoteIds)		
		--Delete from CRE.TransactionEntry where NoteID in (Select NoteID from @tblNoteIds)
		Delete from CRE.TransactionEntry where accountid in (Select accountid from @tblNoteIds)		
		Delete from CRE.PeriodicInterestRateUsed where NoteID in (Select noteid from @tblNoteIds)
		Delete from CRE.DailyInterestAccruals where NoteID in (Select noteid from @tblNoteIds)
		Delete from CRE.InterestCalculator where NoteID in (Select noteid from @tblNoteIds)

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

		Delete from Core.Event where eventid in (Select eventid  from #tbleventId)
	
		Delete from core.Exceptions where ObjectID in (Select noteid from @tblNoteIds)
		Delete from core.Exceptions where ObjectID  = @dealid

		Delete from cre.ServicerDropDateSetup where NoteID in (Select noteid from @tblNoteIds)
	
	
	

		Delete from CORE.[transaction] where RegisterID in (Select RegisterID from core.Register where AccountID in (Select Account_AccountID from cre.Note where NoteID in (Select noteid from @tblNoteIds)))
		Delete from core.Register where AccountID in (Select Account_AccountID from cre.Note where NoteID in (Select noteid from @tblNoteIds))
	
		Delete from CRE.Note  where NoteID in (Select noteid from @tblNoteIds)
		Delete from Core.Account where AccountID in (Select Account_AccountID from cre.Note where NoteID in (Select noteid from @tblNoteIds))
	
		-------


		-----Delete deal---
		Delete from [CRE].[Property] where [Deal_DealID]=@dealid
		Delete from [CRE].DealFunding where dealid = @dealid
		Delete from [CRE].[PayruleSetup] where dealid = @dealid
		Delete from cre.AutoSpreadRule where dealid = @dealid
		Delete from cre.DealAmortizationSchedule where dealid = @dealid
		Delete from cre.DealProjectedPayOffAccounting where dealid = @dealid

		Delete from [CRE].WLDealLegalStatus where dealid = @dealid
		

		Delete from [CRE].[Deal] where dealid = @dealid

		Delete from Core.Account where AccountID = @dealAccountid

		---Clear record form search item---
		Declare @LookupIdForNote int = (Select lookupid from core.Lookup where name = 'Note');
		Declare @LookupIdForDeal int= (Select lookupid from core.Lookup where name = 'Deal');
		Declare @LookupIdForProperty int= (Select lookupid from core.Lookup where name = 'Property');

		Delete from [App].[SearchItem] where Object_ObjectAutoID in (Select ObjectAutoID from [App].[Object] where ObjectID not in (Select Propertyid from CRE.[Property]) AND  ObjectTypeID = @LookupIdForProperty)
		Delete from [App].[Object] where ObjectID not in (Select Propertyid from CRE.[Property]) AND  ObjectTypeID = @LookupIdForProperty

		Delete from [App].[SearchItem] where Object_ObjectAutoID in (Select ObjectAutoID from [App].[Object] where ObjectID not in (Select NoteID from CRE.note) AND  ObjectTypeID = @LookupIdForNote)
		Delete from [App].[Object] where ObjectID not in (Select NoteID from CRE.note) AND  ObjectTypeID = @LookupIdForNote

		Delete from [App].[SearchItem] where Object_ObjectAutoID in (Select ObjectAutoID from [App].[Object] where ObjectID not in (Select DealID from CRE.Deal) AND  ObjectTypeID = @LookupIdForDeal)
		Delete from [App].[Object] where ObjectID not in (Select DealID from CRE.Deal) AND  ObjectTypeID = @LookupIdForDeal

		Print('Deal deleted successfully')
	END
	ELSE
	BEGIN
		Print('Deal does not exists')
	END
END


END