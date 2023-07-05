
CREATE PROCEDURE [dbo].[usp_DeletePrepayScheduleSizer] 
@creNoteID nvarchar(256)

AS
BEGIN

 Declare  @PrepayAndAdditionalFeeSchedule  int  =13;
DECLARE @accountID varchar(256)
DECLARE @ClosingDate datetime 
---------------------------------
DECLARE @Active int = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
DECLARE @Inactive int = (Select LookupID from Core.Lookup where name = 'Inactive' and ParentID = 1)

SELECT @accountID = n.Account_AccountID FROM CRE.Note n WHERE n.CRENoteID=@creNoteID 


SELECT @ClosingDate = ClosingDate FROM CRE.Note n WHERE n.CRENoteID=@creNoteID  

Update core.Event
set StatusID=@Inactive
where Event.AccountID = @accountID and EventTypeID = @PrepayAndAdditionalFeeSchedule and EffectiveStartDate !=@ClosingDate


Delete from core.PrepayAndAdditionalFeeSchedule where EventId=(SELECT TOP 1 EventId FROM CORE.[event] e 
WHERE e.[EffectiveStartDate] = CONVERT(date, @ClosingDate, 101) AND e.[EventTypeID] = @PrepayAndAdditionalFeeSchedule AND e.AccountID = @accountID and e.StatusID=@Active)


END
