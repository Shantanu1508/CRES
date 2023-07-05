CREATE Procedure [dbo].[usp_RevokeUserDelegateConfigByUserDelegateConfigID]  
	@userDelegateConfigID UNIQUEIDENTIFIER
AS  
BEGIN  

	Update [App].[UserDelegateConfig] set
	[IsActive] = 0
	WHERE [UserDelegateConfigID] = @userDelegateConfigID
  
END
