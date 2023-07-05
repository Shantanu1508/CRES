

 
--DROP PROCEDURE [usp_InsertUpdateNoteAdditinalList] 


 
--DROP PROCEDURE [usp_InsertUpdateNoteAdditinalList] 
CREATE PROCEDURE [dbo].[usp_InsertUpdateNoteAdditinalList] 

@noteAdditinallistXML XML,
@CreatedBy nvarchar(256),
@UpdatedBy nvarchar(256),
@RequestType  nvarchar(256) = null,
@AnalysisID nvarchar(500)
--@TmpnoteAdditinallist TableTypeNoteInsert READONLY

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
	[Date] [Date] NULL,
	[DrawFundingId] [nvarchar](256) NULL,
	[EffectiveDate] [Date] NULL,
	[EffectiveEndDate] [Date] NULL,
	[EffectiveStartDate] [Date] NULL,
	[EndDate] [Date] NULL,
	[Event_Date] [Date] NULL,
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
	[UpdatedDate] [Date] NULL,
	[Value] [varchar](256) NULL,
	[ValueTypeID] [varchar](256) NULL,
	[ValueTypeText] [varchar](256) NULL,

	ScheduleEndDate  [varchar](256) NULL,
	FeeName  [varchar](256) NULL,
	FeeAmountOverride  [varchar](256) NULL,
	BaseAmountOverride  [varchar](256) NULL,
	ApplyTrueUpFeatureID  [varchar](256) NULL,
	PercentageOfFeeToBeStripped  [varchar](256) NULL,
	RateOrSpreadToBeStripped [varchar](256) NULL,
	PIKReasonCodeID int null,
	PIKComments nvarchar(max) null,
	PIKIntCalcMethodID int null,
	IndexNameID int null

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
nullif(Pers.value('(ValueTypeText)[1]', 'nvarchar(max)'), ''),

nullif(Pers.value('(ScheduleEndDate)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(FeeName)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(FeeAmountOverride)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(BaseAmountOverride)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(ApplyTrueUpFeatureID)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(PercentageOfFeeToBeStripped)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(RateOrSpreadToBeStripped)[1]', 'nvarchar(max)'), ''),

nullif(Pers.value('(PIKReasonCodeID)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(PIKComments)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(PIKIntCalcMethodID)[1]', 'nvarchar(max)'), ''),
nullif(Pers.value('(IndexNameID)[1]', 'nvarchar(max)'), '')

FROM @noteAdditinallistXML.nodes('/ArrayOfNoteAdditionalList/NoteAdditionalList') as t(Pers);

--=================

--=================


DECLARE @NoteID uniqueidentifier
SET @NoteID = (SELECT TOP 1 (NoteId) FROM @noteAdditinallist);


--INsert Activity log
BEGIN TRY
BEGIN TRAN
	
	EXEC [dbo].[usp_InsertActivityLogForObjects] @noteAdditinallistXML,@CreatedBy,@UpdatedBy

COMMIT TRAN
END TRY
BEGIN CATCH

	DECLARE @ErrorMessage NVARCHAR(4000);
	DECLARE @ErrorSeverity INT;
	DECLARE @ErrorState INT;


	IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION;
	-- Use RAISERROR inside the CATCH block to return error
	-- information about the original error that caused
	-- execution to jump to the CATCH block.


	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	  

END CATCH
--===================================


--Variable's--------------------

DECLARE @accountID varchar(256)

Declare  @BalanceTransactionSchedule  int  =5;
Declare  @DefaultSchedule  int  =6;
Declare  @FeeCouponSchedule  int  =7;
Declare  @FinancingFeeSchedule  int  =8;
Declare  @FinancingSchedule  int  =9;
Declare  @FundingSchedule  int  =10;
Declare  @Maturity  int  =11;
Declare  @PIKSchedule  int  =12;
Declare  @PrepayAndAdditionalFeeSchedule  int  =13;
Declare  @RateSpreadSchedule  int  =14;
Declare  @ServicingFeeSchedule  int  =15;
Declare  @StrippingSchedule  int  =16;
Declare  @PIKScheduleDetail  int  =17;
Declare  @LIBORSchedule  int  =18;
Declare  @AmortSchedule  int  =19;
Declare  @FeeCouponStripReceivable  int  =20;
---------------------------------
DECLARE @Active int = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
DECLARE @Inactive int = (Select LookupID from Core.Lookup where name = 'Inactive' and ParentID = 1)


SELECT @accountID = Account_AccountID FROM CRE.Note n inner join core.Account acc on acc.AccountID = n.Account_AccountID WHERE NoteID = (SELECT TOP 1 (NoteId) FROM @noteAdditinallist) and acc.IsDeleted = 0


	--Maturity
	---Update 
	--UPDATE core.Maturity 
	--SET
	--Maturity.SelectedMaturityDate = t.Date,  
	--Maturity.UpdatedBy = @UpdatedBy, 
	--Maturity.UpdatedDate = GETDATE()
	--FROM core.Event e
	--INNER JOIN @noteAdditinallist t
	--ON e.EventID = t.EventID
	--AND e.EffectiveStartDate = CONVERT(date, t.EffectiveDate, 101)
	--AND ModuleId = @Maturity
	--WHERE
	--Maturity.MaturityID = t.ScheduleID and t.Date is not null

	  --Insert

--	  INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
--		-- OUTPUT inserted.EventID INTO @tInserted(tinsertedVal)		
--		SELECT DISTINCT
--		  CONVERT(date, EffectiveDate, 101),
--		  @accountID,
--		  GETDATE(),
--		  ModuleId,
--		  NULL,
--		  @CreatedBy,
--		  GETDATE(),
--		  @UpdatedBy,
--		  GETDATE()
--		FROM @noteAdditinallist tp
--		WHERE --ScheduleID IS NULL AND
--		 ModuleId = @Maturity
--		AND CONVERT(date, tp.EffectiveDate, 101) NOT IN (SELECT
--		  EffectiveStartDate
--		FROM core.Event e
--		WHERE e.EventTypeID = @Maturity
--		AND e.AccountID = @accountID  ) and tp.date is not null


--IF(@@ROWCOUNT > 0)
--BEGIN
--	  INSERT INTO core.Maturity (EventId, SelectedMaturityDate, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
--		SELECT (SELECT TOP 1
--				 EventId
--			   FROM CORE.[event] e
--			   WHERE e.[EffectiveStartDate] = CONVERT(date, EffectiveDate, 101)
--			   AND e.[EventTypeID] = @Maturity
--			   AND e.AccountID = @accountID ),
--			   CONVERT(date, Date, 101),
--			  @CreatedBy,
--			  GETDATE(),
--			  @UpdatedBy,
--			  GETDATE()
--		FROM @noteAdditinallist
--		WHERE --ScheduleID IS NULL AND
--		 ModuleId = @Maturity and date is not null
--END
-------------------------------------------------------------------------------------------------------------

--RateSpreadSchedule


---Update 
UPDATE core.RateSpreadSchedule 
SET
RateSpreadSchedule.Date = t.Date, 
RateSpreadSchedule.ValueTypeID= t.ValueTypeID, 
RateSpreadSchedule.Value= t.Value, 
RateSpreadSchedule.IntCalcMethodID= t.IntCalcMethodID, 
RateSpreadSchedule.UpdatedBy = @UpdatedBy, 
RateSpreadSchedule.UpdatedDate = GETDATE(),
RateSpreadSchedule.RateOrSpreadToBeStripped = t.RateOrSpreadToBeStripped,
RateSpreadSchedule.IndexNameID = t.IndexNameID

FROM core.Event e
INNER JOIN @noteAdditinallist t
ON e.EventID = t.EventID
AND e.EffectiveStartDate = CONVERT(date, t.EffectiveDate, 101)
AND ModuleId = @RateSpreadSchedule
WHERE
RateSpreadSchedule.RateSpreadScheduleID = t.ScheduleID
and e.StatusID=@Active and t.Date is not null AND t.ValueTypeID IS NOT NULL
	
--Update Effective date as Inactive if ED > current/new effective date
Update core.Event
set StatusID=@Inactive
from @noteAdditinallist t
where Event.AccountID = @accountID and t.ModuleId = @RateSpreadSchedule and Event.EventTypeID = @RateSpreadSchedule 
and Event.EffectiveStartDate>t.EffectiveDate


  --Insert

  INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue,StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
    -- OUTPUT inserted.EventID INTO @tInserted(tinsertedVal)		
    SELECT DISTINCT
      CONVERT(date, EffectiveDate, 101),
      @accountID,
      GETDATE(),
      ModuleId,
      NULL,
	  @Active,
      @CreatedBy,
	  GETDATE(),
	  @UpdatedBy,
	  GETDATE()	
    FROM @noteAdditinallist tp
    WHERE --ScheduleID IS NULL AND
     ModuleId = @RateSpreadSchedule and tp.Date is not null 
	 AND tp.ValueTypeID IS NOT NULL
    AND 
	CONVERT(date, tp.EffectiveDate, 101) NOT IN (SELECT
      EffectiveStartDate
    FROM core.Event e
    WHERE e.EventTypeID = @RateSpreadSchedule
    AND e.AccountID = @accountID and  e.StatusID = @Active)
	
IF(@@ROWCOUNT > 0)
BEGIN
  INSERT INTO core.RateSpreadSchedule (EventId, Date, ValueTypeID, Value, IntCalcMethodID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate,RateOrSpreadToBeStripped,IndexNameID)
    SELECT (SELECT TOP 1
             EventId
           FROM CORE.[event] e
           WHERE e.[EffectiveStartDate] = CONVERT(date, EffectiveDate, 101)
           AND e.[EventTypeID] = @RateSpreadSchedule
           AND e.AccountID = @accountID and e.StatusID=@Active),
           CONVERT(date, Date, 101),
           ValueTypeID,
           Value,
           IntCalcMethodID,
        	@CreatedBy,
	GETDATE(),
	@UpdatedBy,
	GETDATE(),
	RateOrSpreadToBeStripped,
	IndexNameID
    FROM @noteAdditinallist 
    WHERE --ScheduleID IS NULL AND
     ModuleId = @RateSpreadSchedule and date is not null 
	 AND ValueTypeID IS NOT NULL
	 
END
ELSE
BEGIN
	INSERT INTO core.RateSpreadSchedule (EventId, Date, ValueTypeID, Value, IntCalcMethodID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate,RateOrSpreadToBeStripped,IndexNameID)
    SELECT (SELECT TOP 1
             EventId
           FROM CORE.[event] e
           WHERE e.[EffectiveStartDate] = CONVERT(date, EffectiveDate, 101)
           AND e.[EventTypeID] = @RateSpreadSchedule
           AND e.AccountID = @accountID and e.StatusID=@Active),
           CONVERT(date, Date, 101),
           ValueTypeID,
           Value,
           IntCalcMethodID,
        	@CreatedBy,
	GETDATE(),
	@UpdatedBy,
	GETDATE(),
	RateOrSpreadToBeStripped,
	IndexNameID
    FROM @noteAdditinallist
    WHERE --ScheduleID IS NULL AND
    ModuleId = @RateSpreadSchedule and (ScheduleID is null or ScheduleID not in (Select RateSpreadScheduleID from core.RateSpreadSchedule)) and date is not null
	 AND ValueTypeID IS NOT NULL
	
END
--------------------------------------------------------------------------------------------------------------------------------------------------------------

  --PrepayAndAdditionalFeeSchedule
  --Select * from core.PrepayAndAdditionalFeeSchedule

--Update 

UPDATE core.PrepayAndAdditionalFeeSchedule 
SET
PrepayAndAdditionalFeeSchedule.StartDate =  t.StartDate, 
PrepayAndAdditionalFeeSchedule.ValueTypeID= t.ValueTypeID, 
PrepayAndAdditionalFeeSchedule.Value= t.Value, 
PrepayAndAdditionalFeeSchedule.IncludedLevelYield= ISNULL(t.IncludedLevelYield,0), 
PrepayAndAdditionalFeeSchedule.IncludedBasis= ISNULL(t.IncludedBasis,0), 
PrepayAndAdditionalFeeSchedule.UpdatedBy = @UpdatedBy, 
PrepayAndAdditionalFeeSchedule.UpdatedDate = GETDATE(),

PrepayAndAdditionalFeeSchedule.FeeName = t.FeeName, 
PrepayAndAdditionalFeeSchedule.EndDate = t.ScheduleEndDate, 
PrepayAndAdditionalFeeSchedule.FeeAmountOverride = t.FeeAmountOverride, 
PrepayAndAdditionalFeeSchedule.BaseAmountOverride = t.BaseAmountOverride, 
PrepayAndAdditionalFeeSchedule.ApplyTrueUpFeature = t.ApplyTrueUpFeatureID, 
PrepayAndAdditionalFeeSchedule.FeetobeStripped = t.PercentageOfFeeToBeStripped 

FROM core.Event e
INNER JOIN @noteAdditinallist t
ON e.EventID = t.EventID
AND e.EffectiveStartDate = CONVERT(date, t.EffectiveDate, 101)
AND ModuleId = @PrepayAndAdditionalFeeSchedule
and e.StatusID=@Active
WHERE 
PrepayAndAdditionalFeeSchedule.PrepayAndAdditionalFeeScheduleID = t.ScheduleID and t.StartDate is not null
AND t.ValueTypeID IS NOT NULL

--Update Effective date as Inactive if ED > current/new effective date
Update core.Event
set StatusID=@Inactive
from @noteAdditinallist t
where Event.AccountID = @accountID and t.ModuleId = @PrepayAndAdditionalFeeSchedule and Event.EventTypeID = @PrepayAndAdditionalFeeSchedule 
and Event.EffectiveStartDate>t.EffectiveDate


--DELETE FROM core.PrepayAndAdditionalFeeSchedule
--WHERE PrepayAndAdditionalFeeScheduleID IN (SELECT
--t.ScheduleID
--FROM core.Event e
--INNER JOIN @noteAdditinallist t
--ON e.EventID = t.EventID
--AND e.EffectiveStartDate = CONVERT(datetime, t.EffectiveDate, 101)
--AND ModuleId = @PrepayAndAdditionalFeeSchedule)

--INSERT INTO core.PrepayAndAdditionalFeeSchedule (EventId, StartDate, ValueTypeID, Value, IncludedLevelYield, IncludedBasis, UpdatedBy, UpdatedDate)
--SELECT
--EventId,
--CONVERT(datetime, ScheduleStartDate, 101),
--ValueTypeID,
--Value,
--PPIncludeInLevelYieldCalc,
--PPIncludeInBasisCalc,
--UpdatedBy,
--GETDATE()
--FROM @noteAdditinallist
--WHERE ScheduleID IN (SELECT
--t.ScheduleID
--FROM core.Event e
--INNER JOIN @noteAdditinallist t
--ON e.EventID = t.EventID
--AND e.EffectiveStartDate = CONVERT(datetime, t.EffectiveDate, 101)
--AND ModuleId = @PrepayAndAdditionalFeeSchedule)





  --Insert

  INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue, StatusID,CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
    --  OUTPUT inserted.EventID INTO @tInserted(tinsertedVal)		
    SELECT DISTINCT
      CONVERT(date, EffectiveDate, 101),
      @accountID,
      GETDATE(),
      ModuleId,
      NULL,
	  @Active,
    @CreatedBy,
	GETDATE(),
	@UpdatedBy,
	GETDATE()
    FROM @noteAdditinallist tp
    WHERE --ScheduleID IS NULL AND
    ModuleId = @PrepayAndAdditionalFeeSchedule
    AND CONVERT(date, tp.EffectiveDate, 101) NOT IN (SELECT
      EffectiveStartDate
    FROM core.Event e
    WHERE e.EventTypeID = @PrepayAndAdditionalFeeSchedule
    AND e.AccountID = @accountID and e.StatusID = 1) and tp.StartDate is not null
	AND tp.ValueTypeID IS NOT NULL





IF(@@ROWCOUNT > 0)
BEGIN
  INSERT INTO core.PrepayAndAdditionalFeeSchedule (EventId, StartDate, ValueTypeID, Value, IncludedLevelYield, IncludedBasis, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate,FeeName,EndDate,FeeAmountOverride,BaseAmountOverride,ApplyTrueUpFeature,FeetobeStripped)
	SELECT 
	(SELECT TOP 1 EventId FROM CORE.[event] e	WHERE e.[EffectiveStartDate] = CONVERT(date, EffectiveDate, 101)	AND e.[EventTypeID] = @PrepayAndAdditionalFeeSchedule	AND e.AccountID = @accountID and e.StatusID=@Active),
	CONVERT(date, StartDate, 101),
	ValueTypeID,
	Value,
	ISNULL(IncludedLevelYield,0) as IncludedLevelYield,
	ISNULL(IncludedBasis,0) as IncludedBasis,
	@CreatedBy,
	GETDATE(),
	@UpdatedBy,
	GETDATE(),

	FeeName,
	CONVERT(date, ScheduleEndDate, 101) as EndDate,
	FeeAmountOverride as FeeAmountOverride,
	BaseAmountOverride as BaseAmountOverride,
	ApplyTrueUpFeatureID,
	ISNULL(PercentageOfFeeToBeStripped,0) as FeetobeStripped

	FROM @noteAdditinallist
	WHERE --ScheduleID IS NULL AND
	ModuleId = @PrepayAndAdditionalFeeSchedule and StartDate is not null  
	AND ValueTypeID IS NOT NULL

END
ELSE
BEGIN
	INSERT INTO core.PrepayAndAdditionalFeeSchedule (EventId, StartDate, ValueTypeID, Value, IncludedLevelYield, IncludedBasis, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate,FeeName,EndDate,FeeAmountOverride,BaseAmountOverride,ApplyTrueUpFeature,FeetobeStripped)
	SELECT 
	(SELECT TOP 1	EventId	FROM CORE.[event] e	WHERE e.[EffectiveStartDate] = CONVERT(date, EffectiveDate, 101)	AND e.[EventTypeID] = @PrepayAndAdditionalFeeSchedule	AND e.AccountID = @accountID and e.StatusID=@Active),
	CONVERT(date, StartDate, 101),
	ValueTypeID,
	Value,
	ISNULL(IncludedLevelYield,0) as IncludedLevelYield,
	ISNULL(IncludedBasis,0) as IncludedBasis,
	@CreatedBy,
	GETDATE(),
	@UpdatedBy,
	GETDATE(),

	FeeName,
	CONVERT(date, ScheduleEndDate, 101) as EndDate,
	FeeAmountOverride as FeeAmountOverride,
	BaseAmountOverride as BaseAmountOverride,
	ApplyTrueUpFeatureID,
	ISNULL(PercentageOfFeeToBeStripped,0) as FeetobeStripped

	FROM @noteAdditinallist
	WHERE --ScheduleID IS NULL AND
	ValueTypeID IS NOT NULL and
	ModuleId = @PrepayAndAdditionalFeeSchedule and (ScheduleID is null or ScheduleID not in (Select PrepayAndAdditionalFeeScheduleID from core.PrepayAndAdditionalFeeSchedule)) and StartDate is not null
END
 
--------------------------------------------------------------------------------------------------------------------------------------------------------------
--  --Stripping
--  --select * from core.StrippingSchedule

--  ---Update 

--UPDATE core.StrippingSchedule 
--SET
--StrippingSchedule.StartDate = t.StartDate, 
--StrippingSchedule.ValueTypeID= t.ValueTypeID, 
--StrippingSchedule.Value= t.Value, 
--StrippingSchedule.IncludedLevelYield= t.IncludedLevelYield, 
--StrippingSchedule.IncludedBasis= t.IncludedBasis, 
--StrippingSchedule.UpdatedBy = @UpdatedBy, 
--StrippingSchedule.UpdatedDate = GETDATE()
--FROM core.Event e
--INNER JOIN @noteAdditinallist t
--ON e.EventID = t.EventID
--AND e.EffectiveStartDate = CONVERT(date, t.EffectiveDate, 101)
--AND ModuleId = @StrippingSchedule
--WHERE
--StrippingSchedule.StrippingScheduleID = t.ScheduleID
--and e.StatusID=@Active and t.StartDate is not null
--AND t.ValueTypeID IS NOT NULL

----Update Effective date as Inactive if ED > current/new effective date
--Update core.Event
--set StatusID=@Inactive
--from @noteAdditinallist t
--where Event.AccountID = @accountID and t.ModuleId = @StrippingSchedule and Event.EventTypeID = @StrippingSchedule 
--and Event.EffectiveStartDate>t.EffectiveDate

----DELETE FROM core.StrippingSchedule
----WHERE StrippingScheduleID IN (SELECT
----t.ScheduleID
----FROM core.Event e
----INNER JOIN @noteAdditinallist t
----ON e.EventID = t.EventID
----AND e.EffectiveStartDate = CONVERT(datetime, t.EffectiveDate, 101)
----AND ModuleId = @StrippingSchedule)

----INSERT INTO core.StrippingSchedule (EventId, StartDate, ValueTypeID, Value, IncludedLevelYield, IncludedBasis, UpdatedBy, UpdatedDate)
----SELECT
----EventId,
----CONVERT(datetime, ScheduleStartDate, 101),
----ValueTypeID,
----Value,
----IncludedLevelYield,
----IncludedBasis,
----UpdatedBy,
----GETDATE()
----FROM @noteAdditinallist
----WHERE ScheduleID IN (SELECT
----t.ScheduleID
----FROM core.Event e
----INNER JOIN @noteAdditinallist t
----ON e.EventID = t.EventID
----AND e.EffectiveStartDate = CONVERT(datetime, t.EffectiveDate, 101)
----AND ModuleId = @StrippingSchedule)

--  --Insert

--  INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue,StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
--    --  OUTPUT inserted.EventID INTO @tInserted(tinsertedVal)		
--    SELECT DISTINCT
--      CONVERT(date, EffectiveDate, 101),
--      @accountID,
--      GETDATE(),
--      ModuleId,
--      NULL,
--	 @Active,
--   	@CreatedBy,
--	GETDATE(),
--	@UpdatedBy,
--	GETDATE()
--    FROM @noteAdditinallist tp
--    WHERE --ScheduleID IS NULL AND
--     ModuleId = @StrippingSchedule AND ValueTypeID IS NOT NULL
--    AND CONVERT(date, tp.EffectiveDate, 101) NOT IN (SELECT
--      EffectiveStartDate
--    FROM core.Event e
--    WHERE e.EventTypeID = @StrippingSchedule
--    AND e.AccountID = @accountID) and StartDate is not null



--IF(@@ROWCOUNT > 0)
--BEGIN
--  INSERT INTO core.StrippingSchedule (EventId, StartDate, ValueTypeID, Value, IncludedLevelYield, IncludedBasis, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
--    SELECT (SELECT TOP 1
--             EventId
--           FROM CORE.[event] e
--           WHERE e.[EffectiveStartDate] = CONVERT(date, EffectiveDate, 101)
--           AND e.[EventTypeID] = @StrippingSchedule
--           AND e.AccountID = @accountID and e.StatusID=@Active),
--           CONVERT(date,StartDate, 101),
--           ValueTypeID,
--           Value,
--           IncludedLevelYield,
--           IncludedBasis,
--          	@CreatedBy,
--	GETDATE(),
--	@UpdatedBy,
--	GETDATE()
--    FROM @noteAdditinallist
--    WHERE --ScheduleID IS NULL AND
--     ModuleId = @StrippingSchedule and StartDate is not null 
--	AND ValueTypeID IS NOT NULL

--END
--ELSE
--BEGIN
--	 INSERT INTO core.StrippingSchedule (EventId, StartDate, ValueTypeID, Value, IncludedLevelYield, IncludedBasis, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
--    SELECT (SELECT TOP 1
--             EventId
--           FROM CORE.[event] e
--           WHERE e.[EffectiveStartDate] = CONVERT(date, EffectiveDate, 101)
--           AND e.[EventTypeID] = @StrippingSchedule
--           AND e.AccountID = @accountID and e.StatusID=@Active),
--           CONVERT(date,StartDate, 101),
--           ValueTypeID,
--           Value,
--           IncludedLevelYield,
--           IncludedBasis,
--          	@CreatedBy,
--	GETDATE(),
--	@UpdatedBy,
--	GETDATE()
--    FROM @noteAdditinallist
--    WHERE --ScheduleID IS NULL AND
--     ModuleId = @StrippingSchedule and (ScheduleID is null or ScheduleID not in (Select StrippingScheduleID from core.StrippingSchedule)) and StartDate is not null AND ValueTypeID IS NOT NULL
--END
--------------------------------------------------------------------------------------------------------------------------------------------------------------
  --FinancingFeeSchedule 8
 
---Update 
--DELETE FROM core.FinancingFeeSchedule
--WHERE FinancingFeeScheduleID IN (SELECT
--t.ScheduleID
--FROM core.Event e
--INNER JOIN @noteAdditinallist t
--ON e.EventID = t.EventID
--AND e.EffectiveStartDate = CONVERT(datetime, t.EffectiveDate, 101)
--AND ModuleId = @FinancingFeeSchedule)

--INSERT INTO core.FinancingFeeSchedule (EventId, Date, ValueTypeID, Value, UpdatedBy, UpdatedDate)
--SELECT
--EventId,
--CONVERT(datetime, Date, 101),
--ValueTypeID,
--Value,
--UpdatedBy,
--GETDATE()
--FROM @noteAdditinallist
--WHERE ScheduleID IN (SELECT
--t.ScheduleID
--FROM core.Event e
--INNER JOIN @noteAdditinallist t
--ON e.EventID = t.EventID
--AND e.EffectiveStartDate = CONVERT(datetime, t.EffectiveDate, 101)
--AND ModuleId = @FinancingFeeSchedule)

UPDATE core.FinancingFeeSchedule 
SET
FinancingFeeSchedule.Date = t.Date, 
FinancingFeeSchedule.ValueTypeID= t.ValueTypeID, 
FinancingFeeSchedule.Value= t.Value, 
FinancingFeeSchedule.UpdatedBy = @UpdatedBy, 
FinancingFeeSchedule.UpdatedDate = GETDATE()
FROM core.Event e
INNER JOIN @noteAdditinallist t
ON e.EventID = t.EventID
AND e.EffectiveStartDate = CONVERT(date, t.EffectiveDate, 101)
AND ModuleId = @FinancingFeeSchedule and t.date is not null
WHERE
FinancingFeeSchedule.FinancingFeeScheduleID = t.ScheduleID
and e.StatusID=@Active AND t.ValueTypeID IS NOT NULL

--Update Effective date as Inactive if ED > current/new effective date
Update core.Event
set StatusID=@Inactive
from @noteAdditinallist t
where Event.AccountID = @accountID and t.ModuleId = @FinancingFeeSchedule and Event.EventTypeID = @FinancingFeeSchedule 
and Event.EffectiveStartDate>t.EffectiveDate

--Insert

  INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue,StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
    SELECT DISTINCT
      CONVERT(date, EffectiveDate, 101),
      @accountID,
      GETDATE(),
      ModuleId,
      NULL,
    @Active,
	@CreatedBy,
	GETDATE(),
	@UpdatedBy,
	GETDATE()
    FROM @noteAdditinallist tp
    WHERE --ScheduleID IS NULL AND
     ModuleId = @FinancingFeeSchedule
    AND CONVERT(date, tp.EffectiveDate, 101) NOT IN (SELECT
      EffectiveStartDate
    FROM core.Event e
    WHERE e.EventTypeID = @FinancingFeeSchedule
    AND e.AccountID = @accountID) and tp.date is not null AND tp.ValueTypeID IS NOT NULL


IF(@@ROWCOUNT > 0)
BEGIN 
  INSERT INTO core.FinancingFeeSchedule (EventId, Date, ValueTypeID, Value, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
    SELECT (SELECT TOP 1
             EventId
           FROM CORE.[event] e
           WHERE e.[EffectiveStartDate] = CONVERT(date, EffectiveDate, 101)
           AND e.[EventTypeID] = @FinancingFeeSchedule
           AND e.AccountID = @accountID and e.StatusID=@Active),
           CONVERT(date, Date, 101),
           ValueTypeID,
           Value,
         	@CreatedBy,
	GETDATE(),
	@UpdatedBy,
	GETDATE()
    FROM @noteAdditinallist
    WHERE --ScheduleID IS NULL AND
     ModuleId = @FinancingFeeSchedule and date is not null AND ValueTypeID IS NOT NULL
END
ELSE
BEGIN
  INSERT INTO core.FinancingFeeSchedule (EventId, Date, ValueTypeID, Value, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
    SELECT (SELECT TOP 1
             EventId
           FROM CORE.[event] e
           WHERE e.[EffectiveStartDate] = CONVERT(date, EffectiveDate, 101)
           AND e.[EventTypeID] = @FinancingFeeSchedule
           AND e.AccountID = @accountID and e.StatusID=@Active),
           CONVERT(date, Date, 101),
           ValueTypeID,
           Value,
         	@CreatedBy,
	GETDATE(),
	@UpdatedBy,
	GETDATE()
    FROM @noteAdditinallist
    WHERE --ScheduleID IS NULL AND
    ModuleId = @FinancingFeeSchedule and (ScheduleID is null or ScheduleID not in (Select FinancingFeeScheduleID from core.FinancingFeeSchedule)) and date is not null AND ValueTypeID IS NOT NULL
END
 
--------------------------------------------------------------------------------------------------------------------------------------------------------------
  --FinancingSchedule 9
  --SELECT * FROM Core.FinancingSchedule

  ---Update 
  --DELETE FROM core.FinancingSchedule
  --WHERE FinancingScheduleID IN (SELECT
  --    t.ScheduleID
  --  FROM core.Event e
  --  INNER JOIN @noteAdditinallist t
  --    ON e.EventID = t.EventID
  --    AND e.EffectiveStartDate = CONVERT(datetime, t.EffectiveDate, 101)
  --    AND ModuleId = @FinancingSchedule)

  --INSERT INTO core.FinancingSchedule (EventId, Date, ValueTypeID, Value, IntCalcMethodID, CurrencyCode, UpdatedBy, UpdatedDate)
  --  SELECT
  --    EventId,
  --    CONVERT(datetime, Date, 101),
  --    ValueTypeID,
  --    Value,
  --    IntCalcMethodID,
  --    CurrencyCode,
  --    UpdatedBy,
  --    GETDATE()
  --  FROM @noteAdditinallist
  --  WHERE ScheduleID IN (SELECT
  --    t.ScheduleID
  --  FROM core.Event e
  --  INNER JOIN @noteAdditinallist t
  --    ON e.EventID = t.EventID
  --    AND e.EffectiveStartDate = CONVERT(datetime, t.EffectiveDate, 101)
  --    AND ModuleId = @FinancingSchedule)


UPDATE core.FinancingSchedule 
SET
FinancingSchedule.Date = t.Date, 
FinancingSchedule.ValueTypeID= t.ValueTypeID, 
FinancingSchedule.Value= t.Value, 
FinancingSchedule.IntCalcMethodID= t.IntCalcMethodID, 
FinancingSchedule.CurrencyCode= t.CurrencyCode, 
FinancingSchedule.IndexTypeID=t.IndexTypeID,
FinancingSchedule.UpdatedBy = @UpdatedBy, 
FinancingSchedule.UpdatedDate = GETDATE()
FROM core.Event e
INNER JOIN @noteAdditinallist t
ON e.EventID = t.EventID
AND e.EffectiveStartDate = CONVERT(date, t.EffectiveDate, 101)
AND ModuleId = @FinancingSchedule and t.date is not null
WHERE
FinancingSchedule.FinancingScheduleID = t.ScheduleID 
and e.StatusID=@Active AND t.ValueTypeID IS NOT NULL


--Update Effective date as Inactive if ED > current/new effective date
Update core.Event
set StatusID=@Inactive
from @noteAdditinallist t
where Event.AccountID = @accountID and t.ModuleId = @FinancingSchedule and Event.EventTypeID = @FinancingSchedule 
and Event.EffectiveStartDate>t.EffectiveDate



--Insert
INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue, StatusID,CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
  
SELECT DISTINCT
    CONVERT(date, EffectiveDate, 101),
    @accountID,
    GETDATE(),
    ModuleId,
    NULL,
	@Active,
	@CreatedBy,
	GETDATE(),
	@UpdatedBy,
	GETDATE()
FROM @noteAdditinallist tp
WHERE --ScheduleID IS NULL AND
 ModuleId = @FinancingSchedule
AND CONVERT(date, tp.EffectiveDate, 101) NOT IN (SELECT
    EffectiveStartDate
FROM core.Event e
WHERE e.EventTypeID = @FinancingSchedule
AND e.AccountID = @accountID) and tp.date is not null AND tp.ValueTypeID IS NOT NULL

IF(@@ROWCOUNT > 0)
BEGIN  
	INSERT INTO core.FinancingSchedule (EventId, Date, ValueTypeID, Value,IndexTypeID, IntCalcMethodID, CurrencyCode, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
	SELECT (SELECT TOP 1
				EventId
			FROM CORE.[event] e
			WHERE e.[EffectiveStartDate] = CONVERT(date, EffectiveDate, 101)
			AND e.[EventTypeID] = @FinancingSchedule
			AND e.AccountID = @accountID and e.StatusID=@Active),
			CONVERT(date, Date, 101),
			ValueTypeID,
			Value,
			IndexTypeID,
			IntCalcMethodID,
			CurrencyCode,
		@CreatedBy,
		GETDATE(),
		@UpdatedBy,
		GETDATE()
	FROM @noteAdditinallist
	WHERE --ScheduleID IS NULL AND
	 ModuleId = @FinancingSchedule and date is not null AND ValueTypeID IS NOT NULL
END
ELSE
BEGIN
	INSERT INTO core.FinancingSchedule (EventId, Date, ValueTypeID, Value,IndexTypeID, IntCalcMethodID, CurrencyCode, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
	SELECT (SELECT TOP 1
				EventId
			FROM CORE.[event] e
			WHERE e.[EffectiveStartDate] = CONVERT(date, EffectiveDate, 101)
			AND e.[EventTypeID] = @FinancingSchedule
			AND e.AccountID = @accountID and e.StatusID=@Active),
			CONVERT(date, Date, 101),
			ValueTypeID,
			Value,
			IndexTypeID,
			IntCalcMethodID,
			CurrencyCode,
		@CreatedBy,
		GETDATE(),
		@UpdatedBy,
		GETDATE()
	FROM @noteAdditinallist
	WHERE --ScheduleID IS NULL AND
	ModuleId = @FinancingSchedule and (ScheduleID is null or ScheduleID not in (Select FinancingScheduleID from core.FinancingSchedule)) and date is not null AND ValueTypeID IS NOT NULL
END

 
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----@FundingSchedule

--UPDATE core.FundingSchedule 
--SET
--FundingSchedule.Date = t.Date, 
--FundingSchedule.Value= t.Value, 
--FundingSchedule.UpdatedBy = @UpdatedBy, 
--FundingSchedule.UpdatedDate = GETDATE()
--FROM core.Event e
--INNER JOIN @noteAdditinallist t
--ON e.EventID = t.EventID
--AND e.EffectiveStartDate = CONVERT(datetime, t.EffectiveDate, 101)
--AND ModuleId = @FundingSchedule
--WHERE
--FundingSchedule.FundingScheduleID = t.ScheduleID

----Insert in event table if effective date change
--INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue,CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
--SELECT 
--DISTINCT CONVERT(datetime, EffectiveDate, 101),
--@accountID,
--GETDATE(),
--ModuleId,
--NULL,
--	@CreatedBy,
--	GETDATE(),
--	@UpdatedBy,
--	GETDATE()
--FROM @noteAdditinallist tp
--WHERE --ScheduleID IS NULL AND
-- ModuleId = @FundingSchedule
--AND CONVERT(datetime, tp.EffectiveDate, 101) NOT IN 
--(
--	SELECT
--	EffectiveStartDate
--	FROM core.Event e
--	WHERE e.EventTypeID = @FundingSchedule
--	AND e.AccountID = @accountID
--)

--IF(@@ROWCOUNT > 0)
--BEGIN
--	--Insert in FundingSchedule table for changed effective date
--	INSERT INTO core.FundingSchedule (EventId, Date, Value, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate)
--	SELECT 
--	(SELECT TOP 1 EventId FROM CORE.[event] e  WHERE e.[EffectiveStartDate] = CONVERT(datetime, EffectiveDate, 101) 
--	AND e.[EventTypeID] = t.ModuleId AND e.AccountID = @accountID),          
--	CONVERT(datetime, Date, 101),
--	Value,
--	@CreatedBy,
--	GETDATE(),
--	@UpdatedBy,
--	GETDATE()
--	FROM @noteAdditinallist t
--	WHERE --ScheduleID IS NULL AND
--	ModuleId = @FundingSchedule
	

--END
--ELSE
--BEGIN
--	--Insert in FundingSchedule table for changed effective date
--	INSERT INTO core.FundingSchedule (EventId, Date, Value, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate)
--	SELECT 
--	(SELECT TOP 1 EventId FROM CORE.[event] e  WHERE e.[EffectiveStartDate] = CONVERT(datetime, EffectiveDate, 101) 
--	AND e.[EventTypeID] = @FundingSchedule AND e.AccountID = @accountID),          
--	CONVERT(datetime, Date, 101),
--	Value,
--	@CreatedBy,
--	GETDATE(),
--	@UpdatedBy,
--	GETDATE()
--	FROM @noteAdditinallist
--	WHERE --ScheduleID IS NULL AND
--	ModuleId = @FundingSchedule and (ScheduleID is null or ScheduleID not in (Select FundingScheduleID from core.FundingSchedule))
--END
------------------------------------------------------------------------------------------------------------------------------------------------------------------

--DefaultSchedule
---Update 
UPDATE core.DefaultSchedule 
SET
DefaultSchedule.StartDate = t.StartDate, 
DefaultSchedule.EndDate= t.EndDate, 
DefaultSchedule.Value= t.Value, 
DefaultSchedule.ValueTypeID= t.ValueTypeID, 
DefaultSchedule.UpdatedBy = @UpdatedBy, 
DefaultSchedule.UpdatedDate = GETDATE()
FROM core.Event e
INNER JOIN @noteAdditinallist t
ON e.EventID = t.EventID
AND e.EffectiveStartDate = CONVERT(date, t.EffectiveDate, 101)
AND ModuleId = @DefaultSchedule
WHERE
DefaultSchedule.DefaultScheduleID = t.ScheduleID
and e.StatusID=@Active and t.StartDate is not null AND t.ValueTypeID IS NOT NULL


--Update Effective date as Inactive if ED > current/new effective date
Update core.Event
set StatusID=@Inactive
from @noteAdditinallist t
where Event.AccountID = @accountID and t.ModuleId = @DefaultSchedule and Event.EventTypeID = @DefaultSchedule 
and Event.EffectiveStartDate>t.EffectiveDate

  --Insert

  INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue,StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
    -- OUTPUT inserted.EventID INTO @tInserted(tinsertedVal)		
    SELECT DISTINCT
      CONVERT(date, EffectiveDate, 101),
      @accountID,
      GETDATE(),
      ModuleId,
      NULL,
    @Active,
	@CreatedBy,
	GETDATE(),
	@UpdatedBy,
	GETDATE()
    FROM @noteAdditinallist tp
    WHERE --ScheduleID IS NULL AND
     ModuleId = @DefaultSchedule
    AND CONVERT(date, tp.EffectiveDate, 101) NOT IN (SELECT
      EffectiveStartDate
    FROM core.Event e
    WHERE e.EventTypeID = @DefaultSchedule
    AND e.AccountID = @accountID) and tp.StartDate is not null AND tp.ValueTypeID IS NOT NULL

IF(@@ROWCOUNT > 0)
BEGIN  
 
  INSERT INTO core.DefaultSchedule (EventId, StartDate,EndDate, ValueTypeID, Value, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
    SELECT (SELECT TOP 1
             EventId
           FROM CORE.[event] e
           WHERE e.[EffectiveStartDate] = CONVERT(date, EffectiveDate, 101)
           AND e.[EventTypeID] = @DefaultSchedule
           AND e.AccountID = @accountID and e.StatusID=@Active),
           CONVERT(date, StartDate, 101),
		    CONVERT(date, EndDate, 101),
           ValueTypeID,
           Value,          
        	@CreatedBy,
	GETDATE(),
	@UpdatedBy,
	GETDATE()
    FROM @noteAdditinallist
    WHERE --ScheduleID IS NULL AND
     ModuleId = @DefaultSchedule and StartDate is not null AND ValueTypeID IS NOT NULL
END
ELSE
BEGIN
	  INSERT INTO core.DefaultSchedule (EventId, StartDate,EndDate, ValueTypeID, Value, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
    SELECT (SELECT TOP 1
             EventId
           FROM CORE.[event] e
           WHERE e.[EffectiveStartDate] = CONVERT(date, EffectiveDate, 101)
           AND e.[EventTypeID] = @DefaultSchedule
           AND e.AccountID = @accountID and e.StatusID=@Active),
           CONVERT(date, StartDate, 101),
		    CONVERT(date, EndDate, 101),
           ValueTypeID,
           Value,          
        	@CreatedBy,
	GETDATE(),
	@UpdatedBy,
	GETDATE()
    FROM @noteAdditinallist
    WHERE --ScheduleID IS NULL AND
    ModuleId = @DefaultSchedule and (ScheduleID is null or ScheduleID not in (Select DefaultScheduleID from core.DefaultSchedule)) and StartDate is not null AND ValueTypeID IS NOT NULL
END

------------------------------------------------------------------------------------------------------------------------------------------------------------------
----@PIKScheduleDetail

--UPDATE core.PIKScheduleDetail 
--SET
--PIKScheduleDetail.Date = t.Date, 
--PIKScheduleDetail.Value= t.Value, 
--PIKScheduleDetail.UpdatedBy = @UpdatedBy, 
--PIKScheduleDetail.UpdatedDate = GETDATE()
--FROM core.Event e
--INNER JOIN @noteAdditinallist t
--ON e.EventID = t.EventID
--AND e.EffectiveStartDate = CONVERT(datetime, t.EffectiveDate, 101)
--AND ModuleId = @PIKScheduleDetail
--WHERE
--PIKScheduleDetail.PIKScheduleDetailID = t.ScheduleID

----Insert in event table if effective date change
--INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue, CreatedBy, CreatedDate,UpdatedBy, UpdatedDate)	
--SELECT 
--DISTINCT CONVERT(datetime, EffectiveDate, 101),
--@accountID,
--GETDATE(),
--ModuleId,
--NULL,
--	@CreatedBy,
--	GETDATE(),
--	@UpdatedBy,
--	GETDATE()
--FROM @noteAdditinallist tp
--WHERE --ScheduleID IS NULL AND
-- ModuleId = @PIKScheduleDetail
--AND CONVERT(datetime, tp.EffectiveDate, 101) NOT IN 
--(
--	SELECT
--	EffectiveStartDate
--	FROM core.Event e
--	WHERE e.EventTypeID = @PIKScheduleDetail
--	AND e.AccountID = @accountID
--)

--IF(@@ROWCOUNT > 0)
--BEGIN
--	--Insert in PIKScheduleDetail table for changed effective date
--	INSERT INTO core.PIKScheduleDetail (EventId, Date, Value, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate)
--	SELECT 
--	(SELECT TOP 1 EventId FROM CORE.[event] e  WHERE e.[EffectiveStartDate] = CONVERT(datetime, EffectiveDate, 101) 
--	AND e.[EventTypeID] = @PIKScheduleDetail AND e.AccountID = @accountID),          
--	CONVERT(datetime, Date, 101),
--	Value,
--	@CreatedBy,
--	GETDATE(),
--	@UpdatedBy,
--	GETDATE()
--	FROM @noteAdditinallist
--	WHERE --ScheduleID IS NULL AND
--	ModuleId = @PIKScheduleDetail
	

--END
--ELSE
--BEGIN
--	--Insert in PIKScheduleDetail table for changed effective date
--	INSERT INTO core.PIKScheduleDetail (EventId, Date, Value, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate)
--	SELECT 
--	(SELECT TOP 1 EventId FROM CORE.[event] e  WHERE e.[EffectiveStartDate] = CONVERT(datetime, EffectiveDate, 101) 
--	AND e.[EventTypeID] = @PIKScheduleDetail AND e.AccountID = @accountID),          
--	CONVERT(datetime, Date, 101),
--	Value,
--	@CreatedBy,
--	GETDATE(),
--	@UpdatedBy,
--	GETDATE()
--	FROM @noteAdditinallist
--	WHERE --ScheduleID IS NULL AND
--	ModuleId = @PIKScheduleDetail and (ScheduleID is null or ScheduleID not in (Select PIKScheduleDetailID from core.PIKScheduleDetail))
--END
------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------
----@LIBORSchedule

--UPDATE core.LIBORSchedule 
--SET
--LIBORSchedule.Date = t.Date, 
--LIBORSchedule.Value= t.Value, 
--LIBORSchedule.UpdatedBy = @UpdatedBy, 
--LIBORSchedule.UpdatedDate = GETDATE()
--FROM core.Event e
--INNER JOIN @noteAdditinallist t
--ON e.EventID = t.EventID
--AND e.EffectiveStartDate = CONVERT(datetime, t.EffectiveDate, 101)
--AND ModuleId = @LIBORSchedule
--WHERE
--LIBORSchedule.LIBORScheduleID = t.ScheduleID

----Insert in event table if effective date change
--INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue, CreatedBy, CreatedDate,UpdatedBy, UpdatedDate)	
--SELECT 
--DISTINCT CONVERT(datetime, EffectiveDate, 101),
--@accountID,
--GETDATE(),
--ModuleId,
--NULL,
--	@CreatedBy,
--	GETDATE(),
--	@UpdatedBy,
--	GETDATE()
--FROM @noteAdditinallist tp
--WHERE --ScheduleID IS NULL AND
-- ModuleId = @LIBORSchedule
--AND CONVERT(datetime, tp.EffectiveDate, 101) NOT IN 
--(
--	SELECT
--	EffectiveStartDate
--	FROM core.Event e
--	WHERE e.EventTypeID = @LIBORSchedule
--	AND e.AccountID = @accountID
--)

--IF(@@ROWCOUNT > 0)
--BEGIN
--	--Insert in LIBORSchedule table for changed effective date
--	INSERT INTO core.LIBORSchedule (EventId, Date, Value, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate)
--	SELECT 
--	(SELECT TOP 1 EventId FROM CORE.[event] e  WHERE e.[EffectiveStartDate] = CONVERT(datetime, EffectiveDate, 101) 
--	AND e.[EventTypeID] = @LIBORSchedule AND e.AccountID = @accountID),          
--	CONVERT(datetime, Date, 101),
--	Value,
--	@CreatedBy,
--	GETDATE(),
--	@UpdatedBy,
--	GETDATE()
--	FROM @noteAdditinallist
--	WHERE --ScheduleID IS NULL AND
--	ModuleId = @LIBORSchedule
	

--END
--ELSE
--BEGIN
--	--Insert in LIBORSchedule table for changed effective date
--	INSERT INTO core.LIBORSchedule (EventId, Date, Value, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate)
--	SELECT 
--	(SELECT TOP 1 EventId FROM CORE.[event] e  WHERE e.[EffectiveStartDate] = CONVERT(datetime, EffectiveDate, 101) 
--	AND e.[EventTypeID] = @LIBORSchedule AND e.AccountID = @accountID),          
--	CONVERT(datetime, Date, 101),
--	Value,
--	@CreatedBy,
--	GETDATE(),
--	@UpdatedBy,
--	GETDATE()
--	FROM @noteAdditinallist
--	WHERE --ScheduleID IS NULL AND
--	ModuleId = @LIBORSchedule and (ScheduleID is null or ScheduleID not in (Select LIBORScheduleID from core.LIBORSchedule))
--END
------------------------------------------------------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------------------------------------------------------
----@AmortSchedule

--UPDATE core.AmortSchedule 
--SET
--AmortSchedule.Date = t.Date, 
--AmortSchedule.Value= t.Value, 
--AmortSchedule.UpdatedBy = @UpdatedBy, 
--AmortSchedule.UpdatedDate = GETDATE()
--FROM core.Event e
--INNER JOIN @noteAdditinallist t
--ON e.EventID = t.EventID
--AND e.EffectiveStartDate = CONVERT(datetime, t.EffectiveDate, 101)
--AND ModuleId = @AmortSchedule
--WHERE
--AmortSchedule.AmortScheduleID = t.ScheduleID

----Insert in event table if effective date change
--INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue, CreatedBy, CreatedDate,UpdatedBy, UpdatedDate)	
--SELECT 
--DISTINCT CONVERT(datetime, EffectiveDate, 101),
--@accountID,
--GETDATE(),
--ModuleId,
--NULL,
--	@CreatedBy,
--	GETDATE(),
--	@UpdatedBy,
--	GETDATE()
--FROM @noteAdditinallist tp
--WHERE --ScheduleID IS NULL AND
-- ModuleId = @AmortSchedule
--AND CONVERT(datetime, tp.EffectiveDate, 101) NOT IN 
--(
--	SELECT
--	EffectiveStartDate
--	FROM core.Event e
--	WHERE e.EventTypeID = @AmortSchedule
--	AND e.AccountID = @accountID
--)

--IF(@@ROWCOUNT > 0)
--BEGIN
--	--Insert in AmortSchedule table for changed effective date
--	INSERT INTO core.AmortSchedule (EventId, Date, Value, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate)
--	SELECT 
--	(SELECT TOP 1 EventId FROM CORE.[event] e  WHERE e.[EffectiveStartDate] = CONVERT(datetime, EffectiveDate, 101) 
--	AND e.[EventTypeID] = @AmortSchedule AND e.AccountID = @accountID),          
--	CONVERT(datetime, Date, 101),
--	Value,
--	@CreatedBy,
--	GETDATE(),
--	@UpdatedBy,
--	GETDATE()
--	FROM @noteAdditinallist
--	WHERE --ScheduleID IS NULL AND
--	ModuleId = @AmortSchedule
	

--END
--ELSE
--BEGIN
--	--Insert in AmortSchedule table for changed effective date
--	INSERT INTO core.AmortSchedule (EventId, Date, Value, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate)
--	SELECT 
--	(SELECT TOP 1 EventId FROM CORE.[event] e  WHERE e.[EffectiveStartDate] = CONVERT(datetime, EffectiveDate, 101) 
--	AND e.[EventTypeID] = @AmortSchedule AND e.AccountID = @accountID),          
--	CONVERT(datetime, Date, 101),
--	Value,
--	@CreatedBy,
--	GETDATE(),
--	@UpdatedBy,
--	GETDATE()
--	FROM @noteAdditinallist
--	WHERE --ScheduleID IS NULL AND
--	ModuleId = @AmortSchedule and (ScheduleID is null or ScheduleID not in (Select AmortScheduleID from core.AmortSchedule))
--END
------------------------------------------------------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------------------------------------------------------
----@FeeCouponStripReceivable

--UPDATE core.FeeCouponStripReceivable 
--SET
--FeeCouponStripReceivable.Date = t.Date, 
--FeeCouponStripReceivable.Value= t.Value, 
--FeeCouponStripReceivable.UpdatedBy = @UpdatedBy, 
--FeeCouponStripReceivable.UpdatedDate = GETDATE()
--FROM core.Event e
--INNER JOIN @noteAdditinallist t
--ON e.EventID = t.EventID
--AND e.EffectiveStartDate = CONVERT(datetime, t.EffectiveDate, 101)
--AND ModuleId = @FeeCouponStripReceivable
--WHERE
--FeeCouponStripReceivable.FeeCouponStripReceivableID = t.ScheduleID

----Insert in event table if effective date change
--INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue, CreatedBy, CreatedDate,UpdatedBy, UpdatedDate)	
--SELECT 
--DISTINCT CONVERT(datetime, EffectiveDate, 101),
--@accountID,
--GETDATE(),
--ModuleId,
--NULL,
--	@CreatedBy,
--	GETDATE(),
--	@UpdatedBy,
--	GETDATE()
--FROM @noteAdditinallist tp
--WHERE --ScheduleID IS NULL AND
-- ModuleId = @FeeCouponStripReceivable
--AND CONVERT(datetime, tp.EffectiveDate, 101) NOT IN 
--(
--	SELECT
--	EffectiveStartDate
--	FROM core.Event e
--	WHERE e.EventTypeID = @FeeCouponStripReceivable
--	AND e.AccountID = @accountID
--)

--IF(@@ROWCOUNT > 0)
--BEGIN
--	--Insert in FeeCouponStripReceivable table for changed effective date
--	INSERT INTO core.FeeCouponStripReceivable (EventId, Date, Value, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate)
--	SELECT 
--	(SELECT TOP 1 EventId FROM CORE.[event] e  WHERE e.[EffectiveStartDate] = CONVERT(datetime, EffectiveDate, 101) 
--	AND e.[EventTypeID] = @FeeCouponStripReceivable AND e.AccountID = @accountID),          
--	CONVERT(datetime, Date, 101),
--	Value,
--	@CreatedBy,
--	GETDATE(),
--	@UpdatedBy,
--	GETDATE()
--	FROM Core.tempinsert
--	WHERE --ScheduleID IS NULL AND
--	ModuleId = @FeeCouponStripReceivable
	

--END
--ELSE
--BEGIN
--	--Insert in FeeCouponStripReceivable table for changed effective date
--	INSERT INTO core.FeeCouponStripReceivable (EventId, Date, Value, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate)
--	SELECT 
--	(SELECT TOP 1 EventId FROM CORE.[event] e  WHERE e.[EffectiveStartDate] = CONVERT(datetime, EffectiveDate, 101) 
--	AND e.[EventTypeID] = @FeeCouponStripReceivable AND e.AccountID = @accountID),          
--	CONVERT(datetime, Date, 101),
--	Value,
--	@CreatedBy,
--	GETDATE(),
--	@UpdatedBy,
--	GETDATE()
--	FROM Core.tempinsert
--	WHERE --ScheduleID IS NULL AND
--	ModuleId = @FeeCouponStripReceivable and (ScheduleID is null or ScheduleID not in (Select FeeCouponStripReceivableID from core.FeeCouponStripReceivable))
--END
------------------------------------------------------------------------------------------------------------------------------------------------------------------


--PIKSchedule
---Update 
UPDATE core.PIKSchedule 
SET
PIKSchedule.SourceAccountID = t.SourceAccountID,
PIKSchedule.TargetAccountID = t.TargetAccountID,
PIKSchedule.AdditionalIntRate = t.AdditionalIntRate,
PIKSchedule.AdditionalSpread = t.AdditionalSpread,
PIKSchedule.IndexFloor = t.IndexFloor,
PIKSchedule.IntCompoundingRate = t.IntCompoundingRate,
PIKSchedule.IntCompoundingSpread = t.IntCompoundingSpread,
PIKSchedule.StartDate = t.StartDate,
PIKSchedule.EndDate = t.EndDate,
PIKSchedule.IntCapAmt = t.IntCapAmt,
PIKSchedule.PurBal = t.PurBal,
PIKSchedule.AccCapBal = t.AccCapBal,
PIKSchedule.UpdatedBy = @UpdatedBy, 
PIKSchedule.UpdatedDate = GETDATE(),
PIKSchedule.PIKReasonCodeID = t.PIKReasonCodeID,
PIKSchedule.PIKComments = t.PIKComments,
PIKSchedule.PIKIntCalcMethodID = t.PIKIntCalcMethodID

FROM core.Event e
INNER JOIN @noteAdditinallist t
ON e.EventID = t.EventID
AND e.EffectiveStartDate = CONVERT(date, t.EffectiveDate, 101)
AND ModuleId = @PIKSchedule
WHERE
PIKSchedule.PIKScheduleID = t.ScheduleID 

  --Insert

  INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
    -- OUTPUT inserted.EventID INTO @tInserted(tinsertedVal)		
	SELECT DISTINCT
	CONVERT(date, EffectiveDate, 101),
	@accountID,
	GETDATE(),
	ModuleId,
	NULL,
	@CreatedBy,
	GETDATE(),
	@UpdatedBy,
	GETDATE()
	FROM @noteAdditinallist tp
	WHERE --ScheduleID IS NULL AND
	ModuleId = @PIKSchedule
	AND CONVERT(date, tp.EffectiveDate, 101) NOT IN (SELECT
	EffectiveStartDate
	FROM core.Event e
	WHERE e.EventTypeID = @PIKSchedule
	AND e.AccountID = @accountID)




IF(@@ROWCOUNT > 0)
BEGIN
	INSERT INTO core.PIKSchedule (EventID,SourceAccountID,TargetAccountID,AdditionalIntRate,AdditionalSpread,IndexFloor,IntCompoundingRate,IntCompoundingSpread,StartDate,EndDate,IntCapAmt,PurBal,AccCapBal,CreatedBy, CreatedDate,UpdatedBy,UpdatedDate,PIKReasonCodeID,PIKComments,PIKIntCalcMethodID)
	SELECT (SELECT TOP 1
	EventId
	FROM CORE.[event] e
	WHERE e.[EffectiveStartDate] = CONVERT(date, EffectiveDate, 101)
	AND e.[EventTypeID] = @PIKSchedule
	AND e.AccountID = @accountID),
	SourceAccountID,
	TargetAccountID,
	AdditionalIntRate,
	AdditionalSpread,
	IndexFloor,
	IntCompoundingRate,
	IntCompoundingSpread,
	CONVERT(date, StartDate, 101),
	CONVERT(date, EndDate, 101),
	IntCapAmt,
	PurBal,
	AccCapBal,
	@CreatedBy,
	GETDATE(),
	@UpdatedBy,
	GETDATE(),
	PIKReasonCodeID,
	PIKComments,
	PIKIntCalcMethodID
	FROM @noteAdditinallist
	WHERE --ScheduleID IS NULL AND
	ModuleId = @PIKSchedule
END
-------------------------------------------------------------------------------------------------------------


-----Update PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate = Y if null for pik notes-----

IF EXISTS(
	Select Distinct n.noteid 
	from [CORE].PikSchedule pik 	
	INNER JOIN [CORE].[Event] e on e.EventID = pik.EventId  
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	Where acc.isdeleted <> 1
	and n.noteid = @NoteId
)
BEGIN
	update cre.note set PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate = 3 where noteid = @noteid and PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate is null
END












--ServicingFeeSchedule
---Update 
UPDATE core.ServicingFeeSchedule 
SET
ServicingFeeSchedule.Date = t.Date,  
ServicingFeeSchedule.Value = t.Value,  
ServicingFeeSchedule.IsCapitalized = t.IsCapitalized,  
ServicingFeeSchedule.UpdatedBy = @UpdatedBy, 
ServicingFeeSchedule.UpdatedDate = GETDATE()
FROM core.Event e
INNER JOIN @noteAdditinallist t
ON e.EventID = t.EventID
AND e.EffectiveStartDate = CONVERT(date, t.EffectiveDate, 101)
AND ModuleId = @ServicingFeeSchedule
WHERE
ServicingFeeSchedule.ServicingFeeScheduleID = t.ScheduleID
and e.StatusID=@Active and t.date is not null


--Update Effective date as Inactive if ED > current/new effective date
Update core.Event
set StatusID=@Inactive
from @noteAdditinallist t
where Event.AccountID = @accountID and t.ModuleId = @ServicingFeeSchedule and Event.EventTypeID = @ServicingFeeSchedule 
and Event.EffectiveStartDate>t.EffectiveDate

  --Insert

  INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue,StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
    -- OUTPUT inserted.EventID INTO @tInserted(tinsertedVal)		
    SELECT DISTINCT
      CONVERT(date, EffectiveDate, 101),
      @accountID,
      GETDATE(),
      ModuleId,
      NULL,
      @Active,
	  @CreatedBy,
      GETDATE(),
	  @UpdatedBy,
      GETDATE()
    FROM @noteAdditinallist tp
    WHERE --ScheduleID IS NULL AND
     ModuleId = @ServicingFeeSchedule
    AND CONVERT(date, tp.EffectiveDate, 101) NOT IN (SELECT
      EffectiveStartDate
    FROM core.Event e
    WHERE e.EventTypeID = @ServicingFeeSchedule
    AND e.AccountID = @accountID) and tp.date is not null


IF(@@ROWCOUNT > 0)
BEGIN
	INSERT INTO core.ServicingFeeSchedule (EventId,Date,Value,IsCapitalized, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
	SELECT (SELECT TOP 1
	EventId
	FROM CORE.[event] e
	WHERE e.[EffectiveStartDate] = CONVERT(date, EffectiveDate, 101)
	AND e.[EventTypeID] = @ServicingFeeSchedule
	AND e.AccountID = @accountID and e.StatusID=@Active),
	CONVERT(date, Date, 101),
	Value,
	IsCapitalized,
	@CreatedBy,
	GETDATE(),
	@UpdatedBy,
	GETDATE()
	FROM @noteAdditinallist
	WHERE --ScheduleID IS NULL AND
	ModuleId = @ServicingFeeSchedule and date is not null
END
---------------------------------------------------------------------------------------------------------------


DECLARE @SavingFromDeal bit = 0

--IF EXISTS(Select UseRuletoDetermineNoteFunding from cre.Note where noteid = @NoteID and ISNULL(UseRuletoDetermineNoteFunding,4) = 4)
--BEGIN
--	--INsert FundingSchedule new logic
--	DECLARE @noteFundingSchedule [TableTypeFundingSchedule]

--	INSERT INTO @noteFundingSchedule(NoteId,AccountId,Date,Value,PurposeID ,Applied,DrawFundingId,Comments)
--	Select 
--	NoteId,
--	@AccountId,
--	Date,
--	Value,
--	PurposeID,
--	Applied,
--	DrawFundingId,
--	Comments
--	From @noteAdditinallist
--	Where ModuleId = @FundingSchedule
--	and Date is not null

--	exec [dbo].[usp_InsertUpdateFundingSchedule] @noteFundingSchedule,@CreatedBy,@UpdatedBy,@SavingFromDeal

--END

--INsert PIKScheduleDetail new logic
DECLARE @notePIKScheduleDetail [TableTypePIKScheduleDetail]

INSERT INTO @notePIKScheduleDetail(NoteId,AccountId,Date,Value )
Select 
NoteId,
@AccountId,
Date,
Value 
From @noteAdditinallist
Where ModuleId = @PIKScheduleDetail
and Date is not null

exec [dbo].[usp_InsertUpdatePIKScheduleDetail] @notePIKScheduleDetail,@CreatedBy,@UpdatedBy



----INsert LIBORSchedule new logic
--DECLARE @noteLIBORSchedule [TableTypeLIBORSchedule]


--INSERT INTO @noteLIBORSchedule(NoteId,AccountId,Date,Value )
--Select 
--@NoteID,
--@AccountId,
--Date,
--Value 
--From @TmpnoteAdditinallist --@noteAdditinallist
--Where ModuleId = @LIBORSchedule
--and Date is not null

--exec [dbo].[usp_InsertUpdateLIBORSchedule] @noteLIBORSchedule,@CreatedBy,@UpdatedBy



--INsert AmortSchedule new logic
DECLARE @noteAmortSchedule [TableTypeAmortSchedule]

INSERT INTO @noteAmortSchedule(NoteId,AccountId,Date,Value )
Select 
NoteId,
@AccountId,
Date,
Value 
From @noteAdditinallist
Where ModuleId = @AmortSchedule
and Date is not null

exec [dbo].[usp_InsertUpdateAmortSchedule] @noteAmortSchedule,@CreatedBy,@UpdatedBy


----INsert FeeCouponStripReceivable new logic
--DECLARE @noteFeeCouponStripReceivable [TableTypeFeeCouponStripReceivable]

--INSERT INTO @noteFeeCouponStripReceivable(NoteId,AccountId,Date,Value )
--Select 
--NoteId,
--@AccountId,
--Date,
--Value 
--From @noteAdditinallist
--Where ModuleId = @FeeCouponStripReceivable
--and Date is not null and cast([Value] as decimal(28,15)) > 0

--exec [dbo].[usp_InsertUpdateFeeCouponStripReceivable] @noteFeeCouponStripReceivable,@CreatedBy,@UpdatedBy

--Send note for calculation
--if  @RequestType is null
--  BEGIN
--    if not exists(select * from core.Exceptions where ActionLevelID=(select Lookupid from core.Lookup where name='Critical' and ParentID=46)and ObjectTypeID=182 and ObjectID= (Select top 1 NoteId From @noteAdditinallist))
--		Begin
--			declare @TableTypeCalculationRequests TableTypeCalculationRequests
--			insert into @TableTypeCalculationRequests(NoteId,StatusText,UserName,PriorityText,AnalysisID)
--			Select top 1 NoteId,'Processing',@CreatedBy,'Real Time', @AnalysisID From @noteAdditinallist
--			exec  [dbo].[usp_QueueNotesForCalculation] @TableTypeCalculationRequests,@CreatedBy,@UpdatedBy 
--		end
--		ELSE
--		BEGIN
--		PRINT('else')	
--		END
--  END

--declare @NoteID uniqueidentifier=(SELECT TOP 1 (NoteId) FROM @noteAdditinallist)
EXEC [dbo].[usp_UpdateEffectiveDateAsClosingDateByNoteId] @NoteID


--========================================================================================================================
--Delete Duplicate record from schedules

Declare @lookUpEventID int;
Declare @LookUpEventName nvarchar(256);
Declare @EventID Uniqueidentifier;
Declare @effdate Date;

IF CURSOR_STATUS('global','CursorEvent')>=-1    
BEGIN    
DEALLOCATE CursorEvent    
END    
 
DECLARE CursorEvent CURSOR     
FOR    
(    
	Select e.eventid,l.lookupid,l.Name,MAX(e.EffectiveStartDate) effdate 
	from core.Event e
	inner join core.Lookup l on l.LookupID = e.EventTypeID and l.ParentID = 3
	inner join core.account acc on acc.accountid = e.accountid
	inner join cre.Note n on n.account_accountid = acc.accountid
	where e.StatusID = 1
	and n.noteid = (SELECT TOP 1 (NoteId) FROM @noteAdditinallist)
	group by l.lookupid,l.Name,e.AccountID,e.eventid
)
OPEN CursorEvent     
FETCH NEXT FROM CursorEvent    
INTO @EventID,@lookUpEventID,@LookUpEventName,@effdate
WHILE @@FETCH_STATUS = 0    
BEGIN  
	
	IF(@LookUpEventName  = 'DefaultSchedule')
	BEGIN
		WITH cte AS (
		Select StartDate,EndDate,ValueTypeID,Value ,row_number() OVER(PARTITION BY StartDate,EndDate,ValueTypeID,Value ORDER BY StartDate,EndDate,ValueTypeID,Value) AS [rn]
		from core.DefaultSchedule where eventid = @EventID
		)
		Delete from cte where [rn] > 1
	END

				
	IF(@LookUpEventName  = 'FinancingFeeSchedule')
	BEGIN
		WITH cte AS (
		Select Date,ValueTypeID,Value ,row_number() OVER(PARTITION BY Date,ValueTypeID,Value ORDER BY Date,ValueTypeID,Value) AS [rn]
		from core.FinancingFeeSchedule where eventid = @EventID
		)
		Delete from cte where [rn] > 1
	END

	IF(@LookUpEventName  = 'FinancingSchedule')
	BEGIN
		WITH cte AS (
		Select Date,ValueTypeID,Value,CurrencyCode,IndexTypeID,IntCalcMethodID ,row_number() OVER(PARTITION BY Date,ValueTypeID,Value,CurrencyCode,IndexTypeID,IntCalcMethodID ORDER BY Date,ValueTypeID,Value,CurrencyCode,IndexTypeID,IntCalcMethodID) AS [rn]
		from core.FinancingSchedule where eventid = @EventID
		)
		Delete from cte where [rn] > 1
	END
	 
	----as we are allowing duplicate records
	--IF(@LookUpEventName  = 'PrepayAndAdditionalFeeSchedule')
	--BEGIN
	--	WITH cte AS (
	--	Select StartDate,ValueTypeID,Value,IncludedLevelYield,IncludedBasis ,row_number() OVER(PARTITION BY StartDate,ValueTypeID,Value,IncludedLevelYield,IncludedBasis ORDER BY StartDate,ValueTypeID,Value,IncludedLevelYield,IncludedBasis) AS [rn]
	--	from core.PrepayAndAdditionalFeeSchedule where eventid = @EventID
	--	)
	--	Delete from cte where [rn] > 1
	--END

	IF(@LookUpEventName  = 'RateSpreadSchedule')
	BEGIN
		WITH cte AS (
		Select Date,ValueTypeID,Value,IntCalcMethodID ,row_number() OVER(PARTITION BY Date,ValueTypeID,Value,IntCalcMethodID ORDER BY Date,ValueTypeID,Value,IntCalcMethodID) AS [rn]
		from core.RateSpreadSchedule where eventid = @EventID
		)
		Delete from cte where [rn] > 1
	END

	IF(@LookUpEventName  = 'StrippingSchedule')
	BEGIN
		WITH cte AS (
		Select StartDate,ValueTypeID,Value,IncludedLevelYield,IncludedBasis ,row_number() OVER(PARTITION BY StartDate,ValueTypeID,Value,IncludedLevelYield,IncludedBasis ORDER BY StartDate,ValueTypeID,Value,IncludedLevelYield,IncludedBasis) AS [rn]
		from core.StrippingSchedule where eventid = @EventID
		)
		Delete from cte where [rn] > 1
	END

			
FETCH NEXT FROM CursorEvent    
INTO @EventID,@lookUpEventID,@LookUpEventName,@effdate
END  

END
