
CREATE PROCEDURE [dbo].[usp_DeleteAmortScheduleSizer] 
@creNoteID nvarchar(256)

AS
BEGIN

Declare  @AmortSchedule  int  =19;
DECLARE @accountID varchar(256)
DECLARE @ClosingDate datetime 
---------------------------------
DECLARE @Active int = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
DECLARE @Inactive int = (Select LookupID from Core.Lookup where name = 'Inactive' and ParentID = 1)

SELECT @accountID = n.Account_AccountID FROM CRE.Note n WHERE n.CRENoteID=@creNoteID 

SELECT @ClosingDate = ClosingDate FROM CRE.Note n WHERE n.CRENoteID=@creNoteID 

Delete from core.AmortSchedule where EventID in(select EventID from core.Event
where AccountID = @accountID and EventTypeID = @AmortSchedule 
)

Delete from core.Event where AccountID = @accountID and EventTypeID = @AmortSchedule 
END
