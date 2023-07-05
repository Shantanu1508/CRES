--[dbo].[usp_GetSubscribedUserByTaskID]  'DBCEA279-3D61-4452-A3E4-083873867F6C'
CREATE PROCEDURE [dbo].[usp_GetSubscribedUserByTaskID]   --'DBCEA279-3D61-4452-A3E4-083873867F6C'
    @TaskID nvarchar(256)
 
AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

select 
us.UserID, 
UPPER(us.FirstName) + ' ' + UPPER(us.LastName) as FirstName ,
us.LastName,
ts.TaskSubscribedUserID,
ts.TaskID,
(case when ts.TaskSubscribedUserID is null then 'false' else 'true' end) as SubscriptionStatus,
--ts.TaskSubscribedUserID SubscriptionStatus,
UPPER(LEFT(us.FirstName, 1)) + UPPER(LEFT(us.LastName , 1))  as CommentedByFirstLetter,
'avatorcircle notificationdivleft ' + userEx.Color UColor
 from 
App.[User] us left join App.TaskSubscribedUser ts on ts.UserId=us.UserID and ts.TaskID=@TaskID
Left Join app.UserEx userEx ON userEx.userID=us.UserID
where us.StatusID =1 and [Login]!='Sizer' 
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END      



--select * from App.TaskSubscribedUser

