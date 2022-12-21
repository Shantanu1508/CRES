
CREATE PROCEDURE [dbo].[usp_InsertFeeCouponStripReceivableSizer] 
@creNoteID nvarchar(256),
@Date datetime,
@Value decimal(28,15), 
@UpdatedBy nvarchar(256)

AS
BEGIN

Declare  @FeeCouponStripReceivable  int  =20;
DECLARE @accountID varchar(256)
DECLARE @ClosingDate datetime 
---------------------------------
DECLARE @Active int = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
DECLARE @Inactive int = (Select LookupID from Core.Lookup where name = 'Inactive' and ParentID = 1)

SELECT @accountID = n.Account_AccountID FROM CRE.Note n inner join core.Account ac on ac.AccountID=n.Account_AccountID
WHERE n.CRENoteID=@creNoteID 

SELECT @ClosingDate = ClosingDate FROM CRE.Note n WHERE n.CRENoteID=@creNoteID 
-------------------------------------------------------------------------------------------------------------

--Insert
INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue,StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)	
	SELECT DISTINCT
	CONVERT(date, @ClosingDate, 101),
	@accountID,
	GETDATE(),
	@FeeCouponStripReceivable,
	NULL,
	NULL,
	@UpdatedBy,
	GETDATE(),
	@UpdatedBy,
	GETDATE()	
	WHERE @ClosingDate is not null
	AND CONVERT(date, @ClosingDate, 101) NOT IN (SELECT
	EffectiveStartDate FROM core.Event e WHERE e.EventTypeID = @FeeCouponStripReceivable
	AND e.AccountID = @accountID )

INSERT INTO core.FeeCouponStripReceivable (EventId, Date, Value,CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
	SELECT 
	(SELECT TOP 1 EventId FROM CORE.[event] e WHERE e.[EffectiveStartDate] = CONVERT(date, @ClosingDate, 101)
	AND e.[EventTypeID] = @FeeCouponStripReceivable AND e.AccountID = @accountID ),
	CONVERT(date, @Date, 101),
	@Value,
	@UpdatedBy,
	GETDATE(),
	@UpdatedBy,
	GETDATE()  
	WHERE @Date is not null AND @Value IS NOT NULL and @ClosingDate is not null
END
