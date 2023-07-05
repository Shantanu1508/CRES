

CREATE PROCEDURE [dbo].[usp_InsertUpdateMaturityScheduleAllEffectiveDate] 
	@tblMaturityDataForNote [TableTypeMaturityDataForNote] READONLY,	
	@UserID nvarchar(256)
AS
BEGIN

---===Find Top 1 note of this group==========
Declare @tblTopNote as table(
NoteID UNIQUEIDENTIFIER,
crenoteid nvarchar(256),
DealID UNIQUEIDENTIFIER,
MaturityMethodID int,
MaturityGroupName nvarchar(256)
)

INSERT INTO @tblTopNote(NoteID,crenoteid,DealID,MaturityMethodID,MaturityGroupName)  
SELECT top 1 n.NoteID,n.CRENoteID,n.DealID,n.MaturityMethodID,n.MaturityGroupName
From @tblMaturityDataForNote t
inner join cre.note n on n.noteid = t.noteid
inner join core.account acc on acc.accountid = n.account_accountid
Order by ISNULL(n.lienposition,99999), n.Priority,n.InitialFundingAmount desc, acc.Name


Declare @DealID UNIQUEIDENTIFIER;
Declare @Top_NoteId_OfThisGroup UNIQUEIDENTIFIER;
Declare @MaturityMethodID int;
Declare @MaturityGroupName nvarchar(256)

SEt @DealID = (Select DealID from @tblTopNote)
SEt @Top_NoteId_OfThisGroup = (Select noteid from @tblTopNote)
SEt @MaturityMethodID = (Select MaturityMethodID from @tblTopNote)
SEt @MaturityGroupName = (Select MaturityGroupName from @tblTopNote)
---============================================


---=====Insert current maturity data to top 1 note========
DECLARE @tblMaturityData_ForTopNote [TableTypeMaturityDataForNote]

INSERT INTO @tblMaturityData_ForTopNote(NoteID,EffectiveDate,MaturityDate,MaturityType,Approved,IsDeleted,ActualPayoffDate,ExpectedMaturityDate,OpenPrepaymentDate)   
Select NoteID,EffectiveDate,MaturityDate,MaturityType,Approved,IsDeleted,ActualPayoffDate,ExpectedMaturityDate,OpenPrepaymentDate			 
From @tblMaturityDataForNote
Where NoteId = @Top_NoteId_OfThisGroup

exec [dbo].[usp_InsertUpdateMaturitySchedule] @tblMaturityData_ForTopNote,@UserID
---============================================


Declare @tblOtherNotesOfgroup as table(NoteID UNIQUEIDENTIFIER,crenoteid nvarchar(256),AccountID UNIQUEIDENTIFIER)

INSERT INTO @tblOtherNotesOfgroup(NoteID,crenoteid,AccountID)  
SELECT n.NoteID,n.CRENoteID,n.Account_AccountID
From cre.note n 
inner join core.account acc on acc.accountid = n.account_accountid
Where n.dealid = @DealID
and n.MaturityMethodID = @MaturityMethodID
and n.MaturityGroupName = @MaturityGroupName
and n.noteid <> @Top_NoteId_OfThisGroup



IF EXISTS(Select NoteID from @tblOtherNotesOfgroup)
BEGIN



	----======Copy top 1 note's maturity data to other notes of this group=============

	Declare @ActualPayoffDate Date,@ExpectedMaturityDate Date,@OpenPrepaymentDate Date

	Select @ActualPayoffDate = ActualPayoffDate,
	@ExpectedMaturityDate = ExpectedMaturityDate,
	@OpenPrepaymentDate = OpenPrepaymentDate 
	from cre.note where noteid = @Top_NoteId_OfThisGroup


	Update cre.Note SET ActualPayoffDate = @ActualPayoffDate,
	ExpectedMaturityDate = @ExpectedMaturityDate,
	OpenPrepaymentDate = @OpenPrepaymentDate
	where noteid in (Select noteid from @tblOtherNotesOfgroup)
	---============================================



	---======Delete maturity data of other notes===========
	IF OBJECT_ID('tempdb..#tbleventId') IS NOT NULL         
	DROP TABLE #tbleventId  
	CREATE TABLE #tbleventId  
	(  
	 eventid uniqueidentifier
	)    
	INSERT INTO #tbleventId(eventid)   
	Select EventID 
	from core.Event e  
	inner join core.Account acc on e.AccountID = acc.AccountID  
	Inner join cre.Note n on acc.AccountID = n.Account_AccountID  
	where e.eventtypeid = 11
	and n.NoteID in (Select noteid from @tblOtherNotesOfgroup)

	IF EXISTS(Select eventid from #tbleventId)
	BEGIN
		Delete From  CORE.Maturity  where eventid in (Select eventid  from #tbleventId)  
		Delete From  CORE.[Event]  where eventid in (Select eventid  from #tbleventId)  
	END
	---============================================

	----===Copy maturity data of top one note to other============

	INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)  
	Select EffectiveStartDate, t.AccountID, Date, EventTypeID, StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate
	From(
		SELECT DISTINCT  
		EffectiveStartDate,  
		null as AccountID,  
		GETDATE() as Date,  
		11 as EventTypeID,  
		e.StatusID,  
		e.CreatedBy,  
		e.CreatedDate,  
		e.UpdatedBy,  
		e.UpdatedDate  
		FROM Core.Event  e  
		inner join core.Account acc on e.AccountID = acc.AccountID  
		Inner join cre.Note n on acc.AccountID = n.Account_AccountID  
		where e.eventtypeid = 11 and e.StatusID = 1 
		and n.NoteID = @Top_NoteId_OfThisGroup
	)a,@tblOtherNotesOfgroup t
  
  
 
	INSERT INTO core.Maturity (EventId, MaturityDate,MaturityType,Approved,CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)  
	Select 
	(SELECT TOP 1  
	EventId  
	FROM CORE.[event] se 
	WHERE se.[EffectiveStartDate] = CONVERT(date, a.EffectiveStartDate, 101)  
	AND se.[EventTypeID] = 11
	AND se.AccountID = t.AccountID) EventID,
	MaturityDate,
	MaturityType,
	Approved,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate
	From(

		SELECT   
		null as EventID,
		e.effectivestartdate,
		CONVERT(date, mt.MaturityDate, 101) as MaturityDate,   
		mt.MaturityType,  
		mt.Approved,         
		e.CreatedBy,  
		e.CreatedDate,  
		e.UpdatedBy,  
		e.UpdatedDate   
		FROM Core.Maturity mt  
		inner join core.Event e on e.eventid =  mt.EventId  
		inner join core.Account acc on acc.AccountID =  e.AccountID  
		inner join cre.note n on n.Account_AccountID = acc.AccountID
		WHERE e.statusID = 1 and e.eventtypeid = 11
		and n.noteid = @Top_NoteId_OfThisGroup

	)a,@tblOtherNotesOfgroup t
  

	--Update first effective date as Closing
	Update [CORE].[Event] set [CORE].[Event].EffectiveStartDate = a.ClosingDate
	From(
		Select Distinct e.EventID,e.EffectiveStartDate,nt.ClosingDate
		from [CORE].Maturity mat      
		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
		INNER JOIN     
		(       
			Select       
			(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,         
			MIN(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve      
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID      
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID      
			where EventTypeID = 11
			and acc.IsDeleted = 0	
			and eve.StatusID = 1 
			and n.NoteID in (Select noteid from @tblOtherNotesOfgroup)
			GROUP BY n.Account_AccountID,EventTypeID     
		) sEvent      
		ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID     and e.StatusID = 1 
		INNER JOIN [CRE].[Note] nt on nt.Account_AccountID = sEvent.AccountID      
		Where nt.NoteID in (Select noteid from @tblOtherNotesOfgroup)
		and e.EffectiveStartDate <> nt.ClosingDate
	)a
	where [CORE].[Event].EventID = a.EventID

END




END
