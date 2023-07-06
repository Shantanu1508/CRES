  

--'15-0050'  'Alden Park'
--'15-0480'	 '10 Jay Street'
--[dbo].[usp_ImportLandingtableToMainDB] '15-0006',''746FD15F-6DB3-4862-B578-7E40CCA95FB6'','51f000be-d881-463a-9bf9-5cc9422ff3a9'


CREATE PROCEDURE [dbo].[usp_ImportLandingtableToMainDB] --'15-0015',''746FD15F-6DB3-4862-B578-7E40CCA95FB6'','51f000be-d881-463a-9bf9-5cc9422ff3a9'
(
	@DealID nvarchar(256),
	@UserName nvarchar(256),
	@BatchLogID UNIQUEIDENTIFIER
)
AS
BEGIN


SET XACT_ABORT ON;

Declare @Active int= (Select lookupid from core.Lookup where name = 'Active' and parentid = 1);

Declare @LookupIdForNote int = (Select lookupid from core.Lookup where name = 'Note');
Declare @LookupIdForDeal int= (Select lookupid from core.Lookup where name = 'Deal');

Declare @ClosigDateAsEffDate date;

---Variable Declaration---------------------------
Declare @CreatedUpdatedDate dateTime = getdate();
Declare @ImportDate date = CONVERT(date,getdate());		--DAteAdd(day,1,getdate())

DECLARE @CursorIndex int = 0;

DECLARE @DealStartTime DATETIME;
DECLARE @DealEndTime DATETIME;
DECLARE @NoteStartTime DATETIME;
DECLARE @NoteEndTime DATETIME;

DECLARE @AccountStartTime DATETIME;
DECLARE @AccountEndTime DATETIME;

DECLARE @RateSpreadScheduleStartTime DATETIME;
DECLARE @RateSpreadScheduleEndTime DATETIME;
DECLARE @StrippingScheduleStartTime DATETIME;
DECLARE @StrippingScheduleEndTime DATETIME;
DECLARE @PikScheduleStartTime DATETIME;
DECLARE @PikScheduleEndTime DATETIME;
--------------------------------------------------
--DECLARE @DealID nvarchar(256) = (Select ClientDealID from [IO].IN_UnderwritingDeal  where dealname = @DealName) --Change



SET @DealStartTime = GETDATE();
--Insert Deal data
IF NOT EXISTS(Select * from [CRE].[Deal] where ClientDealID = @DealID and IsDeleted = 0)
BEGIN

	PRINT('INSERT DEAL');
	INSERT INTO [CRE].[Deal]
	([CREDealID],
	[ClientDealID],
	[DealName],
	[GeneratedBy],
	AssetManager,
	DealCity,
	DealState,
	DealPropertyType,
	TotalCommitment,
	FullyExtMaturityDate,
	[Status],
	AggregatedTotal,
	[CreatedBy],
	[CreatedDate],
	[UpdatedBy],
	[UpdatedDate],
	isDeleted)

	select 
	ClientDealID,
	ClientDealID,
	DealName,
	(Select LookupID from CORE.Lookup where Name = 'By BackShop'),
	AssetManager,
	DealCity,
	DealState,
	DealPropertyType,
	TotalCommitment,
	FullyExtMaturityDate,
	(Select lookupid from core.lookup where name = 'Active' and ParentID = 51),
	TotalCommitment,
	@UserName,
	@CreatedUpdatedDate,
	@UserName,
	@CreatedUpdatedDate  ,
	0 as isDeleted
	from [IO].IN_UnderwritingDeal  
	where ClientDealID = @DealID

	--Add Notification
	Declare @NewDealID Uniqueidentifier = (Select top 1 DealID from [CRE].[Deal] where ClientDealID = @DealID and isdeleted = 0)
	Exec [dbo].[usp_InsertUserNotification]  @UserName,'adddealbackshop',@NewDealID


END
ELSE
BEGIN
	PRINT('UPDATE DEAL');
	UPDATE [CRE].[Deal] SET 
	[CREDealID] = DealData.CREDealID,
	[ClientDealID] = DealData.ClientDealID,
	[DealName] = DealData.DealName,
	[GeneratedBy] = DealData.GeneratedBy,
	AssetManager = DealData.AssetManager,
	DealCity = DealData.DealCity,
	DealState = DealData.DealState,
	DealPropertyType = DealData.DealPropertyType,
	TotalCommitment = DealData.TotalCommitment,
	FullyExtMaturityDate = DealData.FullyExtMaturityDate,
	[Status] = (Select lookupid from core.lookup where name = 'Active' and ParentID = 51),
	AggregatedTotal = DealData.TotalCommitment,
	[UpdatedBy] = @UserName, 
	[UpdatedDate] = @CreatedUpdatedDate ,
	isDeleted = 0
	FROM
	(
		select 
		ClientDealID as CREDealID,
		ClientDealID,
		DealName,
		(Select LookupID from CORE.Lookup where Name = 'By BackShop') as GeneratedBy,
		AssetManager,
		DealCity,
		DealState,
		DealPropertyType,
		TotalCommitment,
		FullyExtMaturityDate 
		from [IO].IN_UnderwritingDeal  
		where ClientDealID = @DealID

	)DealData
	where [Deal].ClientDealID = @DealID
	and  [Deal].isdeleted = 0

	
	--Add Notification
	Declare @NewDealID1 Uniqueidentifier = (Select top 1 DealID from [CRE].[Deal] where ClientDealID = @DealID)
	Exec [dbo].[usp_InsertUserNotification]  @UserName,'editdealbackshop',@NewDealID1


END

SET @DealEndTime = GETDATE();


			------------------------------------------------------------------------------------
			DECLARE @EffectiveDateAccOrEventTypeWise TABLE 
			(IN_UnderwritingAccountID	UNIQUEIDENTIFIER,
			EffectiveStartDate	DATE,
			EventTypeName	Nvarchar(256),
			EventTypeID int)

			INSERT  INTO @EffectiveDateAccOrEventTypeWise (IN_UnderwritingAccountID,EffectiveStartDate,EventTypeName,EventTypeID)
			Select eve.IN_UnderwritingAccountID,MAX(EffectiveStartDate) EffectiveStartDate,l.name as EventTypeName,eve.EventTypeID from [IO].[IN_UnderwritingEvent] eve
			INNER JOIN [IO].[IN_UnderwritingNote] n ON n.IN_UnderwritingAccountID = eve.IN_UnderwritingAccountID
			INNER JOIN [IO].[IN_UnderwritingAccount] acc ON acc.IN_UnderwritingAccountID = n.IN_UnderwritingAccountID
			INNER JOIN [CORE].[LookUp] l ON l.lookupid = eve.EventTypeID
			GROUP BY eve.IN_UnderwritingAccountID,l.name,eve.EventTypeID
			------------------------------------------------------------------------------------


			Declare @LDealID uniqueidentifier;
			SELECT @LDealID = (Select DealID from [CRE].[Deal] where  ClientDealID = @DealID and IsDeleted = 0)
	

			--Deal Cursor-------------------------------------------------------
			Declare   @NoteId nvarchar(256);;
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
			
			Declare   @LiborFloor float ;
			Declare   @ExpectedMaturityDate date;
			Declare   @ExtendedMaturityScenario1 date;
			Declare   @ExtendedMaturityScenario2 date;
			Declare   @ExtendedMaturityScenario3 date;
			Declare   @TotalCommitment float ;
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
				note.ClientNoteId as NoteId,
				acc.Name as NoteName,
				--LPayFrequency.name as PaymentFreqDesc,
				NULL as PaymentFreqDesc,
				deal.clientdealid as ControlId,
				acc.PayFrequency as PaymentFreqCd,
				note.ClosingDate as FundingDate,
				note.FirstPaymentDate as FirstPIPaymentDate,
				note.SelectedMaturityDate as StatedMaturityDate,
				note.InitialFundingAmount as OrigLoanAmount,
				note.OriginationFee as OriginationFee,
				note.IOTerm as AmortIOPeriod,
				note.AmortTerm as AmortizationTerm,
				
				note.DeterminationDateReferenceDayoftheMonth  as DeterminationDate,
				note.DeterminationDateLeadDays as DeterminationMethodDay,

				LRoundingMethod.name as RoundingType,
				note.IndexRoundingRule as RoundingDenominator,

				(Select rs.value from [IO].IN_UnderwritingRateSpreadSchedule rs 
				INNER JOIN [IO].[IN_UnderwritingEvent] e ON e.IN_UnderwritingEventID = rs.IN_UnderwritingEventID
				INNER JOIN [IO].[IN_UnderwritingNote] n ON n.IN_UnderwritingAccountID = e.IN_UnderwritingAccountID
				INNER JOIN [IO].[IN_UnderwritingAccount] acc ON acc.IN_UnderwritingAccountID = n.IN_UnderwritingAccountID
				 WHERE 
				e.EventTypeID = (Select LookupID from CORE.Lookup where Name = 'RateSpreadSchedule')
				and rs.[ValueTypeID] = (Select LookupID from CORE.Lookup where Name = 'Spread')
				and  e.EffectiveStartDate = (SELECT temp.EffectiveStartDate FROM @EffectiveDateAccOrEventTypeWise temp where temp.IN_UnderwritingAccountID = acc.IN_UnderwritingAccountID and temp.EventTypeName = 'RateSpreadSchedule')
				and n.ClientNoteID = note.ClientNoteID ) as InterestSpread,


				(Select name from CORE.[LookUp] where lookupid = (Select rs.IntCalcMethodID from [IO].IN_UnderwritingRateSpreadSchedule rs 
				INNER JOIN [IO].[IN_UnderwritingEvent] e ON e.IN_UnderwritingEventID = rs.IN_UnderwritingEventID
				INNER JOIN [IO].[IN_UnderwritingNote] n ON n.IN_UnderwritingAccountID = e.IN_UnderwritingAccountID
				INNER JOIN [IO].[IN_UnderwritingAccount] acc ON acc.IN_UnderwritingAccountID = n.IN_UnderwritingAccountID
				 WHERE 
				e.EventTypeID = (Select LookupID from CORE.Lookup where Name = 'RateSpreadSchedule')
				and rs.[ValueTypeID] = (Select LookupID from CORE.Lookup where Name = 'Spread')
				and  e.EffectiveStartDate = (SELECT temp.EffectiveStartDate FROM @EffectiveDateAccOrEventTypeWise temp where temp.IN_UnderwritingAccountID = acc.IN_UnderwritingAccountID and temp.EventTypeName = 'RateSpreadSchedule')
				and n.ClientNoteID = note.ClientNoteID )) as IntCalcMethodDesc,

				(Select ss.Value from [IO].IN_UnderwritingStrippingSchedule ss 
				INNER JOIN [IO].[IN_UnderwritingEvent] e ON e.IN_UnderwritingEventID = ss.IN_UnderwritingEventID
				INNER JOIN [IO].[IN_UnderwritingNote] n ON n.IN_UnderwritingAccountID = e.IN_UnderwritingAccountID
				INNER JOIN [IO].[IN_UnderwritingAccount] acc ON acc.IN_UnderwritingAccountID = n.IN_UnderwritingAccountID
				 WHERE 
				e.EventTypeID = (Select LookupID from CORE.Lookup where Name = 'StrippingSchedule')
				and ss.[ValueTypeID] = (Select LookupID from CORE.Lookup where Name = 'Origination Fee Strip')
				and  e.EffectiveStartDate = (SELECT temp.EffectiveStartDate FROM @EffectiveDateAccOrEventTypeWise temp where temp.IN_UnderwritingAccountID = acc.IN_UnderwritingAccountID and temp.EventTypeName = 'StrippingSchedule')
				and n.ClientNoteID = note.ClientNoteID ) as OriginationFeePct,

				(Select pik.AdditionalIntRate from [IO].IN_UnderwritingPIKSchedule pik 
				INNER JOIN [IO].[IN_UnderwritingEvent] e ON e.IN_UnderwritingEventID = pik.IN_UnderwritingEventID
				INNER JOIN [IO].[IN_UnderwritingNote] n ON n.IN_UnderwritingAccountID = e.IN_UnderwritingAccountID
				INNER JOIN [IO].[IN_UnderwritingAccount] acc ON acc.IN_UnderwritingAccountID = n.IN_UnderwritingAccountID
				 WHERE 
				e.EventTypeID = (Select LookupID from CORE.Lookup where Name = 'PIKSchedule')
				--and ss.[ValueTypeID] = (Select LookupID from CORE.Lookup where Name = 'Origination Fee Strip')
				and  e.EffectiveStartDate = (SELECT temp.EffectiveStartDate FROM @EffectiveDateAccOrEventTypeWise temp where temp.IN_UnderwritingAccountID = acc.IN_UnderwritingAccountID and temp.EventTypeName = 'PIKSchedule')
				and n.ClientNoteID = note.ClientNoteID ) as AccrualRate,

				
				(Select rs.value from [IO].IN_UnderwritingRateSpreadSchedule rs 
				INNER JOIN [IO].[IN_UnderwritingEvent] e ON e.IN_UnderwritingEventID = rs.IN_UnderwritingEventID
				INNER JOIN [IO].[IN_UnderwritingNote] n ON n.IN_UnderwritingAccountID = e.IN_UnderwritingAccountID
				INNER JOIN [IO].[IN_UnderwritingAccount] acc ON acc.IN_UnderwritingAccountID = n.IN_UnderwritingAccountID
				 WHERE 
				e.EventTypeID = (Select LookupID from CORE.Lookup where Name = 'RateSpreadSchedule')
				and rs.[ValueTypeID] = (Select LookupID from CORE.Lookup where Name = 'Index Floor')
				and  e.EffectiveStartDate = (SELECT temp.EffectiveStartDate FROM @EffectiveDateAccOrEventTypeWise temp where temp.IN_UnderwritingAccountID = acc.IN_UnderwritingAccountID and temp.EventTypeName = 'RateSpreadSchedule')
				and n.ClientNoteID = note.ClientNoteID ) as LiborFloor,
				

				note.ExpectedMaturityDate,
				--note.ExtendedMaturityScenario1,
				--note.ExtendedMaturityScenario2,
				--note.ExtendedMaturityScenario3,
				note.TotalCommitment,
				note.lienposition,
				note.[priority]

				from [IO].IN_UnderwritingDeal deal
				INNER JOIN [IO].IN_UnderwritingNote note ON note.IN_UnderwritingDealID = deal.IN_UnderwritingDealID
				INNER JOIN [IO].IN_UnderwritingAccount acc ON acc.IN_UnderwritingAccountID = note.IN_UnderwritingAccountID
				--LEFT JOIN [CORE].[LookUp] LPayFrequency ON LPayFrequency.lookupid = acc.PayFrequency
				LEFT JOIN [CORE].[LookUp] LRoundingMethod ON LRoundingMethod.lookupid = note.RoundingMethod

				WHERE deal.ClientDealID = @DealID --and note.Clientnoteid = @NoteId
			)
			OPEN CursorDeal     
			FETCH NEXT FROM CursorDeal    
			INTO @NoteId,@NoteName,@PaymentFreqDesc,@ControlId,@PaymentFreqCd,@FundingDate,@FirstPIPaymentDate,@StatedMaturityDate,@OrigLoanAmount,@OriginationFee,@AmortIOPeriod,@AmortizationTerm,@DeterminationDate,@DeterminationMethodDay,@RoundingType,@RoundingDenominator,@InterestSpread,@IntCalcMethodDesc,@OriginationFeePct,@AccrualRate,@LiborFloor,@ExpectedMaturityDate,@ExtendedMaturityScenario1,@ExtendedMaturityScenario2,@ExtendedMaturityScenario3,@TotalCommitment,@lienposition,@priority
			WHILE @@FETCH_STATUS = 0    
			BEGIN  


			BEGIN TRY
			BEGIN TRAN

			--Declare @accid UNIQUEIDENTIFIER = (Select Top 1 AccountID from [CORE].[Account] unAcc where unAcc.ClientNoteID = @NoteId and IsDeleted = 0)
			--Declare @NoteIdUnique UNIQUEIDENTIFIER = (Select NoteID from cre.note n inner join core.Account acc on n.Account_AccountID = acc.AccountID where n.ClientNoteID = @NoteId and acc.IsDeleted = 0)
			 
			------------------Account Insert/Update--------------------------------------------
			IF(@CursorIndex = 0)BEGIN SET @AccountStartTime = getdate(); END

			IF NOT EXISTS(Select * from [CORE].[Account] where ClientNoteID = @NoteId  and IsDeleted = 0)
			BEGIN

			PRINT('INSERT ACCOUNT');
					--Insert Account(Note) data
					INSERT INTO [CORE].[Account]
							   ([ClientNoteID]
							   ,[Name]
							   ,[PayFrequency]
							   ,[AccountTypeID]
							   ,[CreatedBy]
							   ,[CreatedDate]
							   ,[UpdatedBy]
							   ,[UpdatedDate]
							   ,isDeleted)
					Values(
						@NoteId,
						@NoteName, 
						@PaymentFreqCd,
						--(Select LookupID from CORE.Lookup where Name = @PaymentFreqDesc),
						(Select LookUpID from CORE.lookup where name = 'Note'),
						@UserName,
						@CreatedUpdatedDate,
						@UserName,
						@CreatedUpdatedDate ,
						0
					)
			END
			ELSE
			BEGIN

			PRINT('UPDATE ACCOUNT');
				UPDATE [CORE].[Account] set 
				isDeleted = 0,
				--[PayFrequency] = (Select LookupID from CORE.Lookup where Name = @PaymentFreqDesc) 
				[PayFrequency] = @PaymentFreqCd
				where ClientNoteID = @NoteId
				and IsDeleted = 0
			END
			
			SET @AccountEndTime = getdate();
			------------------------------------------------------------------------------------

			------------------Note Insert/Update--------------------------------------------

			IF(@CursorIndex = 0)BEGIN SET @NoteStartTime = getdate(); END

			IF NOT EXISTS(Select * from [CRE].[Note] n inner join core.Account acc on n.Account_AccountID=acc.AccountID where n.ClientNoteID = @NoteId and acc.IsDeleted =0 )
			BEGIN


			PRINT('INSERT NOTE');
				--Insert Note data
				INSERT INTO [CRE].[Note]
					([Account_AccountID]
					,CRENoteID
					,[DealID]
					,[ClientNoteID]
					--,[ClientDealID]
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
					,[GeneratedBy]
					,ExpectedMaturityDate
					--,ExtendedMaturityScenario1
					--,ExtendedMaturityScenario2
					--,ExtendedMaturityScenario3
					,lienposition 
					,[priority]
					,[CreatedBy]
					,[CreatedDate]
					,[UpdatedBy]
					,[UpdatedDate])
		
					VALUES(
					(Select Top 1 AccountID from [CORE].[Account] unAcc where unAcc.ClientNoteID = @NoteId and IsDeleted = 0),
					@NoteId,
					@LDealID,
					@NoteId ,
					--@ControlId ,
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
					(Select LookupID from CORE.Lookup where Name = 'By BackShop'),
					@ExpectedMaturityDate,
					--@ExtendedMaturityScenario1,
					--@ExtendedMaturityScenario2,
					--@ExtendedMaturityScenario3,
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
	
					PRINT('UPDATE NOTE');
					Update [CRE].[Note] SET
					[ClosingDate]  = @FundingDate ,
					[FirstPaymentDate]  = @FirstPIPaymentDate ,
					[SelectedMaturityDate]  = @StatedMaturityDate ,
					[InitialFundingAmount]  = @OrigLoanAmount ,
					[OriginationFee]  = @OriginationFee ,
					[IOTerm]  = @AmortIOPeriod ,
					[AmortTerm]  = @AmortizationTerm ,
					[DeterminationDateLeadDays]  = @DeterminationMethodDay,
					[DeterminationDateReferenceDayoftheMonth]  =  @DeterminationDate,
					[RoundingMethod]  = (Select LookupID from CORE.Lookup where Name = @RoundingType),
					[IndexRoundingRule]  = @RoundingDenominator,
					ExpectedMaturityDate	 = 	@ExpectedMaturityDate,
					--ExtendedMaturityScenario1	 = 	@ExtendedMaturityScenario1,
					--ExtendedMaturityScenario2	 = 	@ExtendedMaturityScenario2,
					--ExtendedMaturityScenario3	 = 	@ExtendedMaturityScenario3,
					lienposition = @lienposition,
					[priority] = @priority,
					[UpdatedBy]  = @UserName,
					[UpdatedDate]  = @CreatedUpdatedDate					
					--WHERE [ClientNoteID] = @NoteId
					WHERE [NoteID] in (Select NoteID from cre.note n inner join core.Account acc on n.Account_AccountID = acc.AccountID where n.ClientNoteID = @NoteId and acc.IsDeleted = 0)
					 
			END

			SET @NoteEndTime = GETDATE();
			------------------------------------------------------------------------------------


------------------RateSpread Insert/Update--------------------------------------------
IF(@CursorIndex = 0)BEGIN SET @RateSpreadScheduleStartTime = getdate(); END

--IF(@InterestSpread IS NOT NULL)
--BEGIN


--	IF NOT EXISTS(
--			Select 
--			RateSpreadScheduleID,
--			rs.Value 
--			from [CORE].RateSpreadSchedule rs
--			where EventID in 
--			(

--				Select e.EventID from [CORE].[Event] e
--				INNER JOIN 
--						(
--							--Select eve.AccountID,MAX(EffectiveStartDate) EffectiveStartDate from [CORE].[Event] eve
--							--INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
--							--INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
--							--where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'RateSpreadSchedule')
--							--and n.ClientNoteID = @NoteId
--							--GROUP BY eve.AccountID

--							Select 
--							(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
--							MAX(EffectiveStartDate) EffectiveStartDate from [CORE].[Event] eve
--							INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
--							INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
--							where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'RateSpreadSchedule')
--							and n.ClientNoteID = @NoteId
--							GROUP BY n.Account_AccountID


--						) sEvent

--				ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate and EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'RateSpreadSchedule')
--			)
--			and rs.[ValueTypeID] = (Select LookupID from CORE.Lookup where Name = 'Spread')
--	)
--	BEGIN

--			DECLARE @tEvent TABLE (tEventID UNIQUEIDENTIFIER)
--			Declare @EventID uniqueidentifier;
--			Delete from @tEvent

--			PRINT('INSERT EVENT FOR RATE SPREAD');

--			IF(@FundingDate is null)
--			Begin
--				SET @ClosigDateAsEffDate = @ImportDate
--			END
--			ELSE
--			BEGIN
--				SET @ClosigDateAsEffDate = @FundingDate
--			END


--			INSERT INTO [CORE].[Event]
--			([AccountID]
--			,[Date]
--			,[EventTypeID]
--			,[EffectiveStartDate]
--			,[EffectiveEndDate]
--			,[SingleEventValue]
--			,[CreatedBy]
--			,[CreatedDate]
--			,[UpdatedBy]
--			,[UpdatedDate])

--			OUTPUT inserted.EventID INTO @tEvent(tEventID)

--			VALUES(
--			(Select Top 1 AccountID from [CORE].[Account] unAcc where unAcc.ClientNoteID = @NoteId),
--			@ImportDate,
--			(Select LookupID from CORE.Lookup where Name = 'RateSpreadSchedule'),
--			@ClosigDateAsEffDate,
--			NULL,
--			NULL,
--			@UserName,
--			@CreatedUpdatedDate,
--			@UserName,
--			@CreatedUpdatedDate
--			)

--			SELECT @EventID = tEventID FROM @tEvent; 

--		   PRINT('INSERT RATE SPREAD');
--			INSERT INTO [CORE].[RateSpreadSchedule]
--					([EventID]
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
--			@InterestSpread,
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
--		Declare @L_RateSpreadScheduleID uniqueidentifier;

--		Select 
--		@L_RateSpreadScheduleID = RateSpreadScheduleID,
--		@L_InterestSpread = rs.Value 
--		from [CORE].RateSpreadSchedule rs
--		where EventID in 
--		(

--			Select e.EventID from [CORE].[Event] e
--			INNER JOIN 
--					(
--						--Select eve.AccountID,MAX(EffectiveStartDate) EffectiveStartDate from [CORE].[Event] eve
--						--INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
--						--INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
--						--where EventTypeID = (Select LookupID from CORE.Lookup where Name = 'RateSpreadSchedule')
--						--and n.ClientNoteID = @NoteId
--						--GROUP BY eve.AccountID
--						Select 
--							(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
--							MAX(EffectiveStartDate) EffectiveStartDate from [CORE].[Event] eve
--							INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
--							INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
--							where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'RateSpreadSchedule')
--							and n.ClientNoteID = @NoteId
--							GROUP BY n.Account_AccountID

--					) sEvent

--			ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'RateSpreadSchedule')
--		)
--		and rs.[ValueTypeID] = (Select LookupID from CORE.Lookup where Name = 'Spread')


--		Declare @L_EffectiveDate Date;
--			Select @L_EffectiveDate = MAX(EffectiveStartDate)  
--			from [CORE].[Event] eve
--						INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
--						INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
--						where EventTypeID = (Select LookupID from CORE.Lookup where Name = 'RateSpreadSchedule')
--						and n.ClientNoteID = @NoteId
						

					

--		IF(@InterestSpread != @L_InterestSpread and @ImportDate > @L_EffectiveDate )
--		BEGIN
			 
--			DECLARE @tEvent2 TABLE (tEventID2 UNIQUEIDENTIFIER)
--			Declare @EventID2 uniqueidentifier;
--			Delete from @tEvent2


--			PRINT('INSERT EVENT FOR RATE SPREAD');
--			INSERT INTO [CORE].[Event]
--			([AccountID]
--			,[Date]
--			,[EventTypeID]
--			,[EffectiveStartDate]
--			,[EffectiveEndDate]
--			,[SingleEventValue]
--			,[CreatedBy]
--			,[CreatedDate]
--			,[UpdatedBy]
--			,[UpdatedDate])

--			OUTPUT inserted.EventID INTO @tEvent2(tEventID2)

--			VALUES(
--			(Select Top 1 AccountID from [CORE].[Account] unAcc where unAcc.ClientNoteID = @NoteId),
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

--		   PRINT('INSERT RATE SPREAD');
--			INSERT INTO [CORE].[RateSpreadSchedule]
--					([EventID]
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
--			@InterestSpread,
--			(Select LookupID from CORE.Lookup where Name = @IntCalcMethodDesc),
--			@UserName,
--			@CreatedUpdatedDate,
--			@UserName,
--			@CreatedUpdatedDate
--			)
--		END
--		ELSE
--		BEGIN
		
--		PRINT('UPDATE RATE SPREAD');
--			UPDATE [CORE].[RateSpreadSchedule] SET
--					[Value] = @InterestSpread,
--					[IntCalcMethodID] = (Select LookupID from CORE.[Lookup] where Name = @IntCalcMethodDesc),
--					[UpdatedBy] = @UserName,
--					[UpdatedDate] =@CreatedUpdatedDate
--			WHERE RateSpreadScheduleID = @L_RateSpreadScheduleID

--		END
--	END

--END


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
			RateSpreadScheduleID,
			rs.Value 
			from [CORE].RateSpreadSchedule rs
			where EventID in 
			(

				Select e.EventID from [CORE].[Event] e
				INNER JOIN 
						(
							Select eve.AccountID,MAX(EffectiveStartDate) EffectiveStartDate from [CORE].[Event] eve
							INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
							INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
							where EventTypeID = (Select LookupID from CORE.Lookup where Name = 'RateSpreadSchedule')
							and n.ClientNoteID = @NoteId and acc.IsDeleted = 0
							GROUP BY eve.AccountID
						) sEvent

				ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate and EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'RateSpreadSchedule')
			)
			--and rs.[ValueTypeID] = (Select LookupID from CORE.Lookup where Name = 'Spread')
	)
	BEGIN

			DECLARE @tEvent TABLE (tEventID UNIQUEIDENTIFIER)
			Declare @EventID uniqueidentifier;
			Delete from @tEvent

			INSERT INTO [CORE].[Event]
			([AccountID]
			,[Date]
			,[EventTypeID]
			,[EffectiveStartDate]
			,[EffectiveEndDate]
			,[SingleEventValue]
			,[StatusID]
			,[CreatedBy]
			,[CreatedDate]
			,[UpdatedBy]
			,[UpdatedDate])

			OUTPUT inserted.EventID INTO @tEvent(tEventID)

			VALUES(
			(Select Top 1 AccountID from [CORE].[Account] unAcc where unAcc.ClientNoteID = @NoteId  and unAcc.IsDeleted = 0),
			@ImportDate,
			(Select LookupID from CORE.Lookup where Name = 'RateSpreadSchedule'),
			@ClosigDateAsEffDate,
			NULL,
			NULL,
			@Active,
			@UserName,
			@CreatedUpdatedDate,
			@UserName,
			@CreatedUpdatedDate
			)

			SELECT @EventID = tEventID FROM @tEvent; 

			IF(@InterestSpread is not null)
			begin 
				INSERT INTO [CORE].[RateSpreadSchedule]([EventID],[Date],[ValueTypeID],[Value],[IntCalcMethodID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
				VALUES (@EventID,@ClosigDateAsEffDate,(Select LookupID from CORE.Lookup where Name = 'Spread'),@InterestSpread  ,(Select LookupID from CORE.Lookup where Name = @IntCalcMethodDesc),@UserName,@CreatedUpdatedDate,@UserName,@CreatedUpdatedDate)
			END
			IF(@LiborFloor is not null)
			begin 
				INSERT INTO [CORE].[RateSpreadSchedule]([EventID],[Date],[ValueTypeID],[Value],[IntCalcMethodID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
				VALUES (@EventID,@ClosigDateAsEffDate,(Select LookupID from CORE.Lookup where Name = 'Index Floor'),@LiborFloor ,(Select LookupID from CORE.Lookup where Name = @IntCalcMethodDesc),@UserName,@CreatedUpdatedDate,@UserName,@CreatedUpdatedDate)
			END
	END
	ELSE
	BEGIN

		Declare @L_InterestSpreadPlusLiborFloor float;
		--Declare @L_RateSpreadScheduleID uniqueidentifier;

		Select 
		@L_InterestSpreadPlusLiborFloor = SUM(ABS(ISNULL(rs.Value,0)))
		from [Core].RateSpreadSchedule rs
		where EventID in 
		(

			Select e.EventID from [Core].[Event] e
			INNER JOIN 
					(
						Select eve.AccountID,MAX(EffectiveStartDate) EffectiveStartDate from [Core].[Event] eve
						INNER JOIN [Cre].[Note] n ON n.Account_AccountID = eve.AccountID
						INNER JOIN [Core].[Account] acc ON acc.AccountID = n.Account_AccountID
						where EventTypeID = (Select LookupID from CORE.Lookup where Name = 'RateSpreadSchedule')
						and n.ClientNoteID = @NoteId and  acc.IsDeleted = 0
						GROUP BY eve.AccountID
					) sEvent

			ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate and EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'RateSpreadSchedule')
		)
		and rs.[ValueTypeID] in (Select LookupID from CORE.Lookup where Name in ('Spread','Index Floor'))


		Declare @L_EffectiveDate Date;
			Select @L_EffectiveDate = MAX(EffectiveStartDate)  
			from [Core].[Event] eve
						INNER JOIN [Cre].[Note] n ON n.Account_AccountID = eve.AccountID
						INNER JOIN [Core].[Account] acc ON acc.AccountID = n.Account_AccountID
						where EventTypeID = (Select LookupID from CORE.Lookup where Name = 'RateSpreadSchedule')
						and n.ClientNoteID = @NoteId and acc.IsDeleted = 0
						GROUP BY eve.AccountID

					
		Declare @BAckshopSpreadPlusLiborFloor decimal;
		SET @BAckshopSpreadPlusLiborFloor = ABS(ISnull(@InterestSpread,0)) + ABS(ISnull(@LiborFloor,0))
		

		IF(@BAckshopSpreadPlusLiborFloor != @L_InterestSpreadPlusLiborFloor and @ImportDate > @L_EffectiveDate )
		BEGIN
			 
			DECLARE @tEvent2 TABLE (tEventID2 UNIQUEIDENTIFIER)
			Declare @EventID2 uniqueidentifier;
			Delete from @tEvent2

			INSERT INTO [Core].[Event]
			([AccountID]
			,[Date]
			,[EventTypeID]
			,[EffectiveStartDate]
			,[EffectiveEndDate]
			,[SingleEventValue]
			,[StatusID]
			,[CreatedBy]
			,[CreatedDate]
			,[UpdatedBy]
			,[UpdatedDate])

			OUTPUT inserted.EventID INTO @tEvent2(tEventID2)

			VALUES(
			(Select Top 1 AccountID from [Core].[Account] unAcc where unAcc.ClientNoteID = @NoteId and unAcc.IsDeleted = 0),
			@ImportDate,
			(Select LookupID from CORE.Lookup where Name = 'RateSpreadSchedule'),
			@ImportDate,
			NULL,
			NULL,
			@Active,
			@UserName,			
			@CreatedUpdatedDate,
			@UserName,
			@CreatedUpdatedDate
			)

			SELECT @EventID2 = tEventID2 FROM @tEvent2; 

		   
			IF(@InterestSpread is not null)
			begin 
				INSERT INTO [Core].[RateSpreadSchedule]([EventID],[Date],[ValueTypeID],[Value],[IntCalcMethodID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
				VALUES (@EventID2,@ClosigDateAsEffDate,(Select LookupID from CORE.Lookup where Name = 'Spread'),@InterestSpread  ,(Select LookupID from CORE.Lookup where Name = @IntCalcMethodDesc),@UserName,@CreatedUpdatedDate,@UserName,@CreatedUpdatedDate)
			END
			IF(@LiborFloor is not null)
			begin 
				INSERT INTO [Core].[RateSpreadSchedule]([EventID],[Date],[ValueTypeID],[Value],[IntCalcMethodID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
				VALUES (@EventID2,@ClosigDateAsEffDate,(Select LookupID from CORE.Lookup where Name = 'Index Floor'),@LiborFloor ,(Select LookupID from CORE.Lookup where Name = @IntCalcMethodDesc),@UserName,@CreatedUpdatedDate,@UserName,@CreatedUpdatedDate)
			END

		END
		ELSE
		BEGIN
			Declare @L_IN_UnderRSScheduleIDSpread uniqueidentifier;
			Declare @L_IN_UnderRSScheduleIDLibor uniqueidentifier;

				Select 
				@L_IN_UnderRSScheduleIDSpread = rs.RateSpreadScheduleID
				from [Core].RateSpreadSchedule rs
				where EventID in 
				(

				Select e.EventID from [Core].[Event] e
				INNER JOIN 
						(
							Select eve.AccountID,MAX(EffectiveStartDate) EffectiveStartDate from [Core].[Event] eve
							INNER JOIN [Cre].[Note] n ON n.Account_AccountID = eve.AccountID
							INNER JOIN [Core].[Account] acc ON acc.AccountID = n.Account_AccountID
							where EventTypeID = (Select LookupID from CORE.Lookup where Name = 'RateSpreadSchedule')
							and n.ClientNoteID = @NoteId and acc.IsDeleted = 0
							GROUP BY eve.AccountID
						) sEvent

				ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate and EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'RateSpreadSchedule')
				)
				and rs.[ValueTypeID] in (Select LookupID from CORE.Lookup where Name in ('Spread'))
				-------------------------
				Select 
				@L_IN_UnderRSScheduleIDLibor = rs.RateSpreadScheduleID
				from [Core].RateSpreadSchedule rs
				where EventID in 
				(

				Select e.EventID from [Core].[Event] e
				INNER JOIN 
						(
							Select eve.AccountID,MAX(EffectiveStartDate) EffectiveStartDate from [Core].[Event] eve
							INNER JOIN [Cre].[Note] n ON n.Account_AccountID = eve.AccountID
							INNER JOIN [Core].[Account] acc ON acc.AccountID = n.Account_AccountID
							where EventTypeID = (Select LookupID from CORE.Lookup where Name = 'RateSpreadSchedule')
							and n.ClientNoteID = @NoteId and acc.IsDeleted = 0
							GROUP BY eve.AccountID
						) sEvent

				ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate and EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'RateSpreadSchedule')
				)
				and rs.[ValueTypeID] in (Select LookupID from CORE.Lookup where Name in ('Index Floor'))


			UPDATE [Core].[RateSpreadSchedule] SET
					[Value] = @InterestSpread,
					[IntCalcMethodID] = (Select LookupID from CORE.Lookup where Name = @IntCalcMethodDesc),
					[UpdatedBy] = @UserName,
					[UpdatedDate] =@CreatedUpdatedDate
			WHERE RateSpreadScheduleID = @L_IN_UnderRSScheduleIDSpread


			UPDATE [Core].[RateSpreadSchedule] SET
					[Value] = @LiborFloor,
					[IntCalcMethodID] = (Select LookupID from CORE.Lookup where Name = @IntCalcMethodDesc),
					[UpdatedBy] = @UserName,
					[UpdatedDate] =@CreatedUpdatedDate
			WHERE RateSpreadScheduleID = @L_IN_UnderRSScheduleIDLibor

		END
	END

END

SET @RateSpreadScheduleEndTime = getdate(); 
------------------------------------------------------------------------------------

--------------------Stripping Schedule Insert/Update----------------------------------------------
--IF(@CursorIndex = 0)BEGIN SET @StrippingScheduleStartTime = getdate(); END

--IF(@OriginationFeePct IS NOT NULL)
--BEGIN


--	IF NOT EXISTS(
--			Select 
--			StrippingScheduleID,
--			ss.Value 
--			from [CORE].StrippingSchedule ss
--			where EventID in 
--			(

--				Select e.EventID from [CORE].[Event] e
--				INNER JOIN 
--						(
--							--Select eve.AccountID,MAX(EffectiveStartDate) EffectiveStartDate from [CORE].[Event] eve
--							--INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
--							--INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
--							--where EventTypeID = (Select LookupID from CORE.Lookup where Name = 'StrippingSchedule')
--							--and n.ClientNoteID = @NoteId
--							--GROUP BY eve.AccountID


--							Select 
--							(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
--							MAX(EffectiveStartDate) EffectiveStartDate from [CORE].[Event] eve
--							INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
--							INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
--							where EventTypeID = (Select LookupID from CORE.Lookup where Name = 'StrippingSchedule')
--							and n.ClientNoteID = @NoteId
--							GROUP BY n.Account_AccountID

--						) sEvent

--				ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate and EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'StrippingSchedule')
--			)
--			and ss.[ValueTypeID] = (Select LookupID from CORE.Lookup where Name = 'Origination Fee Strip')
--	)
--	BEGIN

--			DECLARE @tEventss TABLE (tEventIDss UNIQUEIDENTIFIER)
--			Declare @EventIDss uniqueidentifier;
--			Delete from @tEventss

--			PRINT('INSERT EVENT FOR STRIPPING SCHEDULE');

--			IF(@FundingDate is null)
--			Begin
--				SET @ClosigDateAsEffDate = @ImportDate
--			END
--			ELSE
--			BEGIN
--				SET @ClosigDateAsEffDate = @FundingDate
--			END

--			INSERT INTO [CORE].[Event]
--			([AccountID]
--			,[Date]
--			,[EventTypeID]
--			,[EffectiveStartDate]
--			,[EffectiveEndDate]
--			,[SingleEventValue]
--			,[CreatedBy]
--			,[CreatedDate]
--			,[UpdatedBy]
--			,[UpdatedDate])

--			OUTPUT inserted.EventID INTO @tEventss(tEventIDss)

--			VALUES(
--			(Select Top 1 AccountID from [CORE].[Account] unAcc where unAcc.ClientNoteID = @NoteId),
--			@ImportDate,
--			(Select LookupID from CORE.Lookup where Name = 'StrippingSchedule'),
--			@ClosigDateAsEffDate,
--			NULL,
--			NULL,
--			@UserName,
--			@CreatedUpdatedDate,
--			@UserName,
--			@CreatedUpdatedDate
--			)

--			SELECT @EventIDss = tEventIDss FROM @tEventss; 

--		   PRINT(@EventIDss);

--		   PRINT('INSERT STRIPPING SCHEDULE');
--			INSERT INTO [CORE].[StrippingSchedule]
--           ([EventID]
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
--		Declare @L_StrippingScheduleID uniqueidentifier;

--		Select 
--			@L_StrippingScheduleID = StrippingScheduleID,
--			@L_OriginationFeePct = ss.Value 
--			from [CORE].StrippingSchedule ss
--			where EventID in 
--			(

--				Select e.EventID from [CORE].[Event] e
--				INNER JOIN 
--						(
--							--Select eve.AccountID,MAX(EffectiveStartDate) EffectiveStartDate from [CORE].[Event] eve
--							--INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
--							--INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
--							--where EventTypeID = (Select LookupID from CORE.Lookup where Name = 'StrippingSchedule')
--							--and n.ClientNoteID = @NoteId
--							--GROUP BY eve.AccountID

--							Select 
--							(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
--							MAX(EffectiveStartDate) EffectiveStartDate from [CORE].[Event] eve
--							INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
--							INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
--							where EventTypeID = (Select LookupID from CORE.Lookup where Name = 'StrippingSchedule')
--							and n.ClientNoteID = @NoteId
--							GROUP BY n.Account_AccountID

--						) sEvent

--				ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate and EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'StrippingSchedule')
--			)
--			and ss.[ValueTypeID] = (Select LookupID from CORE.Lookup where Name = 'Origination Fee Strip')


		

--			Declare @L_EffectiveDatess Date;
--			Select @L_EffectiveDatess = MAX(EffectiveStartDate)  
--			from [CORE].[Event] eve
--			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
--			INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
--			where EventTypeID = (Select LookupID from CORE.Lookup where Name = 'StrippingSchedule')
--			and n.ClientNoteID = @NoteId
			

					

--		IF(@OriginationFeePct != @L_OriginationFeePct and @ImportDate > @L_EffectiveDateSS )
--		BEGIN
			 
--			DECLARE @tEventss2 TABLE (tEventIDss2 UNIQUEIDENTIFIER)
--			Declare @EventIDss2 uniqueidentifier;
--			Delete from @tEventss2

--			PRINT('INSERT EVENT FOR STRIPPING SCHEDULE');
--			INSERT INTO [CORE].[Event]
--			([AccountID]
--			,[Date]
--			,[EventTypeID]
--			,[EffectiveStartDate]
--			,[EffectiveEndDate]
--			,[SingleEventValue]
--			,[CreatedBy]
--			,[CreatedDate]
--			,[UpdatedBy]
--			,[UpdatedDate])

--			OUTPUT inserted.EventID INTO @tEventss2(tEventIDss2)

--			VALUES(
--			(Select Top 1 AccountID from [CORE].[Account] unAcc where unAcc.ClientNoteID = @NoteId),
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
		   
--		   PRINT('INSERT STRIPPING SCHEDULE');
--			INSERT INTO [CORE].[StrippingSchedule]
--           ([EventID]
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
		
--		PRINT('UPDATE STRIPPING SCHEDULE');
--			UPDATE [CORE].[StrippingSchedule] SET
--					[Value] = @OriginationFeePct,
--					[UpdatedBy] = @UserName,
--					[UpdatedDate] =@CreatedUpdatedDate
--			WHERE StrippingScheduleID = @L_StrippingScheduleID

--		END
--	END
--END	--IF(@OriginationFeePct IS NOT NULL)

--SET @StrippingScheduleEndTime = getdate(); 
--------------------------------------------------------------------------------------

------------------PIK Schedule Insert/Update------------------------------------------
IF(@CursorIndex = 0)BEGIN SET @PikScheduleStartTime = getdate(); END

IF(@AccrualRate IS NOT NULL)
BEGIN


	IF NOT EXISTS(
			Select 
			pik.PIKScheduleID,
			pik.AdditionalIntRate 
			from [CORE].PIKSchedule pik
			where EventID in 
			(

				Select e.EventID from [CORE].[Event] e
				INNER JOIN 
						(
							
							Select 
							(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
							MAX(EffectiveStartDate) EffectiveStartDate from [CORE].[Event] eve
							INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
							INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
							where EventTypeID = (Select LookupID from CORE.Lookup where Name = 'PIKSchedule')
							and n.ClientNoteID = @NoteId and acc.IsDeleted = 0
							GROUP BY n.Account_AccountID


						) sEvent

				ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'PIKSchedule')
			)
			--and pik.[ValueTypeID] = (Select LookupID from CORE.Lookup where Name = 'Origination Fee Strip')
	)
	BEGIN

			DECLARE @tEventpik TABLE (tEventIDpik UNIQUEIDENTIFIER)
			Declare @EventIDpik uniqueidentifier;
			Delete from @tEventpik

			PRINT('INSERT EVENT FOR PIK SCHEDULE');

			IF(@FundingDate is null)
			Begin
				SET @ClosigDateAsEffDate = @ImportDate
			END
			ELSE
			BEGIN
				SET @ClosigDateAsEffDate = @FundingDate
			END


			INSERT INTO [CORE].[Event]
			([AccountID]
			,[Date]
			,[EventTypeID]
			,[EffectiveStartDate]
			,[EffectiveEndDate]
			,[SingleEventValue]
			,[CreatedBy]
			,[CreatedDate]
			,[UpdatedBy]
			,[UpdatedDate])

			OUTPUT inserted.EventID INTO @tEventpik(tEventIDpik)

			VALUES(
			(Select Top 1 AccountID from [CORE].[Account] unAcc where unAcc.ClientNoteID = @NoteId and unAcc.IsDeleted = 0),
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

		   PRINT('INSERT PIK SCHEDULE');

			INSERT INTO [CORE].[PIKSchedule]
           ([EventID]
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
		Declare @L_PIKScheduleID uniqueidentifier;

		Select 
			@L_PIKScheduleID = pik.PIKScheduleID,
			@L_AccrualRate = pik.AdditionalIntRate 
			from [CORE].PIKSchedule pik
			where EventID in 
			(

				Select e.EventID from [CORE].[Event] e
				INNER JOIN 
						(
						 
							Select 
							(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
							MAX(EffectiveStartDate) EffectiveStartDate from [CORE].[Event] eve
							INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
							INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
							where EventTypeID = (Select LookupID from CORE.Lookup where Name = 'PIKSchedule')
							and n.ClientNoteID = @NoteId and acc.IsDeleted = 0
							GROUP BY n.Account_AccountID

						) sEvent

				ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'PIKSchedule')
			)
			--and pik.[ValueTypeID] = (Select LookupID from CORE.Lookup where Name = 'Origination Fee Strip')


			Declare @L_EffectiveDatePik Date;
			Select @L_EffectiveDatePik = MAX(EffectiveStartDate)  
			from [CORE].[Event] eve
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
			where EventTypeID = (Select LookupID from CORE.Lookup where Name = 'PIKSchedule')
			and n.ClientNoteID = @NoteId and acc.IsDeleted = 0
			

					

		IF(@AccrualRate != @L_AccrualRate and @ImportDate > @L_EffectiveDatePik )
		BEGIN
			 
			DECLARE @tEventpik2 TABLE (tEventIDpik2 UNIQUEIDENTIFIER)
			Declare @EventIDpik2 uniqueidentifier;
			Delete from @tEventpik2

			PRINT('INSERT EVENT FOR PIK SCHEDULE');

			INSERT INTO [CORE].[Event]
			([AccountID]
			,[Date]
			,[EventTypeID]
			,[EffectiveStartDate]
			,[EffectiveEndDate]
			,[SingleEventValue]
			,[CreatedBy]
			,[CreatedDate]
			,[UpdatedBy]
			,[UpdatedDate])

			OUTPUT inserted.EventID INTO @tEventpik2(tEventIDpik2)

			VALUES(
			(Select Top 1 AccountID from [CORE].[Account] unAcc where unAcc.ClientNoteID = @NoteId and unAcc.IsDeleted = 0),
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

		   
		   PRINT('INSERT PIK SCHEDULE');
			INSERT INTO [CORE].[PIKSchedule]
           ([EventID]
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
		
		PRINT('UPDATE PIK SCHEDULE');
			UPDATE [CORE].[PIKSchedule] SET
					[AdditionalIntRate] = @AccrualRate,
					[UpdatedBy] = @UserName,
					[UpdatedDate] = @CreatedUpdatedDate
			WHERE PIKScheduleID = @L_PIKScheduleID

		END
	END
END	--IF(@AccrualRate IS NOT NULL)

SET @PikScheduleEndTime = getdate();
------------------------------------------------------------------------------------


------Insert update Initial maturity date-------------
	IF(@StatedMaturityDate is not null)
	BEGIN
		Declare  @EventTypeMaturity  int  = 11;
	
	
	
		IF EXISTS(Select mat.MaturityID from [CORE].Maturity mat INNER JOIN [CORE].[Event] eve ON mat.eventid = eve.eventid INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID inner join core.Account acc on n.Account_AccountID = acc.AccountID where EventTypeID = @EventTypeMaturity and n.crenoteid = @Noteid and acc.IsDeleted = 0)
		BEGIN

		 
			Declare @MaturityID UNIQUEIDENTIFIER;

			Select @MaturityID = mat.MaturityID
			from [CORE].Maturity mat
			INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
			INNER JOIN 
				(
						
					Select 
						(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
						MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
						INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
						INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
						where EventTypeID = @EventTypeMaturity
						and n.CRENoteID = @Noteid and acc.IsDeleted = 0
						GROUP BY n.Account_AccountID,EventTypeID

				) sEvent
			ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID


			Update [CORE].Maturity set SelectedMaturityDate = @StatedMaturityDate where MaturityID = @MaturityID
			
		END
		ELSE
		BEGIN
			 
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

			INSERT INTO [CORE].[Event]
			([AccountID]
			,[Date]
			,[EventTypeID]
			,[EffectiveStartDate]
			,[EffectiveEndDate]
			,[SingleEventValue]
			,[CreatedBy]
			,[CreatedDate]
			,[UpdatedBy]
			,[UpdatedDate])

			OUTPUT inserted.EventID INTO @tEventMat(tEventIDMat)

			VALUES(
			(Select Top 1 AccountID from [CORE].[Account] unAcc where unAcc.ClientNoteID = @NoteId and unAcc.IsDeleted = 0),
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
			INSERT INTO [CORE].[Maturity](EventId, SelectedMaturityDate, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
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
--------------------------------------------




SET @CursorIndex += 1;


COMMIT TRAN
END TRY
BEGIN CATCH

	DECLARE @ErrorMessage NVARCHAR(4000);
	DECLARE @ErrorSeverity INT;
	DECLARE @ErrorState INT;

	SELECT @ErrorMessage = 'SQL error ' + ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();

	Update [IO].BatchLog set ErrorMessage = @ErrorMessage where BatchLogID = @BatchLogID

	IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION;

	-- Use RAISERROR inside the CATCH block to return error
	-- information about the original error that caused
	-- execution to jump to the CATCH block.


	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	  

END CATCH
			  


			FETCH NEXT FROM CursorDeal    
			INTO @NoteId,@NoteName,@PaymentFreqDesc,@ControlId,@PaymentFreqCd,@FundingDate,@FirstPIPaymentDate,@StatedMaturityDate,@OrigLoanAmount,@OriginationFee,@AmortIOPeriod,@AmortizationTerm,@DeterminationDate,@DeterminationMethodDay,@RoundingType,@RoundingDenominator,@InterestSpread,@IntCalcMethodDesc,@OriginationFeePct,@AccrualRate,@LiborFloor,@ExpectedMaturityDate,@ExtendedMaturityScenario1,@ExtendedMaturityScenario2,@ExtendedMaturityScenario3,@TotalCommitment,@lienposition,@priority
			END  




-----Manage BatchLog/BatchDetail---------------------------------------------------------------

DECLARE @CNT_RateSpreadSchedule INT;
DECLARE @CNT_StrippingSchedule INT;
DECLARE @CNT_PikSchedule INT;

Select @CNT_RateSpreadSchedule = COUNT(*)
FROM [CORE].[RateSpreadSchedule] rs
INNER JOIN [CORE].[Event] eve ON eve.EventID = rs.EventID
INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
INNER JOIN [CRE].[Note] note ON note.Account_AccountID = acc.AccountID
WHERE note.NoteID in (select NoteID from [CRE].Note where DealID in (Select DealID from [CRE].[Deal] where ClientDealID =  @DealID and isdeleted = 0))
and eve.EventTypeID = (Select LookupID from CORE.Lookup where Name = 'RateSpreadSchedule')
and rs.ValueTypeID = (Select LookupID from CORE.Lookup where Name = 'Spread')


Select @CNT_PikSchedule = COUNT(*)
FROM [CORE].[PikSchedule] pik
INNER JOIN [CORE].[Event] eve ON eve.EventID = pik.EventID
INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
INNER JOIN [CRE].[Note] note ON note.Account_AccountID = acc.AccountID
WHERE note.NoteID in (select NoteID from [CRE].Note where DealID in (Select DealID from [CRE].[Deal] where ClientDealID =  @DealID and isdeleted = 0))
and eve.EventTypeID = (Select LookupID from CORE.Lookup where Name = 'PikSchedule')
 
 
Select @CNT_StrippingSchedule = COUNT(*)
FROM [CORE].[StrippingSchedule] ss
INNER JOIN [CORE].[Event] eve ON eve.EventID = ss.EventID
INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
INNER JOIN [CRE].[Note] note ON note.Account_AccountID = acc.AccountID
WHERE note.NoteID in (select NoteID from [CRE].Note where DealID in (Select DealID from [CRE].[Deal] where ClientDealID =  @DealID and isdeleted = 0))
and eve.EventTypeID = (Select LookupID from CORE.Lookup where Name = 'StrippingSchedule')
and ss.ValueTypeID = (Select LookupID from CORE.Lookup where Name = 'Origination Fee Strip')




Update [IO].BatchLog set EndTime = GETDATE() where BatchLogID = @BatchLogID


UPDATE [IO].[BatchDetail]
   SET [BatchLog_BatchLogID] = @BatchLogID
      ,[DestinationTableName] = 'Deal'
      ,[DestinationTableRecordCount] = (Select COUNT(*) from [CRE].[Deal] where ClientDealID = @DealID and isdeleted = 0)
      ,[DestinationTableCheckSumValue] = NULL
      ,[DestinationTableStartTime] = @DealStartTime
      ,[DestinationTableEndTime] = @DealEndTime
      ,[DestinationTableErrorMessage] = NULL
      ,[CreatedBy] = @UserName
      ,[CreatedDate] = @CreatedUpdatedDate
      ,[UpdatedBy] = @UserName
      ,[UpdatedDate] = @CreatedUpdatedDate
 WHERE BatchLog_BatchLogID = @BatchLogID
 AND SourceTableName = 'IN_UnderwritingDeal'

 UPDATE [IO].[BatchDetail]
   SET [BatchLog_BatchLogID] = @BatchLogID
      ,[DestinationTableName] = 'Note'
      ,[DestinationTableRecordCount] = (Select COUNT(*) from [CRE].[Note] where DealID = (Select DealID from [CRE].[Deal] where ClientDealID = @DealID and isdeleted = 0))
      ,[DestinationTableCheckSumValue] = NULL
      ,[DestinationTableStartTime] = @NoteStartTime
      ,[DestinationTableEndTime] = @NoteEndTime
      ,[DestinationTableErrorMessage] = NULL
      ,[CreatedBy] = @UserName
      ,[CreatedDate] = @CreatedUpdatedDate
      ,[UpdatedBy] = @UserName
      ,[UpdatedDate] = @CreatedUpdatedDate
 WHERE BatchLog_BatchLogID = @BatchLogID
 AND SourceTableName = 'IN_UnderwritingNote'
 





 UPDATE [IO].[BatchDetail]
   SET [BatchLog_BatchLogID] = @BatchLogID
      ,[DestinationTableName] = 'Account'
      ,[DestinationTableRecordCount] = (SELECT COUNT(*) FROM [Core].Account acc
										INNER JOIN [CRE].Note n ON ACC.AccountID = n.Account_AccountID
										INNER JOIN [CRE].Deal d ON n.DealID = d.DealID
										WHERE d.ClientDealID = @DealID and d.isdeleted = 0)
      ,[DestinationTableCheckSumValue] = NULL
      ,[DestinationTableStartTime] = @AccountStartTime
      ,[DestinationTableEndTime] = @AccountEndTime
      ,[DestinationTableErrorMessage] = NULL
      ,[CreatedBy] = @UserName
      ,[CreatedDate] = @CreatedUpdatedDate
      ,[UpdatedBy] = @UserName
      ,[UpdatedDate] = @CreatedUpdatedDate
 WHERE BatchLog_BatchLogID = @BatchLogID
 AND SourceTableName = 'IN_UnderwritingAccount'


UPDATE [IO].[BatchDetail]
   SET [BatchLog_BatchLogID] = @BatchLogID
      ,[DestinationTableName] = 'RateSpreadSchedule'
      ,[DestinationTableRecordCount] = @CNT_RateSpreadSchedule
      ,[DestinationTableCheckSumValue] = NULL
      ,[DestinationTableStartTime] = @RateSpreadScheduleStartTime
      ,[DestinationTableEndTime] = @RateSpreadScheduleEndTime
      ,[DestinationTableErrorMessage] = NULL
      ,[CreatedBy] = @UserName
      ,[CreatedDate] = @CreatedUpdatedDate
      ,[UpdatedBy] = @UserName
      ,[UpdatedDate] = @CreatedUpdatedDate
 WHERE BatchLog_BatchLogID = @BatchLogID
 AND SourceTableName = 'IN_UnderwritingRateSpreadSchedule'


 UPDATE [IO].[BatchDetail]
   SET [BatchLog_BatchLogID] = @BatchLogID
      ,[DestinationTableName] = 'StrippingSchedule'
      ,[DestinationTableRecordCount] = @CNT_StrippingSchedule
      ,[DestinationTableCheckSumValue] = NULL
      ,[DestinationTableStartTime] = @StrippingScheduleStartTime
      ,[DestinationTableEndTime] = @StrippingScheduleEndTime
      ,[DestinationTableErrorMessage] = NULL
      ,[CreatedBy] = @UserName
      ,[CreatedDate] = @CreatedUpdatedDate
      ,[UpdatedBy] = @UserName
      ,[UpdatedDate] = @CreatedUpdatedDate
 WHERE BatchLog_BatchLogID = @BatchLogID
 AND SourceTableName = 'IN_UnderwritingStrippingSchedule'

 UPDATE [IO].[BatchDetail]
   SET [BatchLog_BatchLogID] = @BatchLogID
      ,[DestinationTableName] = 'PIKSchedule'
      ,[DestinationTableRecordCount] = @CNT_PikSchedule
      ,[DestinationTableCheckSumValue] = NULL
      ,[DestinationTableStartTime] = @PikScheduleStartTime
      ,[DestinationTableEndTime] = @PikScheduleEndTime
      ,[DestinationTableErrorMessage] = NULL
      ,[CreatedBy] = @UserName
      ,[CreatedDate] = @CreatedUpdatedDate
      ,[UpdatedBy] = @UserName
      ,[UpdatedDate] = @CreatedUpdatedDate
 WHERE BatchLog_BatchLogID = @BatchLogID
 AND SourceTableName = 'IN_UnderwritingPIKSchedule'

 
 ----Add into searchitem table
	PRINT('Start - Add into search item table')
	DECLARE @DealIDt nvarchar(256) = (Select DealID from [CRE].[Deal]  where ClientDealID = @DealID and isdeleted = 0)
	exec [App].[usp_AddUpdateObject] @DealIDt,@LookupIdForDeal,null,null

	-----Save Note----------------------------
	Declare @ObjectIDNote UNIQUEIDENTIFIER
 
	IF CURSOR_STATUS('global','CursorNote')>=-1
	BEGIN
		DEALLOCATE CursorNote
	END

	DECLARE CursorNote CURSOR 
	for
	(
		Select NoteID from cre.Note where dealid = @DealIDt
	)


	OPEN CursorNote 

	FETCH NEXT FROM CursorNote
	INTO @ObjectIDNote

	WHILE @@FETCH_STATUS = 0
	BEGIN

		EXEC [App].[usp_AddUpdateObject] @ObjectIDNote,@LookupIdForNote ,'Kbaderia','Kbaderia'
					 
	FETCH NEXT FROM CursorNote
	INTO @ObjectIDNote
	END
	CLOSE CursorNote   
	DEALLOCATE CursorNote
	PRINT('END - Add into search item table')
 -------------------------------



 -----CursorUpdateEffectiveDateAsClosing----------------------------
	Declare @ObjectIDNote1 UNIQUEIDENTIFIER
 
	IF CURSOR_STATUS('global','CursorUpdateEffectiveDateAsClosing')>=-1
	BEGIN
		DEALLOCATE CursorUpdateEffectiveDateAsClosing
	END

	DECLARE CursorUpdateEffectiveDateAsClosing CURSOR 
	for
	(
		Select NoteID from cre.Note where dealid = @DealIDt
	)


	OPEN CursorUpdateEffectiveDateAsClosing 

	FETCH NEXT FROM CursorUpdateEffectiveDateAsClosing
	INTO @ObjectIDNote1

	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		EXEC [usp_UpdateEffectiveDateAsClosingDateByNoteId] @ObjectIDNote1	 

	FETCH NEXT FROM CursorUpdateEffectiveDateAsClosing
	INTO @ObjectIDNote1
	END
	CLOSE CursorUpdateEffectiveDateAsClosing   
	DEALLOCATE CursorUpdateEffectiveDateAsClosing
	
 -------------------------------
 


END



