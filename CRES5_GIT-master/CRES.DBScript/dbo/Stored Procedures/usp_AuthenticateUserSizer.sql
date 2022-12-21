

CREATE PROCEDURE [DBO].[usp_AuthenticateUserSizer] 
(
	@UserName nvarchar(256),
	@Password nvarchar(256)
)
AS
BEGIN

 select count(Login) from app.[user] where Login=@UserName and Password=@Password and StatusID=1

END


