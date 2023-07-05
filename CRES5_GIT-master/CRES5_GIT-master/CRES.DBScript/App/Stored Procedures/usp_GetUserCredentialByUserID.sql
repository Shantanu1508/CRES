-- [App].[usp_GetUserCredentialByUserID] 'b0e6697b-3534-4c09-be0a-04473401ab93', 'c41205eb-2bf6-48a3-abc3-398face6fd6e'  
CREATE PROCEDURE [App].[usp_GetUserCredentialByUserID] --'b0e6697b-3534-4c09-be0a-04473401ab93', 'c41205eb-2bf6-48a3-abc3-398face6fd6e'  
(  
 @UserID uniqueidentifier,  
 @DelegateUserID uniqueidentifier = '00000000-0000-0000-0000-000000000000'  
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
IF(@DelegateUserID = '00000000-0000-0000-0000-000000000000')  
BEGIN  
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
   ,u.[ContactNo1]  
   ,u.[UserToken]  
   ,uex.[Timezone]
   ,u.[IP]
 FROM [App].[User] u   
 LEFt JOIN [App].[UserEx] uex on uex.UserID = u.UserID  
 WHERE u.UserID = @UserID  
END  
ELSE  
BEGIN  
 IF EXISTS(  
  SELECT  
   DISTINCT(udc.UserID),  
   DelegatedUserID  
  FROM [App].[UserDelegateConfig]  udc   
  where udc.DelegatedUserID = @DelegateUserID and   
  udc.UserID = @UserID  
  and IsActive = 1  
  and udc.[StartDate] <= CONVERT(date, getdate())  
  and udc.[EndDate] >= CONVERT(date, getdate())   
  )  
 BEGIN  
  SELECT u.[UserID]  
    ,u.[FirstName]  
    ,u.[LastName]  
    ,u.[Email]  
    ,u.[Login]  
    --,u.[Password]  
    ,'' as [Password]  
    ,u.[ExpirationDate]  
    ,u.[StatusID]  
    ,u.[CreatedBy]  
    ,u.[CreatedDate]  
    ,u.[UpdatedBy]  
    ,u.[UpdatedDate]  
    ,u.[ContactNo1]  
    ,u.[UserToken]  
    ,uex.[Timezone]
	,u.[IP]
  FROM [App].[User] u   
 LEFt JOIN [App].[UserEx] uex on uex.UserID = u.UserID  
  WHERE u.UserID = @UserID  
 END  
 ELSE  
  BEGIN  
       
SELECT u.[UserID]  
      ,u.[FirstName]  
      ,u.[LastName]  
      ,u.[Email]  
      ,u.[Login]  
      ,u.[Password]  
      ,u.[ExpirationDate]  
      ,u.[StatusID]  
      ,u.[CreatedBy]  
      ,u.[CreatedDate]  
      ,u.[UpdatedBy]  
      ,u.[UpdatedDate]  
   ,u.[ContactNo1]  
   ,u.[UserToken]  
   ,uex.[Timezone]
   ,u.[IP]
 FROM [App].[User] u   
 LEFt JOIN [App].[UserEx] uex on uex.UserID = u.UserID  
 WHERE u.UserID = '00000000-0000-0000-0000-000000000000'  
  END  
  
END  
  
  
  
  
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END
GO

