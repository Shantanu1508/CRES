CREATE PROCEDURE [App].[usp_GetAllUsers]  
  
AS  
BEGIN  
  
 SET NOCOUNT ON;  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
   
SELECT  u.[UserID]  
      ,u.[FirstName]  
      ,u.[LastName]  
      ,u.[Email]  
      ,u.[Login]  
      ,u.[Password]  
      ,u.[ExpirationDate]  
      ,u.[StatusID]  
   ,r.roleId  
   ,r.[RoleName]  
      ,u.[CreatedBy]  
      ,u.[CreatedDate]  
      ,u.[UpdatedBy]  
      ,u.[UpdatedDate]  
   ,lstatus.Name as [Status]  
   ,u.ContactNo1  
   ,u.UserToken
   ,ux.TimeZone
     
 FROM [App].[User] u  
 left join [App].[UserRoleMap] rm on rm.[UserID] = u.[UserID]  
 left join [App].[Role] r on r.[RoleID] = rm.[RoleID]  
 left join core.Lookup lstatus on lstatus.LookupID = u.StatusID  
 Left Join APP.[UserEx] ux on u.UserID = ux.UserID
 order by u.[FirstName]  
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END  
  
  
