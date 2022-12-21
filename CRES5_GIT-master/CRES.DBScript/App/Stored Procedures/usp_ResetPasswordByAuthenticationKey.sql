

CREATE PROCEDURE [App].[usp_ResetPasswordByAuthenticationKey] --'85abfcfd511c59d3e047fe47d9e776b4','f225999720b317e32fa0ffac27b84269'
(
	@AuthenticationKey NVARCHAR(256),
    @NewPassword NVARCHAR(256)
)	
AS
BEGIN

    if EXISTS(SELECT UserID FROM app.[user] WHERE AuthenticationKey = @AuthenticationKey)
	 BEGIN
	    UPDATE App.[User] SET [Password] = @NewPassword , AuthenticationKey = '', UpdatedDate = GETDATE() WHERE AuthenticationKey = @AuthenticationKey;
	  END
	 ELSE
	  BEGIN
	    RETURN 0;
	  END

	RETURN @@RowCount

END


