


CREATE PROCEDURE [App].[usp_UserForgotPassword] --'skhan2@hvantagetechnologies.com', '0293591a6e6358aa034dc71c9e52f8df'
	@UserLogin nvarchar(256),	
	@AuthenticationKey nvarchar(256)
AS
BEGIN
   DECLARE @UserID UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000'
   
   if EXISTS(SELECT UserID FROM app.[user] WHERE Email = @UserLogin OR Login = @UserLogin)
	 BEGIN
	    SELECT @UserID = UserID FROM app.[user] WHERE Email = @UserLogin OR Login = @UserLogin;
	    UPDATE App.[User] 
		  SET [AuthenticationKey] = @AuthenticationKey, UpdatedDate = GETDATE(), UpdatedBy =@UserID 
		WHERE UserID =@UserID;
	  END
	 ELSE
	  BEGIN
	    RETURN 0;
	  END

	SELECT u.FirstName +' '+ u.LastName as FullName, u.Email  FROM app.[User] u WHERE UserID =  @UserID;			
      
END

