CREATE PROCEDURE [dbo].[usp_GetUsersToImpersonate]  --'144D2B78-D5FE-40C7-8307-58CE8723B369'
    @userID UNIQUEIDENTIFIER
	 
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	SELECT
		DISTINCT(udc.UserID),
		U1.FirstName +' '+ U1.LastName as UserIDText,
		DelegatedUserID,
		U2.FirstName +' '+ U2.LastName as DelegatedUserIDText,
		--UserDelegateConfigID,
		--StartDate,
		--EndDate	,
		IsActive
	FROM [App].[UserDelegateConfig]  udc 
	INNER JOIN [App].[User] U1  on udc.UserID = U1.UserID
	INNER JOIN [App].[User] U2  on udc.DelegatedUserID = U2.UserID
	where udc.DelegatedUserID = @userID and 
	udc.IsActive = 1 
	and udc.[StartDate] <= CONVERT(date, getdate())
	and udc.[EndDate] >= CONVERT(date, getdate()) 

 SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
END      

