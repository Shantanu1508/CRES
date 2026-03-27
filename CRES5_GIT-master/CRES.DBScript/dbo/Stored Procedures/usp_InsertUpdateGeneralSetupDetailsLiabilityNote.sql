
CREATE PROCEDURE [dbo].[usp_InsertUpdateGeneralSetupDetailsLiabilityNote] 
(
	@AccountID UNIQUEIDENTIFIER,
	@EffectiveDate Date,
	@PaydownAdvanceRate   decimal(28,15),
	@FundingAdvanceRate	 decimal(28,15),
	@TargetAdvanceRate	 decimal(28,15),
	@MaturityDate Date,
	@UserID	nvarchar(256),
	@PledgeDate Date,
	@LiabilitySourceID Int
)
AS
BEGIN
	DECLARE @LookupID int = (Select LookupID from core.lookup where parentid = 3 and [Name]='GeneralSetupDetailsLiabilityNote')

	Update core.Event set StatusID = 2 where EventID in (Select EventID from [Core].[Event] Where EventTypeID = @LookupID and AccountID=@AccountID and EffectiveStartDate > @EffectiveDate)


	Declare  @EventID UNIQUEIDENTIFIER;
	Set @EventID = (Select EventID from [Core].[Event] Where AccountID=@AccountID and EffectiveStartDate = @EffectiveDate and EventTypeID = @LookupID and StatusID = 1)

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
		Delete from [Core].[GeneralSetupDetailsLiabilityNote] Where EventID = @EventID;
	END

	Insert INTO [Core].[GeneralSetupDetailsLiabilityNote] ([EventId],PaydownAdvanceRate,FundingAdvanceRate,TargetAdvanceRate,MaturityDate,[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],PledgeDate,LiabilitySourceID)
	VALUES(@EventID,@PaydownAdvanceRate,@FundingAdvanceRate,@TargetAdvanceRate,@MaturityDate,@UserID,getdate(),@UserID,getdate(),@PledgeDate,@LiabilitySourceID)

END
