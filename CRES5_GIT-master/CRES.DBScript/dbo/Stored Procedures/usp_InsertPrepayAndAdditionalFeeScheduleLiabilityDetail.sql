
CREATE PROCEDURE [dbo].[usp_InsertPrepayAndAdditionalFeeScheduleLiabilityDetail] 
(
	@tbltype_PrepayAndAdditionalFeeScheduleLiabilityDetail [dbo].[TableTypePrepayAndAdditionalFeeScheduleLiabilityDetail] READONLY,
	@UserID	nvarchar(256)
)
AS
BEGIN
	
	DECLARE @AccountID UNIQUEIDENTIFIER, @EffectiveDate DATE, @AdditionalAccountID UNIQUEIDENTIFIER, @EventID UNIQUEIDENTIFIER;
	DECLARE @LookupID int = (Select LookupID from core.lookup where parentid = 3 and [Name]='PrepayAndAdditionalFeeScheduleLiability');

	SELECT TOP 1 @AccountID = AccountID, @EffectiveDate = EffectiveDate, @AdditionalAccountID = AdditionalAccountID FROM @tbltype_PrepayAndAdditionalFeeScheduleLiabilityDetail;

	Set @EventID = (Select EventID from [Core].[Event] Where AccountID=@AccountID and CAST(EffectiveStartDate as Date) = Cast(@EffectiveDate as Date) and StatusID = 1  and EventTypeID = @LookupID and AdditionalAccountID = @AdditionalAccountID)
	
	Delete from [Core].[PrepayAndAdditionalFeeScheduleLiabilityDetail] Where PrepayAndAdditionalFeeScheduleLiabilityID NOT IN ( SELECT PrepayAndAdditionalFeeScheduleLiabilityID from [Core].[PrepayAndAdditionalFeeScheduleLiability]);
	
	Insert INTO [Core].[PrepayAndAdditionalFeeScheduleLiabilityDetail] (PrepayAndAdditionalFeeScheduleLiabilityId,[From],[To],[Value],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
	SELECT PA.PrepayAndAdditionalFeeScheduleLiabilityId, t.[From], t.[To], t.[Value], @UserID, GETDATE(), @UserID, GETDATE()
	FROM @tbltype_PrepayAndAdditionalFeeScheduleLiabilityDetail t 
	INNER JOIN Core.PrepayAndAdditionalFeeScheduleLiability PA 
	ON PA.ValueTypeID = t.ValueTypeID 
	AND CAST(PA.StartDate as Date) = Cast(t.StartDate as Date)
	AND PA.EventID = @EventID
	
END;