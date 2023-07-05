
CREATE PROCEDURE [dbo].[usp_InsertActivityLogForObjects] 
@noteAdditinallistXML XML,
@CreatedBy nvarchar(256),
@UpdatedBy nvarchar(256)
AS
BEGIN

declare @noteAdditinallist TABLE
(
	[AccCapBal] [varchar](256) NULL,
	[AccountID] [varchar](256) NULL,
	[AdditionalIntRate] [varchar](256) NULL,
	[AdditionalSpread] [varchar](256) NULL,
	[Applied] [varchar](256) NULL,
	[Comments] [nvarchar](256) NULL,
	[CreatedBy] [varchar](256) NULL,
	[CreatedDate] [varchar](256) NULL,
	[CurrencyCode] [varchar](256) NULL,
	[CurrencyCodeText] [varchar](256) NULL,
	[Date] [varchar](256) NULL,
	[DrawFundingId] [nvarchar](256) NULL,
	[EffectiveDate] [varchar](256) NULL,
	[EffectiveEndDate] [varchar](256) NULL,
	[EffectiveStartDate] [varchar](256) NULL,
	[EndDate] [varchar](256) NULL,
	[Event_Date] [varchar](256) NULL,
	[EventId] [varchar](256) NULL,
	[EventTypeID] [varchar](256) NULL,
	[EventTypeText] [varchar](256) NULL,
	[FeeCouponReceivable] [varchar](256) NULL,
	[FinancingFeeScheduleID] [varchar](256) NULL,
	[FinancingScheduleID] [varchar](256) NULL,
	[IncludedBasis] [varchar](256) NULL,
	[IncludedLevelYield] [varchar](256) NULL,
	[IndexFloor] [varchar](256) NULL,
	[IndexTypeID] [varchar](256) NULL,
	[IndexTypeText] [varchar](256) NULL,
	[IntCalcMethodID] [varchar](256) NULL,
	[IntCalcMethodText] [varchar](256) NULL,
	[IntCapAmt] [varchar](256) NULL,
	[IntCompoundingRate] [varchar](256) NULL,
	[IntCompoundingSpread] [varchar](256) NULL,
	[IsCapitalized] [varchar](256) NULL,
	[IsCapitalizedText] [varchar](256) NULL,
	[ModuleId] [varchar](256) NULL,
	[NoteID] [varchar](256) NULL,
	[NotePrepayAndAdditionalFeeScheduleID] [varchar](256) NULL,
	[NotePrepayAndAdditionalValue] [varchar](256) NULL,
	[NotePrepayAndAdditionalValueType] [varchar](256) NULL,
	[PIKScheduleID] [varchar](256) NULL,
	[PPIncludeInBasisCalc] [varchar](256) NULL,
	[PPIncludeInLevelYieldCalc] [varchar](256) NULL,
	[PrepayAndAdditionalFeeScheduleID] [varchar](256) NULL,
	[PrepayValueTypeText] [varchar](256) NULL,
	[PurBal] [varchar](256) NULL,
	[PurposeID] [varchar](256) NULL,
	[ScheduleID] [varchar](256) NULL,
	[ScheduleStartDate] [varchar](256) NULL,
	[SourceAccount] [varchar](256) NULL,
	[SourceAccountID] [varchar](256) NULL,
	[StartDate] [varchar](256) NULL,
	[TargetAccount] [varchar](256) NULL,
	[TargetAccountID] [varchar](256) NULL,
	[UpdatedBy] [varchar](256) NULL,
	[UpdatedDate] [varchar](256) NULL,
	[Value] [varchar](256) NULL,
	[ValueTypeID] [varchar](256) NULL,
	[ValueTypeText] [varchar](256) NULL
)

INSERT INTO @noteAdditinallist
SELECT 
nullif(Pers.value('(AccCapBal)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(AccountID)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(AdditionalIntRate)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(AdditionalSpread)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(Applied)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(Comments)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(CreatedBy)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(CreatedDate)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(CurrencyCode)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(CurrencyCodeText)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(Date)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(DrawFundingId)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(EffectiveDate)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(EffectiveEndDate)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(EffectiveStartDate)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(EndDate)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(Event_Date)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(EventId)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(EventTypeID)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(EventTypeText)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(FeeCouponReceivable)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(FinancingFeeScheduleID)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(FinancingScheduleID)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(IncludedBasis)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(IncludedLevelYield)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(IndexFloor)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(IndexTypeID)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(IndexTypeText)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(IntCalcMethodID)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(IntCalcMethodText)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(IntCapAmt)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(IntCompoundingRate)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(IntCompoundingSpread)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(IsCapitalized)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(IsCapitalizedText)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(ModuleId)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(NoteID)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(NotePrepayAndAdditionalFeeScheduleID)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(NotePrepayAndAdditionalValue)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(NotePrepayAndAdditionalValueType)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(PIKScheduleID)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(PPIncludeInBasisCalc)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(PPIncludeInLevelYieldCalc)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(PrepayAndAdditionalFeeScheduleID)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(PrepayValueTypeText)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(PurBal)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(PurposeID)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(ScheduleID)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(ScheduleStartDate)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(SourceAccount)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(SourceAccountID)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(StartDate)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(TargetAccount)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(TargetAccountID)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(UpdatedBy)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(UpdatedDate)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(Value)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(ValueTypeID)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(ValueTypeText)[1]', 'nvarchar(max)'), '')
  
FROM @noteAdditinallistXML.nodes('/ArrayOfNoteAdditionalList/NoteAdditionalList') as T(Pers)

--Variable's--------------------
DECLARE @accountID varchar(256)
DECLARE @NoteId varchar(256)

Declare  @BalanceTransactionSchedule  int  =5;
Declare  @DefaultSchedule  int  =6;
Declare  @FeeCouponSchedule  int  =7;
Declare  @FinancingFeeSchedule  int  =8;
Declare  @FinancingSchedule  int  =9;
Declare  @FundingSchedule  int  =10;
--Declare  @Maturity  int  =11;
Declare  @PIKSchedule  int  =12;
Declare  @PrepayAndAdditionalFeeSchedule  int  =13;
Declare  @RateSpreadSchedule  int  =14;
Declare  @ServicingFeeSchedule  int  =15;
Declare  @StrippingSchedule  int  =16;
Declare  @PIKScheduleDetail  int  =17;
Declare  @LIBORSchedule  int  =18;
Declare  @AmortSchedule  int  =19;
Declare  @FeeCouponStripReceivable  int  =20;


DECLARE @Active int = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
DECLARE @Inactive int = (Select LookupID from Core.Lookup where name = 'Inactive' and ParentID = 1)

DECLARE @DisplayMessage varchar(256) ='Inserted'

SELECT  top 1 @NoteId = NoteId FROM @noteAdditinallist

SELECT @accountID = Account_AccountID FROM CRE.Note n inner join core.Account acc on acc.AccountID = n.Account_AccountID WHERE NoteID = (SELECT TOP 1 (NoteId) FROM @noteAdditinallist) and acc.IsDeleted = 0
--====================================================================================================

--Maturity log

--IF NOT EXISTS
--(
--	select 1 FROM core.Event e
--	INNER JOIN  @noteAdditinallist t
--	ON e.EventID = t.EventID
--	where  e.EffectiveStartDate = CONVERT(date, t.EffectiveDate, 101)
--	AND ModuleId = @Maturity
--	AND e.AccountID=@accountID
--)
--AND EXISTS
--(
-- select 1 from @noteAdditinallist where ModuleId = @Maturity
--)
--BEGIN
--  INSERT INTO [App].[ActivityLog]
--           ([ParentModuleID]
--		   ,[ParentModuleTypeID]
--		   ,[ModuleID]
           
--           ,[ActivityType]
--           ,[DisplayMessage]
--           ,[CreatedBy]
--           ,[CreatedDate]
--           ,[UpdatedBy]
--           ,[UpdatedDate])
--		 SELECT @NoteId,182,@NoteId,@Maturity,'inserted',@CreatedBy,GETDATE(),@UpdatedBy,GETDATE()
--END
--ELSE 
--BEGIN
--		IF exists(SELECT 1 FROM @noteAdditinallist tp WHERE ModuleId = @Maturity and ScheduleID is null AND Date IS NOT NULL )
--		BEGIN
--		INSERT INTO [App].[ActivityLog]
--           ([ParentModuleID]
--		   ,[ParentModuleTypeID]
--		   ,[ModuleID]
           
--           ,[ActivityType]
--           ,[DisplayMessage]
--           ,[CreatedBy]
--           ,[CreatedDate]
--           ,[UpdatedBy]
--           ,[UpdatedDate])
--				 select @NoteId,182,@NoteId,@Maturity,'inserted',@CreatedBy,GETDATE(),@UpdatedBy,GETDATE()
--		END

--		IF exists(
--				select m.MaturityID FROM core.Event e
--				INNER JOIN @noteAdditinallist t
--				ON e.EventID = t.EventID
--				AND e.EffectiveStartDate = CONVERT(date, t.EffectiveDate, 101)
--				AND ModuleId = @Maturity
--				LEFT JOIN core.Maturity m
--				ON m.MaturityID = t.ScheduleID
--				AND m.SelectedMaturityDate = t.Date
--				WHERE t.Date is not null 
--				AND t.ScheduleID IS NOT NULL
--				AND m.MaturityID IS NULL
--				)
--		BEGIN
--				INSERT INTO [App].[ActivityLog]
--			   ([ParentModuleID]
--			   ,[ParentModuleTypeID]
--			   ,[ModuleID]
			   
--			   ,[ActivityType]
--			   ,[DisplayMessage]
--			   ,[CreatedBy]
--			   ,[CreatedDate]
--			   ,[UpdatedBy]
--			   ,[UpdatedDate])
--				 select @NoteId,182,@NoteId,@Maturity,'updated',@CreatedBy,GETDATE(),@UpdatedBy,GETDATE()
--		END


--END

--===@RateSpreadSchedule===============================

IF NOT EXISTS
(
	select 1 FROM core.Event e
	INNER JOIN  @noteAdditinallist t
	ON e.EventID = t.EventID
	where  e.EffectiveStartDate = CONVERT(date, t.EffectiveDate, 101)
	AND ModuleId = @RateSpreadSchedule
	AND e.AccountID=@accountID
)
AND EXISTS
(
 select 1 from @noteAdditinallist where ModuleId = @RateSpreadSchedule
)

BEGIN
  INSERT INTO [App].[ActivityLog]
			   ([ParentModuleID]
			   ,[ParentModuleTypeID]
			   ,[ModuleID]
			   
			   ,[ActivityType]
			   ,[DisplayMessage]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[UpdatedBy]
			   ,[UpdatedDate])
		 SELECT @NoteId,182,@NoteId,@RateSpreadSchedule,'inserted',@CreatedBy,GETDATE(),@UpdatedBy,GETDATE()
END
ELSE 
BEGIN
		IF exists(
				SELECT 1 FROM @noteAdditinallist tp
				WHERE ModuleId = @RateSpreadSchedule and ScheduleID is null AND ValueTypeID IS NOT NULL )
		BEGIN
				INSERT INTO [App].[ActivityLog]
			   ([ParentModuleID]
			   ,[ParentModuleTypeID]
			   ,[ModuleID]
			   
			   ,[ActivityType]
			   ,[DisplayMessage]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[UpdatedBy]
			   ,[UpdatedDate])
				 select @NoteId,182,@NoteId,@RateSpreadSchedule,'inserted',@CreatedBy,GETDATE(),@UpdatedBy,GETDATE()
		END

		IF exists(
				select r.ValueTypeID FROM core.Event e
				INNER JOIN @noteAdditinallist t
				ON e.EventID = t.EventID
				AND e.EffectiveStartDate = CONVERT(date, t.EffectiveDate, 101)
				AND ModuleId = @RateSpreadSchedule
				LEFT JOIN core.RateSpreadSchedule r
				ON r.RateSpreadScheduleID = t.ScheduleID
				AND r.Date = t.Date
				AND r.ValueTypeID= t.ValueTypeID
				AND isnull(r.Value,0)= isnull(t.Value,0)
				AND isnull(r.IntCalcMethodID,0)= isnull(t.IntCalcMethodID,0)
				WHERE
				e.StatusID=@Active and t.Date is not null AND t.ValueTypeID IS NOT NULL 
				AND t.ScheduleID IS NOT NULL
				AND r.ValueTypeID IS  NULL
				)
		BEGIN
				INSERT INTO [App].[ActivityLog]
			   ([ParentModuleID]
			   ,[ParentModuleTypeID]
			   ,[ModuleID]
			   
			   ,[ActivityType]
			   ,[DisplayMessage]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[UpdatedBy]
			   ,[UpdatedDate])
				 select @NoteId,182,@NoteId,@RateSpreadSchedule,'updated',@CreatedBy,GETDATE(),@UpdatedBy,GETDATE()
		END


END


--PrepayAndAdditionalFeeSchedule

IF NOT EXISTS
(
	select 1 FROM core.Event e
	INNER JOIN  @noteAdditinallist t
	ON e.EventID = t.EventID
	where  e.EffectiveStartDate = CONVERT(date, t.EffectiveDate, 101)
	AND ModuleId = @PrepayAndAdditionalFeeSchedule
	AND e.AccountID=@accountID
)
AND EXISTS
(
 select 1 from @noteAdditinallist where ModuleId = @PrepayAndAdditionalFeeSchedule
)

BEGIN
  INSERT INTO [App].[ActivityLog]
			   ([ParentModuleID]
			   ,[ParentModuleTypeID]
			   ,[ModuleID]
			   
			   ,[ActivityType]
			   ,[DisplayMessage]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[UpdatedBy]
			   ,[UpdatedDate])
		 SELECT @NoteId,182,@NoteId,@PrepayAndAdditionalFeeSchedule,'inserted',@CreatedBy,GETDATE(),@UpdatedBy,GETDATE()
END
ELSE 
BEGIN
		IF exists(
				SELECT 1 FROM @noteAdditinallist tp
				WHERE ModuleId = @PrepayAndAdditionalFeeSchedule and ScheduleID is null AND ValueTypeID IS NOT NULL AND StartDate is not null)
		BEGIN
				 INSERT INTO [App].[ActivityLog]
			   ([ParentModuleID]
			   ,[ParentModuleTypeID]
			   ,[ModuleID]
			   
			   ,[ActivityType]
			   ,[DisplayMessage]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[UpdatedBy]
			   ,[UpdatedDate])
				 select @NoteId,182,@NoteId,@PrepayAndAdditionalFeeSchedule,'inserted',@CreatedBy,GETDATE(),@UpdatedBy,GETDATE()
		END

		IF exists(
				select r.ValueTypeID FROM core.Event e
				INNER JOIN @noteAdditinallist t
				ON e.EventID = t.EventID
				AND e.EffectiveStartDate = CONVERT(date, t.EffectiveDate, 101)
				AND ModuleId = @PrepayAndAdditionalFeeSchedule
				LEFT JOIN core.PrepayAndAdditionalFeeSchedule r
				ON r.PrepayAndAdditionalFeeScheduleID = t.ScheduleID
				AND r.StartDate =  t.StartDate
				AND r.ValueTypeID= t.ValueTypeID 
				AND isnull(r.Value,0)= isnull(t.Value,0)
				AND ISNULL(r.IncludedLevelYield,0)= ISNULL(t.IncludedLevelYield,0) 
				AND ISNULL(r.IncludedBasis,0)= ISNULL(t.IncludedBasis,0)
				WHERE
				e.StatusID=@Active and t.ValueTypeID IS NOT NULL 
				AND t.ScheduleID IS NOT NULL
				AND t.StartDate is not null
				AND r.ValueTypeID IS  NULL
				)
		BEGIN
				 INSERT INTO [App].[ActivityLog]
			   ([ParentModuleID]
			   ,[ParentModuleTypeID]
			   ,[ModuleID]
			   
			   ,[ActivityType]
			   ,[DisplayMessage]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[UpdatedBy]
			   ,[UpdatedDate])
				 select @NoteId,182,@NoteId,@PrepayAndAdditionalFeeSchedule,'updated',@CreatedBy,GETDATE(),@UpdatedBy,GETDATE()
		END


END

-------------------------------------------------------------------------------------------------------------

--Stripping

IF NOT EXISTS
(
	select 1 FROM core.Event e
	INNER JOIN  @noteAdditinallist t
	ON e.EventID = t.EventID
	where  e.EffectiveStartDate = CONVERT(date, t.EffectiveDate, 101)
	AND ModuleId = @StrippingSchedule
	AND e.AccountID=@accountID
)
AND EXISTS
(
 select 1 from @noteAdditinallist where ModuleId = @StrippingSchedule
)

BEGIN
   INSERT INTO [App].[ActivityLog]
			   ([ParentModuleID]
			   ,[ParentModuleTypeID]
			   ,[ModuleID]
			   
			   ,[ActivityType]
			   ,[DisplayMessage]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[UpdatedBy]
			   ,[UpdatedDate])
				 select @NoteId,182,@NoteId,@StrippingSchedule,'inserted',@CreatedBy,GETDATE(),@UpdatedBy,GETDATE()
END
ELSE 
BEGIN
		IF exists(
				SELECT 1 FROM @noteAdditinallist tp
				WHERE ModuleId = @StrippingSchedule and ScheduleID is null AND ValueTypeID IS NOT NULL  AND StartDate is not null)
		BEGIN
				 INSERT INTO [App].[ActivityLog]
			   ([ParentModuleID]
			   ,[ParentModuleTypeID]
			   ,[ModuleID]
			   
			   ,[ActivityType]
			   ,[DisplayMessage]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[UpdatedBy]
			   ,[UpdatedDate])
				 select @NoteId,182,@NoteId,@StrippingSchedule,'inserted',@CreatedBy,GETDATE(),@UpdatedBy,GETDATE()
		END

		IF exists(
				select r.ValueTypeID FROM core.Event e
				INNER JOIN @noteAdditinallist t
				ON e.EventID = t.EventID
				AND e.EffectiveStartDate = CONVERT(date, t.EffectiveDate, 101)
				AND ModuleId = @StrippingSchedule
				LEFT JOIN core.StrippingSchedule r
				ON r.StrippingScheduleID = t.ScheduleID
				AND r.StartDate =  t.StartDate
				AND r.ValueTypeID= t.ValueTypeID 
				AND isnull(r.Value,0)= isnull(t.Value,0)
				AND ISNULL(r.IncludedLevelYield,0)= ISNULL(t.IncludedLevelYield,0) 
				AND ISNULL(r.IncludedBasis,0)= ISNULL(t.IncludedBasis,0)

				WHERE
				e.StatusID=@Active and t.ValueTypeID IS NOT NULL 
				and t.StartDate is not null
				AND t.ScheduleID IS NOT NULL
				AND r.ValueTypeID IS  NULL
				)
		BEGIN
				 INSERT INTO [App].[ActivityLog]
			   ([ParentModuleID]
			   ,[ParentModuleTypeID]
			   ,[ModuleID]
			   
			   ,[ActivityType]
			   ,[DisplayMessage]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[UpdatedBy]
			   ,[UpdatedDate])
				 select @NoteId,182,@NoteId,@StrippingSchedule,'updated',@CreatedBy,GETDATE(),@UpdatedBy,GETDATE()
		END


END

-------------------------------------------------------------------------------------------------------------

--FinancingFeeSchedule

IF NOT EXISTS
(
	select 1 FROM core.Event e
	INNER JOIN  @noteAdditinallist t
	ON e.EventID = t.EventID
	where  e.EffectiveStartDate = CONVERT(date, t.EffectiveDate, 101)
	AND ModuleId = @FinancingFeeSchedule
	AND e.AccountID=@accountID
)
AND EXISTS
(
 select 1 from @noteAdditinallist where ModuleId = @FinancingFeeSchedule
)

BEGIN
   INSERT INTO [App].[ActivityLog]
			   ([ParentModuleID]
			   ,[ParentModuleTypeID]
			   ,[ModuleID]
			   
			   ,[ActivityType]
			   ,[DisplayMessage]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[UpdatedBy]
			   ,[UpdatedDate])
				 select @NoteId,182,@NoteId,@FinancingFeeSchedule,'inserted',@CreatedBy,GETDATE(),@UpdatedBy,GETDATE()
END
ELSE 
BEGIN
		IF exists(
				SELECT 1 FROM @noteAdditinallist tp
				WHERE ModuleId = @FinancingFeeSchedule and ScheduleID is null AND ValueTypeID IS NOT NULL AND [Date] is not null)
		BEGIN
				 INSERT INTO [App].[ActivityLog]
			   ([ParentModuleID]
			   ,[ParentModuleTypeID]
			   ,[ModuleID]
			   
			   ,[ActivityType]
			   ,[DisplayMessage]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[UpdatedBy]
			   ,[UpdatedDate])
				 select @NoteId,182,@NoteId,@FinancingFeeSchedule,'inserted',@CreatedBy,GETDATE(),@UpdatedBy,GETDATE()
		END

		IF exists(
				select r.ValueTypeID FROM core.Event e
				INNER JOIN @noteAdditinallist t
				ON e.EventID = t.EventID
				AND e.EffectiveStartDate = CONVERT(date, t.EffectiveDate, 101)
				AND ModuleId = @FinancingFeeSchedule
				LEFT JOIN core.FinancingFeeSchedule r
				ON r.FinancingFeeScheduleID = t.ScheduleID
				AND r.Date = t.Date 
				AND r.ValueTypeID= t.ValueTypeID 
				AND isnull(r.Value,0)= isnull(t.Value,0) 
				
				WHERE
				e.StatusID=@Active and t.ValueTypeID IS NOT NULL 
				AND t.ScheduleID IS NOT NULL
				AND t.date is not null
				AND r.ValueTypeID IS NULL
				)
		BEGIN
				 INSERT INTO [App].[ActivityLog]
			   ([ParentModuleID]
			   ,[ParentModuleTypeID]
			   ,[ModuleID]
			   
			   ,[ActivityType]
			   ,[DisplayMessage]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[UpdatedBy]
			   ,[UpdatedDate])
				 select @NoteId,182,@NoteId,@FinancingFeeSchedule,'updated',@CreatedBy,GETDATE(),@UpdatedBy,GETDATE()
		END


END

-------------------------------------------------------------------------------------------------------------

--FinancingSchedule

IF NOT EXISTS
(
	select 1 FROM core.Event e
	INNER JOIN  @noteAdditinallist t
	ON e.EventID = t.EventID
	where  e.EffectiveStartDate = CONVERT(date, t.EffectiveDate, 101)
	AND ModuleId = @FinancingSchedule
	AND e.AccountID=@accountID
)
AND EXISTS
(
 select 1 from @noteAdditinallist where ModuleId = @FinancingSchedule
)

BEGIN
   INSERT INTO [App].[ActivityLog]
			   ([ParentModuleID]
			   ,[ParentModuleTypeID]
			   ,[ModuleID]
			   
			   ,[ActivityType]
			   ,[DisplayMessage]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[UpdatedBy]
			   ,[UpdatedDate])
				 select @NoteId,182,@NoteId,@FinancingSchedule,'inserted',@CreatedBy,GETDATE(),@UpdatedBy,GETDATE()
END
ELSE 
BEGIN
		IF exists(
				SELECT 1 FROM @noteAdditinallist tp
				WHERE ModuleId = @FinancingSchedule and ScheduleID is null AND ValueTypeID IS NOT NULL AND [Date] is not null)
		BEGIN
				 INSERT INTO [App].[ActivityLog]
			   ([ParentModuleID]
			   ,[ParentModuleTypeID]
			   ,[ModuleID]
			   
			   ,[ActivityType]
			   ,[DisplayMessage]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[UpdatedBy]
			   ,[UpdatedDate])
				 select @NoteId,182,@NoteId,@FinancingSchedule,'inserted',@CreatedBy,GETDATE(),@UpdatedBy,GETDATE()
		END

		IF exists(
				select r.ValueTypeID FROM core.Event e
				INNER JOIN @noteAdditinallist t
				ON e.EventID = t.EventID
				AND e.EffectiveStartDate = CONVERT(date, t.EffectiveDate, 101)
				AND ModuleId = @FinancingSchedule
				LEFT JOIN core.FinancingSchedule r
				ON r.FinancingScheduleID = t.ScheduleID
				AND r.Date = t.Date 
				AND r.ValueTypeID= t.ValueTypeID 
				AND isnull(r.Value,0)= isnull(t.Value,0) 
				AND isnull(r.IntCalcMethodID,0)= isnull(t.IntCalcMethodID,0)
				AND isnull(r.CurrencyCode,0)= isnull(t.CurrencyCode,0)
				AND isnull(r.IndexTypeID,0)= isnull(t.IndexTypeID,0)
				WHERE
				e.StatusID=@Active and t.ValueTypeID IS NOT NULL 
				AND t.ScheduleID IS NOT NULL
				AND t.date is not null
				AND r.ValueTypeID IS NULL
				)
		BEGIN
				 INSERT INTO [App].[ActivityLog]
			   ([ParentModuleID]
			   ,[ParentModuleTypeID]
			   ,[ModuleID]
			   
			   ,[ActivityType]
			   ,[DisplayMessage]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[UpdatedBy]
			   ,[UpdatedDate])
				 select @NoteId,182,@NoteId,@FinancingSchedule,'updated',@CreatedBy,GETDATE(),@UpdatedBy,GETDATE()
		END


END

-------------------------------------------------------------------------------------------------------------

--DefaultSchedule

IF NOT EXISTS
(
	select 1 FROM core.Event e
	INNER JOIN  @noteAdditinallist t
	ON e.EventID = t.EventID
	where  e.EffectiveStartDate = CONVERT(date, t.EffectiveDate, 101)
	AND ModuleId = @DefaultSchedule
	AND e.AccountID=@accountID
)
AND EXISTS
(
 select 1 from @noteAdditinallist where ModuleId = @DefaultSchedule
)


BEGIN
   INSERT INTO [App].[ActivityLog]
			   ([ParentModuleID]
			   ,[ParentModuleTypeID]
			   ,[ModuleID]
			   
			   ,[ActivityType]
			   ,[DisplayMessage]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[UpdatedBy]
			   ,[UpdatedDate])
				 select @NoteId,182,@NoteId,@DefaultSchedule,'inserted',@CreatedBy,GETDATE(),@UpdatedBy,GETDATE()
END
ELSE 
BEGIN
		IF exists(
				SELECT 1 FROM @noteAdditinallist tp
				WHERE ModuleId = @DefaultSchedule and ScheduleID is null AND ValueTypeID IS NOT NULL AND StartDate is not null)
		BEGIN
				 INSERT INTO [App].[ActivityLog]
			   ([ParentModuleID]
			   ,[ParentModuleTypeID]
			   ,[ModuleID]
			   
			   ,[ActivityType]
			   ,[DisplayMessage]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[UpdatedBy]
			   ,[UpdatedDate])
				 select @NoteId,182,@NoteId,@DefaultSchedule,'inserted',@CreatedBy,GETDATE(),@UpdatedBy,GETDATE()
		END

		IF exists(
				select r.ValueTypeID FROM core.Event e
				INNER JOIN @noteAdditinallist t
				ON e.EventID = t.EventID
				AND e.EffectiveStartDate = CONVERT(date, t.EffectiveDate, 101)
				AND ModuleId = @DefaultSchedule
				LEFT JOIN core.DefaultSchedule r
				ON r.DefaultScheduleID = t.ScheduleID
				AND r.StartDate = t.StartDate
				AND r.EndDate = t.EndDate
				AND r.ValueTypeID= t.ValueTypeID 
				AND isnull(r.Value,0)= isnull(t.Value,0) 
				WHERE
				e.StatusID=@Active and t.ValueTypeID IS NOT NULL 
				AND t.ScheduleID IS NOT NULL
				AND t.StartDate is not null
				AND r.ValueTypeID IS NULL
				)
		BEGIN
				 INSERT INTO [App].[ActivityLog]
			   ([ParentModuleID]
			   ,[ParentModuleTypeID]
			   ,[ModuleID]
			   
			   ,[ActivityType]
			   ,[DisplayMessage]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[UpdatedBy]
			   ,[UpdatedDate])
				 select @NoteId,182,@NoteId,@DefaultSchedule,'updated',@CreatedBy,GETDATE(),@UpdatedBy,GETDATE()
		END


END

-------------------------------------------------------------------------------------------------------------

--PIKSchedule

IF NOT EXISTS 
(
	select 1 FROM core.Event e
	INNER JOIN  @noteAdditinallist t
	ON e.EventID = t.EventID
	where  e.EffectiveStartDate = CONVERT(date, t.EffectiveDate, 101)
	AND ModuleId = @PIKSchedule
	AND e.AccountID=@accountID
)
AND EXISTS
(
 select 1 from @noteAdditinallist where ModuleId = @PIKSchedule
)

BEGIN
   INSERT INTO [App].[ActivityLog]
			   ([ParentModuleID]
			   ,[ParentModuleTypeID]
			   ,[ModuleID]
			   
			   ,[ActivityType]
			   ,[DisplayMessage]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[UpdatedBy]
			   ,[UpdatedDate])
				 select @NoteId,182,@NoteId,@PIKSchedule,'inserted',@CreatedBy,GETDATE(),@UpdatedBy,GETDATE()
END
ELSE 
BEGIN
		IF exists(
				SELECT 1 FROM @noteAdditinallist tp
				WHERE ModuleId = @PIKSchedule and ScheduleID is null)
		BEGIN
				 INSERT INTO [App].[ActivityLog]
			   ([ParentModuleID]
			   ,[ParentModuleTypeID]
			   ,[ModuleID]
			   
			   ,[ActivityType]
			   ,[DisplayMessage]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[UpdatedBy]
			   ,[UpdatedDate])
				 select @NoteId,182,@NoteId,@PIKSchedule,'inserted',@CreatedBy,GETDATE(),@UpdatedBy,GETDATE()
		END

		IF exists(
				select r.PIKScheduleID FROM core.Event e
				INNER JOIN @noteAdditinallist t
				ON e.EventID = t.EventID
				AND e.EffectiveStartDate = CONVERT(date, t.EffectiveDate, 101)
				AND ModuleId = @PIKSchedule
				LEFT JOIN core.PIKSchedule r
				ON r.PIKScheduleID = t.ScheduleID
				AND isnull(r.SourceAccountID,'00000000-0000-0000-0000-000000000000') = isnull(t.SourceAccountID,'00000000-0000-0000-0000-000000000000')
				AND isnull(r.TargetAccountID,'00000000-0000-0000-0000-000000000000') = isnull(t.TargetAccountID,'00000000-0000-0000-0000-000000000000')
				AND isnull(r.AdditionalIntRate,0) =  isnull(t.AdditionalIntRate,0)
				AND isnull(r.AdditionalSpread,0) =  isnull(t.AdditionalSpread,0)
				AND isnull(r.IndexFloor,0) =  isnull(t.IndexFloor,0)
				AND isnull(r.IntCompoundingRate,0) =  isnull(t.IntCompoundingRate,0)
				AND isnull(r.IntCompoundingSpread,0) =  isnull(t.IntCompoundingSpread,0)
				AND r.StartDate = t.StartDate
				AND isnull(r.EndDate,getdate()) = isnull(t.EndDate,getdate())
				AND isnull(r.IntCapAmt,0) =  isnull(t.IntCapAmt,0)
				AND isnull(r.PurBal,0) =  isnull(t.PurBal,0)
				AND isnull(r.AccCapBal,0) =  isnull(t.AccCapBal,0)
				where  r.PIKScheduleID IS NULL
				)
		BEGIN
				 INSERT INTO [App].[ActivityLog]
			   ([ParentModuleID]
			   ,[ParentModuleTypeID]
			   ,[ModuleID]
			   
			   ,[ActivityType]
			   ,[DisplayMessage]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[UpdatedBy]
			   ,[UpdatedDate])
				 select @NoteId,182,@NoteId,@PIKSchedule,'updated',@CreatedBy,GETDATE(),@UpdatedBy,GETDATE()
		END


END

-------------------------------------------------------------------------------------------------------------

--ServicingFeeSchedule

IF NOT EXISTS
(
	select 1 FROM core.Event e
	INNER JOIN  @noteAdditinallist t
	ON e.EventID = t.EventID
	where  e.EffectiveStartDate = CONVERT(date, t.EffectiveDate, 101)
	AND ModuleId = @ServicingFeeSchedule
	AND e.AccountID=@accountID
)
AND EXISTS
(
 select 1 from @noteAdditinallist where ModuleId = @ServicingFeeSchedule
)

BEGIN
   INSERT INTO [App].[ActivityLog]
			   ([ParentModuleID]
			   ,[ParentModuleTypeID]
			   ,[ModuleID]
			   
			   ,[ActivityType]
			   ,[DisplayMessage]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[UpdatedBy]
			   ,[UpdatedDate])
				 select @NoteId,182,@NoteId,@ServicingFeeSchedule,'inserted',@CreatedBy,GETDATE(),@UpdatedBy,GETDATE()
END
ELSE 
BEGIN
		IF exists(
				SELECT 1 FROM @noteAdditinallist tp
				WHERE ModuleId = @ServicingFeeSchedule and ScheduleID is null and [date] is not null)
		BEGIN
				 INSERT INTO [App].[ActivityLog]
			   ([ParentModuleID]
			   ,[ParentModuleTypeID]
			   ,[ModuleID]
			   
			   ,[ActivityType]
			   ,[DisplayMessage]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[UpdatedBy]
			   ,[UpdatedDate])
				 select @NoteId,182,@NoteId,@ServicingFeeSchedule,'inserted',@CreatedBy,GETDATE(),@UpdatedBy,GETDATE()
		END

		IF exists(
				select r.ServicingFeeScheduleID FROM core.Event e
				INNER JOIN @noteAdditinallist t
				ON e.EventID = t.EventID
				AND e.EffectiveStartDate = CONVERT(date, t.EffectiveDate, 101)
				AND ModuleId = @ServicingFeeSchedule
				LEFT JOIN core.ServicingFeeSchedule r
				ON r.ServicingFeeScheduleID = t.ScheduleID
				AND r.Date = t.Date 
				AND isnull(r.Value,0) =  isnull(t.Value,0)
				AND isnull(r.IsCapitalized,0) =  isnull(t.IsCapitalized,0)
				where e.StatusID=@Active and t.date is not null
				and r.ServicingFeeScheduleID IS NULL
				)
		BEGIN
				 INSERT INTO [App].[ActivityLog]
			   ([ParentModuleID]
			   ,[ParentModuleTypeID]
			   ,[ModuleID]
			   
			   ,[ActivityType]
			   ,[DisplayMessage]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[UpdatedBy]
			   ,[UpdatedDate])
				 select @NoteId,182,@NoteId,@ServicingFeeSchedule,'updated',@CreatedBy,GETDATE(),@UpdatedBy,GETDATE()
		END


END

---------------------------------------------------------------------------------------------------------------

--Concept change
--FundingSchedule EventTypeID

DECLARE @SourceTable int, @DestinationTable int, @countAll int;
Select @SourceTable = count(f.Date) from Core.Event E
		Inner join Core.Account A on E.AccountID = A.Accountid
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = E.AccountID
		INNER JOIN CORE.FundingSchedule f ON f.EventId = E.EventID
		WHERE E.EventTypeID=@FundingSchedule
		AND n.NoteID = @NoteId
		AND E.StatusID=1
		AND E.EffectiveStartDate = (select max(EffectiveStartDate) from Core.Event where AccountID = A.Accountid and EventTypeID=@FundingSchedule AND StatusID=1)

--Select @DestinationTable = count(f.Date) from Core.Event E
--		Inner join Core.Account A on E.AccountID = A.Accountid
--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = E.AccountID
--		INNER JOIN @noteAdditinallist f ON f.EventId = E.EventID
--		WHERE E.EventTypeID=@FundingSchedule
--		AND n.NoteID = @NoteId

Select @DestinationTable = COUNT(ModuleId) from @noteAdditinallist where ModuleId = @FundingSchedule

		

--Comparing both tables
SELECT @countAll = COUNT(Date) from
(
select f.Date,f.Value,f.PurposeID,f.Applied,f.DrawFundingId,f.Comments from Core.Event E
		Inner join Core.Account A on E.AccountID = A.Accountid
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = E.AccountID
		INNER JOIN CORE.FundingSchedule f ON f.EventId = E.EventID
		WHERE E.EventTypeID=@FundingSchedule
		AND n.NoteID = @NoteId
		and E.StatusID=1
		AND E.EffectiveStartDate = (select max(EffectiveStartDate) from Core.Event where AccountID = A.Accountid and EventTypeID=@FundingSchedule AND StatusID=1)
UNION

select f.Date,f.Value,f.PurposeID,f.Applied,f.DrawFundingId,f.Comments from @noteAdditinallist f where ModuleId = @FundingSchedule

)a
   
IF(@SourceTable <> @DestinationTable OR @SourceTable <> @countAll )
BEGIN

IF EXISTS
	(
		select 1 from Core.Event E
		Inner join Core.Account A on E.AccountID = A.Accountid
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = E.AccountID
		INNER JOIN CORE.FundingSchedule f ON f.EventId = E.EventID
		WHERE E.EventTypeID=@FundingSchedule
		AND n.NoteID = @NoteId
	)
	SET @DisplayMessage = 'Updated'
	
	INSERT INTO [App].[ActivityLog]([ParentModuleID],[ParentModuleTypeID],
	[ModuleID],[ActivityType],[DisplayMessage],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
	SELECT @NoteId,182,@NoteId,@FundingSchedule,@DisplayMessage,@CreatedBy,GETDATE(),@UpdatedBy,GETDATE()
END

---------------------------------------------------------------------------------------------------------------

--PIKScheduleDetail
SET @DisplayMessage = 'Inserted'

Select @SourceTable = count(f.Date) from Core.Event E
		Inner join Core.Account A on E.AccountID = A.Accountid
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = E.AccountID
		INNER JOIN CORE.PIKScheduleDetail f ON f.EventId = E.EventID
		WHERE E.EventTypeID=@PIKScheduleDetail
		AND n.NoteID = @NoteId
		AND E.EffectiveStartDate = (select max(EffectiveStartDate) from Core.Event where AccountID = A.Accountid and EventTypeID=@PIKScheduleDetail)

--Select @DestinationTable = count(f.Date) from Core.Event E
--		Inner join Core.Account A on E.AccountID = A.Accountid
--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = E.AccountID
--		INNER JOIN @noteAdditinallist f ON f.EventId = E.EventID
--		WHERE E.EventTypeID=@PIKScheduleDetail
--		AND n.NoteID = @NoteId

Select @DestinationTable = COUNT(ModuleId) from @noteAdditinallist where ModuleId = @PIKScheduleDetail


--Comparing both tables
SELECT @countAll = COUNT(Date) from
(
select f.Date,f.Value from Core.Event E
		Inner join Core.Account A on E.AccountID = A.Accountid
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = E.AccountID
		INNER JOIN CORE.PIKScheduleDetail f ON f.EventId = E.EventID
		WHERE E.EventTypeID=@PIKScheduleDetail
		AND n.NoteID = @NoteId
		AND E.EffectiveStartDate = (select max(EffectiveStartDate) from Core.Event where AccountID = A.Accountid and EventTypeID=@PIKScheduleDetail)
UNION
--select f.Date,f.Value from Core.Event E
--		Inner join Core.Account A on E.AccountID = A.Accountid
--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = E.AccountID
--		INNER JOIN @noteAdditinallist f ON f.EventId = E.EventID
--		WHERE E.EventTypeID=@PIKScheduleDetail
--		AND n.NoteID = @NoteId
select f.Date,f.Value from @noteAdditinallist f where ModuleId = @PIKScheduleDetail
)a
   
IF(@SourceTable <> @DestinationTable OR @SourceTable <> @countAll )
BEGIN

IF EXISTS
	(
		select 1 from Core.Event E
		Inner join Core.Account A on E.AccountID = A.Accountid
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = E.AccountID
		INNER JOIN CORE.PIKScheduleDetail f ON f.EventId = E.EventID
		WHERE E.EventTypeID=@PIKScheduleDetail
		AND n.NoteID = @NoteId
	)
	SET @DisplayMessage = 'Updated'
	
	INSERT INTO [App].[ActivityLog]([ParentModuleID],[ParentModuleTypeID],
	[ModuleID],[ActivityType],[DisplayMessage],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
	SELECT @NoteId,182,@NoteId,@PIKScheduleDetail,@DisplayMessage,@CreatedBy,GETDATE(),@UpdatedBy,GETDATE()
END

---------------------------------------------------------------------------------------------------------------
--LIBORSchedule
IF EXISTS(Select 1 from @noteAdditinallist where ModuleId = @LIBORSchedule AND Value is not null)
BEGIN
SET @DisplayMessage = 'Inserted'

Select @SourceTable = count(f.Date) from Core.Event E
		Inner join Core.Account A on E.AccountID = A.Accountid
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = E.AccountID
		INNER JOIN CORE.LIBORSchedule f ON f.EventId = E.EventID
		WHERE E.EventTypeID=@LIBORSchedule
		AND n.NoteID = @NoteId
		AND f.Value is not null
		AND ISNULL(E.StatusID,1)=1
		AND E.EffectiveStartDate = (select max(EffectiveStartDate) from Core.Event where AccountID = A.Accountid and EventTypeID=@LIBORSchedule AND ISNULL(StatusID,1)=1)

--Select @DestinationTable = count(f.Date) from Core.Event E
--		Inner join Core.Account A on E.AccountID = A.Accountid
--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = E.AccountID
--		INNER JOIN @noteAdditinallist f ON f.EventId = E.EventID
--		WHERE E.EventTypeID=@LIBORSchedule
--		AND n.NoteID = @NoteId

Select @DestinationTable = COUNT(ModuleId) from @noteAdditinallist where ModuleId = @LIBORSchedule AND Value is not null


--Comparing both tables
SELECT @countAll = COUNT(Date) from
(
select f.Date,f.Value from Core.Event E
		Inner join Core.Account A on E.AccountID = A.Accountid
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = E.AccountID
		INNER JOIN CORE.LIBORSchedule f ON f.EventId = E.EventID
		WHERE E.EventTypeID=@LIBORSchedule
		AND n.NoteID = @NoteId
		AND f.Value is not null
		AND ISNULL(E.StatusID,1)=1
		AND E.EffectiveStartDate = (select max(EffectiveStartDate) from Core.Event where AccountID = A.Accountid and EventTypeID=@LIBORSchedule AND ISNULL(StatusID,1)=1)
UNION
--select f.Date,f.Value from Core.Event E
--		Inner join Core.Account A on E.AccountID = A.Accountid
--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = E.AccountID
--		INNER JOIN @noteAdditinallist f ON f.EventId = E.EventID
--		WHERE E.EventTypeID=@LIBORSchedule
--		AND n.NoteID = @NoteId
select f.Date,f.Value from @noteAdditinallist f where ModuleId = @LIBORSchedule AND Value is not null
)a
   
IF(@SourceTable <> @DestinationTable OR @SourceTable <> @countAll )
BEGIN

IF EXISTS
	(
		select 1 from Core.Event E
		Inner join Core.Account A on E.AccountID = A.Accountid
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = E.AccountID
		INNER JOIN CORE.LIBORSchedule f ON f.EventId = E.EventID
		WHERE E.EventTypeID=@LIBORSchedule
		AND n.NoteID = @NoteId
	)
	SET @DisplayMessage = 'Updated'
	
	INSERT INTO [App].[ActivityLog]([ParentModuleID],[ParentModuleTypeID],
	[ModuleID],[ActivityType],[DisplayMessage],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
	SELECT @NoteId,182,@NoteId,@LIBORSchedule,@DisplayMessage,@CreatedBy,GETDATE(),@UpdatedBy,GETDATE()
END
END
---------------------------------------------------------------------------------------------------------------
--AmortSchedule
SET @DisplayMessage = 'Inserted'

Select @SourceTable = count(f.Date) from Core.Event E
		Inner join Core.Account A on E.AccountID = A.Accountid
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = E.AccountID
		INNER JOIN CORE.AmortSchedule f ON f.EventId = E.EventID
		WHERE E.EventTypeID=@AmortSchedule
		AND n.NoteID = @NoteId
		AND E.StatusID=1
		AND E.EffectiveStartDate = (select max(EffectiveStartDate) from Core.Event where AccountID = A.Accountid and EventTypeID=@AmortSchedule AND StatusID=1)

--Select @DestinationTable = count(f.Date) from Core.Event E
--		Inner join Core.Account A on E.AccountID = A.Accountid
--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = E.AccountID
--		INNER JOIN @noteAdditinallist f ON f.EventId = E.EventID
--		WHERE E.EventTypeID=@AmortSchedule
--		AND n.NoteID = @NoteId

Select @DestinationTable = COUNT(ModuleId) from @noteAdditinallist where ModuleId = @AmortSchedule


--Comparing both tables
SELECT @countAll = COUNT(Date) from
(
select f.Date,f.Value from Core.Event E
		Inner join Core.Account A on E.AccountID = A.Accountid
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = E.AccountID
		INNER JOIN CORE.AmortSchedule f ON f.EventId = E.EventID
		WHERE E.EventTypeID=@AmortSchedule
		AND n.NoteID = @NoteId
		AND E.StatusID=1
		AND E.EffectiveStartDate = (select max(EffectiveStartDate) from Core.Event where AccountID = A.Accountid and EventTypeID=@AmortSchedule AND StatusID=1)
UNION
--select f.Date,f.Value from Core.Event E
--		Inner join Core.Account A on E.AccountID = A.Accountid
--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = E.AccountID
--		INNER JOIN @noteAdditinallist f ON f.EventId = E.EventID
--		WHERE E.EventTypeID=@AmortSchedule
--		AND n.NoteID = @NoteId

 select f.Date,f.Value from @noteAdditinallist f where ModuleId = @AmortSchedule
)a
   
IF(@SourceTable <> @DestinationTable OR @SourceTable <> @countAll )
BEGIN

IF EXISTS
	(
		select 1 from Core.Event E
		Inner join Core.Account A on E.AccountID = A.Accountid
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = E.AccountID
		INNER JOIN CORE.AmortSchedule f ON f.EventId = E.EventID
		WHERE E.EventTypeID=@AmortSchedule
		AND n.NoteID = @NoteId
	)
	SET @DisplayMessage = 'Updated'
	
	INSERT INTO [App].[ActivityLog]([ParentModuleID],[ParentModuleTypeID],
	[ModuleID],[ActivityType],[DisplayMessage],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
	SELECT @NoteId,182,@NoteId,@AmortSchedule,@DisplayMessage,@CreatedBy,GETDATE(),@UpdatedBy,GETDATE()
END



END
