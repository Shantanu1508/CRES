
CREATE PROCEDURE [dbo].[usp_GetAllActiveDelegatedUser]  --'80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B'
    @userID UNIQUEIDENTIFIER
	 
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

		SELECT 
		 distinct udc.UserID,
		udc.UserDelegateConfigID,
		udc.StartDate,
		udc.EndDate,
		udc.DelegatedUserID,
		udc.IsActive,
		ud.FirstName +' '+ ud.LastName as DelegatedUserIDText
		from   [App].[UserDelegateConfig] udc
		left JOIN [App].[User] ud on udc.DelegatedUserID = ud.UserID	 
		WHERE udc.UserID = @userID and 
		IsActive =1 
		--and getdate() between [StartDate] and DATEADD(day, +1, [EndDate])
		and  [EndDate] >= CONVERT(date, getdate()) 

 SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
END      

