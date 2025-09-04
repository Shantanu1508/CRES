-- Procedure

CREATE PROCEDURE [dbo].[usp_InsertRateSpreadScheduleSizer] 
@creNoteID nvarchar(256), 
@StartDate datetime,
@ValueTypeID int,
@Value decimal(28,15),
@IntCalcMethodID int,
@RateOrSpreadToBeStripped decimal(28,15),
@UpdatedBy nvarchar(256)

AS
BEGIN

Declare  @RateSpreadSchedule  int  =14;
DECLARE @accountID varchar(256)
DECLARE @ClosingDate datetime 
---------------------------------
DECLARE @Active int = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
DECLARE @Inactive int = (Select LookupID from Core.Lookup where name = 'Inactive' and ParentID = 1)

SELECT @accountID = n.Account_AccountID FROM CRE.Note n inner join core.Account ac on ac.AccountID=n.Account_AccountID
WHERE n.CRENoteID=@creNoteID  
 
 SELECT @ClosingDate = ClosingDate FROM CRE.Note n WHERE n.CRENoteID=@creNoteID 
--Insert
INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue,StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)	
	SELECT DISTINCT
	CONVERT(date, @ClosingDate, 101),
	@accountID,
	GETDATE(),
	@RateSpreadSchedule,
	NULL,
	@Active,
	@UpdatedBy,
	GETDATE(),
	@UpdatedBy,
	GETDATE()	
	WHERE @ClosingDate is not null
	AND CONVERT(date, @ClosingDate, 101) NOT IN (SELECT
	EffectiveStartDate FROM core.Event e WHERE e.EventTypeID = @RateSpreadSchedule
	AND e.AccountID = @accountID and  e.StatusID = @Active)


INSERT INTO core.RateSpreadSchedule (EventId, Date, ValueTypeID, Value, IntCalcMethodID,RateOrSpreadToBeStripped, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
	SELECT 
	(SELECT TOP 1 EventId FROM CORE.[event] e WHERE e.[EffectiveStartDate] = CONVERT(date, @ClosingDate, 101)
	AND e.[EventTypeID] = @RateSpreadSchedule AND e.AccountID = @accountID and e.StatusID=@Active),
	CONVERT(date, @StartDate, 101),
	@ValueTypeID,
	@Value,
	@IntCalcMethodID,
	@RateOrSpreadToBeStripped,
	@UpdatedBy,
	GETDATE(),
	@UpdatedBy,
	GETDATE()  
	WHERE @StartDate is not null AND @ValueTypeID IS NOT NULL and @ClosingDate is not null


	Declare @IndexNameID int;
	SET @IndexNameID = (SELECT n.IndexNameID FROM CRE.Note n inner join core.Account ac on ac.AccountID=n.Account_AccountID	WHERE n.CRENoteID=@creNoteID )


	IF NOT EXISTS(
	Select rs.RateSpreadScheduleID from [CORE].RateSpreadSchedule rs  
	INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId 
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	where e.StatusID = 1 
	and e.EffectiveStartDate = @ClosingDate
	and n.CRENoteID = @creNoteID
	and rs.[Date] = @ClosingDate
	and ValueTypeID = 778
	and rs.IndexNameID = @IndexNameID)
	BEGIN
		INSERT INTO core.RateSpreadSchedule (EventId, Date, ValueTypeID, Value, IntCalcMethodID,RateOrSpreadToBeStripped, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate,IndexNameID,DeterminationDateHolidayList)
		SELECT 
		(SELECT TOP 1 EventId FROM CORE.[event] e WHERE e.[EffectiveStartDate] = CONVERT(date, @ClosingDate, 101)
		AND e.[EventTypeID] = @RateSpreadSchedule AND e.AccountID = @accountID and e.StatusID=@Active),
		CONVERT(date, @ClosingDate, 101),
		778 as ValueTypeID,
		null as Value,
		null as IntCalcMethodID,
		null as RateOrSpreadToBeStripped,
		@UpdatedBy,
		GETDATE(),
		@UpdatedBy,
		GETDATE()  ,
		@IndexNameID,
		(CASE WHEN @IndexNameID = 245 THEN 412 ELSE  411 END)	 --245 -> 412, 777 -> 411
	END







END
