

--DROP  PROCEDURE [dbo].[usp_InsertUpdateNoteCalculatorJsonAdditinalList]
CREATE PROCEDURE [dbo].[usp_InsertUpdateNoteCalculatorJsonAdditinalList] 
	@noteAdditinallist tblNoteAdditionalListForCalculator READONLY,
	@CreatedBy nvarchar(256),
	@UpdatedBy nvarchar(256)
AS
BEGIN



--DELETE FROM @noteAdditinallist

--INSERT INTO @noteAdditinallist
--(
--NoteId
--,EffectiveDate
--,Date
--,SelectedMaturityDate
--,EndDate
--,ValueTypeID
--,Value
--,IntCalcMethodID
--,IncludedLevelYield
--,IncludedBasis
--,MaxFeeAmt
--,IndexTypeID
--,CurrencyCode
--,IsCapitalized
--,SourceAccountID
--,SourceAccountText
--,TargetAccountID
--,TargetAccountText
--,AdditionalIntRate
--,AdditionalSpread
--,IndexFloor
--,IntCompoundingRate
--,IntCompoundingSpread
--,StartDate
--,ScheduleStartDate
--,IntCapAmt
--,PurBal
--,AccCapBal
--,ValueTypeText
--,IntCalcMethodText
--,CurrencyCodeText
--,IndexTypeText
--,IsCapitalizedText
--,ModuleId
--,CreatedBy
--,CreatedDate
--,UpdatedBy
--,UpdatedDate

--)
--Select 
--NoteId
--,EffectiveDate
--,Date
--,SelectedMaturityDate
--,EndDate
--,ValueTypeID
--,Value
--,IntCalcMethodID
--,IncludedLevelYield
--,IncludedBasis
--,MaxFeeAmt
--,IndexTypeID
--,CurrencyCode
--,IsCapitalized
--,SourceAccountID
--,SourceAccountText
--,TargetAccountID
--,TargetAccountText
--,AdditionalIntRate
--,AdditionalSpread
--,IndexFloor
--,IntCompoundingRate
--,IntCompoundingSpread
--,StartDate
--,ScheduleStartDate
--,IntCapAmt
--,PurBal
--,AccCapBal
--,ValueTypeText
--,IntCalcMethodText
--,CurrencyCodeText
--,IndexTypeText
--,IsCapitalizedText
--,ModuleId

--,@CreatedBy
--,GETDATE()
--,@UpdatedBy
--,GETDATE()
--From  @noteAdditinallist


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

DECLARE @Active int = (Select LookupID from Core.Lookup where name = 'Active'  and Parentid = 1)
---------------------------------

SELECT @accountID = Account_AccountID FROM CRE.Note n inner join core.Account acc on acc.AccountID = n.Account_AccountID WHERE NoteID = (SELECT TOP 1 (NoteId) FROM @noteAdditinallist) and acc.IsDeleted = 0


--@RateSpreadSchedule

Delete from CORE.RateSpreadSchedule where eventid in 
(
	Select eventid from CORE.Event 
	where eventtypeid = @RateSpreadSchedule
	and AccountID = @accountID and StatusID=@Active 
)

Delete from CORE.[Event] where EventTypeID = @RateSpreadSchedule AND AccountID = @accountID and StatusID=@Active


INSERT INTO Core.[Event](
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

Select 
Distinct EffectiveDate as [EffectiveStartDate],
@AccountID,
GETDATE() as [Date],
@RateSpreadSchedule as [EventTypeID],
NUll as [EffectiveEndDate],
NUll as [SingleEventValue],
@Active,
@CreatedBy,
getdate(),
@UpdatedBy,
getdate()
From @noteAdditinallist tp
where ModuleId = @RateSpreadSchedule
AND CONVERT(datetime, tp.EffectiveDate, 101) NOT IN (
	SELECT
	EffectiveStartDate
	FROM core.Event e
	WHERE e.EventTypeID = @RateSpreadSchedule AND e.AccountID = @accountID and e.StatusID=@Active
)


--Delete from CORE.RateSpreadSchedule where eventid in 
--(
--	Select eventid from CORE.Event where eventtypeid = @RateSpreadSchedule and EffectiveStartDate in 
--	(Select Distinct EffectiveDate from @noteAdditinallist where ModuleId = @RateSpreadSchedule) and AccountID=@accountID
--)

INSERT INTO core.RateSpreadSchedule (EventId, Date, ValueTypeID, Value, IntCalcMethodID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
    
SELECT 
(SELECT TOP 1 EventId FROM CORE.[event] e WHERE e.[EffectiveStartDate] = CONVERT(date, EffectiveDate, 101) AND e.[EventTypeID] = @RateSpreadSchedule AND e.AccountID = @accountID and e.StatusID=@Active),
CONVERT(datetime, Date, 101),
(Select LookupID from CORE.Lookup where name = t.ValueTypeText),
Value,
(Select LookupID from CORE.Lookup where name = t.IntCalcMethodText),
@CreatedBy,
GETDATE(),
@UpdatedBy,
GETDATE()
FROM @noteAdditinallist t
WHERE ModuleId = @RateSpreadSchedule
--------------------------------------------------------------------------

--@Maturity


Delete from CORE.maturity where eventid in (Select Eventid from core.event where accountid = @accountID and EventTypeID = @Maturity ) 
Delete from core.event where accountid = @accountID and EventTypeID = @Maturity


INSERT INTO Core.[Event](
[EffectiveStartDate],
[AccountID],
[Date],
[EventTypeID],
[EffectiveEndDate],
[SingleEventValue],
[CreatedBy],
[CreatedDate],
[UpdatedBy],
[UpdatedDate]
,StatusID)

Select 
Distinct EffectiveDate as [EffectiveStartDate],
@AccountID,
GETDATE() as [Date],
@Maturity as [EventTypeID],
NUll as [EffectiveEndDate],
NUll as [SingleEventValue],
@CreatedBy,
getdate(),
@UpdatedBy,
getdate(),
1 as StatusID
From @noteAdditinallist tp
where ModuleId = @Maturity
AND CONVERT(datetime, tp.EffectiveDate, 101) NOT IN (
	SELECT
	EffectiveStartDate
	FROM core.Event e
	WHERE e.EventTypeID = @Maturity AND e.AccountID = @accountID
)


--Delete from CORE.Maturity where eventid in 
--(
--	Select eventid from CORE.Event where eventtypeid = @Maturity and EffectiveStartDate in 
--	(Select Distinct EffectiveDate from @noteAdditinallist where ModuleId = @Maturity) and AccountID=@accountID
--)

INSERT INTO core.Maturity (EventId, SelectedMaturityDate, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
    
SELECT 
(SELECT TOP 1 EventId FROM CORE.[event] e WHERE e.[EffectiveStartDate] = CONVERT(date, EffectiveDate, 101) AND e.[EventTypeID] = @Maturity AND e.AccountID = @accountID),
CONVERT(datetime, t.SelectedMaturityDate, 101),
@CreatedBy,
GETDATE(),
@UpdatedBy,
GETDATE()
FROM @noteAdditinallist t
WHERE ModuleId = @Maturity
--------------------------------------------------------------------------

--@PrepayAndAdditionalFeeSchedule

Delete from CORE.PrepayAndAdditionalFeeSchedule where eventid in 
(
	Select eventid from CORE.Event 
	where eventtypeid = @PrepayAndAdditionalFeeSchedule
	and AccountID = @accountID and StatusID=@Active
)

Delete from CORE.[Event] where EventTypeID = @PrepayAndAdditionalFeeSchedule AND AccountID = @accountID and StatusID=@Active


INSERT INTO Core.[Event](
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

Select 
Distinct EffectiveDate as [EffectiveStartDate],
@AccountID,
GETDATE() as [Date],
@PrepayAndAdditionalFeeSchedule as [EventTypeID],
NUll as [EffectiveEndDate],
NUll as [SingleEventValue],
@Active,
@CreatedBy,
getdate(),
@UpdatedBy,
getdate()
From @noteAdditinallist tp
where ModuleId = @PrepayAndAdditionalFeeSchedule
AND CONVERT(datetime, tp.EffectiveDate, 101) NOT IN (
	SELECT
	EffectiveStartDate
	FROM core.Event e
	WHERE e.EventTypeID = @PrepayAndAdditionalFeeSchedule AND e.AccountID = @accountID and e.StatusID=@Active
)


--Delete from CORE.PrepayAndAdditionalFeeSchedule where eventid in 
--(
--	Select eventid from CORE.Event where eventtypeid = @PrepayAndAdditionalFeeSchedule and EffectiveStartDate in 
--	(Select Distinct EffectiveDate from @noteAdditinallist where ModuleId = @PrepayAndAdditionalFeeSchedule) and AccountID=@accountID
--)

INSERT INTO core.PrepayAndAdditionalFeeSchedule (EventId, StartDate, ValueTypeID, Value, IncludedLevelYield, IncludedBasis, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
    
SELECT 
(SELECT TOP 1 EventId FROM CORE.[event] e WHERE e.[EffectiveStartDate] = CONVERT(date, EffectiveDate, 101) AND e.[EventTypeID] = @PrepayAndAdditionalFeeSchedule AND e.AccountID = @accountID and e.StatusID=@Active),
t.ScheduleStartDate,
(Select LookupID from CORE.Lookup where name = t.ValueTypeText),
Value,
t.IncludedLevelYield,
t.IncludedBasis,
@CreatedBy,
GETDATE(),
@UpdatedBy,
GETDATE()
FROM @noteAdditinallist t
WHERE ModuleId = @PrepayAndAdditionalFeeSchedule
--------------------------------------------------------------------------

--@StrippingSchedule


Delete from CORE.StrippingSchedule where eventid in 
(
	Select eventid from CORE.Event 
	where eventtypeid = @StrippingSchedule
	and AccountID = @accountID and StatusID=@Active
)

Delete from CORE.[Event] where EventTypeID = @StrippingSchedule AND AccountID = @accountID and StatusID=@Active

INSERT INTO Core.[Event](
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

Select 
Distinct EffectiveDate as [EffectiveStartDate],
@AccountID,
GETDATE() as [Date],
@StrippingSchedule as [EventTypeID],
NUll as [EffectiveEndDate],
NUll as [SingleEventValue],
@Active,
@CreatedBy,
getdate(),
@UpdatedBy,
getdate()
From @noteAdditinallist tp
where ModuleId = @StrippingSchedule
AND CONVERT(datetime, tp.EffectiveDate, 101) NOT IN (
	SELECT
	EffectiveStartDate
	FROM core.Event e
	WHERE e.EventTypeID = @StrippingSchedule AND e.AccountID = @accountID and e.StatusID=@Active
)


--Delete from CORE.StrippingSchedule where eventid in 
--(
--	Select eventid from CORE.Event where eventtypeid = @StrippingSchedule and EffectiveStartDate in 
--	(Select Distinct EffectiveDate from @noteAdditinallist where ModuleId = @StrippingSchedule) and AccountID=@accountID
--)

INSERT INTO core.StrippingSchedule (EventId, StartDate, ValueTypeID, Value, IncludedLevelYield, IncludedBasis, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
    
SELECT 
(SELECT TOP 1 EventId FROM CORE.[event] e WHERE e.[EffectiveStartDate] = CONVERT(date, EffectiveDate, 101) AND e.[EventTypeID] = @StrippingSchedule AND e.AccountID = @accountID and e.StatusID=@Active),
t.StartDate,
(Select LookupID from CORE.Lookup where name = t.ValueTypeText),
Value,
t.IncludedLevelYield,
t.IncludedBasis,
@CreatedBy,
GETDATE(),
@UpdatedBy,
GETDATE()
FROM @noteAdditinallist t
WHERE ModuleId = @StrippingSchedule
--------------------------------------------------------------------------


--@FinancingFeeSchedule


Delete from CORE.FinancingFeeSchedule where eventid in 
(
	Select eventid from CORE.Event 
	where eventtypeid = @FinancingFeeSchedule
	and AccountID = @accountID and StatusID=@Active
)

Delete from CORE.[Event] where EventTypeID = @FinancingFeeSchedule AND AccountID = @accountID and StatusID=@Active

INSERT INTO Core.[Event](
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

Select 
Distinct EffectiveDate as [EffectiveStartDate],
@AccountID,
GETDATE() as [Date],
@FinancingFeeSchedule as [EventTypeID],
NUll as [EffectiveEndDate],
NUll as [SingleEventValue],
@Active,
@CreatedBy,
getdate(),
@UpdatedBy,
getdate()
From @noteAdditinallist tp
where ModuleId = @FinancingFeeSchedule
AND CONVERT(datetime, tp.EffectiveDate, 101) NOT IN (
	SELECT
	EffectiveStartDate
	FROM core.Event e
	WHERE e.EventTypeID = @FinancingFeeSchedule AND e.AccountID = @accountID and e.StatusID=@Active
)


--Delete from CORE.FinancingFeeSchedule where eventid in 
--(
--	Select eventid from CORE.Event where eventtypeid = @FinancingFeeSchedule and EffectiveStartDate in 
--	(Select Distinct EffectiveDate from @noteAdditinallist where ModuleId = @FinancingFeeSchedule) and AccountID=@accountID
--)

INSERT INTO core.FinancingFeeSchedule (EventId, Date, ValueTypeID, Value, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
    
SELECT 
(SELECT TOP 1 EventId FROM CORE.[event] e WHERE e.[EffectiveStartDate] = CONVERT(date, EffectiveDate, 101) AND e.[EventTypeID] = @FinancingFeeSchedule AND e.AccountID = @accountID and e.StatusID=@Active),
t.Date,
(Select LookupID from CORE.Lookup where name = t.ValueTypeText),
Value,
@CreatedBy,
GETDATE(),
@UpdatedBy,
GETDATE()
FROM @noteAdditinallist t
WHERE ModuleId = @FinancingFeeSchedule
--------------------------------------------------------------------------


--@FinancingSchedule

Delete from CORE.FinancingSchedule where eventid in 
(
	Select eventid from CORE.Event 
	where eventtypeid = @FinancingSchedule
	and AccountID = @accountID and StatusID=@Active
)

Delete from CORE.[Event] where EventTypeID = @FinancingSchedule AND AccountID = @accountID and StatusID=@Active

INSERT INTO Core.[Event](
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

Select 
Distinct EffectiveDate as [EffectiveStartDate],
@AccountID,
GETDATE() as [Date],
@FinancingSchedule as [EventTypeID],
NUll as [EffectiveEndDate],
NUll as [SingleEventValue],
@Active,
@CreatedBy,
getdate(),
@UpdatedBy,
getdate()
From @noteAdditinallist tp
where ModuleId = @FinancingSchedule
AND CONVERT(datetime, tp.EffectiveDate, 101) NOT IN (
	SELECT
	EffectiveStartDate
	FROM core.Event e
	WHERE e.EventTypeID = @FinancingSchedule AND e.AccountID = @accountID and e.StatusID=@Active
)


--Delete from CORE.FinancingSchedule where eventid in 
--(
--	Select eventid from CORE.Event where eventtypeid = @FinancingSchedule and EffectiveStartDate in 
--	(Select Distinct EffectiveDate from @noteAdditinallist where ModuleId = @FinancingSchedule) and AccountID=@accountID
--)

INSERT INTO core.FinancingSchedule (EventId, Date, ValueTypeID, Value, IntCalcMethodID, CurrencyCode, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
    
SELECT 
(SELECT TOP 1 EventId FROM CORE.[event] e WHERE e.[EffectiveStartDate] = CONVERT(date, EffectiveDate, 101) AND e.[EventTypeID] = @FinancingSchedule AND e.AccountID = @accountID and e.StatusID=@Active),
t.Date,
(Select LookupID from CORE.Lookup where name = t.ValueTypeText),
Value,
(Select LookupID from CORE.Lookup where name = t.IntCalcMethodText),
(Select LookupID from CORE.Lookup where name = t.CurrencyCodeText),
@CreatedBy,
GETDATE(),
@UpdatedBy,
GETDATE()
FROM @noteAdditinallist t
WHERE ModuleId = @FinancingSchedule
--------------------------------------------------------------------------


--@PIKSchedule

Delete from CORE.PIKSchedule where eventid in 
(
	Select eventid from CORE.Event 
	where eventtypeid = @PIKSchedule
	and AccountID = @accountID
)

Delete from CORE.[Event] where EventTypeID = @PIKSchedule AND AccountID = @accountID

INSERT INTO Core.[Event](
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

Select 
Distinct EffectiveDate as [EffectiveStartDate],
@AccountID,
GETDATE() as [Date],
@PIKSchedule as [EventTypeID],
NUll as [EffectiveEndDate],
NUll as [SingleEventValue],
@CreatedBy,
getdate(),
@UpdatedBy,
getdate()
From @noteAdditinallist tp
where ModuleId = @PIKSchedule
AND CONVERT(datetime, tp.EffectiveDate, 101) NOT IN (
	SELECT
	EffectiveStartDate
	FROM core.Event e
	WHERE e.EventTypeID = @PIKSchedule AND e.AccountID = @accountID
)


--Delete from CORE.PIKSchedule where eventid in 
--(
--	Select eventid from CORE.Event where eventtypeid = @PIKSchedule and EffectiveStartDate in 
--	(Select Distinct EffectiveDate from @noteAdditinallist where ModuleId = @PIKSchedule) and AccountID=@accountID
--)

INSERT INTO core.PIKSchedule (EventID,SourceAccountID,TargetAccountID,AdditionalIntRate,AdditionalSpread,IndexFloor,IntCompoundingRate,IntCompoundingSpread,StartDate,EndDate,IntCapAmt,PurBal,AccCapBal,CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
    
SELECT 
(SELECT TOP 1 EventId FROM CORE.[event] e WHERE e.[EffectiveStartDate] = CONVERT(date, EffectiveDate, 101) AND e.[EventTypeID] = @PIKSchedule AND e.AccountID = @accountID),
nSourceAcc.Account_AccountID,
nTargetAcc.Account_AccountID,
t.AdditionalIntRate,
t.AdditionalSpread,
t.IndexFloor,
t.IntCompoundingRate,
t.IntCompoundingSpread,
t.StartDate,
t.EndDate,
t.IntCapAmt,
t.PurBal,
t.AccCapBal,
@CreatedBy,
GETDATE(),
@UpdatedBy,
GETDATE()
FROM @noteAdditinallist t
LEFT JOIN CRE.Note nSourceAcc on nSourceAcc.CRENoteID = t.SourceAccountID
LEFT JOIN CRE.Note nTargetAcc on nTargetAcc.CRENoteID = t.TargetAccountID
WHERE ModuleId = @PIKSchedule
--------------------------------------------------------------------------

--@DefaultSchedule

Delete from CORE.DefaultSchedule where eventid in 
(
	Select eventid from CORE.Event 
	where eventtypeid = @DefaultSchedule
	and AccountID = @accountID and StatusID=@Active
)

Delete from CORE.[Event] where EventTypeID = @DefaultSchedule AND AccountID = @accountID and StatusID=@Active

INSERT INTO Core.[Event](
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

Select 
Distinct EffectiveDate as [EffectiveStartDate],
@AccountID,
GETDATE() as [Date],
@DefaultSchedule as [EventTypeID],
NUll as [EffectiveEndDate],
NUll as [SingleEventValue],
@Active,
@CreatedBy,
getdate(),
@UpdatedBy,
getdate()
From @noteAdditinallist tp
where ModuleId = @DefaultSchedule
AND CONVERT(datetime, tp.EffectiveDate, 101) NOT IN (
	SELECT
	EffectiveStartDate
	FROM core.Event e
	WHERE e.EventTypeID = @DefaultSchedule AND e.AccountID = @accountID and e.StatusID=@Active
)


--Delete from CORE.DefaultSchedule where eventid in 
--(
--	Select eventid from CORE.Event where eventtypeid = @DefaultSchedule and EffectiveStartDate in 
--	(Select Distinct EffectiveDate from @noteAdditinallist where ModuleId = @DefaultSchedule) and AccountID=@accountID
--)

INSERT INTO core.DefaultSchedule (EventId, StartDate,EndDate, ValueTypeID, Value, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
    
SELECT 
(SELECT TOP 1 EventId FROM CORE.[event] e WHERE e.[EffectiveStartDate] = CONVERT(date, EffectiveDate, 101) AND e.[EventTypeID] = @DefaultSchedule AND e.AccountID = @accountID and e.StatusID=@Active),
t.StartDate,
t.EndDate,
(Select LookupID from CORE.Lookup where name = t.ValueTypeText),
Value,
@CreatedBy,
GETDATE(),
@UpdatedBy,
GETDATE()
FROM @noteAdditinallist t
WHERE ModuleId = @DefaultSchedule
--------------------------------------------------------------------------

 
--@ServicingFeeSchedule

Delete from CORE.ServicingFeeSchedule where eventid in 
(
	Select eventid from CORE.Event 
	where eventtypeid = @ServicingFeeSchedule
	and AccountID = @accountID and StatusID=@Active
)

Delete from CORE.[Event] where EventTypeID = @ServicingFeeSchedule AND AccountID = @accountID and StatusID=@Active


INSERT INTO Core.[Event](
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

Select 
Distinct EffectiveDate as [EffectiveStartDate],
@AccountID,
GETDATE() as [Date],
@ServicingFeeSchedule as [EventTypeID],
NUll as [EffectiveEndDate],
NUll as [SingleEventValue],
@Active,
@CreatedBy,
getdate(),
@UpdatedBy,
getdate()
From @noteAdditinallist tp
where ModuleId = @ServicingFeeSchedule
AND CONVERT(datetime, tp.EffectiveDate, 101) NOT IN (
	SELECT
	EffectiveStartDate
	FROM core.Event e
	WHERE e.EventTypeID = @ServicingFeeSchedule AND e.AccountID = @accountID and e.StatusID=@Active
)


--Delete from CORE.ServicingFeeSchedule where eventid in 
--(
--	Select eventid from CORE.Event where eventtypeid = @ServicingFeeSchedule and EffectiveStartDate in 
--	(Select Distinct EffectiveDate from @noteAdditinallist where ModuleId = @ServicingFeeSchedule) and AccountID=@accountID
--)

INSERT INTO core.ServicingFeeSchedule (EventId,Date,Value,IsCapitalized, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
    
SELECT 
(SELECT TOP 1 EventId FROM CORE.[event] e WHERE e.[EffectiveStartDate] = CONVERT(date, EffectiveDate, 101) AND e.[EventTypeID] = @ServicingFeeSchedule AND e.AccountID = @accountID and e.StatusID=@Active),
t.Date,
Value,
(Select LookupID from CORE.Lookup where name = t.IsCapitalizedText),
@CreatedBy,
GETDATE(),
@UpdatedBy,
GETDATE()
FROM @noteAdditinallist t
WHERE ModuleId = @ServicingFeeSchedule


----------------------------------------------------------



--@FundingSchedule

Delete from CORE.FundingSchedule where eventid in 
(
	Select eventid from CORE.Event 
	where eventtypeid = @FundingSchedule 
	and StatusID = @Active
	and AccountID = @accountID
)

Delete from CORE.[Event] where EventTypeID = @FundingSchedule AND AccountID = @accountID and StatusID = @Active


INSERT INTO Core.[Event](
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

Select 
Distinct EffectiveDate as [EffectiveStartDate],
@AccountID,
GETDATE() as [Date],
@FundingSchedule as [EventTypeID],
NUll as [EffectiveEndDate],
NUll as [SingleEventValue],
@Active,
@CreatedBy,
getdate(),
@UpdatedBy,
getdate()
From @noteAdditinallist tp
where ModuleId = @FundingSchedule
AND CONVERT(datetime, tp.EffectiveDate, 101) NOT IN (
	SELECT
	EffectiveStartDate
	FROM core.Event e
	WHERE e.EventTypeID = @FundingSchedule AND e.AccountID = @accountID and e.StatusID=@Active
)




INSERT INTO core.FundingSchedule (EventId, Date, Value, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate)
    
SELECT 
(SELECT TOP 1 EventId FROM CORE.[event] e WHERE e.[EffectiveStartDate] = CONVERT(date, EffectiveDate, 101) AND e.[EventTypeID] = @FundingSchedule AND e.AccountID = @accountID and e.StatusID=@Active),
t.Date,
Value,
@CreatedBy,
GETDATE(),
@UpdatedBy,
GETDATE()
FROM @noteAdditinallist t
WHERE ModuleId = @FundingSchedule
----------------------------------------------------------------------------------

--@PIKScheduleDetail

Delete from CORE.PIKScheduleDetail where eventid in 
(
	Select eventid from CORE.Event 
	where eventtypeid = @PIKScheduleDetail
	and AccountID = @accountID
)

Delete from CORE.[Event] where EventTypeID = @PIKScheduleDetail AND AccountID = @accountID


INSERT INTO Core.[Event](
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

Select 
Distinct EffectiveDate as [EffectiveStartDate],
@AccountID,
GETDATE() as [Date],
@PIKScheduleDetail as [EventTypeID],
NUll as [EffectiveEndDate],
NUll as [SingleEventValue],
@CreatedBy,
getdate(),
@UpdatedBy,
getdate()
From @noteAdditinallist tp
where ModuleId = @PIKScheduleDetail
AND CONVERT(datetime, tp.EffectiveDate, 101) NOT IN (
	SELECT
	EffectiveStartDate
	FROM core.Event e
	WHERE e.EventTypeID = @PIKScheduleDetail AND e.AccountID = @accountID
)


--Delete from CORE.PIKScheduleDetail where eventid in 
--(
--	Select eventid from CORE.Event where eventtypeid = @PIKScheduleDetail and EffectiveStartDate in 
--	(Select Distinct EffectiveDate from @noteAdditinallist where ModuleId = @PIKScheduleDetail) and AccountID=@accountID
--)

INSERT INTO core.PIKScheduleDetail (EventId, Date, Value, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate)
    
SELECT 
(SELECT TOP 1 EventId FROM CORE.[event] e WHERE e.[EffectiveStartDate] = CONVERT(date, EffectiveDate, 101) AND e.[EventTypeID] = @PIKScheduleDetail AND e.AccountID = @accountID),
t.Date,
Value,
@CreatedBy,
GETDATE(),
@UpdatedBy,
GETDATE()
FROM @noteAdditinallist t
WHERE ModuleId = @PIKScheduleDetail


----------------------------------------------------------------------------------
--@LIBORSchedule

--Insert LIBORSchedule new logic
DECLARE @noteLIBORSchedule [TableTypeLIBORSchedule]

INSERT INTO @noteLIBORSchedule(NoteId,AccountId,Date,Value )
Select 
NoteId,
@AccountId,
Date,
Value 
From @noteAdditinallist t
Where ModuleId = @LIBORSchedule
and Date is not null
AND t.EffectiveDate=(Select max(EffectiveDate) From @noteAdditinallist t Where ModuleId = @LIBORSchedule)
exec [dbo].[usp_InsertUpdateLIBORSchedule] @noteLIBORSchedule,@CreatedBy,@UpdatedBy

----------------------------------------------------------------------------------

--@AmortSchedule

Delete from CORE.AmortSchedule where eventid in 
(
	Select eventid from CORE.Event 
	where eventtypeid = @AmortSchedule
	and AccountID = @accountID
)

Delete from CORE.[Event] where EventTypeID = @AmortSchedule AND AccountID = @accountID

INSERT INTO Core.[Event](
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

Select 
Distinct EffectiveDate as [EffectiveStartDate],
@AccountID,
GETDATE() as [Date],
@AmortSchedule as [EventTypeID],
NUll as [EffectiveEndDate],
NUll as [SingleEventValue],
@CreatedBy,
getdate(),
@UpdatedBy,
getdate()
From @noteAdditinallist tp
where ModuleId = @AmortSchedule
AND CONVERT(datetime, tp.EffectiveDate, 101) NOT IN (
	SELECT
	EffectiveStartDate
	FROM core.Event e
	WHERE e.EventTypeID = @AmortSchedule AND e.AccountID = @accountID
)


--Delete from CORE.AmortSchedule where eventid in 
--(
--	Select eventid from CORE.Event where eventtypeid = @AmortSchedule and EffectiveStartDate in 
--	(Select Distinct EffectiveDate from @noteAdditinallist where ModuleId = @AmortSchedule) and AccountID=@accountID
--)

INSERT INTO core.AmortSchedule (EventId, Date, Value, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate)
    
SELECT 
(SELECT TOP 1 EventId FROM CORE.[event] e WHERE e.[EffectiveStartDate] = CONVERT(date, EffectiveDate, 101) AND e.[EventTypeID] = @AmortSchedule AND e.AccountID = @accountID),
t.Date,
Value,
@CreatedBy,
GETDATE(),
@UpdatedBy,
GETDATE()
FROM @noteAdditinallist t
WHERE ModuleId = @AmortSchedule

----------------------------------------------------------------------------------


--@FeeCouponStripReceivable

Delete from CORE.FeeCouponStripReceivable where eventid in 
(
	Select eventid from CORE.Event 
	where eventtypeid = @FeeCouponStripReceivable
	and AccountID = @accountID
)

Delete from CORE.[Event] where EventTypeID = @FeeCouponStripReceivable AND AccountID = @accountID


INSERT INTO Core.[Event](
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

Select 
Distinct EffectiveDate as [EffectiveStartDate],
@AccountID,
GETDATE() as [Date],
@FeeCouponStripReceivable as [EventTypeID],
NUll as [EffectiveEndDate],
NUll as [SingleEventValue],
@CreatedBy,
getdate(),
@UpdatedBy,
getdate()
From @noteAdditinallist tp
where ModuleId = @FeeCouponStripReceivable
AND CONVERT(datetime, tp.EffectiveDate, 101) NOT IN (
	SELECT
	EffectiveStartDate
	FROM core.Event e
	WHERE e.EventTypeID = @FeeCouponStripReceivable AND e.AccountID = @accountID
)


--Delete from CORE.FeeCouponStripReceivable where eventid in 
--(
--	Select eventid from CORE.Event where eventtypeid = @FeeCouponStripReceivable and EffectiveStartDate in 
--	(Select Distinct EffectiveDate from @noteAdditinallist where ModuleId = @FeeCouponStripReceivable) and AccountID=@accountID
--)

INSERT INTO core.FeeCouponStripReceivable (EventId, Date, Value, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate)
    
SELECT 
(SELECT TOP 1 EventId FROM CORE.[event] e WHERE e.[EffectiveStartDate] = CONVERT(date, EffectiveDate, 101) AND e.[EventTypeID] = @FeeCouponStripReceivable AND e.AccountID = @accountID),
t.Date,
Value,
@CreatedBy,
GETDATE(),
@UpdatedBy,
GETDATE()
FROM @noteAdditinallist t
WHERE ModuleId = @FeeCouponStripReceivable

----------------------------------------------------------------------------------



END
