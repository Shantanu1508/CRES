



CREATE PROCEDURE [dbo].[usp_InsertUpdateLIBORSchedule] 
	@notefunding [TableTypeLIBORSchedule] READONLY,
	@CreatedBy nvarchar(256),
	@UpdatedBy nvarchar(256)
AS
BEGIN


IF((Select Count(NoteId) from @notefunding) = 0) return

Declare  @LIBORSchedule  int  =18;
 
DECLARE @NoteId UNIQUEIDENTIFIER  
DECLARE @AccountId UNIQUEIDENTIFIER

SET @NoteId = (Select top 1 NoteId from @notefunding)
SET @AccountId = (Select top 1 Accountid from @notefunding)



DECLARE @closingDate date = (Select isnull(ClosingDate,GETDATE()) from CRE.Note n WHERE n.NoteID = @NoteId)

Delete from core.LIBORSchedule where eventid in (Select eventid from core.Event WHERE EventTypeID = @LIBORSchedule and AccountID in (Select Account_AccountID from CRE.NOte where noteid = @NoteId))
Delete from core.Event WHERE EventTypeID = @LIBORSchedule and AccountID in (Select Account_AccountID from CRE.NOte where noteid = @NoteId)

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
@LIBORSchedule as [EventTypeID],
NUll as [EffectiveEndDate],
NUll as [SingleEventValue],
@CreatedBy,
getdate(),
@UpdatedBy,
getdate()
						
SELECT @eventidNew = tEventIDNew FROM @tEventNew;


INSERT INTO core.LIBORSchedule (EventId, Date, Value, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate)    
SELECT 
@eventidNew,
t.Date,
t.Value,
@CreatedBy,
GETDATE(),
@UpdatedBy,
GETDATE()
FROM @notefunding t
WHERE t.noteid = @NoteId


--IF CURSOR_STATUS('global','CursorNoteFF')>=-1    
--BEGIN    
--DEALLOCATE CursorNoteFF    
--END    
 
--DECLARE CursorNoteFF CURSOR     
--FOR    
--(    
--	--Select DISTINCT NoteId,(SELECT TOP 1 Account_AccountID FROM CRE.Note WHERE NoteID = nf.NoteId) AccountId from @notefunding nf
--	Select DISTINCT nf.NoteId NoteId,Account_AccountID AccountId from @notefunding nf INNER JOIN CRE.Note N ON N.nOTEid=NF.NoteID inner join Core.Account ac on ac.AccountID=n.Account_AccountID where n.ClosingDate is not null and ac.IsDeleted=0
	 
--)
--OPEN CursorNoteFF     
--FETCH NEXT FROM CursorNoteFF    
--INTO @NoteId,@AccountId
--WHILE @@FETCH_STATUS = 0    
--BEGIN 
--	DECLARE @effectiveDate date = (Select e.EffectiveStartDate from  CORE.Event e  INNER JOIN CORE.Account acc ON acc.AccountID = e.AccountID INNER JOIN CRE.Note n ON n.Account_AccountID = acc.AccountID WHERE e.EventTypeID = @LIBORSchedule and n.NoteID = @NoteId and acc.isdeleted=0)
--	DECLARE @closingDate date = (Select isnull(ClosingDate,GETDATE()) from CRE.Note n WHERE n.NoteID = @NoteId)
--	DECLARE @eventid UNIQUEIDENTIFIER=(Select eventid from CORE.Event where eventtypeid = @LIBORSchedule and EffectiveStartDate = @effectiveDate and accountid = @AccountId);
	
--	IF EXISTS(Select * from  CORE.Event e  INNER JOIN CORE.Account acc ON acc.AccountID = e.AccountID INNER JOIN CRE.Note n ON n.Account_AccountID = acc.AccountID WHERE e.EventTypeID = @LIBORSchedule and n.NoteID = @NoteId and acc.IsDeleted=0)
--	BEGIN
--		PRINT('EffectiveDate Exit');
--		--check for closing date as effective date		
--		IF(@effectiveDate = @closingDate)
--		BEGIN
--			Print('Effective date same as closing');	
--			--Delete from CORE.LIBORSchedule where eventid  = @eventid			 
--			--INSERT INTO core.LIBORSchedule (EventId, Date, Value, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate)
--			--SELECT 
--			--@eventid,
--			--t.Date,
--			--t.Value,
--			--@CreatedBy,
--			--GETDATE(),
--			--@UpdatedBy,
--			--GETDATE()
--			--FROM @notefunding t
--			--WHERE t.noteid = @NoteId

--		END
--		ELSE
--		BEGIN
--			Print('Effective date not same as closing');						
--			update [Core].[Event] set 
--			[EffectiveStartDate]=@closingDate
--			,[UpdatedBy]=@UpdatedBy
--			,[UpdatedDate]=getdate()
--			where eventtypeid = @LIBORSchedule and accountid = @AccountId and @eventid=eventid
--		END
		
		
--	END
--	ELSE
--	BEGIN 
--		PRINT('No libor schedule found - Insert');
			 
--			DECLARE @tEvent2 TABLE (tEventID2 UNIQUEIDENTIFIER)
--			--Declare @EveID2 uniqueidentifier;
--			Delete from @tEvent2

--			INSERT INTO [Core].[Event](
--			[EffectiveStartDate],
--			[AccountID],
--			[Date],
--			[EventTypeID],
--			[EffectiveEndDate],
--			[SingleEventValue],
--			[CreatedBy],
--			[CreatedDate],
--			[UpdatedBy],
--			[UpdatedDate])

--			OUTPUT inserted.EventID INTO @tEvent2(tEventID2)

--			Select 
--			@closingDate as [EffectiveStartDate],
--			@AccountId,
--			GETDATE() as [Date],
--			@LIBORSchedule as [EventTypeID],
--			NUll as [EffectiveEndDate],
--			NUll as [SingleEventValue],
--			@CreatedBy,
--			getdate(),
--			@UpdatedBy,
--			getdate()
						
--			SELECT @eventid = tEventID2 FROM @tEvent2;
			
--	END

--	---Insert into LIBOR table
--	Delete from CORE.LIBORSchedule where eventid  = @eventid
--	INSERT INTO core.LIBORSchedule (EventId, Date, Value, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate)    
--			SELECT 
--			@eventid,
--			t.Date,
--			t.Value,
--			@CreatedBy,
--			GETDATE(),
--			@UpdatedBy,
--			GETDATE()
--			FROM @notefunding t
--			WHERE t.noteid = @NoteId			
--FETCH NEXT FROM CursorNoteFF    
--INTO @NoteId,@AccountId
--END




END  





