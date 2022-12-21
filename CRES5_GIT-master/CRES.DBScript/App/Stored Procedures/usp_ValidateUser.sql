--   [App].[usp_ValidateUser] 'pjain',''
CREATE PROCEDURE [App].[usp_ValidateUser] --'pjain',null
(
	@Login nvarchar(256),
	@Password nvarchar(256)
)
AS
BEGIN 
SET NOCOUNT ON;
IF(@Password = '' OR @Password is null)
BEGIN
	(select Password from app.[user] where (login = @Login or [Email] = @Login)); 
END

	SELECT u.[UserID]
      ,u.[FirstName]
      ,u.[LastName]
      ,u.[Email]
      ,u.[Login]
	  ,'' as [Password]
      --,u.[Password]
      ,u.[ExpirationDate]
      ,u.[StatusID]
      ,u.[CreatedBy]
      ,u.[CreatedDate]
      ,u.[UpdatedBy]
      ,u.[UpdatedDate]
	  ,r.roleId
	  ,r.[RoleName]
	  ,u.[ContactNo1]
	  ,u.[UserToken]
	  ,ue.[TimeZone]
	FROM [App].[User] u
	left join [App].[UserRoleMap] rm on rm.[UserID] = u.[UserID]
	left join [App].[Role] r on r.[RoleID] = rm.[RoleID]
	left join [App].[UserEx] ue on u.[UserID] = ue.[UserID]



	WHERE ([Login] = @Login or [Email] = @Login) and [Password] = @Password
	and u.StatusID = (Select LookupID from COre.Lookup where Name ='Active' and ParentID = 1)
	
	
END


