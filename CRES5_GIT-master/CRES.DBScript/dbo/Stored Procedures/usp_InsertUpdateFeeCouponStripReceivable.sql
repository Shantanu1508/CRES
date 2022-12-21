



CREATE PROCEDURE [dbo].[usp_InsertUpdateFeeCouponStripReceivable] 
	@notefunding [TableTypeFeeCouponStripReceivable] READONLY,
	@CreatedBy nvarchar(256),
	@UpdatedBy nvarchar(256)
AS
BEGIN


--Variable's--------------------
Declare  @FeeCouponStripReceivable  int  =20;
DECLARE @NoteId UNIQUEIDENTIFIER  
DECLARE @AccountId UNIQUEIDENTIFIER

IF CURSOR_STATUS('global','CursorNoteFF')>=-1    
BEGIN    
DEALLOCATE CursorNoteFF    
END    
 
DECLARE CursorNoteFF CURSOR     
FOR    
(    
	Select DISTINCT nf.NoteID,(SELECT TOP 1 Account_AccountID FROM CRE.Note n inner join Core.Account acc on n.Account_AccountID=acc.AccountID WHERE NoteID = nf.NoteId and acc.IsDeleted=0) AccountId from @notefunding nf INNER JOIN CRE.Note N ON N.nOTEid=NF.NoteID where n.ClosingDate is not null
)
OPEN CursorNoteFF     
FETCH NEXT FROM CursorNoteFF    
INTO @NoteId,@AccountId
WHILE @@FETCH_STATUS = 0    
BEGIN 


DECLARE @closingDate date = (Select isnull(ClosingDate,GETDATE()) from CRE.Note n WHERE n.NoteID = @NoteId)
--DECLARE @effectiveDate date = (Select e.EffectiveStartDate from  CORE.Event e  INNER JOIN CORE.Account acc ON acc.AccountID = e.AccountID INNER JOIN CRE.Note n ON n.Account_AccountID = acc.AccountID WHERE e.EventTypeID = @FeeCouponStripReceivable and n.NoteID = @NoteId)
--DECLARE @eventid UNIQUEIDENTIFIER=(Select eventid from CORE.Event where eventtypeid = @FeeCouponStripReceivable and EffectiveStartDate = @effectiveDate and accountid = @AccountId );

--IF EXISTS(Select * from  CORE.Event e  INNER JOIN CORE.Account acc ON acc.AccountID = e.AccountID INNER JOIN CRE.Note n ON n.Account_AccountID = acc.AccountID WHERE e.EventTypeID = @FeeCouponStripReceivable and n.NoteID = @NoteId )
--	BEGIN
--		PRINT('EffectiveDate Exit');
--		--check for closing date as effective date		
--		IF(@effectiveDate = @closingDate)
--		BEGIN
--			Print('Effective date same as closing');	

--		END
--		ELSE
--		BEGIN
--			Print('Effective date not same as closing');						
--			update [Core].[Event] set 
--			[EffectiveStartDate]=@closingDate
--			,[UpdatedBy]=@UpdatedBy
--			,[UpdatedDate]=getdate()
--			where eventtypeid = @FeeCouponStripReceivable and accountid = @AccountId and @eventid=eventid 
--		END
		
		
--	END
--	ELSE
--	BEGIN 
--		PRINT('No fee coupon schedule found - Insert');
			 
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
--			@FeeCouponStripReceivable as [EventTypeID],
--			NUll as [EffectiveEndDate],
--			NUll as [SingleEventValue],
--			@CreatedBy,
--			getdate(),
--			@UpdatedBy,
--			getdate()
						
--			SELECT @eventid = tEventID2 FROM @tEvent2;
			
--	END
	-----Insert into LIBOR table
	--Delete from CORE.[FeeCouponStripReceivable] where eventid  = @eventid
	--INSERT INTO core.[FeeCouponStripReceivable] (EventId, Date, Value, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate)    
	--		SELECT 
	--		@eventid,
	--		t.Date,
	--		t.Value,
	--		@CreatedBy,
	--		GETDATE(),
	--		@UpdatedBy,
	--		GETDATE()
	--		FROM @notefunding t
	--		WHERE t.noteid = @NoteId



	Delete from core.[FeeCouponStripReceivable] where eventid in (Select eventid from core.Event WHERE EventTypeID = @FeeCouponStripReceivable and AccountID in (Select Account_AccountID from CRE.NOte where noteid = @NoteId))
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
	@CreatedBy,
	getdate(),
	@UpdatedBy,
	getdate()
						
	SELECT @eventidNew = tEventIDNew FROM @tEventNew;


	INSERT INTO core.[FeeCouponStripReceivable] (EventId, Date, Value, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate)    
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


			
FETCH NEXT FROM CursorNoteFF    
INTO @NoteId,@AccountId

END

END
