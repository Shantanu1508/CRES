CREATE Procedure [dbo].[usp_ForceLogout]  
  @userID UNIQUEIDENTIFIER = null
AS  
BEGIN  

	IF(@userID is null)
	BEGIN
		Update [App].[User] set
		[UserToken] = newid()
	END
	ELSE
	BEGIN
		Update [App].[User] set
		[UserToken] = newid()
		WHERE UserID = @userID
	END
END
