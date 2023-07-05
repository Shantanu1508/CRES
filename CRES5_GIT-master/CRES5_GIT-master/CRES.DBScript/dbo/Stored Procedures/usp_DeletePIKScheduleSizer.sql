
CREATE PROCEDURE [dbo].[usp_DeletePIKScheduleSizer] 
@creNoteID nvarchar(256)

AS
BEGIN

 Declare  @PIKSchedule  int  =12;
DECLARE @accountID varchar(256)
DECLARE @SourceAccountID varchar(256)
DECLARE @TargetAccountID varchar(256)

---------------------------------
DECLARE @Active int = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
DECLARE @Inactive int = (Select LookupID from Core.Lookup where name = 'Inactive' and ParentID = 1)
SELECT @accountID = n.Account_AccountID FROM CRE.Note n WHERE n.CRENoteID=@creNoteID 
SELECT @SourceAccountID = n.Account_AccountID FROM CRE.Note n WHERE n.CRENoteID=@creNoteID 
SELECT @TargetAccountID = n.Account_AccountID FROM CRE.Note n WHERE n.CRENoteID=@creNoteID 
--SELECT @ClosingDate = ClosingDate FROM CRE.Note n WHERE n.CRENoteID=@creNoteID 
-------------------------------------------------------------------------------------------------------------
Delete from core.PIKSchedule where EventID in(select EventID from core.Event
where Event.AccountID = @accountID and EventTypeID = @PIKSchedule
)
Delete from core.Event where Event.AccountID = @accountID and EventTypeID = @PIKSchedule

END
