
CREATE PROCEDURE [dbo].[usp_InsertUpdateGeneralSetupDetailsEquity] 
(
	@AccountID UNIQUEIDENTIFIER,
	@EffectiveDate Date,
	@Commitment   decimal(28,15),
	@InitialMaturityDate	 Date,	

	@UserID	nvarchar(256)
)
AS
BEGIN
	DECLARE @LookupID int = (Select LookupID from core.lookup where parentid = 3 and [Name]='GeneralSetupDetailsEquity')

	Update core.Event set StatusID = 2 where EventID in (Select EventID from [Core].[Event] Where EventTypeID = @LookupID and AccountID=@AccountID and EffectiveStartDate > @EffectiveDate)


	Declare  @EventID UNIQUEIDENTIFIER;
	Set @EventID = (Select EventID from [Core].[Event] Where AccountID=@AccountID and EffectiveStartDate = @EffectiveDate)

	IF @EventID IS NULL
	BEGIN
		---=====Insert into Event table=====  
		DECLARE @insertedEventID uniqueidentifier;        
        
		DECLARE @tEvent TABLE (tEventID UNIQUEIDENTIFIER)        
		
		INSERT INTO Core.Event (EffectiveStartDate, AccountID, EventTypeID, StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
		OUTPUT inserted.EventID INTO @tEvent(tEventID)       
		VALUES(@EffectiveDate,@AccountID,@LookupID,1,@UserID,getdate(),@UserID,getdate()) 		     
  
		SELECT @insertedEventID = tEventID FROM @tEvent;        
		------------------------------------------- 
		
		Set @EventID=@insertedEventID;
	END
	ELSE
	BEGIN
		Delete from [Core].[GeneralSetupDetailsEquity] Where EventID = @EventID;
	END

	Insert INTO [Core].[GeneralSetupDetailsEquity] ([EventId],Commitment,InitialMaturityDate,[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
	VALUES(@EventID,@Commitment,@InitialMaturityDate,@UserID,getdate(),@UserID,getdate())

END
