
CREATE PROCEDURE [dbo].[usp_InsertUpdateLiabilityRateSpreadSchedule] 
(
	@tbltype_LiabilityRateSpreadSchedule [dbo].[TableTypeLiabilityRateSpreadSchedule] READONLY,
	@UserID	nvarchar(256)
)
AS
BEGIN
	DECLARE @LookupID int = (Select LookupID from core.lookup where parentid = 3 and [Name]='RateSpreadScheduleLiability')

	DECLARE @AccountID UNIQUEIDENTIFIER
	DECLARE @EffectiveDate DATE
	DECLARE @AdditionalAccountID UNIQUEIDENTIFIER
	Declare @EventID UNIQUEIDENTIFIER

	DECLARE cur CURSOR FOR
    SELECT DISTINCT AccountID, EffectiveDate, AdditionalAccountID
    FROM @tbltype_LiabilityRateSpreadSchedule

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
		Delete from [Core].[RateSpreadScheduleLiability] Where EventID = @EventID;
	END

	INSERT INTO [Core].[RateSpreadScheduleLiability] (EventId, Date, ValueTypeID, Value, IntCalcMethodID,RateOrSpreadToBeStripped,IndexNameID,DeterminationDateHolidayList, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)

	SELECT @EventID, Date, ValueTypeID, Value, IntCalcMethodID,RateOrSpreadToBeStripped,IndexNameID,DeterminationDateHolidayList, @UserID, GETDATE(), @UserID, GETDATE()
	FROM @tbltype_LiabilityRateSpreadSchedule t 
	where   t.AccountID = @AccountID AND 
            t.EffectiveDate = @EffectiveDate AND 
            ISNULL(t.IsDeleted, 0) <> 1 AND
            t.AdditionalAccountID = @AdditionalAccountID

	--Delete effective dates thats do not have RSS
	Delete eve from core.Event eve where eve.EventTypeID = 909 and eve.AccountID = @AccountID and eve.AdditionalAccountID = @AdditionalAccountID
	and eve.EventID in (
		Select eventid from(
			SELECT e.EventID, e.EffectiveStartDate, COUNT(t.RateSpreadScheduleLiabilityID) cnt
			FROM core.Event e
			LEFT JOIN [Core].[RateSpreadScheduleLiability] t ON e.EventID = t.EventID
			WHERE e.EventTypeID = 909 and e.AccountID=@AccountID and e.AdditionalAccountID = @AdditionalAccountID
			group by e.EventID, e.EffectiveStartDate
		) a
		where cnt = 0
	)

	FETCH NEXT FROM cur INTO @AccountID, @EffectiveDate, @AdditionalAccountID
    END

    CLOSE cur
    DEALLOCATE cur

END
