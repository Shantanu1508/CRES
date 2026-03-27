CREATE PROCEDURE [dbo].[usp_InsertUpdateInterestExpenseSchedule] 
(
	@tbltype_InterestExpenseSchedule [dbo].[TableTypeInterestExpenseSchedule] READONLY,
	@UserID	nvarchar(256)
)
AS
BEGIN
	DECLARE @LookupID int = 914 -- for 'LiabilityInterestExpense'

	DECLARE @AccountID UNIQUEIDENTIFIER
	DECLARE @EffectiveDate DATE
	DECLARE @AdditionalAccountID UNIQUEIDENTIFIER
	Declare @EventID UNIQUEIDENTIFIER

	DECLARE cur CURSOR FOR
    SELECT DISTINCT DebtAccountID, EffectiveDate, AdditionalAccountID
    FROM @tbltype_InterestExpenseSchedule

    OPEN cur
    FETCH NEXT FROM cur INTO @AccountID, @EffectiveDate, @AdditionalAccountID

	WHILE @@FETCH_STATUS = 0
    BEGIN

	Update core.Event set StatusID = 2 where EventID in (Select EventID from [Core].[Event] Where EventTypeID = @LookupID and AccountID=@AccountID and EffectiveStartDate > @EffectiveDate and AdditionalAccountID = @AdditionalAccountID)

	Set @EventID = (Select EventID from [Core].[Event] Where AccountID=@AccountID and EffectiveStartDate = @EffectiveDate and StatusID = 1 and EventTypeID = @LookupID and AdditionalAccountID = @AdditionalAccountID)

	IF @EventID IS NULL
	BEGIN
		---=====Insert into Event table=====  
		DECLARE @insertedEventID uniqueidentifier;        
        
		DECLARE @tEvent TABLE (tEventID UNIQUEIDENTIFIER)        
		
		INSERT INTO Core.Event (EffectiveStartDate, AccountID, EventTypeID, StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate, AdditionalAccountID)
		OUTPUT inserted.EventID INTO @tEvent(tEventID)       
		VALUES(@EffectiveDate,@AccountID,@LookupID,1,@UserID,getdate(),@UserID,getdate(), @AdditionalAccountID) 		     
  
		SELECT @insertedEventID = tEventID FROM @tEvent;        
		------------------------------------------- 
		
		Set @EventID=@insertedEventID;
	END
	ELSE
	BEGIN
		Delete from [Core].[InterestExpenseSchedule] Where EventID = @EventID;
	END

	INSERT INTO [Core].[InterestExpenseSchedule] (EventId, InitialInterestAccrualEndDate,PaymentDayOfMonth,PaymentDateBusinessDayLag,DeterminationDateLeadDays,DeterminationDateReferenceDayOftheMonth,InitialIndexValueOverride,FirstRateIndexResetDate,Recourse,CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
	SELECT @EventID, InitialInterestAccrualEndDate,PaymentDayOfMonth,PaymentDateBusinessDayLag,DeterminationDateLeadDays,DeterminationDateReferenceDayOftheMonth,InitialIndexValueOverride,FirstRateIndexResetDate,Recourse, @UserID, GETDATE(), @UserID, GETDATE()
	FROM @tbltype_InterestExpenseSchedule t 
	where   t.DebtAccountID = @AccountID AND 
            t.EffectiveDate = @EffectiveDate AND 
            t.AdditionalAccountID = @AdditionalAccountID

	--Delete effective dates thats do not have RSS
	Delete eve from core.Event eve where eve.EventTypeID = @LookupID and eve.AccountID = @AccountID and eve.AdditionalAccountID = @AdditionalAccountID
	and eve.EventID in (
		Select eventid from(
			SELECT e.EventID, e.EffectiveStartDate, COUNT(t.InterestExpenseScheduleID) cnt
			FROM core.Event e
			LEFT JOIN [Core].[InterestExpenseSchedule] t ON e.EventID = t.EventID
			WHERE e.EventTypeID = @LookupID and e.AccountID=@AccountID and e.AdditionalAccountID = @AdditionalAccountID
			group by e.EventID, e.EffectiveStartDate
		) a
		where cnt = 0
	)

	FETCH NEXT FROM cur INTO @AccountID, @EffectiveDate, @AdditionalAccountID
    END

    CLOSE cur
    DEALLOCATE cur

END