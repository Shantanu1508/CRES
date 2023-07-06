
CREATE PROCEDURE [dbo].[usp_InsertNoteFundingScheduleSizer] 
@creNoteID nvarchar(256), 
@Date datetime,
@Amount int,
@PurposeID decimal(28,15), 
@UpdatedBy nvarchar(256)

AS
BEGIN

if  exists (select *  from cre.note n where creNoteID =@creNoteID and n.UseRuletoDetermineNoteFunding =(select LookupID from core.lookup where parentID=2 and name='N'))
BEGIN

Declare  @FundingSchedule  int  =10;
DECLARE @accountID varchar(256)
DECLARE @ClosingDate datetime 
---------------------------------
DECLARE @Active int = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
DECLARE @Inactive int = (Select LookupID from Core.Lookup where name = 'Inactive' and ParentID = 1)

SELECT @accountID = n.Account_AccountID FROM CRE.Note n inner join core.Account ac on ac.AccountID=n.Account_AccountID
WHERE n.CRENoteID=@creNoteID  


--closing 
SELECT @ClosingDate = ClosingDate FROM CRE.Note n WHERE n.CRENoteID=@creNoteID  
-------------------------------------------------------------------------------------------------------------

--Insert
INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue,StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)	
	SELECT DISTINCT
	CONVERT(date, @ClosingDate, 101),
	@accountID,
	GETDATE(),
	@FundingSchedule,
	NULL,
	@Active,
	@UpdatedBy,
	GETDATE(),
	@UpdatedBy,
	GETDATE()	
	WHERE @ClosingDate is not null
	AND CONVERT(date, @ClosingDate, 101) NOT IN (SELECT
	EffectiveStartDate FROM core.Event e WHERE e.EventTypeID = @FundingSchedule
	AND e.AccountID = @accountID and  e.StatusID = @Active)


INSERT INTO core.FundingSchedule (EventId, Date, Value,PurposeID, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate)
	SELECT 
	(SELECT TOP 1 EventId FROM CORE.[event] e WHERE e.[EffectiveStartDate] = CONVERT(date, @ClosingDate, 101)
	AND e.[EventTypeID] = @FundingSchedule AND e.AccountID = @accountID and e.StatusID=@Active),
	CONVERT(date, @Date, 101),
	@Amount,
	@PurposeID,
	@UpdatedBy,
	GETDATE(),
	@UpdatedBy,
	GETDATE()  
	WHERE @Date is not null AND isnull(@Amount,0) !=0 and @ClosingDate is not null
END

end 
