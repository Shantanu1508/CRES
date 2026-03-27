-- Procedure
CREATE PROCEDURE [App].[usp_GetDeviceCodeByUser] --'msingh@newconinfosystems.com'
(
	@Login nvarchar(256),
	@DeviceCode Nvarchar(256)
)
AS
BEGIN 
	SET NOCOUNT ON;
	Declare @Days int;

	SELECT @Days = (DATEDIFF(d,UE.DeviceLoginDate,GETDATE()))
	FROM [App].[User] U
	INNER JOIN [App].[UserExtension] UE ON U.UserID = UE.UserID
	WHERE (U.[Login] = @Login or U.[Email] = @Login) AND UE.DeviceCode = @DeviceCode
	and U.StatusID = (Select LookupID from Core.Lookup where Name ='Active' and ParentID = 1)

	IF @Days<10
	BEGIN 
		SELECT 'Success' as Response
	END
	ELSE
	BEGIN
		SELECT 'Failed' as Response
	END
END
GO

