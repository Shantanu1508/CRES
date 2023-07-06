
CREATE PROCEDURE [dbo].[usp_GetImpersonateUserCountByUserId] 
(
	@UserID UNIQUEIDENTIFIER 
)
	
AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

   SELECT count(*) as TotalCount
		
	FROM [App].[UserDelegateConfig]  udc 
	
	where udc.DelegatedUserID = @UserID
	and IsActive = 1
	and udc.[StartDate] <= CONVERT(date, getdate())
	and udc.[EndDate] >= CONVERT(date, getdate()) 



	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
