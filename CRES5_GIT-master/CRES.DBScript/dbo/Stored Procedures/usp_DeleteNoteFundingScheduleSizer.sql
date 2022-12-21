
CREATE PROCEDURE [dbo].[usp_DeleteNoteFundingScheduleSizer] --'42201'
@creNoteID nvarchar(256)

AS
BEGIN

 Declare  @FundingSchedule  int  =10;
DECLARE @accountID varchar(256)
DECLARE @ClosingDate datetime 

DECLARE @Active int = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
DECLARE @Inactive int = (Select LookupID from Core.Lookup where name = 'Inactive' and ParentID = 1)

SELECT @accountID = n.Account_AccountID FROM CRE.Note n WHERE n.CRENoteID=@creNoteID and n.UseRuletoDetermineNoteFunding =(select LookupID from core.lookup where parentID=2 and name='Y')


IF(@accountID is not null)
BEGIN

	IF OBJECT_ID('tempdb..#tblEventID') IS NOT NULL               
	DROP TABLE #tblEventID             
              
	create table #tblEventID          
	(
		EventID UNIQUEIDENTIFIER
	)

	Select e.EventID from CORE.Event e
	inner join core.account acc on acc.accountid = e.accountid
	inner join cre.note n on n.account_accountid = acc.accountid
	where e.EventTypeID = @FundingSchedule
	and n.crenoteid = @creNoteID
		

	Delete from CORE.FundingSchedule where eventid in (Select EventID from #tblEventID)

	Delete core.Event where eventid in (Select EventID from #tblEventID)

END
	

--Delete from CORE.FundingSchedule where eventid in (SELECT  EventId FROM CORE.[event] e WHERE e.[EventTypeID] = @FundingSchedule AND e.AccountID = @accountID) and @accountID is not null

--Delete core.Event where Event.AccountID = @accountID and EventTypeID = @FundingSchedule and @accountID is not null

	
END
