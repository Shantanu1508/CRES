
--[App].[usp_GetUsersInfoByRoleNameForDropDown] 'Asset Manager'
CREATE PROCEDURE [App].[usp_GetUsersInfoByRoleNameForDropDown]  
(
@RoleName VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;
	
SELECT  u.[UserID]
      ,u.[FirstName]
      ,u.[LastName]
	  ,u.[FirstName]+' '+u.[LastName] as FullName      
	 
	  
 FROM [App].[User] u
	join [App].[UserRoleMap] rm on rm.[UserID] = u.[UserID]
	join [App].[Role] r on r.[RoleID] = rm.[RoleID]
	join core.Lookup lstatus on lstatus.LookupID = u.StatusID
	where RTRIM(LTRIM(r.RoleName))=RTRIM(LTRIM(@RoleName))
	order by u.[FirstName]
END


