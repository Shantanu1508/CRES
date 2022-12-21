
CREATE PROCEDURE [dbo].[usp_GetNotificationSubscriptionByUserID]
(
	@UserID uniqueidentifier,
	@PageIndex INT,
    @PageSize INT,
	@TotalCount INT OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	--SELECT @TotalCount = COUNT(NotificationID) FROM App.Notification where StatusID = 1
	SELECT n.NotificationID 
		  ,n.Name
          ,ISNULL(ns.[NotificationSubscriptionID],'00000000-0000-0000-0000-000000000000') as NotificationSubscriptionID
          ,[Status]
    from App.Notification n
	left outer join App.NotificationSubscription ns on 
	n.NotificationID = ns.NotificationID 
	and ns.UserID = @UserID
	where n.StatusID = 1 and EndDate is null
	ORDER BY n.CreatedDate
	--OFFSET (@PageIndex - 1)*@PageSize ROWS
	--FETCH NEXT @PageSize ROWS ONLY
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END

