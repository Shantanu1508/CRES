

CREATE PROCEDURE [App].[usp_UpdatePassword] --'A33FF36F-ABDA-4AA9-A903-9F83B5280492','03241cbc0c2690dd807006b7a20a9976','03241cbc0c2690dd807006b7a20a9976'
(
	@UserID UNIQUEIDENTIFIER,
	@OldPassword NVARCHAR(256),
    @NewPassword NVARCHAR(256)
)	
AS
BEGIN
   --SET NOCOUNT ON;
	UPDATE App.[User] SET [Password] = @NewPassword WHERE UserID = @UserID AND [Password] = @OldPassword
    
	--Return @@RowCount;

END

