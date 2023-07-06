
Create PROCEDURE [App].[usp_UpdateUserCredentialByUserID] 
(
	@UserID uniqueidentifier,
	@FirstName nvarchar(256),
	@LastName nvarchar(256),
	@Email nvarchar(256),
	@UpdatedBy nvarchar(256)
)
AS
BEGIN

	UPDATE [App].[User]
   SET [FirstName] = @FirstName
      ,[LastName] = @LastName
      ,[Email] = @Email
      ,[UpdatedBy] = @UpdatedBy
      ,[UpdatedDate] = getdate()
 WHERE UserID = @UserID


END


