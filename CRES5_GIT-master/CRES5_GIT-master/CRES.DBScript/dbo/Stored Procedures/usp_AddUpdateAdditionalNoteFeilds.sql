
CREATE PROCEDURE [dbo].[usp_AddUpdateAdditionalNoteFeilds]
(
	@NoteId uniqueidentifier,
	@Maturity_EffectiveDate Date,
	@Maturity_MaturityDate Date,
	@RateSpreadSch_EffectiveDate Date,
	@RateSpreadSch_Date Date,
	@RateSpreadSch_ValueTypeID int,
	@RateSpreadSch_Value decimal(28,12),
	@RateSpreadSch_IntCalcMethodID Int,
	@PrepayAddFeeSch_EffectiveDate Date,
	@PrepayAddFeeSch_StartDate Date,
	@PrepayAddFeeSch_ValueTypeID Int,
	@PrepayAddFeeSch_Value decimal(28,12),
	@PrepayAddFeeSch_IncludedLevelYield decimal(28,12),
	@PrepayAddFeeSch_IncludedBasis decimal(28,12),
	
	@stripping_EffectiveDate Date,
	@stripping_StartDate Date,
	@stripping_ValueTypeID Int,
	@stripping_Value decimal(28,12),
	@stripping_IncludedLevelYield decimal(28,12),
	@stripping_IncludedBasis decimal(28,12),
	@FinancingFeeSch_EffectiveDate Date,
	@FinancingFeeSch_Date Date,
	@FinancingFeeSch_ValueTypeID int,
	@FinancingFeeSch_Value decimal(28,12),
	@FinancingSch_EffectiveDate Date,
	@FinancingSch_Date Date,
	@FinancingSch_ValueTypeID int,
	@FinancingSch_Value decimal(28,12),
	@FinancingSch_IndexTypeID int,
	@FinancingSch_IntCalcMethodID int,
	@FinancingSch_CurrencyCode int,
	@DefaultSch_EffectiveDate Date,
	@DefaultSch_StartDate Date,
	@DefaultSch_EndDate Date,
	@DefaultSch_ValueTypeID int,
	@DefaultSch_Value decimal(28,12),
	@ServicingFeeSch_EffectiveDate Date,
	@ServicingFeeSch_Date Date,
	@ServicingFeeSch_Value decimal(28,12),
	@ServicingFeeSch_IsCapitalized INT,
	
    @PIK_EffectiveDate  Date,
    @SourceAccountID  varchar(256),
    @TargetAccountID varchar(256),
    @AdditionalIntRate int,
    @AdditionalSpread int,
    @IndexFloor int,
    @IntCompoundingRate int,
    @IntCompoundingSpread int,
    @StartDate Date,
    @EndDate Date,
    @IntCapAmt int,
    @PurBal  int,
    @AccCapBal  int,
	@CreatedBy nvarchar(256) ,
	@CreatedDate datetime ,
	@UpdatedBy nvarchar(256) ,
	@UpdatedDate datetime 
)
as 
BEGIN

	Declare @accountID varchar(256)
	Declare @evntlookupid int
	Declare @tmpeventid uniqueidentifier;
	Declare @count int
	Declare @insertedid uniqueidentifier;


	Create table #tmpEvent (evtTypeid int,effStartDate date,LookupName Varchar(100))
	DECLARE @tInserted TABLE (tinsertedVal UNIQUEIDENTIFIER)

	SELECT @accountID=Account_AccountID from CRE.Note n inner join core.Account acc on acc.AccountID = n.Account_AccountID  where NoteID=@NoteId and acc.IsDeleted = 0

	INSERT INTO #tmpEvent (evtTypeid, effStartDate,LookupName) 
	SELECT 	
	EventTypeID,
	max(EffectiveStartDate),
	lk.Name
	from Core.Event eve
	INNER JOIN [CORE].[Lookup] lk ON lk.LookupID = eve.EventTypeID
	where AccountID=@accountID 
	group by EventTypeID,lk.Name

	SELECT * from #tmpEvent
	------------------ Maturity------------------------------

	SELECt @evntlookupid=LookupID from Core.Lookup where Name = 'Maturity'

	Select @count=count(evtTypeid) from #tmpEvent where evtTypeid=@evntlookupid and effStartDate=@Maturity_EffectiveDate

	if(@count=0)
	BEGIN
			INSERT into Core.Event (AccountID,	Date	,EventTypeID,	EffectiveStartDate,SingleEventValue,CreatedBy,CreatedDate)
			  OUTPUT inserted.EventID INTO @tInserted(tinsertedVal)
			values
			(@accountID,GETDATE(),@evntlookupid,@Maturity_EffectiveDate,1,@CreatedBy,GETDATE())


			SELECT @insertedid = tinsertedVal FROM @tInserted;

			INSERT into Core.Maturity(EventId,SelectedMaturityDate,CreatedBy,CreatedDate) VALUES
			(@insertedid,@Maturity_MaturityDate,@CreatedBy,GETDATE())

	END
	ELSE
	BEGIN
			UPDATE mt
			SET 
			mt.SelectedMaturityDate=@Maturity_MaturityDate,
			UpdatedBy=@UpdatedBy,
			UpdatedDate=GETDATE()
			from Core.Maturity mt 
			INNER JOIN Core.Event evt  on mt.EventId=evt.EventID
			where 	
			 evt.EventTypeID=@evntlookupid 
			 and evt.EffectiveStartDate=@Maturity_EffectiveDate
			 and evt.StatusID = 1

	END
	-----------------------Rate Spread Schedule---------------------------
		select @evntlookupid=LookupID from Core.Lookup where name ='RateSpreadSchedule'
		
		Select @count=count(evtTypeid) from #tmpEvent where evtTypeid=@evntlookupid and effStartDate=@RateSpreadSch_EffectiveDate
		if(@count=0)
	BEGIN
	INSERT into Core.Event (AccountID,	Date	,EventTypeID,	EffectiveStartDate,SingleEventValue,CreatedBy,CreatedDate)
			  OUTPUT inserted.EventID INTO @tInserted(tinsertedVal)
			values
			(@accountID,GETDATE(),@evntlookupid,@RateSpreadSch_EffectiveDate,1,@CreatedBy,GETDATE())

			SELECT @insertedid = tinsertedVal FROM @tInserted;


		INSERT into Core.RateSpreadSchedule(EventId,Date,ValueTypeID,Value,IntCalcMethodID,CreatedBy,CreatedDate)
		VALUES(@insertedid,@RateSpreadSch_Date,@RateSpreadSch_ValueTypeID,@RateSpreadSch_Value,@RateSpreadSch_IntCalcMethodID,@CreatedBy,GETDATE())


	END
	ELSE
	BEGIN

		UPDATE rss
			SET 
			rss.Date=@RateSpreadSch_Date,
			ValueTypeID=@RateSpreadSch_ValueTypeID,
			Value=@RateSpreadSch_Value,
			IntCalcMethodID=@RateSpreadSch_IntCalcMethodID,
			UpdatedBy=@UpdatedBy,
			UpdatedDate=GETDATE()
			from Core.RateSpreadSchedule rss 
			INNER JOIN Core.Event evt  on rss.EventId=evt.EventID
			where 	
			 evt.EventTypeID=@evntlookupid 
			 and evt.EffectiveStartDate=@RateSpreadSch_EffectiveDate
	END

	---------------------------Prepay And Additional Fee Schedule-----------------------------
	select @evntlookupid=LookupID from Core.Lookup where name ='PrepayAndAdditionalFeeSchedule'
		
		Select @count=count(evtTypeid) from #tmpEvent where evtTypeid=@evntlookupid and effStartDate=@PrepayAddFeeSch_EffectiveDate
		if(@count=0)
		BEGIN
		INSERT into Core.Event (AccountID,	Date	,EventTypeID,	EffectiveStartDate,SingleEventValue,CreatedBy,CreatedDate)
			  OUTPUT inserted.EventID INTO @tInserted(tinsertedVal)
			values
			(@accountID,GETDATE(),@evntlookupid,@PrepayAddFeeSch_EffectiveDate,1,@CreatedBy,GETDATE())
			SELECT @insertedid = tinsertedVal FROM @tInserted;


			INSERT into Core.PrepayAndAdditionalFeeSchedule([EventID],[StartDate],[ValueTypeID],[Value],[IncludedLevelYield],[IncludedBasis],[CreatedBy],[CreatedDate])
			VALUES(@insertedid,@PrepayAddFeeSch_StartDate,@PrepayAddFeeSch_ValueTypeID,@PrepayAddFeeSch_Value,@PrepayAddFeeSch_IncludedLevelYield,@PrepayAddFeeSch_IncludedBasis,@CreatedBy,GETDATE())
						
		END
		ELSE
		BEGIN

		UPDATE pafs
			SET 
			[StartDate]=@PrepayAddFeeSch_StartDate,
			[ValueTypeID]=@PrepayAddFeeSch_ValueTypeID,
			[Value]=@PrepayAddFeeSch_Value,
			[IncludedLevelYield]=@PrepayAddFeeSch_IncludedLevelYield,
			[IncludedBasis]=@PrepayAddFeeSch_IncludedBasis,
			
			UpdatedBy=@UpdatedBy,
			UpdatedDate=GETDATE()
			from Core.PrepayAndAdditionalFeeSchedule pafs 
			INNER JOIN Core.Event evt  on pafs.EventId=evt.EventID
			where 	
			 evt.EventTypeID=@evntlookupid 
			 and evt.EffectiveStartDate=@PrepayAddFeeSch_EffectiveDate
	END

	----------------------Stripping-----------------
	select @evntlookupid=LookupID from Core.Lookup where name ='StrippingSchedule'
		
		Select @count=count(evtTypeid) from #tmpEvent where evtTypeid=@evntlookupid and effStartDate=@stripping_EffectiveDate
		if(@count=0)
		BEGIN
		INSERT into Core.Event (AccountID,	Date	,EventTypeID,	EffectiveStartDate,SingleEventValue,CreatedBy,CreatedDate)
			  OUTPUT inserted.EventID INTO @tInserted(tinsertedVal)
			values
			(@accountID,GETDATE(),@evntlookupid,@stripping_EffectiveDate,1,@CreatedBy,GETDATE())
			SELECT @insertedid = tinsertedVal FROM @tInserted;

			insert into Core.StrippingSchedule(EventID,	StartDate,ValueTypeID,Value,IncludedLevelYield,IncludedBasis,CreatedBy,CreatedDate) Values
			(@insertedid,@stripping_StartDate,@stripping_ValueTypeID,@stripping_Value,@stripping_IncludedLevelYield,@stripping_IncludedBasis,@CreatedBy,GETDATE())
								
		END
		ELSE
		BEGIN

		UPDATE ss
			SET 
			[StartDate]=@stripping_StartDate,
			[ValueTypeID]=@stripping_ValueTypeID,
			[Value]=@stripping_Value,
			[IncludedLevelYield]=@stripping_IncludedLevelYield,
			[IncludedBasis]=@stripping_IncludedBasis,			
			UpdatedBy=@UpdatedBy,
			UpdatedDate=GETDATE()
			from Core.StrippingSchedule ss 
			INNER JOIN Core.Event evt  on ss.EventId=evt.EventID
			where 	
			 evt.EventTypeID=@evntlookupid 
			 and evt.EffectiveStartDate=@stripping_EffectiveDate
	END

	----------------------Financing Fee Schedule-----------------
	select @evntlookupid=LookupID from Core.Lookup where name ='FinancingFeeSchedule'
		
		Select @count=count(evtTypeid) from #tmpEvent where evtTypeid=@evntlookupid and effStartDate=@FinancingFeeSch_EffectiveDate
		if(@count=0)
		BEGIN
		INSERT into Core.Event (AccountID,	Date	,EventTypeID,	EffectiveStartDate,SingleEventValue,CreatedBy,CreatedDate)
			  OUTPUT inserted.EventID INTO @tInserted(tinsertedVal)
			values
			(@accountID,GETDATE(),@evntlookupid,@FinancingFeeSch_EffectiveDate,1,@CreatedBy,GETDATE())
			SELECT @insertedid = tinsertedVal FROM @tInserted;

			insert into Core.FinancingFeeSchedule(EventId,Date,ValueTypeID,Value,CreatedBy,CreatedDate) Values
			(@insertedid,@FinancingFeeSch_Date,@FinancingFeeSch_ValueTypeID,@FinancingFeeSch_Value,@CreatedBy,GETDATE())
			
			
		END
		ELSE
		BEGIN

		UPDATE ffs
			SET 
			Date=@FinancingFeeSch_Date,
			[ValueTypeID]=@FinancingFeeSch_ValueTypeID,
			[Value]=@FinancingFeeSch_Value,				
			UpdatedBy=@UpdatedBy,
			UpdatedDate=GETDATE()
			from Core.FinancingFeeSchedule ffs 
			INNER JOIN Core.Event evt  on ffs.EventId=evt.EventID
			where 	
			 evt.EventTypeID=@evntlookupid 
			 and evt.EffectiveStartDate=@FinancingFeeSch_EffectiveDate
	END


		----------------------Financing Schedule-----------------

			select @evntlookupid=LookupID from Core.Lookup where name ='FinancingSchedule'
		
		Select @count=count(evtTypeid) from #tmpEvent where evtTypeid=@evntlookupid and effStartDate=@FinancingSch_EffectiveDate
		if(@count=0)
		BEGIN
		INSERT into Core.Event (AccountID,	Date	,EventTypeID,	EffectiveStartDate,SingleEventValue,CreatedBy,CreatedDate)
			  OUTPUT inserted.EventID INTO @tInserted(tinsertedVal)
			values
			(@accountID,GETDATE(),@evntlookupid,@FinancingSch_EffectiveDate,1,@CreatedBy,GETDATE())
			SELECT @insertedid = tinsertedVal FROM @tInserted;

			insert into Core.FinancingSchedule(EventId,Date,ValueTypeID,Value,IndexTypeID,IntCalcMethodID,CurrencyCode,CreatedBy,CreatedDate) Values
			(@insertedid,@FinancingSch_Date,@FinancingSch_ValueTypeID,@FinancingSch_Value,@FinancingSch_IndexTypeID,@FinancingSch_IntCalcMethodID,@FinancingSch_CurrencyCode,@CreatedBy,GETDATE())
			
			
		END
		ELSE
		BEGIN

		UPDATE fs
			SET 
			Date=@FinancingSch_Date,
			[ValueTypeID]=@FinancingSch_ValueTypeID,
			[Value]=@FinancingSch_Value,	
			IndexTypeID=@FinancingSch_IndexTypeID,
			IntCalcMethodID=@FinancingSch_IntCalcMethodID,
			CurrencyCode=@FinancingSch_CurrencyCode,			
			UpdatedBy=@UpdatedBy,
			UpdatedDate=GETDATE()
			from Core.FinancingSchedule fs 
			INNER JOIN Core.Event evt  on fs.EventId=evt.EventID
			where 	
			 evt.EventTypeID=@evntlookupid 
			 and evt.EffectiveStartDate=@FinancingSch_EffectiveDate
	END


	----------------------Default-----------------

	Select @evntlookupid=LookupID from Core.Lookup where name ='DefaultSchedule'
		
		Select @count=count(evtTypeid) from #tmpEvent where evtTypeid=@evntlookupid and effStartDate=@DefaultSch_EffectiveDate
		if(@count=0)
		BEGIN
		INSERT into Core.Event (AccountID,	Date	,EventTypeID,	EffectiveStartDate,SingleEventValue,CreatedBy,CreatedDate)
			  OUTPUT inserted.EventID INTO @tInserted(tinsertedVal)
			values
			(@accountID,GETDATE(),@evntlookupid,@DefaultSch_EffectiveDate,1,@CreatedBy,GETDATE())
			SELECT @insertedid = tinsertedVal FROM @tInserted;

			insert into Core.DefaultSchedule(EventId,StartDate,EndDate,ValueTypeID,Value,CreatedBy,CreatedDate) Values
			(@insertedid,@DefaultSch_StartDate,@DefaultSch_EndDate,@DefaultSch_ValueTypeID,@DefaultSch_Value,@CreatedBy,GETDATE())
			
			
		END
		ELSE
		BEGIN

		UPDATE ds
			SET 
			StartDate=@DefaultSch_StartDate,
			EndDate=@DefaultSch_EndDate,
			ValueTypeID=@DefaultSch_ValueTypeID,	
			Value=@DefaultSch_Value,
			UpdatedBy=@UpdatedBy,
			UpdatedDate=GETDATE()
			from Core.DefaultSchedule ds 
			INNER JOIN Core.Event evt  on ds.EventId=evt.EventID
			where 	
			 evt.EventTypeID=@evntlookupid 
			 and evt.EffectiveStartDate=@DefaultSch_EffectiveDate
	END

	---------------------- Servicing Fee Schedule-----------------

	Select @evntlookupid=LookupID from Core.Lookup where name ='ServicingFeeSchedule'
		
		Select @count=count(evtTypeid) from #tmpEvent where evtTypeid=@evntlookupid and effStartDate=@ServicingFeeSch_EffectiveDate
		if(@count=0)
		BEGIN
		INSERT into Core.Event (AccountID,	Date,EventTypeID,	EffectiveStartDate,SingleEventValue,CreatedBy,CreatedDate)
			  OUTPUT inserted.EventID INTO @tInserted(tinsertedVal)
			values
			(@accountID,GETDATE(),@evntlookupid,@ServicingFeeSch_EffectiveDate,1,@CreatedBy,GETDATE())
			SELECT @insertedid = tinsertedVal FROM @tInserted;

			insert into Core.ServicingFeeSchedule(EventId,Date,Value,IsCapitalized,CreatedBy,CreatedDate) Values
			(@insertedid,@ServicingFeeSch_Date,@ServicingFeeSch_Value,@ServicingFeeSch_IsCapitalized,@CreatedBy,GETDATE())
			
			
		END
		ELSE
		BEGIN

		UPDATE sfs
			SET 
			Date=@ServicingFeeSch_Date,
			Value=@ServicingFeeSch_Value,
			IsCapitalized=@ServicingFeeSch_IsCapitalized,				
			UpdatedBy=@UpdatedBy,
			UpdatedDate=GETDATE()
			from Core.ServicingFeeSchedule sfs 
			INNER JOIN Core.Event evt  on sfs.EventId=evt.EventID
			where 	
			 evt.EventTypeID=@evntlookupid 
			 and evt.EffectiveStartDate=@ServicingFeeSch_EffectiveDate
	END

	------------------PIK Schedule----------------------
		Select @evntlookupid=LookupID from Core.Lookup where name ='PIKSchedule'
		
		Select @count=count(evtTypeid) from #tmpEvent where evtTypeid=@evntlookupid and effStartDate=@PIK_EffectiveDate
		if(@count=0)
		BEGIN
		INSERT into Core.Event (AccountID,	Date,EventTypeID,	EffectiveStartDate,SingleEventValue,CreatedBy,CreatedDate)
			  OUTPUT inserted.EventID INTO @tInserted(tinsertedVal)
			values
			(@accountID,GETDATE(),@evntlookupid,@PIK_EffectiveDate,1,@CreatedBy,GETDATE())
			SELECT @insertedid = tinsertedVal FROM @tInserted;

			insert into Core.PIKSchedule( [EventID],[SourceAccountID],[TargetAccountID],[AdditionalIntRate],[AdditionalSpread],[IndexFloor],[IntCompoundingRate]
			 ,[IntCompoundingSpread],[StartDate],[EndDate],[IntCapAmt],[PurBal],[AccCapBal],[CreatedBy],[CreatedDate]) Values
			(@insertedid,@SourceAccountID,@TargetAccountID,@AdditionalIntRate,@AdditionalSpread,@IndexFloor,@IntCompoundingRate,@IntCompoundingSpread,@StartDate,
			@EndDate,@IntCapAmt,@PurBal,@AccCapBal,@CreatedBy,GETDATE())
		END
		ELSE
		BEGIN

		UPDATE pik
			SET 	
			[SourceAccountID]=@SourceAccountID
			  ,[TargetAccountID]=@TargetAccountID
			  ,[AdditionalIntRate]=@AdditionalIntRate
			  ,[AdditionalSpread]=@AdditionalSpread
			  ,[IndexFloor]=@IndexFloor
			  ,[IntCompoundingRate]=@IntCompoundingRate
			  ,[IntCompoundingSpread]=@IntCompoundingSpread
			  ,[StartDate]=@StartDate
			  ,[EndDate]=@EndDate
			  ,[IntCapAmt]=@IntCapAmt
			  ,[PurBal]=@PurBal
			  ,[AccCapBal]=@AccCapBal
			from Core.PIKSchedule pik 
			INNER JOIN Core.Event evt  on pik.EventId=evt.EventID
			where 	
			 evt.EventTypeID=@evntlookupid 
			 and evt.EffectiveStartDate=@PIK_EffectiveDate
	END


	Drop  table #tmpEvent

END
