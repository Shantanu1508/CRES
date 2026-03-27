
CREATE PROCEDURE [dbo].[usp_InsertLiborAndMaturityScheduleSizer]-- '16-1081',0.01,'s'
@creDealID nvarchar(256),
@Value decimal(28,15),
@UpdatedBy nvarchar(256)

AS
BEGIN


Print('removed script')
--DECLARE @Maturity  int  =11;
--DECLARE @accountID varchar(256);
--DECLARE @ClosingDate datetime 
-----------------------------------
--DECLARE @Active int = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
--DECLARE @Inactive int = (Select LookupID from Core.Lookup where name = 'Inactive' and ParentID = 1)
--DECLARE @DealID varchar(256)=(select DealID from cre.Deal where CREDealID=@CreDealID)
---------------------------------------------------------------------------------------------------------------

--DECLARE  @NoteId nvarchar(256)
--DECLARE  @InitialMaturityDate datetime
  
--IF CURSOR_STATUS('global','MyCur')>=-1  
-- BEGIN  
--  DEALLOCATE MyCur  
-- END  
  
--DECLARE MyCur CURSOR   
--FOR  
--(  
--  select NoteId from cre.Note where DealID=@DealID
--)  
  
--OPEN MyCur   
  
--FETCH NEXT FROM MyCur INTO @NoteId
  
--WHILE @@FETCH_STATUS = 0  
--BEGIN  


--	SELECT @accountID = n.Account_AccountID FROM CRE.Note n inner join core.Account ac on ac.AccountID=n.Account_AccountID WHERE n.NoteID=@NoteID
--	SELECT @ClosingDate = ClosingDate FROM CRE.Note n WHERE n.NoteID=@NoteID
--	SELECT @InitialMaturityDate = InitialMaturityDate FROM CRE.Note n WHERE n.NoteID=@NoteID

	
--	Delete from core.Maturity where EventID in(select EventID from core.Event
--	where Event.AccountID = @accountID and EventTypeID = @Maturity)
	
--	Delete from core.Event where Event.AccountID = @accountID and EventTypeID in (@Maturity)

--	--Insert
--	INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue,StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)	
	

--	SELECT DISTINCT
--	CONVERT(date, @ClosingDate, 101),
--	@accountID,
--	GETDATE(),
--	@Maturity,
--	NULL,
--	Null,
--	@UpdatedBy,
--	GETDATE(),
--	@UpdatedBy,
--	GETDATE()	
--	WHERE @ClosingDate is not null
--	AND CONVERT(date, @ClosingDate, 101) NOT IN (SELECT
--	EffectiveStartDate FROM core.Event e WHERE e.EventTypeID = @Maturity
--	AND e.AccountID = @accountID)




--	INSERT INTO core.Maturity(EventId, SelectedMaturityDate, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
--	SELECT 
--	(SELECT TOP 1 EventId FROM CORE.[event] e WHERE e.[EffectiveStartDate] = CONVERT(date, @ClosingDate, 101)
--	AND e.[EventTypeID] = @Maturity AND e.AccountID = @accountID),
--	CONVERT(date, @InitialMaturityDate, 101),
--	@UpdatedBy,
--	GETDATE(),
--	@UpdatedBy,
--	GETDATE()  
--	WHERE @ClosingDate is not null
	
--	FETCH NEXT FROM MyCur INTO @NoteId
--END  
  
 
  
--CLOSE MyCur;  
--DEALLOCATE MyCur;  

END  

 
