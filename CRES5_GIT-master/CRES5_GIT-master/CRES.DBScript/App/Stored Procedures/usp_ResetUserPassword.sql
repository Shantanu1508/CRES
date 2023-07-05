
CREATE PROCEDURE [App].[usp_ResetUserPassword]
	@userId [uniqueidentifier],	
	@password nvarchar(256),
	@updatedBy nvarchar(256)
AS
BEGIN

Update App.[User] set Password=@password,
                    AuthenticationKey = @password, 
					[UpdatedBy]=@updatedBy,
					[UpdatedDate]=GetDATE()
					where UserID=@userId;
					
      
END
