
CREATE PROCEDURE [dbo].[usp_InsertPrepayAndAdditionalFeeScheduleSizer] 
@creNoteID nvarchar(256),
@StartDate datetime,
@ValueTypeID int,
@Value decimal(28,15),
@IncludedLevelYield decimal(28,15),
@IncludedBasis decimal(28,15),
@FeeName nvarchar(256)= NULL,
@EndDate date =NULL,
@FeeAmountOverride decimal(28, 12)= NULL,
@BaseAmountOverride decimal(28, 12)= NULL,
@ApplyTrueUpFeature int= NULL,
@FeetobeStripped decimal(28, 12)= NULL,
@UpdatedBy nvarchar(256)=null

AS
BEGIN

Declare  @PrepayAndAdditionalFeeSchedule  int  =13;
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
	@PrepayAndAdditionalFeeSchedule,
	NULL,
	@Active,
	@UpdatedBy,
	GETDATE(),
	@UpdatedBy,
	GETDATE()	
	WHERE @ClosingDate is not null
	AND CONVERT(date, @ClosingDate, 101) NOT IN (SELECT
	EffectiveStartDate FROM core.Event e WHERE e.EventTypeID = @PrepayAndAdditionalFeeSchedule
	AND e.AccountID = @accountID and  e.StatusID = @Active)


 INSERT INTO core.PrepayAndAdditionalFeeSchedule (
	EventId, 
	StartDate, 
	ValueTypeID, 
	Value, 
	IncludedLevelYield, 
	IncludedBasis,
	CreatedBy,
	CreatedDate,
	UpdatedBy,
	UpdatedDate,
	FeeName ,
EndDate  ,
FeeAmountOverride  ,
BaseAmountOverride ,
ApplyTrueUpFeature  ,
FeetobeStripped  
   )
	SELECT 
	(SELECT TOP 1 EventId FROM CORE.[event] e WHERE e.[EffectiveStartDate] = CONVERT(date, @ClosingDate, 101)
	AND e.[EventTypeID] = @PrepayAndAdditionalFeeSchedule AND e.AccountID = @accountID and e.StatusID=@Active),
	CONVERT(date, @StartDate, 101),
	@ValueTypeID,
	@Value,
	ISNULL(@IncludedLevelYield,0),
    ISNULL(@IncludedBasis,0),
	@UpdatedBy,
	GETDATE(),
	@UpdatedBy,
	GETDATE(),
	@FeeName ,
	@EndDate  ,
	@FeeAmountOverride  ,
	@BaseAmountOverride ,
	@ApplyTrueUpFeature  ,
	@FeetobeStripped  
	WHERE @StartDate is not null AND @ValueTypeID IS NOT NULL and @ClosingDate is not null
END
