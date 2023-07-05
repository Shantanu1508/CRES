  


--'15-0007'		'Stanley Hotel'
--'15-0050'		'Alden Park'
--'15-0480'		'10 Jay Street'

--'15-0007'		'Stanley Hotel'
--'15-0050'		'Alden Park'
--'15-0480'		'10 Jay Street'

CREATE PROCEDURE [dbo].[usp_ImportBackShopInLandingtable] --'15-0006','b0e6697b-3534-4c09-be0a-04473401ab93','ea81e8ea-8e59-40ca-8729-cfc130da10ff'
(
	@DealID nvarchar(256),
	@UserName nvarchar(256),
	@BatchLogID UNIQUEIDENTIFIER
)
AS
BEGIN

SET XACT_ABORT ON;

--Import Data From Backshop Views
--EXEC [dbo].[usp_ImportDataFromBackshopViews]

--Import Data From Backshop Views
EXEC [usp_DeleteINUnderwritingDealDataByDealID] @DealID,@UserName



Declare @ClosigDateAsEffDate date;

---Variable Declaration---------------------------
Declare @CreatedUpdatedDate dateTime = getdate();
Declare @ImportDate date = CONVERT(date,getdate());		--DAteAdd(day,1,getdate())

DECLARE @CursorIndex int = 0;

DECLARE @IN_UnderwritingDealStartTime DATETIME;
DECLARE @IN_UnderwritingDealEndTime DATETIME;
DECLARE @IN_UnderwritingNoteStartTime DATETIME;
DECLARE @IN_UnderwritingNoteEndTime DATETIME;
DECLARE @IN_UnderwritingAccountStartTime DATETIME;
DECLARE @IN_UnderwritingAccountEndTime DATETIME;

DECLARE @IN_UnderwritingRateSpreadScheduleStartTime DATETIME;
DECLARE @IN_UnderwritingRateSpreadScheduleEndTime DATETIME;
DECLARE @IN_UnderwritingStrippingScheduleStartTime DATETIME;
DECLARE @IN_UnderwritingStrippingScheduleEndTime DATETIME;
DECLARE @IN_UnderwritingPikScheduleStartTime DATETIME;
DECLARE @IN_UnderwritingPikScheduleEndTime DATETIME;
--------------------------------------------------

DECLARE @NoteExt TABLE
(
  NoteID int, 
  ExtStatedMaturityDate date,
  Rowno int
)
INSERT INTO @NoteExt (NoteID, ExtStatedMaturityDate,Rowno)
select Noteid_F,ExtStatedMaturityDate,ROW_NUMBER() OVER(PARTITION BY noteid_F ORDER BY ExtStatedMaturityDate) as rowno
from [io].[IN_AcctNoteExt] where ControlId = @DealID
order by Noteid_F,ExtStatedMaturityDate asc
--------------------------------------------------


--DECLARE @DealID nvarchar(256) = (Select controlid from tblControlMaster  where dealname = @DealName) --Change

 

--Insert Deal data
SET @IN_UnderwritingDealStartTime = getdate();

IF NOT EXISTS(Select * from [IO].[IN_UnderwritingDeal] where ClientDealID = @DealID) 
BEGIN

	INSERT INTO [IO].[IN_UnderwritingDeal]
	([ClientDealID],
	[DealName],
	[StatusID],
	AssetManager,
	DealCity,
	DealState,
	DealPropertyType,
	TotalCommitment,
	FullyExtMaturityDate,
	[CreatedBy],
	[CreatedDate],
	[UpdatedBy],
	[UpdatedDate]
	)
	

	select 
	cm.ControlID,
	cm.dealname,
	(Select LookupID from [CORE].[Lookup] where Name = 'Not Posted')as [status],
	cm.AssetManager	,
	
	CASE 
	WHEN (Select COUNT(city) FROM (SELECT city FROM [IO].[IN_AcctProperty]  WHERE [ControlId]= cm.ControlID and city is not null GROUP BY city )a) = 1
	THEN (SELECT DISTINCT city FROM [IO].[IN_AcctProperty]  WHERE [ControlId]= cm.ControlID and city is not null)
	ELSE 'Multiple'
	END as DealCity	,

	CASE 
	WHEN (Select COUNT([State]) FROM (SELECT [State] FROM [IO].[IN_AcctProperty]  WHERE [ControlId]= cm.ControlID and [State] is not null GROUP BY [State] )a) = 1
	THEN (SELECT DISTINCT [State] FROM [IO].[IN_AcctProperty]  WHERE [ControlId]= cm.ControlID and [State] is not null)
	ELSE 'Multiple'
	END as DealState,

	CASE 
	WHEN (Select COUNT(PropertyTypeMajorDesc) FROM (SELECT PropertyTypeMajorDesc FROM [IO].[IN_AcctProperty]  WHERE [ControlId]= cm.ControlID and PropertyTypeMajorDesc is not null  GROUP BY PropertyTypeMajorDesc )a) = 1
	THEN (SELECT DISTINCT PropertyTypeMajorDesc FROM [IO].[IN_AcctProperty]  WHERE [ControlId]= cm.ControlID and PropertyTypeMajorDesc is not null)
	ELSE 'Multiple'
	END as DealPropertyType,

	
	cm.CommitmentAmount as TotalCommitment	,
	NULL as FullyExtMaturityDate , 
	@UserName,
	@CreatedUpdatedDate,
	@UserName,
	@CreatedUpdatedDate  
	
	from [IO].[IN_AcctDeal] cm 
	where cm.ControlId = @DealID 
 
	-----------------------------------------------------------
END
ELSE
BEGIN
	PRINT('UPDATE IN_UnderwritingDeal');
	UPDATE [IO].[IN_UnderwritingDeal] SET 
	[ClientDealID] = DealData.ControlID,
	[DealName] = DealData.dealname,
	[StatusID] = DealData.StatusID,
	AssetManager = DealData.AssetManager,
	DealCity = DealData.DealCity,
	DealState = DealData.DealState,
	DealPropertyType = DealData.DealPropertyType,
	TotalCommitment = DealData.TotalCommitment,
	FullyExtMaturityDate = DealData.FullyExtMaturityDate,
	[UpdatedBy] = @UserName, 
	[UpdatedDate] = @CreatedUpdatedDate 
	FROM
	(
		select 
		cm.ControlID,
		cm.dealname,
		(Select LookupID from [CORE].[Lookup] where Name = 'Not Posted')as [StatusID],
		cm.AssetManager	,
	
		CASE 
		WHEN (Select COUNT(city) FROM (SELECT city FROM [IO].[IN_AcctProperty]  WHERE [ControlId]= cm.ControlID and city is not null GROUP BY city )a) = 1
		THEN (SELECT DISTINCT city FROM [IO].[IN_AcctProperty]  WHERE [ControlId]= cm.ControlID and city is not null)
		ELSE 'Multiple'
		END as DealCity	,

		CASE 
		WHEN (Select COUNT([State]) FROM (SELECT [State] FROM [IO].[IN_AcctProperty]  WHERE [ControlId]= cm.ControlID and [State] is not null GROUP BY [State] )a) = 1
		THEN (SELECT DISTINCT [State] FROM [IO].[IN_AcctProperty]  WHERE [ControlId]= cm.ControlID and [State] is not null)
		ELSE 'Multiple'
		END as DealState,

		CASE 
		WHEN (Select COUNT(PropertyTypeMajorDesc) FROM (SELECT PropertyTypeMajorDesc FROM [IO].[IN_AcctProperty]  WHERE [ControlId]= cm.ControlID and PropertyTypeMajorDesc is not null  GROUP BY PropertyTypeMajorDesc )a) = 1
		THEN (SELECT DISTINCT PropertyTypeMajorDesc FROM [IO].[IN_AcctProperty]  WHERE [ControlId]= cm.ControlID and PropertyTypeMajorDesc is not null)
		ELSE 'Multiple'
		END as DealPropertyType,

	
		cm.CommitmentAmount as TotalCommitment	,
		NULL as FullyExtMaturityDate
		from [IO].[IN_AcctDeal] cm 
		where cm.ControlId = @DealID 

	)DealData
	where ClientDealID = @DealID

END



SET @IN_UnderwritingDealEndTime = getdate();



Declare @LDealID uniqueidentifier;
SELECT @LDealID = (Select IN_UnderwritingDealID from [IO].[IN_UnderwritingDeal] where  ClientDealID = @DealID) 
	

--Deal Cursor-------------------------------------------------------
Declare   @NoteId nvarchar(256);
Declare   @NoteName nvarchar(256);
Declare   @PaymentFreqDesc nvarchar(256);
Declare   @ControlId  nvarchar(256);
Declare   @PaymentFreqCd int;
Declare   @FundingDate datetime;
Declare   @FirstPIPaymentDate datetime;
Declare   @StatedMaturityDate datetime;
Declare   @OrigLoanAmount money;
Declare   @OriginationFee money;
Declare   @AmortIOPeriod  int;
Declare   @AmortizationTerm  int;
Declare   @DeterminationDate nvarchar(2) ;
Declare   @DeterminationMethodDay nvarchar(2) ;
Declare   @RoundingType  nvarchar(256);
Declare   @RoundingDenominator int;
Declare   @InterestSpread float ;
Declare   @IntCalcMethodDesc nvarchar(256);
Declare   @OriginationFeePct float ;
Declare   @AccrualRate float ;
Declare   @TotalCommitment float ;
Declare   @LiborFloor float ;
Declare   @ExpectedMaturityDate date;
Declare   @ExtendedMaturityScenario1 date;
Declare   @ExtendedMaturityScenario2 date;
Declare   @ExtendedMaturityScenario3 date;

Declare   @lienposition int;
Declare   @priority int;	

	
	


IF CURSOR_STATUS('global','CursorDeal')>=-1    
BEGIN    
DEALLOCATE CursorDeal    
END    
 
DECLARE CursorDeal CURSOR     
FOR    
(    
	Select
	NoteId,
	NoteName,
	PaymentFreqDesc,
	cm.ControlId,
	(CASE PaymentFreqCd_F WHEN 12 THEN 1 ELSE PaymentFreqCd_F END) as PaymentFreqCd,
	FundingDate,
	FirstPIPaymentDate,
	StatedMaturityDate,
	OrigLoanAmount,
	(CASE WHEN n.OriginationFee is null THEN (n.OriginationFeePct * TotalCommitment) ELSE n.OriginationFee END) as OriginationFee,
	AmortIOPeriod,
	AmortizationTerm,
	DeterminationDate,
	(CASE WHEN DeterminationMethodDay < 0 THEN ABS(DeterminationMethodDay) ELSE (-1 * n.DeterminationMethodDay) END) as DeterminationMethodDay,
	RoundingType,
	RoundingDenominator,
	InterestSpread,
	IntCalcMethodDesc,
	n.OriginationFeePct,
	AccrualRate,
	n.TotalCommitment,
	LiborFloor,
	(Select MAX(ExtStatedMaturityDate) from @NoteExt where NoteID = n.noteid) as ExpectedMaturityDate,
	(Select ExtStatedMaturityDate from @NoteExt where  NoteID = n.noteid and Rowno = 1) as ExtendedMaturityScenario1,
	(Select ExtStatedMaturityDate from @NoteExt where   NoteID = n.noteid and Rowno = 2) as ExtendedMaturityScenario2,
	(Select ExtStatedMaturityDate from @NoteExt where  NoteID = n.noteid and  Rowno = 3) as ExtendedMaturityScenario3,
	(Select top 1 lookupid from core.lookup where name = lienposition and parentid = 56) as lienposition,
	[priority]

	from [IO].[IN_AcctDeal] cm 
	inner join [IO].[IN_AcctNote] n on n.ControlId = cm.ControlId
	where cm.ControlId = @DealID  --cm.dealname =  @DealName
)
OPEN CursorDeal     
FETCH NEXT FROM CursorDeal    
INTO @NoteId,@NoteName,@PaymentFreqDesc,@ControlId,@PaymentFreqCd,@FundingDate,@FirstPIPaymentDate,@StatedMaturityDate,@OrigLoanAmount,@OriginationFee,@AmortIOPeriod,@AmortizationTerm,@DeterminationDate,@DeterminationMethodDay,@RoundingType,@RoundingDenominator,@InterestSpread,@IntCalcMethodDesc,@OriginationFeePct,@AccrualRate,@TotalCommitment,@LiborFloor,@ExpectedMaturityDate,@ExtendedMaturityScenario1,@ExtendedMaturityScenario2,@ExtendedMaturityScenario3,@lienposition,@priority
WHILE @@FETCH_STATUS = 0    
BEGIN  


BEGIN TRY
BEGIN TRAN

------------------Account Insert/Update--------------------------------------------
IF(@CursorIndex = 0)BEGIN SET @IN_UnderwritingAccountStartTime = getdate(); END

IF NOT EXISTS(Select * from [IO].[IN_UnderwritingAccount] where ClientNoteID = @NoteId)
BEGIN
		--Insert Account(Note) data
		INSERT INTO [IO].[IN_UnderwritingAccount]
				   ([ClientNoteID]
				   ,[Name]
				   ,[PayFrequency]
				   ,[StatusID]
				   ,[CreatedBy]
				   ,[CreatedDate]
				   ,[UpdatedBy]
				   ,[UpdatedDate])
		Values(
			@NoteId,
			@NoteName, 
			--(Select Value from CORE.Lookup where Name = @PaymentFreqDesc),
			@PaymentFreqCd,
			(Select LookupID from CORE.Lookup where Name = 'Not Posted'),
			@UserName,
			@CreatedUpdatedDate,
			@UserName,
			@CreatedUpdatedDate 
		)
END
ELSE
BEGIN

		PRINT('UPDATE ACCOUNT');
		UPDATE [IO].[IN_UnderwritingAccount] set 
		[PayFrequency] = @PaymentFreqCd
		where ClientNoteID = @NoteId
END
SET @IN_UnderwritingAccountEndTime = getdate();
-------------------------------------------------------------------------------------

------------------Note Insert/Update--------------------------------------------
IF(@CursorIndex = 0)BEGIN SET @IN_UnderwritingNoteStartTime = getdate(); END
IF NOT EXISTS(Select * from [IO].[IN_UnderwritingNote] where ClientNoteID = @NoteId)
BEGIN
	--Insert Note data
	INSERT INTO [IO].[IN_UnderwritingNote]
		([IN_UnderwritingAccountID]
		,[IN_UnderwritingDealID]
		,[ClientNoteID]
		,[ClientDealID]
		,[ClosingDate]
		,[FirstPaymentDate]
		,[SelectedMaturityDate]
		,[InitialFundingAmount]
		,[OriginationFee]
		,[IOTerm]
		,[AmortTerm]
		,[DeterminationDateLeadDays]
		,[DeterminationDateReferenceDayoftheMonth]
		,[RoundingMethod]
		,[IndexRoundingRule]
		,[StatusID]
		,ExpectedMaturityDate
		,ExtendedMaturityScenario1
		,ExtendedMaturityScenario2
		,ExtendedMaturityScenario3
		,[TotalCommitment]
		,lienposition 
		,[priority]
		,[CreatedBy]
		,[CreatedDate]
		,[UpdatedBy]
		,[UpdatedDate])
		
		VALUES(
		(Select Top 1 IN_UnderwritingAccountID from [IO].[IN_UnderwritingAccount] unAcc where unAcc.ClientNoteID = @NoteId),
		@LDealID,
		@NoteId ,
		@ControlId ,
		@FundingDate ,
		@FirstPIPaymentDate ,
		@StatedMaturityDate ,
		@OrigLoanAmount ,
		@OriginationFee ,
		@AmortIOPeriod ,
		@AmortizationTerm ,
		@DeterminationMethodDay ,
		@DeterminationDate,
		
		(Select LookupID from CORE.Lookup where Name = @RoundingType),
		@RoundingDenominator,
		(Select LookupID from CORE.Lookup where Name = 'Not Posted'),
		@ExpectedMaturityDate,
		@ExtendedMaturityScenario1,
		@ExtendedMaturityScenario2,
		@ExtendedMaturityScenario3,
		@TotalCommitment,
		@lienposition,
		@priority,
		@UserName,
		@CreatedUpdatedDate,
		@UserName,
		@CreatedUpdatedDate 
		)
END
ELSE
BEGIN
	
		Update [IO].[IN_UnderwritingNote] SET
		[ClosingDate]  = @FundingDate ,
		[FirstPaymentDate]  = @FirstPIPaymentDate ,
		[SelectedMaturityDate]  = @StatedMaturityDate ,
		[InitialFundingAmount]  = @OrigLoanAmount ,
		[OriginationFee]  = @OriginationFee ,
		[IOTerm]  = @AmortIOPeriod ,
		[AmortTerm]  = @AmortizationTerm ,
		[DeterminationDateLeadDays]  =@DeterminationMethodDay ,
		[DeterminationDateReferenceDayoftheMonth]  = @DeterminationDate ,
		[RoundingMethod]  = (Select LookupID from CORE.Lookup where Name = @RoundingType),
		[IndexRoundingRule]  = @RoundingDenominator,
		[StatusID]  = (Select LookupID from CORE.Lookup where Name = 'Not Posted'),
		ExpectedMaturityDate	 = 	@ExpectedMaturityDate,
		ExtendedMaturityScenario1	 = 	@ExtendedMaturityScenario1,
		ExtendedMaturityScenario2	 = 	@ExtendedMaturityScenario2,
		ExtendedMaturityScenario3	 = 	@ExtendedMaturityScenario3,
		TotalCommitment = @TotalCommitment,
		lienposition = @lienposition,
		[priority] = @priority,
		[UpdatedBy]  = @UserName,
		[UpdatedDate]  = @CreatedUpdatedDate
		WHERE [ClientNoteID] = @NoteId
END


SET @IN_UnderwritingNoteEndTime = getdate();
-------------------------------------------------------------------------------------


------------------RateSpreadSchedule Insert/Update--------------------------------------------
IF(@CursorIndex = 0)BEGIN SET @IN_UnderwritingRateSpreadScheduleStartTime = getdate(); END

--IF(@InterestSpread IS NOT NULL)
--BEGIN


--	IF NOT EXISTS(
--			Select 
--			IN_UnderwritingRateSpreadScheduleID,
--			rs.Value 
--			from [IO].IN_UnderwritingRateSpreadSchedule rs
--			where IN_UnderwritingEventID in 
--			(

--				Select e.IN_UnderwritingEventID from [IO].[IN_UnderwritingEvent] e
--				INNER JOIN 
--						(
--							Select eve.IN_UnderwritingAccountID,MAX(EffectiveStartDate) EffectiveStartDate from [IO].[IN_UnderwritingEvent] eve
--							INNER JOIN [IO].[IN_UnderwritingNote] n ON n.IN_UnderwritingAccountID = eve.IN_UnderwritingAccountID
--							INNER JOIN [IO].[IN_UnderwritingAccount] acc ON acc.IN_UnderwritingAccountID = n.IN_UnderwritingAccountID
--							where EventTypeID = (Select LookupID from CORE.Lookup where Name = 'RateSpreadSchedule')
--							and n.ClientNoteID = @NoteId
--							GROUP BY eve.IN_UnderwritingAccountID
--						) sEvent

--				ON sEvent.IN_UnderwritingAccountID = e.IN_UnderwritingAccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate and EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'RateSpreadSchedule')
--			)
--			and rs.[ValueTypeID] = (Select LookupID from CORE.Lookup where Name = 'Spread')
--	)
--	BEGIN

--			DECLARE @tEvent TABLE (tEventID UNIQUEIDENTIFIER)
--			Declare @EventID uniqueidentifier;
--			Delete from @tEvent

--			INSERT INTO [IO].[IN_UnderwritingEvent]
--			([IN_UnderwritingAccountID]
--			,[Date]
--			,[EventTypeID]
--			,[EffectiveStartDate]
--			,[EffectiveEndDate]
--			,[SingleEventValue]
--			,[CreatedBy]
--			,[CreatedDate]
--			,[UpdatedBy]
--			,[UpdatedDate])

--			OUTPUT inserted.IN_UnderwritingEventID INTO @tEvent(tEventID)

--			VALUES(
--			(Select Top 1 IN_UnderwritingAccountID from [IO].[IN_UnderwritingAccount] unAcc where unAcc.ClientNoteID = @NoteId),
--			@ImportDate,
--			(Select LookupID from CORE.Lookup where Name = 'RateSpreadSchedule'),
--			@ImportDate,
--			NULL,
--			NULL,
--			@UserName,
--			@CreatedUpdatedDate,
--			@UserName,
--			@CreatedUpdatedDate
--			)

--			SELECT @EventID = tEventID FROM @tEvent; 

		   
--			INSERT INTO [IO].[IN_UnderwritingRateSpreadSchedule]
--					([IN_UnderwritingEventID]
--					,[Date]
--					,[ValueTypeID]
--					,[Value]
--					,[IntCalcMethodID]
--					,[CreatedBy]
--					,[CreatedDate]
--					,[UpdatedBy]
--					,[UpdatedDate])

--			VALUES 
--			(@EventID,
--			@ImportDate,
--			(Select LookupID from CORE.Lookup where Name = 'Spread'),
--			@InterestSpread  ,
--			(Select LookupID from CORE.Lookup where Name = @IntCalcMethodDesc),
--			@UserName,
--			@CreatedUpdatedDate,
--			@UserName,
--			@CreatedUpdatedDate
--			)
--	END
--	ELSE
--	BEGIN

--		Declare @L_InterestSpread float;
--		Declare @L_IN_UnderwritingRateSpreadScheduleID uniqueidentifier;

--		Select 
--		@L_IN_UnderwritingRateSpreadScheduleID = IN_UnderwritingRateSpreadScheduleID,
--		@L_InterestSpread = rs.Value 
--		from [IO].IN_UnderwritingRateSpreadSchedule rs
--		where IN_UnderwritingEventID in 
--		(

--			Select e.IN_UnderwritingEventID from [IO].[IN_UnderwritingEvent] e
--			INNER JOIN 
--					(
--						Select eve.IN_UnderwritingAccountID,MAX(EffectiveStartDate) EffectiveStartDate from [IO].[IN_UnderwritingEvent] eve
--						INNER JOIN [IO].[IN_UnderwritingNote] n ON n.IN_UnderwritingAccountID = eve.IN_UnderwritingAccountID
--						INNER JOIN [IO].[IN_UnderwritingAccount] acc ON acc.IN_UnderwritingAccountID = n.IN_UnderwritingAccountID
--						where EventTypeID = (Select LookupID from CORE.Lookup where Name = 'RateSpreadSchedule')
--						and n.ClientNoteID = @NoteId
--						GROUP BY eve.IN_UnderwritingAccountID
--					) sEvent

--			ON sEvent.IN_UnderwritingAccountID = e.IN_UnderwritingAccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate and EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'RateSpreadSchedule')
--		)
--		and rs.[ValueTypeID] = (Select LookupID from CORE.Lookup where Name = 'Spread')


--		Declare @L_EffectiveDate Date;
--			Select @L_EffectiveDate = MAX(EffectiveStartDate)  
--			from [IO].[IN_UnderwritingEvent] eve
--						INNER JOIN [IO].[IN_UnderwritingNote] n ON n.IN_UnderwritingAccountID = eve.IN_UnderwritingAccountID
--						INNER JOIN [IO].[IN_UnderwritingAccount] acc ON acc.IN_UnderwritingAccountID = n.IN_UnderwritingAccountID
--						where EventTypeID = (Select LookupID from CORE.Lookup where Name = 'RateSpreadSchedule')
--						and n.ClientNoteID = @NoteId
--						GROUP BY eve.IN_UnderwritingAccountID

					

--		IF(@InterestSpread != @L_InterestSpread and @ImportDate > @L_EffectiveDate )
--		BEGIN
			 
--			DECLARE @tEvent2 TABLE (tEventID2 UNIQUEIDENTIFIER)
--			Declare @EventID2 uniqueidentifier;
--			Delete from @tEvent2

--			INSERT INTO [IO].[IN_UnderwritingEvent]
--			([IN_UnderwritingAccountID]
--			,[Date]
--			,[EventTypeID]
--			,[EffectiveStartDate]
--			,[EffectiveEndDate]
--			,[SingleEventValue]
--			,[CreatedBy]
--			,[CreatedDate]
--			,[UpdatedBy]
--			,[UpdatedDate])

--			OUTPUT inserted.IN_UnderwritingEventID INTO @tEvent2(tEventID2)

--			VALUES(
--			(Select Top 1 IN_UnderwritingAccountID from [IO].[IN_UnderwritingAccount] unAcc where unAcc.ClientNoteID = @NoteId),
--			@ImportDate,
--			(Select LookupID from CORE.Lookup where Name = 'RateSpreadSchedule'),
--			@ImportDate,
--			NULL,
--			NULL,
--			@UserName,
--			@CreatedUpdatedDate,
--			@UserName,
--			@CreatedUpdatedDate
--			)

--			SELECT @EventID2 = tEventID2 FROM @tEvent2; 

		   
--			INSERT INTO [IO].[IN_UnderwritingRateSpreadSchedule]
--					([IN_UnderwritingEventID]
--					,[Date]
--					,[ValueTypeID]
--					,[Value]
--					,[IntCalcMethodID]
--					,[CreatedBy]
--					,[CreatedDate]
--					,[UpdatedBy]
--					,[UpdatedDate])

--			VALUES 
--			(@EventID2,
--			@ImportDate,
--			(Select LookupID from CORE.Lookup where Name = 'Spread'),
--			@InterestSpread  ,
--			(Select LookupID from CORE.Lookup where Name = @IntCalcMethodDesc),
--			@UserName,
--			@CreatedUpdatedDate,
--			@UserName,
--			@CreatedUpdatedDate
--			)
--		END
--		ELSE
--		BEGIN
		
--			UPDATE [IO].[IN_UnderwritingRateSpreadSchedule] SET
--					[Value] = @InterestSpread,
--					[IntCalcMethodID] = (Select LookupID from CORE.Lookup where Name = @IntCalcMethodDesc),
--					[UpdatedBy] = @UserName,
--					[UpdatedDate] =@CreatedUpdatedDate
--			WHERE IN_UnderwritingRateSpreadScheduleID = @L_IN_UnderwritingRateSpreadScheduleID

--		END
--	END

--END

------------Spread + Libor Floor--------------------

IF(@InterestSpread IS NOT NULL OR @LiborFloor is not null)
BEGIN

	IF(@FundingDate is null)
	Begin
		SET @ClosigDateAsEffDate = @ImportDate
	END
	ELSE
	BEGIN
		SET @ClosigDateAsEffDate = @FundingDate
	END

	IF NOT EXISTS(
			Select 
			IN_UnderwritingRateSpreadScheduleID,
			rs.Value 
			from [IO].IN_UnderwritingRateSpreadSchedule rs
			where IN_UnderwritingEventID in 
			(

				Select e.IN_UnderwritingEventID from [IO].[IN_UnderwritingEvent] e
				INNER JOIN 
						(
							Select eve.IN_UnderwritingAccountID,MAX(EffectiveStartDate) EffectiveStartDate from [IO].[IN_UnderwritingEvent] eve
							INNER JOIN [IO].[IN_UnderwritingNote] n ON n.IN_UnderwritingAccountID = eve.IN_UnderwritingAccountID
							INNER JOIN [IO].[IN_UnderwritingAccount] acc ON acc.IN_UnderwritingAccountID = n.IN_UnderwritingAccountID
							where EventTypeID = (Select LookupID from CORE.Lookup where Name = 'RateSpreadSchedule')
							and n.ClientNoteID = @NoteId
							GROUP BY eve.IN_UnderwritingAccountID
						) sEvent

				ON sEvent.IN_UnderwritingAccountID = e.IN_UnderwritingAccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate and EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'RateSpreadSchedule')
			)
			--and rs.[ValueTypeID] = (Select LookupID from CORE.Lookup where Name = 'Spread')
	)
	BEGIN
			PRINT('RSS NOt exist ' + @NoteId)
			DECLARE @tEvent TABLE (tEventID UNIQUEIDENTIFIER)
			Declare @EventID uniqueidentifier;
			Delete from @tEvent

			INSERT INTO [IO].[IN_UnderwritingEvent]
			([IN_UnderwritingAccountID]
			,[Date]
			,[EventTypeID]
			,[EffectiveStartDate]
			,[EffectiveEndDate]
			,[SingleEventValue]
			,[CreatedBy]
			,[CreatedDate]
			,[UpdatedBy]
			,[UpdatedDate])

			OUTPUT inserted.IN_UnderwritingEventID INTO @tEvent(tEventID)

			VALUES(
			(Select Top 1 IN_UnderwritingAccountID from [IO].[IN_UnderwritingAccount] unAcc where unAcc.ClientNoteID = @NoteId),
			@ImportDate,
			(Select LookupID from CORE.Lookup where Name = 'RateSpreadSchedule'),
			@ClosigDateAsEffDate,
			NULL,
			NULL,
			@UserName,
			@CreatedUpdatedDate,
			@UserName,
			@CreatedUpdatedDate
			)

			SELECT @EventID = tEventID FROM @tEvent; 

			IF(@InterestSpread is not null)
			begin 
				INSERT INTO [IO].[IN_UnderwritingRateSpreadSchedule]([IN_UnderwritingEventID],[Date],[ValueTypeID],[Value],[IntCalcMethodID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
				VALUES (@EventID,@ClosigDateAsEffDate,(Select LookupID from CORE.Lookup where Name = 'Spread'),@InterestSpread  ,(Select LookupID from CORE.Lookup where Name = @IntCalcMethodDesc),@UserName,@CreatedUpdatedDate,@UserName,@CreatedUpdatedDate)
			END
			IF(@LiborFloor is not null)
			begin 
				INSERT INTO [IO].[IN_UnderwritingRateSpreadSchedule]([IN_UnderwritingEventID],[Date],[ValueTypeID],[Value],[IntCalcMethodID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
				VALUES (@EventID,@ClosigDateAsEffDate,(Select LookupID from CORE.Lookup where Name = 'Index Floor'),@LiborFloor ,(Select LookupID from CORE.Lookup where Name = @IntCalcMethodDesc),@UserName,@CreatedUpdatedDate,@UserName,@CreatedUpdatedDate)
			END
	END
	ELSE
	BEGIN
		PRINT('RSS  exist ' + @NoteId)
		Declare @L_InterestSpreadPlusLiborFloor float;
		--Declare @L_IN_UnderwritingRateSpreadScheduleID uniqueidentifier;

		Select 
		@L_InterestSpreadPlusLiborFloor = SUM(ABS(ISNULL(rs.Value,0)))
		from [IO].IN_UnderwritingRateSpreadSchedule rs
		where IN_UnderwritingEventID in 
		(

			Select e.IN_UnderwritingEventID from [IO].[IN_UnderwritingEvent] e
			INNER JOIN 
					(
						Select eve.IN_UnderwritingAccountID,MAX(EffectiveStartDate) EffectiveStartDate from [IO].[IN_UnderwritingEvent] eve
						INNER JOIN [IO].[IN_UnderwritingNote] n ON n.IN_UnderwritingAccountID = eve.IN_UnderwritingAccountID
						INNER JOIN [IO].[IN_UnderwritingAccount] acc ON acc.IN_UnderwritingAccountID = n.IN_UnderwritingAccountID
						where EventTypeID = (Select LookupID from CORE.Lookup where Name = 'RateSpreadSchedule')
						and n.ClientNoteID = @NoteId
						GROUP BY eve.IN_UnderwritingAccountID
					) sEvent

			ON sEvent.IN_UnderwritingAccountID = e.IN_UnderwritingAccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate and EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'RateSpreadSchedule')
		)
		and rs.[ValueTypeID] in (Select LookupID from CORE.Lookup where Name in ('Spread','Index Floor'))


		Declare @L_EffectiveDate Date;
			Select @L_EffectiveDate = MAX(EffectiveStartDate)  
			from [IO].[IN_UnderwritingEvent] eve
						INNER JOIN [IO].[IN_UnderwritingNote] n ON n.IN_UnderwritingAccountID = eve.IN_UnderwritingAccountID
						INNER JOIN [IO].[IN_UnderwritingAccount] acc ON acc.IN_UnderwritingAccountID = n.IN_UnderwritingAccountID
						where EventTypeID = (Select LookupID from CORE.Lookup where Name = 'RateSpreadSchedule')
						and n.ClientNoteID = @NoteId
						GROUP BY eve.IN_UnderwritingAccountID

					
		Declare @BAckshopSpreadPlusLiborFloor decimal;
		SET @BAckshopSpreadPlusLiborFloor = ABS(ISnull(@InterestSpread,0)) + ABS(ISnull(@LiborFloor,0))
		

		IF(@BAckshopSpreadPlusLiborFloor != @L_InterestSpreadPlusLiborFloor and @ImportDate > @L_EffectiveDate )
		BEGIN
			 
			DECLARE @tEvent2 TABLE (tEventID2 UNIQUEIDENTIFIER)
			Declare @EventID2 uniqueidentifier;
			Delete from @tEvent2

			INSERT INTO [IO].[IN_UnderwritingEvent]
			([IN_UnderwritingAccountID]
			,[Date]
			,[EventTypeID]
			,[EffectiveStartDate]
			,[EffectiveEndDate]
			,[SingleEventValue]
			,[CreatedBy]
			,[CreatedDate]
			,[UpdatedBy]
			,[UpdatedDate])

			OUTPUT inserted.IN_UnderwritingEventID INTO @tEvent2(tEventID2)

			VALUES(
			(Select Top 1 IN_UnderwritingAccountID from [IO].[IN_UnderwritingAccount] unAcc where unAcc.ClientNoteID = @NoteId),
			@ImportDate,
			(Select LookupID from CORE.Lookup where Name = 'RateSpreadSchedule'),
			@ImportDate,
			NULL,
			NULL,
			@UserName,
			@CreatedUpdatedDate,
			@UserName,
			@CreatedUpdatedDate
			)

			SELECT @EventID2 = tEventID2 FROM @tEvent2; 

		   
			IF(@InterestSpread is not null)
			begin 
				INSERT INTO [IO].[IN_UnderwritingRateSpreadSchedule]([IN_UnderwritingEventID],[Date],[ValueTypeID],[Value],[IntCalcMethodID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
				VALUES (@EventID2,@ClosigDateAsEffDate,(Select LookupID from CORE.Lookup where Name = 'Spread'),@InterestSpread  ,(Select LookupID from CORE.Lookup where Name = @IntCalcMethodDesc),@UserName,@CreatedUpdatedDate,@UserName,@CreatedUpdatedDate)
			END
			IF(@LiborFloor is not null)
			begin 
				INSERT INTO [IO].[IN_UnderwritingRateSpreadSchedule]([IN_UnderwritingEventID],[Date],[ValueTypeID],[Value],[IntCalcMethodID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
				VALUES (@EventID2,@ClosigDateAsEffDate,(Select LookupID from CORE.Lookup where Name = 'Index Floor'),@LiborFloor ,(Select LookupID from CORE.Lookup where Name = @IntCalcMethodDesc),@UserName,@CreatedUpdatedDate,@UserName,@CreatedUpdatedDate)
			END

		END
		ELSE
		BEGIN
			PRINT('RSS Update ' + @NoteId)
			Declare @L_IN_UnderRSScheduleIDSpread uniqueidentifier;
			Declare @L_IN_UnderRSScheduleIDLibor uniqueidentifier;

				Select 
				@L_IN_UnderRSScheduleIDSpread = rs.IN_UnderwritingRateSpreadScheduleID
				from [IO].IN_UnderwritingRateSpreadSchedule rs
				where IN_UnderwritingEventID in 
				(

				Select e.IN_UnderwritingEventID from [IO].[IN_UnderwritingEvent] e
				INNER JOIN 
						(
							Select eve.IN_UnderwritingAccountID,MAX(EffectiveStartDate) EffectiveStartDate from [IO].[IN_UnderwritingEvent] eve
							INNER JOIN [IO].[IN_UnderwritingNote] n ON n.IN_UnderwritingAccountID = eve.IN_UnderwritingAccountID
							INNER JOIN [IO].[IN_UnderwritingAccount] acc ON acc.IN_UnderwritingAccountID = n.IN_UnderwritingAccountID
							where EventTypeID = (Select LookupID from CORE.Lookup where Name = 'RateSpreadSchedule')
							and n.ClientNoteID = @NoteId
							GROUP BY eve.IN_UnderwritingAccountID
						) sEvent

				ON sEvent.IN_UnderwritingAccountID = e.IN_UnderwritingAccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate and EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'RateSpreadSchedule')
				)
				and rs.[ValueTypeID] in (Select LookupID from CORE.Lookup where Name in ('Spread'))
				-------------------------
				Select 
				@L_IN_UnderRSScheduleIDLibor = rs.IN_UnderwritingRateSpreadScheduleID
				from [IO].IN_UnderwritingRateSpreadSchedule rs
				where IN_UnderwritingEventID in 
				(

				Select e.IN_UnderwritingEventID from [IO].[IN_UnderwritingEvent] e
				INNER JOIN 
						(
							Select eve.IN_UnderwritingAccountID,MAX(EffectiveStartDate) EffectiveStartDate from [IO].[IN_UnderwritingEvent] eve
							INNER JOIN [IO].[IN_UnderwritingNote] n ON n.IN_UnderwritingAccountID = eve.IN_UnderwritingAccountID
							INNER JOIN [IO].[IN_UnderwritingAccount] acc ON acc.IN_UnderwritingAccountID = n.IN_UnderwritingAccountID
							where EventTypeID = (Select LookupID from CORE.Lookup where Name = 'RateSpreadSchedule')
							and n.ClientNoteID = @NoteId
							GROUP BY eve.IN_UnderwritingAccountID
						) sEvent

				ON sEvent.IN_UnderwritingAccountID = e.IN_UnderwritingAccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate and EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'RateSpreadSchedule')
				)
				and rs.[ValueTypeID] in (Select LookupID from CORE.Lookup where Name in ('Index Floor'))




			UPDATE [IO].[IN_UnderwritingRateSpreadSchedule] SET
					[Value] = @InterestSpread,
					[IntCalcMethodID] = (Select LookupID from CORE.Lookup where Name = @IntCalcMethodDesc),
					[UpdatedBy] = @UserName,
					[UpdatedDate] =@CreatedUpdatedDate
			WHERE IN_UnderwritingRateSpreadScheduleID = @L_IN_UnderRSScheduleIDSpread


			UPDATE [IO].[IN_UnderwritingRateSpreadSchedule] SET
					[Value] = @LiborFloor,
					[IntCalcMethodID] = (Select LookupID from CORE.Lookup where Name = @IntCalcMethodDesc),
					[UpdatedBy] = @UserName,
					[UpdatedDate] =@CreatedUpdatedDate
			WHERE IN_UnderwritingRateSpreadScheduleID = @L_IN_UnderRSScheduleIDLibor

		END
	END

END
-----------------------------------------------


SET @IN_UnderwritingRateSpreadScheduleEndTime = getdate();
-----------------------------------------------------------------------------------------------


--------------------Stripping Schedule Insert/Update--------------------------------------------
--IF(@CursorIndex = 0)BEGIN SET @IN_UnderwritingStrippingScheduleStartTime = getdate(); END
--IF(@OriginationFeePct IS NOT NULL)
--BEGIN


--	IF NOT EXISTS(
--			Select 
--			IN_UnderwritingStrippingScheduleID,
--			ss.Value 
--			from [IO].IN_UnderwritingStrippingSchedule ss
--			where IN_UnderwritingEventID in 
--			(

--				Select e.IN_UnderwritingEventID from [IO].[IN_UnderwritingEvent] e
--				INNER JOIN 
--						(
--							Select eve.IN_UnderwritingAccountID,MAX(EffectiveStartDate) EffectiveStartDate from [IO].[IN_UnderwritingEvent] eve
--							INNER JOIN [IO].[IN_UnderwritingNote] n ON n.IN_UnderwritingAccountID = eve.IN_UnderwritingAccountID
--							INNER JOIN [IO].[IN_UnderwritingAccount] acc ON acc.IN_UnderwritingAccountID = n.IN_UnderwritingAccountID
--							where EventTypeID = (Select LookupID from CORE.Lookup where Name = 'StrippingSchedule')
--							and n.ClientNoteID = @NoteId
--							GROUP BY eve.IN_UnderwritingAccountID
--						) sEvent

--				ON sEvent.IN_UnderwritingAccountID = e.IN_UnderwritingAccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate and EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'StrippingSchedule')
--			)
--			and ss.[ValueTypeID] = (Select LookupID from CORE.Lookup where Name = 'Origination Fee Strip')
--	)
--	BEGIN

--			DECLARE @tEventss TABLE (tEventIDss UNIQUEIDENTIFIER)
--			Declare @EventIDss uniqueidentifier;
--			Delete from @tEventss

--			INSERT INTO [IO].[IN_UnderwritingEvent]
--			([IN_UnderwritingAccountID]
--			,[Date]
--			,[EventTypeID]
--			,[EffectiveStartDate]
--			,[EffectiveEndDate]
--			,[SingleEventValue]
--			,[CreatedBy]
--			,[CreatedDate]
--			,[UpdatedBy]
--			,[UpdatedDate])

--			OUTPUT inserted.IN_UnderwritingEventID INTO @tEventss(tEventIDss)

--			VALUES(
--			(Select Top 1 IN_UnderwritingAccountID from [IO].[IN_UnderwritingAccount] unAcc where unAcc.ClientNoteID = @NoteId),
--			@ImportDate,
--			(Select LookupID from CORE.Lookup where Name = 'StrippingSchedule'),
--			@ImportDate,
--			NULL,
--			NULL,
--			@UserName,
--			@CreatedUpdatedDate,
--			@UserName,
--			@CreatedUpdatedDate
--			)

--			SELECT @EventIDss = tEventIDss FROM @tEventss; 

--		   PRINT(@EventIDss);

--			INSERT INTO [IO].[IN_UnderwritingStrippingSchedule]
--           ([IN_UnderwritingEventID]
--           ,[StartDate]
--           ,[ValueTypeID]
--           ,[Value]
--           ,[CreatedBy]
--           ,[CreatedDate]
--           ,[UpdatedBy]
--           ,[UpdatedDate])

--			VALUES 
--			(@EventIDss,
--			@ImportDate,
--			(Select LookupID from CORE.Lookup where Name = 'Origination Fee Strip'),
--			@OriginationFeePct  ,
--			@UserName,
--			@CreatedUpdatedDate,
--			@UserName,
--			@CreatedUpdatedDate
--			)
--	END
--	ELSE
--	BEGIN

--		Declare @L_OriginationFeePct float;
--		Declare @L_IN_UnderwritingStrippingScheduleID uniqueidentifier;

--		Select 
--			@L_IN_UnderwritingStrippingScheduleID = IN_UnderwritingStrippingScheduleID,
--			@L_OriginationFeePct = ss.Value 
--			from [IO].IN_UnderwritingStrippingSchedule ss
--			where IN_UnderwritingEventID in 
--			(

--				Select e.IN_UnderwritingEventID from [IO].[IN_UnderwritingEvent] e
--				INNER JOIN 
--						(
--							Select eve.IN_UnderwritingAccountID,MAX(EffectiveStartDate) EffectiveStartDate from [IO].[IN_UnderwritingEvent] eve
--							INNER JOIN [IO].[IN_UnderwritingNote] n ON n.IN_UnderwritingAccountID = eve.IN_UnderwritingAccountID
--							INNER JOIN [IO].[IN_UnderwritingAccount] acc ON acc.IN_UnderwritingAccountID = n.IN_UnderwritingAccountID
--							where EventTypeID = (Select LookupID from CORE.Lookup where Name = 'StrippingSchedule')
--							and n.ClientNoteID = @NoteId
--							GROUP BY eve.IN_UnderwritingAccountID
--						) sEvent

--				ON sEvent.IN_UnderwritingAccountID = e.IN_UnderwritingAccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'StrippingSchedule')
--			)
--			and ss.[ValueTypeID] = (Select LookupID from CORE.Lookup where Name = 'Origination Fee Strip')


--		Declare @L_EffectiveDateSS Date;
--			Select @L_EffectiveDateSS = MAX(EffectiveStartDate)  
--			from [IO].[IN_UnderwritingEvent] eve
--						INNER JOIN [IO].[IN_UnderwritingNote] n ON n.IN_UnderwritingAccountID = eve.IN_UnderwritingAccountID
--						INNER JOIN [IO].[IN_UnderwritingAccount] acc ON acc.IN_UnderwritingAccountID = n.IN_UnderwritingAccountID
--						where EventTypeID = (Select LookupID from CORE.Lookup where Name = 'StrippingSchedule')
--						and n.ClientNoteID = @NoteId
--						GROUP BY eve.IN_UnderwritingAccountID

					

--		IF(@OriginationFeePct != @L_OriginationFeePct and @ImportDate > @L_EffectiveDateSS )
--		BEGIN
			 
--			DECLARE @tEventss2 TABLE (tEventIDss2 UNIQUEIDENTIFIER)
--			Declare @EventIDss2 uniqueidentifier;
--			Delete from @tEventss2

--			INSERT INTO [IO].[IN_UnderwritingEvent]
--			([IN_UnderwritingAccountID]
--			,[Date]
--			,[EventTypeID]
--			,[EffectiveStartDate]
--			,[EffectiveEndDate]
--			,[SingleEventValue]
--			,[CreatedBy]
--			,[CreatedDate]
--			,[UpdatedBy]
--			,[UpdatedDate])

--			OUTPUT inserted.IN_UnderwritingEventID INTO @tEventss2(tEventIDss2)

--			VALUES(
--			(Select Top 1 IN_UnderwritingAccountID from [IO].[IN_UnderwritingAccount] unAcc where unAcc.ClientNoteID = @NoteId),
--			@ImportDate,
--			(Select LookupID from CORE.Lookup where Name = 'StrippingSchedule'),
--			@ImportDate,
--			NULL,
--			NULL,
--			@UserName,
--			@CreatedUpdatedDate,
--			@UserName,
--			@CreatedUpdatedDate
--			)

--			SELECT @EventIDss2 = tEventIDss2 FROM @tEventss2; 

--			PRINT(@EventIDss2);
		   
--			INSERT INTO [IO].[IN_UnderwritingStrippingSchedule]
--           ([IN_UnderwritingEventID]
--           ,[StartDate]
--           ,[ValueTypeID]
--           ,[Value]
--           ,[CreatedBy]
--           ,[CreatedDate]
--           ,[UpdatedBy]
--           ,[UpdatedDate])

--			VALUES 
--			(@EventIDss2,
--			@ImportDate,
--			(Select LookupID from CORE.Lookup where Name = 'Origination Fee Strip'),
--			@OriginationFeePct  ,
--			@UserName,
--			@CreatedUpdatedDate,
--			@UserName,
--			@CreatedUpdatedDate
--			)
--		END
--		ELSE
--		BEGIN
		
--			UPDATE [IO].[IN_UnderwritingStrippingSchedule] SET
--					[Value] = @OriginationFeePct,
--					[UpdatedBy] = @UserName,
--					[UpdatedDate] =@CreatedUpdatedDate
--			WHERE IN_UnderwritingStrippingScheduleID = @L_IN_UnderwritingStrippingScheduleID

--		END
--	END
--END	--IF(@OriginationFeePct IS NOT NULL)

--SET @IN_UnderwritingStrippingScheduleEndTime = getdate();
------------------------------------------------------------------------------------------------



------------------PIK Schedule Insert/Update--------------------------------------------
IF(@CursorIndex = 0)BEGIN SET @IN_UnderwritingPikScheduleStartTime = getdate(); END
IF(@AccrualRate IS NOT NULL)
BEGIN


	IF(@FundingDate is null)
	Begin
		SET @ClosigDateAsEffDate = @ImportDate
	END
	ELSE
	BEGIN
		SET @ClosigDateAsEffDate = @FundingDate
	END


	IF NOT EXISTS(
			Select 
			pik.IN_UnderwritingPIKScheduleID,
			pik.AdditionalIntRate 
			from [IO].IN_UnderwritingPIKSchedule pik
			where IN_UnderwritingEventID in 
			(

				Select e.IN_UnderwritingEventID from [IO].[IN_UnderwritingEvent] e
				INNER JOIN 
						(
							Select eve.IN_UnderwritingAccountID,MAX(EffectiveStartDate) EffectiveStartDate from [IO].[IN_UnderwritingEvent] eve
							INNER JOIN [IO].[IN_UnderwritingNote] n ON n.IN_UnderwritingAccountID = eve.IN_UnderwritingAccountID
							INNER JOIN [IO].[IN_UnderwritingAccount] acc ON acc.IN_UnderwritingAccountID = n.IN_UnderwritingAccountID
							where EventTypeID = (Select LookupID from CORE.Lookup where Name = 'PIKSchedule')
							and n.ClientNoteID = @NoteId
							GROUP BY eve.IN_UnderwritingAccountID
						) sEvent

				ON sEvent.IN_UnderwritingAccountID = e.IN_UnderwritingAccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'PIKSchedule')
			)
			--and pik.[ValueTypeID] = (Select LookupID from CORE.Lookup where Name = 'Origination Fee Strip')
	)
	BEGIN

			DECLARE @tEventpik TABLE (tEventIDpik UNIQUEIDENTIFIER)
			Declare @EventIDpik uniqueidentifier;
			Delete from @tEventpik

			INSERT INTO [IO].[IN_UnderwritingEvent]
			([IN_UnderwritingAccountID]
			,[Date]
			,[EventTypeID]
			,[EffectiveStartDate]
			,[EffectiveEndDate]
			,[SingleEventValue]
			,[CreatedBy]
			,[CreatedDate]
			,[UpdatedBy]
			,[UpdatedDate])

			OUTPUT inserted.IN_UnderwritingEventID INTO @tEventpik(tEventIDpik)

			VALUES(
			(Select Top 1 IN_UnderwritingAccountID from [IO].[IN_UnderwritingAccount] unAcc where unAcc.ClientNoteID = @NoteId),
			@ImportDate,
			(Select LookupID from CORE.Lookup where Name = 'PIKSchedule'),
			@ClosigDateAsEffDate,
			NULL,
			NULL,
			@UserName,
			@CreatedUpdatedDate,
			@UserName,
			@CreatedUpdatedDate
			)

			SELECT @EventIDpik = tEventIDpik FROM @tEventpik; 

		   PRINT(@EventIDpik);

			INSERT INTO [IO].[IN_UnderwritingPIKSchedule]
           ([IN_UnderwritingEventID]
           ,[AdditionalIntRate]
           ,[StartDate]
           ,[EndDate]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])

			VALUES 
			(@EventIDpik,
			@AccrualRate,
			@ClosigDateAsEffDate,
			@ClosigDateAsEffDate,
			@UserName,
			@CreatedUpdatedDate,
			@UserName,
			@CreatedUpdatedDate
			)
	END
	ELSE
	BEGIN

		Declare @L_AccrualRate float;
		Declare @L_IN_UnderwritingPIKScheduleID uniqueidentifier;

		Select 
			@L_IN_UnderwritingPIKScheduleID = pik.IN_UnderwritingPIKScheduleID,
			@L_AccrualRate = pik.AdditionalIntRate 
			from [IO].IN_UnderwritingPIKSchedule pik
			where IN_UnderwritingEventID in 
			(

				Select e.IN_UnderwritingEventID from [IO].[IN_UnderwritingEvent] e
				INNER JOIN 
						(
							Select eve.IN_UnderwritingAccountID,MAX(EffectiveStartDate) EffectiveStartDate from [IO].[IN_UnderwritingEvent] eve
							INNER JOIN [IO].[IN_UnderwritingNote] n ON n.IN_UnderwritingAccountID = eve.IN_UnderwritingAccountID
							INNER JOIN [IO].[IN_UnderwritingAccount] acc ON acc.IN_UnderwritingAccountID = n.IN_UnderwritingAccountID
							where EventTypeID = (Select LookupID from CORE.Lookup where Name = 'PIKSchedule')
							and n.ClientNoteID = @NoteId
							GROUP BY eve.IN_UnderwritingAccountID
						) sEvent

				ON sEvent.IN_UnderwritingAccountID = e.IN_UnderwritingAccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate and EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'PIKSchedule')
			)
			--and pik.[ValueTypeID] = (Select LookupID from CORE.Lookup where Name = 'Origination Fee Strip')


		Declare @L_EffectiveDatePik Date;
			Select @L_EffectiveDatePik = MAX(EffectiveStartDate)  
			from [IO].[IN_UnderwritingEvent] eve
						INNER JOIN [IO].[IN_UnderwritingNote] n ON n.IN_UnderwritingAccountID = eve.IN_UnderwritingAccountID
						INNER JOIN [IO].[IN_UnderwritingAccount] acc ON acc.IN_UnderwritingAccountID = n.IN_UnderwritingAccountID
						where EventTypeID = (Select LookupID from CORE.Lookup where Name = 'PIKSchedule')
						and n.ClientNoteID = @NoteId
						GROUP BY eve.IN_UnderwritingAccountID

					

		IF(@AccrualRate != @L_AccrualRate and @ImportDate > @L_EffectiveDatePik )
		BEGIN
			 
			DECLARE @tEventpik2 TABLE (tEventIDpik2 UNIQUEIDENTIFIER)
			Declare @EventIDpik2 uniqueidentifier;
			Delete from @tEventpik2

			INSERT INTO [IO].[IN_UnderwritingEvent]
			([IN_UnderwritingAccountID]
			,[Date]
			,[EventTypeID]
			,[EffectiveStartDate]
			,[EffectiveEndDate]
			,[SingleEventValue]
			,[CreatedBy]
			,[CreatedDate]
			,[UpdatedBy]
			,[UpdatedDate])

			OUTPUT inserted.IN_UnderwritingEventID INTO @tEventpik2(tEventIDpik2)

			VALUES(
			(Select Top 1 IN_UnderwritingAccountID from [IO].[IN_UnderwritingAccount] unAcc where unAcc.ClientNoteID = @NoteId),
			@ImportDate,
			(Select LookupID from CORE.Lookup where Name = 'PIKSchedule'),
			@ClosigDateAsEffDate,
			NULL,
			NULL,
			@UserName,
			@CreatedUpdatedDate,
			@UserName,
			@CreatedUpdatedDate
			)

			SELECT @EventIDpik2 = tEventIDpik2 FROM @tEventpik2; 

		   

			INSERT INTO [IO].[IN_UnderwritingPIKSchedule]
           ([IN_UnderwritingEventID]
           ,[AdditionalIntRate]
           ,[StartDate]
           ,[EndDate]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])

			VALUES 
			(@EventIDpik2,
			@AccrualRate,
			@ClosigDateAsEffDate,
			@ClosigDateAsEffDate,
			@UserName,
			@CreatedUpdatedDate,
			@UserName,
			@CreatedUpdatedDate
			)
		END
		ELSE
		BEGIN
		
			UPDATE [IO].[IN_UnderwritingPIKSchedule] SET
					[AdditionalIntRate] = @AccrualRate,
					[UpdatedBy] = @UserName,
					[UpdatedDate] =@CreatedUpdatedDate
			WHERE IN_UnderwritingPIKScheduleID = @L_IN_UnderwritingPIKScheduleID

		END
	END
END	--IF(@AccrualRate IS NOT NULL)

SET @IN_UnderwritingPikScheduleEndTime = getdate();
----------------------------------------------------------------------------------------------

-------Insert/Update maturity "StatedMaturityDate"
IF(@StatedMaturityDate is not null)
	BEGIN
		Declare  @EventTypeMaturity  int  = (Select LookupID from CORE.Lookup where Name = 'Maturity');
	
		IF EXISTS(Select mat.IN_UnderwritingMaturityID from [IO].[IN_UnderwritingMaturity] mat INNER JOIN [IO].[IN_UnderwritingEvent] eve ON mat.IN_UnderwritingEventId = eve.IN_UnderwritingEventID INNER JOIN [IO].[IN_UnderwritingNote] n ON n.IN_UnderwritingAccountID = eve.IN_UnderwritingAccountID where EventTypeID = @EventTypeMaturity and n.ClientNoteID = @NoteId)
		BEGIN
		
			Declare @MaturityID UNIQUEIDENTIFIER;

			Select @MaturityID = mat.IN_UnderwritingMaturityID
			from [IO].[IN_UnderwritingMaturity] mat
			INNER JOIN [IO].[IN_UnderwritingEvent] e on e.IN_UnderwritingEventID = mat.IN_UnderwritingEventID
			INNER JOIN 
				(
						
					Select 
						(Select IN_UnderwritingAccountID from [IO].[IN_UnderwritingAccount] ac where ac.IN_UnderwritingAccountID = n.IN_UnderwritingAccountID) AccountID ,
						MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [IO].[IN_UnderwritingEvent] eve
						INNER JOIN [IO].[IN_UnderwritingNote] n ON n.IN_UnderwritingAccountID = eve.IN_UnderwritingAccountID
						INNER JOIN [IO].[IN_UnderwritingAccount] acc ON acc.IN_UnderwritingAccountID = n.IN_UnderwritingAccountID
						where EventTypeID = 11
						and n.ClientNoteID = @Noteid
						GROUP BY n.IN_UnderwritingAccountID,EventTypeID

				) sEvent
			ON sEvent.AccountID= e.IN_UnderwritingAccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID


			Update [IO].[IN_UnderwritingMaturity] set SelectedMaturityDate = @StatedMaturityDate where IN_UnderwritingMaturityID = @MaturityID

		END
		ELSE
		BEGIN
			 
			DECLARE @accountID UNIQUEIDENTIFIER;
			
			IF(@FundingDate is null)
			Begin
				SET @ClosigDateAsEffDate = @ImportDate
			END
			ELSE
			BEGIN
				SET @ClosigDateAsEffDate = @FundingDate
			END

			--Insert into event table
			DECLARE @tEventMat TABLE (tEventIDMat UNIQUEIDENTIFIER)
			Declare @EventIDMat uniqueidentifier;
			Delete from @tEventMat

			INSERT INTO [IO].[IN_UnderwritingEvent]
			([IN_UnderwritingAccountID]
			,[Date]
			,[EventTypeID]
			,[EffectiveStartDate]
			,[EffectiveEndDate]
			,[SingleEventValue]
			,[CreatedBy]
			,[CreatedDate]
			,[UpdatedBy]
			,[UpdatedDate])

			OUTPUT inserted.IN_UnderwritingEventID INTO @tEventMat(tEventIDMat)

			VALUES(
			(Select Top 1 IN_UnderwritingAccountID from [IO].[IN_UnderwritingAccount] unAcc where unAcc.ClientNoteID = @NoteId),
			@ImportDate,
			(Select LookupID from CORE.Lookup where Name = 'Maturity'),
			@ClosigDateAsEffDate,
			NULL,
			NULL,
			@UserName,
			@CreatedUpdatedDate,
			@UserName,
			@CreatedUpdatedDate
			)

			SELECT @EventIDMat = tEventIDMat FROM @tEventMat; 

			--Insert into Maturity table
			INSERT INTO [IO].[IN_UnderwritingMaturity](IN_UnderwritingEventId, SelectedMaturityDate, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
			VALUES 
			(@EventIDMat,
			@StatedMaturityDate,
			@UserName,
			@CreatedUpdatedDate,
			@UserName,
			@CreatedUpdatedDate
			)
		
		END
	END
--------------------------------

SET @CursorIndex += 1;


COMMIT TRAN
END TRY
BEGIN CATCH

	DECLARE @ErrorMessage NVARCHAR(4000);
	DECLARE @ErrorSeverity INT;
	DECLARE @ErrorState INT;

	SELECT @ErrorMessage = 'SQL error ' + ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();

	IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION;

	-- Use RAISERROR inside the CATCH block to return error
	-- information about the original error that caused
	-- execution to jump to the CATCH block.

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	  
END CATCH


FETCH NEXT FROM CursorDeal    
INTO @NoteId,@NoteName,@PaymentFreqDesc,@ControlId,@PaymentFreqCd,@FundingDate,@FirstPIPaymentDate,@StatedMaturityDate,@OrigLoanAmount,@OriginationFee,@AmortIOPeriod,@AmortizationTerm,@DeterminationDate,@DeterminationMethodDay,@RoundingType,@RoundingDenominator,@InterestSpread,@IntCalcMethodDesc,@OriginationFeePct,@AccrualRate,@TotalCommitment,@LiborFloor,@ExpectedMaturityDate,@ExtendedMaturityScenario1,@ExtendedMaturityScenario2,@ExtendedMaturityScenario3,@lienposition,@priority
END  




-----Manage BatchDetail---------------------------------------------------------------
DECLARE @CNT_RateSpreadSchedule INT;
DECLARE @CNT_StrippingSchedule INT;
DECLARE @CNT_PikSchedule INT;


SELECT @CNT_RateSpreadSchedule = COUNT(*)
FROM [IO].[IN_UnderwritingRateSpreadSchedule] rs
INNER JOIN [IO].[IN_UnderwritingEvent] eve ON eve.IN_UnderwritingEventID = rs.IN_UnderwritingEventID
INNER JOIN [IO].[IN_UnderwritingAccount] acc ON acc.IN_UnderwritingAccountID = eve.IN_UnderwritingAccountID
INNER JOIN [IO].[IN_UnderwritingNote] note ON note.IN_UnderwritingAccountID = acc.IN_UnderwritingAccountID
WHERE note.IN_UnderwritingNoteID in (select IN_UnderwritingNoteID from [IO].IN_UnderwritingNote where ClientDealID = @DealID)
and eve.EventTypeID = (Select LookupID from CORE.Lookup where Name = 'RateSpreadSchedule')
and rs.ValueTypeID = (Select LookupID from CORE.Lookup where Name = 'Spread')
 

SELECT @CNT_PikSchedule = COUNT(*)
FROM [IO].[IN_UnderwritingPikSchedule] pik
INNER JOIN [IO].[IN_UnderwritingEvent] eve ON eve.IN_UnderwritingEventID = pik.IN_UnderwritingEventID
INNER JOIN [IO].[IN_UnderwritingAccount] acc ON acc.IN_UnderwritingAccountID = eve.IN_UnderwritingAccountID
INNER JOIN [IO].[IN_UnderwritingNote] note ON note.IN_UnderwritingAccountID = acc.IN_UnderwritingAccountID
WHERE note.IN_UnderwritingNoteID in (select IN_UnderwritingNoteID from [IO].IN_UnderwritingNote where ClientDealID = @DealID)
and eve.EventTypeID = (Select LookupID from CORE.Lookup where Name = 'PikSchedule')


SELECT @CNT_StrippingSchedule = COUNT(*)
FROM [IO].[IN_UnderwritingStrippingSchedule] ss
INNER JOIN [IO].[IN_UnderwritingEvent] eve ON eve.IN_UnderwritingEventID = ss.IN_UnderwritingEventID
INNER JOIN [IO].[IN_UnderwritingAccount] acc ON acc.IN_UnderwritingAccountID = eve.IN_UnderwritingAccountID
INNER JOIN [IO].[IN_UnderwritingNote] note ON note.IN_UnderwritingAccountID = acc.IN_UnderwritingAccountID
WHERE note.IN_UnderwritingNoteID in (select IN_UnderwritingNoteID from [IO].IN_UnderwritingNote where ClientDealID = @DealID)
and eve.EventTypeID = (Select LookupID from CORE.Lookup where Name = 'StrippingSchedule')
and ss.ValueTypeID = (Select LookupID from CORE.Lookup where Name = 'Origination Fee Strip')


--INSERT IN BATCHDETAIL
INSERT INTO [IO].[BatchDetail]
           ([BatchLog_BatchLogID]
           ,[SourceTableName]
           ,[SourceRecordCount]
           ,[SourceCheckSumValue]
           ,[SourceStartTime]
           ,[SourceEndTime]
           ,[SourceErrorMessage]
           ,[DestinationTableName]
           ,[DestinationTableRecordCount]
           ,[DestinationTableCheckSumValue]
           ,[DestinationTableStartTime]
           ,[DestinationTableEndTime]
           ,[DestinationTableErrorMessage]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])



Select 
@BatchLogID as  BatchLog_BatchLogID,
'IN_UnderwritingDeal' as SourceTableName,
(Select COUNT(ClientDealID) from [IO].IN_UnderwritingDeal where ClientDealID = @DealID) as SourceRecordCount,
NULL as SourceCheckSumValue,
@IN_UnderwritingDealStartTime as SourceStartTime,
@IN_UnderwritingDealEndTime as SourceEndTime,
NULL as SourceErrorMessage,
NULL as DestinationTableName,
NULL as DestinationTableRecordCount,
NULL as DestinationTableCheckSumValue,
NULL as DestinationTableStartTime,
NULL as DestinationTableEndTime,
NULL as DestinationTableErrorMessage,
@UserName as CreatedBy,
GETDATE() as CreatedDate,
@UserName as UpdatedBy,
GETDATE() as UpdatedDate

UNION

Select 
@BatchLogID as  BatchLog_BatchLogID,
'IN_UnderwritingNote' as SourceTableName,
(Select COUNT(*) from [IO].IN_UnderwritingNote where ClientDealID = @DealID) as SourceRecordCount,
NULL as SourceCheckSumValue,
@IN_UnderwritingNoteStartTime as SourceStartTime,
@IN_UnderwritingNoteEndTime as SourceEndTime,
NULL as SourceErrorMessage,
NULL as DestinationTableName,
NULL as DestinationTableRecordCount,
NULL as DestinationTableCheckSumValue,
NULL as DestinationTableStartTime,
NULL as DestinationTableEndTime,
NULL as DestinationTableErrorMessage,
@UserName as CreatedBy,
GETDATE() as CreatedDate,
@UserName as UpdatedBy,
GETDATE() as UpdatedDate


UNION

Select 
@BatchLogID as  BatchLog_BatchLogID,
'IN_UnderwritingAccount' as SourceTableName,
(Select COUNT(*) FROM [IO].[IN_UnderwritingAccount] where IN_UnderwritingAccountID in (Select IN_UnderwritingAccountID from [IO].IN_UnderwritingNote where ClientDealID = @DealID) ) as SourceRecordCount,
NULL as SourceCheckSumValue,
@IN_UnderwritingAccountStartTime as SourceStartTime,
@IN_UnderwritingAccountEndTime as SourceEndTime,
NULL as SourceErrorMessage,
NULL as DestinationTableName,
NULL as DestinationTableRecordCount,
NULL as DestinationTableCheckSumValue,
NULL as DestinationTableStartTime,
NULL as DestinationTableEndTime,
NULL as DestinationTableErrorMessage,
@UserName as CreatedBy,
GETDATE() as CreatedDate,
@UserName as UpdatedBy,
GETDATE() as UpdatedDate


UNION

Select 
@BatchLogID as  BatchLog_BatchLogID,
'IN_UnderwritingRateSpreadSchedule' as SourceTableName,
@CNT_RateSpreadSchedule as SourceRecordCount,
NULL as SourceCheckSumValue,
@IN_UnderwritingRateSpreadScheduleStartTime as SourceStartTime,
@IN_UnderwritingRateSpreadScheduleEndTime as SourceEndTime,
NULL as SourceErrorMessage,
NULL as DestinationTableName,
NULL as DestinationTableRecordCount,
NULL as DestinationTableCheckSumValue,
NULL as DestinationTableStartTime,
NULL as DestinationTableEndTime,
NULL as DestinationTableErrorMessage,
@UserName as CreatedBy,
GETDATE() as CreatedDate,
@UserName as UpdatedBy,
GETDATE() as UpdatedDate

UNION

Select 
@BatchLogID as  BatchLog_BatchLogID,
'IN_UnderwritingStrippingSchedule' as SourceTableName,
@CNT_StrippingSchedule as SourceRecordCount,
NULL as SourceCheckSumValue,
@IN_UnderwritingStrippingScheduleStartTime as SourceStartTime,
@IN_UnderwritingStrippingScheduleEndTime as SourceEndTime,
NULL as SourceErrorMessage,
NULL as DestinationTableName,
NULL as DestinationTableRecordCount,
NULL as DestinationTableCheckSumValue,
NULL as DestinationTableStartTime,
NULL as DestinationTableEndTime,
NULL as DestinationTableErrorMessage,
@UserName as CreatedBy,
GETDATE() as CreatedDate,
@UserName as UpdatedBy,
GETDATE() as UpdatedDate


UNION

Select 
@BatchLogID as  BatchLog_BatchLogID,
'IN_UnderwritingPIKSchedule' as SourceTableName,
@CNT_PikSchedule as SourceRecordCount,
NULL as SourceCheckSumValue,
@IN_UnderwritingPikScheduleStartTime as SourceStartTime,
@IN_UnderwritingPikScheduleEndTime as SourceEndTime,
NULL as SourceErrorMessage,
NULL as DestinationTableName,
NULL as DestinationTableRecordCount,
NULL as DestinationTableCheckSumValue,
NULL as DestinationTableStartTime,
NULL as DestinationTableEndTime,
NULL as DestinationTableErrorMessage,
@UserName as CreatedBy,
GETDATE() as CreatedDate,
@UserName as UpdatedBy,
GETDATE() as UpdatedDate

 



END


