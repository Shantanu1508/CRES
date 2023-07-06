



CREATE PROCEDURE [dbo].[usp_InsertUpdatePIKScheduleDetail] 
	@notefunding [TableTypePIKScheduleDetail] READONLY,
	@CreatedBy nvarchar(256),
	@UpdatedBy nvarchar(256)
AS
BEGIN


DECLARE @ret_Msg Nvarchar(max);

--Variable's--------------------
Declare  @PIKScheduleDetail  int  =17;

 
DECLARE @NoteId UNIQUEIDENTIFIER  
DECLARE @AccountId UNIQUEIDENTIFIER


DECLARE @Active int = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
DECLARE @Inactive int = (Select LookupID from Core.Lookup where name = 'Inactive' and ParentID = 1)




 
IF CURSOR_STATUS('global','CursorNoteFF')>=-1    
BEGIN    
DEALLOCATE CursorNoteFF    
END    
 
DECLARE CursorNoteFF CURSOR     
FOR    
(    
	Select DISTINCT NoteId,(SELECT TOP 1 Account_AccountID FROM CRE.Note WHERE NoteID = nf.NoteId) AccountId from @notefunding nf 
)
OPEN CursorNoteFF     
FETCH NEXT FROM CursorNoteFF    
INTO @NoteId,@AccountId
WHILE @@FETCH_STATUS = 0    
BEGIN 

delete from core.PIKScheduleDetail where eventId in (Select eventID from core.event where EventTypeID = @PIKScheduleDetail and EffectiveStartDate is null and accountid = @AccountId)
delete from core.event where EventTypeID = @PIKScheduleDetail and  EffectiveStartDate is null and accountid = @AccountId Delete from core.event where eventid in (
Select eventid from (
	Select e.eventid,e.accountid,(Select count(*) from core.PIKScheduleDetail ff where ff.eventid = e.eventid) cnt
	from core.event e where eventtypeid = @PIKScheduleDetail and statusid = 1 and e.accountid = @AccountId
)a
where a.cnt = 0 )



DECLARE @ClosingDate Date
SET @ClosingDate = (Select isnull(ClosingDate,getdate()) from cre.Note where NoteID = @NoteId)


Declare @Diffcount int;

Select @Diffcount = COUNT(*)
from 
(
	Select ff.*
		from [CORE].[PIKScheduleDetail] ff
		where EventID in 
		(
			Select e.EventID from [CORE].[Event] e
			INNER JOIN 
			( 
				Select 
				(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
				MAX(EffectiveStartDate) EffectiveStartDate,eve.StatusID from [CORE].[Event] eve
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
				where EventTypeID = @PIKScheduleDetail
				and n.NoteID = @NoteId
				and eve.StatusID = @Active
				GROUP BY n.Account_AccountID,eve.StatusID
			) sEvent
			ON sEvent.AccountID = e.AccountID 
			and e.EffectiveStartDate = sEvent.EffectiveStartDate 
			and EventTypeID = @PIKScheduleDetail
			and e.StatusID = sEvent.StatusID
		)
)as FF

FULL JOIN (Select * from @notefunding where NoteId = @NoteId and [Date]  is not null ) FFforInput
ON (FF.Date = FFforInput.Date and ff.Value = FFforInput.Value )
--and isnull(ff.PurposeID,'') = isnull(FFforInput.PurposeID ,'')and isnull(ff.Applied,'') = isnull(FFforInpuISNULL(t.Applied,0),''))
WHERE FF.Date IS NULL OR FF.Value IS NULL OR FFforInput.Date IS NULL OR FFforInput.Value IS NULL
--OR isnull(FF.PurposeID,'') IS NULL OR isnull(FFforInput.PurposeID,'') IS NULL OR isnull(FF.Applied,'') IS NULL OR isnull(FFforInpuISNULL(t.Applied,0),'') IS NULL

-------------------------get min date ------------------------

Declare @ChangeDate Date; 
Select @ChangeDate = MIN(FFforInput.[Date])
from 
(
	Select ff.*
		from [CORE].[PIKScheduleDetail] ff
		where EventID in 
		(
			Select e.EventID from [CORE].[Event] e
			INNER JOIN 
			( 
				Select 
				(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
				MAX(EffectiveStartDate) EffectiveStartDate,eve.StatusID from [CORE].[Event] eve
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
				where EventTypeID = @PIKScheduleDetail
				and n.NoteID = @NoteId
				and eve.StatusID = @Active
				GROUP BY n.Account_AccountID,eve.StatusID
			) sEvent
			ON sEvent.AccountID = e.AccountID 
			and e.EffectiveStartDate = sEvent.EffectiveStartDate 
			and EventTypeID = @PIKScheduleDetail
			and e.StatusID = sEvent.StatusID
		)
)as FF

FULL JOIN (Select * from @notefunding where NoteId = @NoteId and [Date]  is not null ) FFforInput
ON (FF.Date = FFforInput.Date and ff.Value = FFforInput.Value)
--and ff.PurposeID = FFforInput.PurposeID and ff.Applied = FFforInpuISNULL(t.Applied,0))
WHERE FF.Date IS NULL --OR FF.Value IS NULL OR FFforInput.Date IS NULL OR FFforInput.Value IS NULL



if @ChangeDate > getdate() 
Begin
	
	set @ChangeDate = eomonth(GETDATE(),-1);	
End

if @ChangeDate< @ClosingDate and @ClosingDate is not null
Begin
	set @ChangeDate=@ClosingDate;
End 

----------------------------------------------------------------

IF(@Diffcount > 0)
BEGIN
	PRINT('Difference in FF detail');

	
	DECLARE @PreviousmonthEOD date = (select DATEADD(MONTH, DATEDIFF(MONTH, -1, @ChangeDate)-1, -1));
	--DECLARE @PreviousmonthEOD date = @ChangeDate;


	


	--Logic changed on 2/28/2018	
	DECLARE @ChangeDateEOD date = (select DATEADD(MONTH, DATEDIFF(MONTH, -1, @ChangeDate) - 1, -1));	--Previous month EOD
	--DECLARE @ChangeDateEOD date = (select DATEADD(MONTH, DATEDIFF(MONTH, -1, @ChangeDate) - 0, -1));	--Same month EOD
	--DECLARE @ChangeDateEOD date = @ChangeDate;

	IF(@ChangeDate >= (select DATEADD(MONTH, DATEDIFF(MONTH, -1, getdate())-1, -1)))
	BEGIN
		SET @PreviousmonthEOD  = (select DATEADD(MONTH, DATEDIFF(MONTH, -1, getdate())-1, -1));
		SET @ChangeDateEOD = @PreviousmonthEOD
	END


	IF EXISTS(Select * from  CORE.Event e  INNER JOIN CORE.Account acc ON acc.AccountID = e.AccountID INNER JOIN CRE.Note n ON n.Account_AccountID = acc.AccountID WHERE e.EventTypeID = @PIKScheduleDetail and n.NoteID = @NoteId and e.StatusID=@Active)
	BEGIN
		PRINT('EffectiveDate Exit');

		--Main logic start
		DECLARE @maxEffectiveDate date = (Select MAX(e.EffectiveStartDate) from  CORE.Event e  
											INNER JOIN CORE.Account acc ON acc.AccountID = e.AccountID 
											INNER JOIN CRE.Note n ON n.Account_AccountID = acc.AccountID 
											WHERE e.EventTypeID = @PIKScheduleDetail and n.NoteID = @NoteId
											and e.StatusID = @Active)
		
		--IF @ChangeDate < closing
		IF(@ChangeDate <= @ClosingDate)
		BEGIN
			SET @ChangeDateEOD = @ClosingDate
		END

		IF(@ChangeDateEOD < @ClosingDate)
		BEGIN
			SET @ChangeDateEOD = @ClosingDate
		END


		IF(@ChangeDateEOD <= @maxEffectiveDate)
		BEGIN

			Update [Core].[Event] set StatusID = @Inactive Where eventtypeid = @PIKScheduleDetail and EffectiveStartDate > @ChangeDateEOD and accountid = @AccountId 

			Print('Change Date <= Max EffectiveDate');
			

			IF EXISTS(Select * from CORE.Event where eventtypeid = @PIKScheduleDetail and EffectiveStartDate = @ChangeDateEOD and accountid = @AccountId and StatusID = @Active)
			BEGIN
			
				Print('Effective ChangeDate exist');

				DECLARE @eventid UNIQUEIDENTIFIER = (Select eventid from CORE.Event where eventtypeid = @PIKScheduleDetail and EffectiveStartDate = @ChangeDateEOD and accountid = @AccountId and StatusID = @Active);

				--Update [Core].[Event] set StatusID = @Active Where eventid = @eventid

				Delete from CORE.PIKScheduleDetail where eventid  = @eventid
			 
				INSERT INTO core.PIKScheduleDetail (EventId, Date, Value, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate)
				SELECT 
				@eventid,
				t.Date,
				t.Value,				
				@CreatedBy,
				GETDATE(),
				@UpdatedBy,
				GETDATE()
				FROM @notefunding t
				WHERE t.noteid = @NoteId and t.Value is not null and t.Value !=0
			END
			ELSE
			BEGIN
				Print('Effective ChangeDate not exist');

				DECLARE @tEvent TABLE (tEventID UNIQUEIDENTIFIER)
				Declare @EveID uniqueidentifier;
				Delete from @tEvent

				INSERT INTO [Core].[Event](
				[EffectiveStartDate],
				[AccountID],
				[Date],
				[EventTypeID],
				[EffectiveEndDate],
				[SingleEventValue],
				[StatusID],
				[CreatedBy],
				[CreatedDate],
				[UpdatedBy],
				[UpdatedDate])
				OUTPUT inserted.EventID INTO @tEvent(tEventID)
				Select 
				@ChangeDateEOD as [EffectiveStartDate],
				@AccountId,
				GETDATE() as [Date],
				@PIKScheduleDetail as [EventTypeID],
				NUll as [EffectiveEndDate],
				NUll as [SingleEventValue],
				@Active,
				@CreatedBy,
				getdate(),
				@UpdatedBy,
				getdate()

				SELECT @EveID = tEventID FROM @tEvent;

				INSERT INTO core.PIKScheduleDetail (EventId, Date, Value, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate)
    
				SELECT 
				@EveID,
				t.Date,
				t.Value,
				@CreatedBy,
				GETDATE(),
				@UpdatedBy,
				GETDATE()
				FROM @notefunding t
				WHERE t.noteid = @NoteId and t.Value is not null and t.Value!=0
			END


		END
		ELSE
		BEGIN
			Print('Change Date > Max EffectiveDate');

			IF(@maxEffectiveDate = @PreviousmonthEOD )--or @PreviousmonthEOD is null
			BEGIN
				Print('Scedule for same month');
			
				DECLARE @eventid1 UNIQUEIDENTIFIER = (Select eventid from CORE.Event where eventtypeid = @PIKScheduleDetail and EffectiveStartDate = @maxEffectiveDate and accountid = @AccountId and StatusId = @Active);

				--Update [Core].[Event] set StatusID = @Active Where eventid = @eventid1

				Delete from CORE.PIKScheduleDetail where eventid  = @eventid1
			 
				INSERT INTO core.PIKScheduleDetail (EventId, Date, Value, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate)
				SELECT 
				@eventid1,
				t.Date,
				t.Value,
				@CreatedBy,
				GETDATE(),
				@UpdatedBy,
				GETDATE()
				FROM @notefunding t
				WHERE t.noteid = @NoteId and t.Value is not null and t.Value!=0

			END
			ELSE
			BEGIN
				Print('Scedule for diff month');

				DECLARE @tEvent1 TABLE (tEventID1 UNIQUEIDENTIFIER)
				Declare @EveID1 uniqueidentifier;
				Delete from @tEvent1

				INSERT INTO [Core].[Event](
				[EffectiveStartDate],
				[AccountID],
				[Date],
				[EventTypeID],
				[EffectiveEndDate],
				[SingleEventValue],
				[StatusID],
				[CreatedBy],
				[CreatedDate],
				[UpdatedBy],
				[UpdatedDate])
				OUTPUT inserted.EventID INTO @tEvent1(tEventID1)
				Select 				
				@PreviousmonthEOD as [EffectiveStartDate],
				@AccountId,
				GETDATE() as [Date],
				@PIKScheduleDetail as [EventTypeID],
				NUll as [EffectiveEndDate],
				NUll as [SingleEventValue],
				@Active,
				@CreatedBy,
				getdate(),
				@UpdatedBy,
				getdate()

				

				SELECT @EveID1 = tEventID1 FROM @tEvent1;

				INSERT INTO core.PIKScheduleDetail (EventId, Date, Value,CreatedBy, CreatedDate, UpdatedBy, UpdatedDate)
    
				SELECT 
				@EveID1,
				t.Date,
				t.Value,
				@CreatedBy,
				GETDATE(),
				@UpdatedBy,
				GETDATE()
				FROM @notefunding t
				WHERE t.noteid = @NoteId and t.Value is not null and t.Value!=0

			END
		END

		 
	END
	ELSE
	BEGIN 
		PRINT('No funding schedule found - Insert');
			 
			DECLARE @tEvent2 TABLE (tEventID2 UNIQUEIDENTIFIER)
			Declare @EveID2 uniqueidentifier;
			Delete from @tEvent2

			INSERT INTO [Core].[Event](
			[EffectiveStartDate],
			[AccountID],
			[Date],
			[EventTypeID],
			[EffectiveEndDate],
			[SingleEventValue],
			[StatusID],
			[CreatedBy],
			[CreatedDate],
			[UpdatedBy],
			[UpdatedDate])

			OUTPUT inserted.EventID INTO @tEvent2(tEventID2)

			Select 
			case when (select count(*) from  [Core].[Event] where AccountID=@AccountId and EventTypeID=@PIKScheduleDetail)=0 then
				(select distinct isnull(ClosingDate,@PreviousmonthEOD) from cre.Note where Account_AccountID=@AccountId)
				else
			@PreviousmonthEOD  end as [EffectiveStartDate],
			@AccountId,
			GETDATE() as [Date],
			@PIKScheduleDetail as [EventTypeID],
			NUll as [EffectiveEndDate],
			NUll as [SingleEventValue],
			@Active,
			@CreatedBy,
			getdate(),
			@UpdatedBy,
			getdate()
			
			SELECT @EveID2 = tEventID2 FROM @tEvent2;

			INSERT INTO core.PIKScheduleDetail (EventId, Date, Value, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate)
    
			SELECT 
			@EveID2,
			t.Date,
			t.Value,
			@CreatedBy,
			GETDATE(),
			@UpdatedBy,
			GETDATE()
			FROM @notefunding t
			WHERE t.noteid = @NoteId and t.Value is not null and t.Value!=0
	END
 

END
ELSE
BEGIN
Print('No Chnages');
	

END




FETCH NEXT FROM CursorNoteFF    
INTO @NoteId,@AccountId
END  





END

