
CREATE PROCEDURE [dbo].[usp_InsertUpdateLiabilityFeeSchedule] 
(
	@tbltype_DebtFeeSchedule [dbo].[TableTypeDebtFeeSchedule] READONLY,
	@UserID	nvarchar(256)
)
AS
BEGIN
	DECLARE @LookupID int = (Select LookupID from core.lookup where parentid = 3 and [Name]='PrepayAndAdditionalFeeScheduleLiability')

	DECLARE @AccountID UNIQUEIDENTIFIER
	DECLARE @EffectiveDate DATE
	DECLARE @AdditionalAccountID UNIQUEIDENTIFIER
	Declare @EventID UNIQUEIDENTIFIER

	DECLARE cur CURSOR FOR
    SELECT DISTINCT AccountID, EffectiveDate, AdditionalAccountID
    FROM @tbltype_DebtFeeSchedule

    OPEN cur
    FETCH NEXT FROM cur INTO @AccountID, @EffectiveDate, @AdditionalAccountID

	WHILE @@FETCH_STATUS = 0
    BEGIN

	Update core.Event set StatusID = 2 where EventID in (Select EventID from [Core].[Event] Where EventTypeID = @LookupID and AccountID=@AccountID and EffectiveStartDate > @EffectiveDate and AdditionalAccountID = @AdditionalAccountID)

	Set @EventID = (Select EventID from [Core].[Event] Where AccountID=@AccountID and EffectiveStartDate = @EffectiveDate and StatusID = 1  and EventTypeID = @LookupID and AdditionalAccountID = @AdditionalAccountID)

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
		Delete from [Core].[PrepayAndAdditionalFeeScheduleLiability] Where EventID = @EventID;
	END

	Insert INTO [Core].[PrepayAndAdditionalFeeScheduleLiability] ([EventId],FeeName,StartDate,EndDate,ValueTypeID,Value,FeeAmountOverride,BaseAmountOverride,ApplyTrueUpFeature,IncludedLevelYield,FeetobeStripped,[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
	SELECT @EventID, FeeName, StartDate, EndDate, ValueTypeID, Fee, FeeAmountOverride, BaseAmountOverride, ApplyTrueUpFeatureID, IncludedLevelYield, PercentageOfFeeToBeStripped, @UserID, GETDATE(), @UserID, GETDATE()
	FROM @tbltype_DebtFeeSchedule t 
	where   t.AccountID = @AccountID AND 
            t.EffectiveDate = @EffectiveDate AND 
            ISNULL(t.IsDeleted, 0) <> 1 AND
            t.AdditionalAccountID = @AdditionalAccountID

	--Delete effective dates thats do not have Fees
	Delete from core.Event where EventTypeID = 908 and AccountID= @AccountID and AdditionalAccountID = @AdditionalAccountID
	and EventID in (
		Select eventid from(
			SELECT e.EventID, e.EffectiveStartDate, COUNT(t.PrepayAndAdditionalFeeScheduleLiabilityID) cnt
			FROM core.Event e
			LEFT JOIN [Core].[PrepayAndAdditionalFeeScheduleLiability] t ON e.EventID = t.EventID
			WHERE e.EventTypeID = 908 and e.AccountID=@AccountID and e.AdditionalAccountID = @AdditionalAccountID
			group by e.EventID, e.EffectiveStartDate
		) a
		where cnt = 0
	)

	FETCH NEXT FROM cur INTO @AccountID, @EffectiveDate, @AdditionalAccountID
    END

    CLOSE cur
    DEALLOCATE cur

END
GO

