
CREATE PROCEDURE [dbo].[usp_DeletePIKScheduleDetailSizer] 
@creNoteID nvarchar(256)

AS
BEGIN

 Declare  @PIKScheduleDetail  int  =17;
DECLARE @accountID varchar(256)
DECLARE @ClosingDate datetime 
---------------------------------
DECLARE @Active int = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
DECLARE @Inactive int = (Select LookupID from Core.Lookup where name = 'Inactive' and ParentID = 1)


SELECT @accountID = n.Account_AccountID FROM CRE.Note n WHERE n.CRENoteID=@creNoteID 
SELECT @ClosingDate = ClosingDate FROM CRE.Note n WHERE n.CRENoteID=@creNoteID 
-------------------------------------------------------------------------------------------------------------
Delete from core.PIKScheduleDetail where EventID in(select EventID from core.Event
where Event.AccountID = @accountID and EventTypeID = @PIKScheduleDetail
)
Delete from core.Event where Event.AccountID = @accountID and EventTypeID = @PIKScheduleDetail

END
