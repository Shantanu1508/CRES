
CREATE PROCEDURE [dbo].[usp_InsertPIKScheduleSizer] 
		@creNoteID nvarchar(256),
		@creSourceNoteID nvarchar(256),
		@creTargetNoteID nvarchar(256),
		@AdditionalIntRate decimal(28,15),
		@AdditionalSpread decimal(28,15),
		@IndexFloor decimal(28,15),
		@IntCompoundingRate decimal(28,15),
		@IntCompoundingSpread decimal(28,15),
		@StartDate datetime,
		@EndDate datetime,
		@IntCapAmt decimal(28,15),
		@PurBal decimal(28,15),
		@AccCapBal decimal(28,15), 
		@UpdatedBy nvarchar(256)

AS
BEGIN

	Declare  @PIKSchedule  int  =12;
	DECLARE @accountID varchar(256)
	DECLARE @SourceAccountID varchar(256)
	DECLARE @TargetAccountID varchar(256)
	DECLARE @ClosingDate datetime 
	Declare @PIKSeparateCompounding int
	---------------------------------
	DECLARE @Active int = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
	DECLARE @Inactive int = (Select LookupID from Core.Lookup where name = 'Inactive' and ParentID = 1)

	SELECT @accountID = n.Account_AccountID FROM CRE.Note n WHERE n.CRENoteID=@creNoteID 
	SELECT @SourceAccountID = n.Account_AccountID FROM CRE.Note n WHERE n.CRENoteID=@creSourceNoteID 
	SELECT @TargetAccountID = n.Account_AccountID FROM CRE.Note n WHERE n.CRENoteID=@creTargetNoteID 
	
	SELECT @ClosingDate = ClosingDate ,@PIKSeparateCompounding = PIKSeparateCompounding
	FROM CRE.Note n WHERE n.CRENoteID=@creNoteID 
-------------------------------------------------------------------------------------------------------------
 

--Insert
INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue,StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)	
	SELECT DISTINCT
	CONVERT(date, @ClosingDate, 101),
	@accountID,
	GETDATE(),
	@PIKSchedule,
	NULL,
	NULL,
	@UpdatedBy,
	GETDATE(),
	@UpdatedBy,
	GETDATE()	
	WHERE @ClosingDate is not null
	AND CONVERT(date, @ClosingDate, 101) NOT IN (SELECT
	EffectiveStartDate FROM core.Event e WHERE e.EventTypeID = @PIKSchedule
	AND e.AccountID = @accountID )

INSERT INTO core.PIKSchedule (EventID,SourceAccountID,TargetAccountID,AdditionalIntRate,AdditionalSpread,IndexFloor,IntCompoundingRate,IntCompoundingSpread,StartDate,EndDate,IntCapAmt,PurBal,AccCapBal,CreatedBy, CreatedDate,UpdatedBy,UpdatedDate,PIKSeparateCompounding)
	SELECT 
	(SELECT TOP 1 EventId FROM CORE.[event] e WHERE e.[EffectiveStartDate] = CONVERT(date, @ClosingDate, 101)
	AND e.[EventTypeID] = @PIKSchedule AND e.AccountID = @accountID ),
	@SourceAccountID,
	@TargetAccountID,
	@AdditionalIntRate,
	@AdditionalSpread,
	@IndexFloor,
	@IntCompoundingRate,
	@IntCompoundingSpread,
	CONVERT(date, @StartDate, 101),
	CONVERT(date, @EndDate, 101),
	@IntCapAmt,
	@PurBal,
	@AccCapBal,
	@UpdatedBy,
	GETDATE(),
	@UpdatedBy,
	GETDATE(),
	@PIKSeparateCompounding
	WHERE  @ClosingDate is not null



-----Update PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate = Y if null for pik notes-----

IF EXISTS(
	Select Distinct n.noteid 
	from [CORE].PikSchedule pik 	
	INNER JOIN [CORE].[Event] e on e.EventID = pik.EventId  
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	Where acc.isdeleted <> 1
	and n.CRENoteID = @creNoteID
)
BEGIN
	update cre.note set PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate = 4 where CRENoteID = @creNoteID and PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate is null
END



END

--@StartDate is not null  and