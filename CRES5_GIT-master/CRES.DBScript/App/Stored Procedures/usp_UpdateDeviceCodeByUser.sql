-- Procedure
CREATE PROCEDURE [App].[usp_UpdateDeviceCodeByUser]
(
	@Login nvarchar(256),
	@DeviceCode Nvarchar(256)
)
AS
BEGIN 
	SET NOCOUNT ON;
	
	Update [App].[UserExtension] Set DeviceCode = @DeviceCode, [DeviceLoginDate] = GETDATE()
	WHERE USERID IN (SELECT USERID FROM [App].[USER] WHERE ([Login] = @Login or [Email] = @Login))

	IF @@ROWCOUNT=0 
	BEGIN
		INSERT INTO [App].[UserExtension] ([UserID],[DeviceCode],[DeviceLoginDate],[ExpireDays]) 
		SELECT USERID,@DeviceCode,GETDATE(),10 FROM [App].[User] Where ([Login] = @Login or [Email] = @Login)
	END
END
GO

