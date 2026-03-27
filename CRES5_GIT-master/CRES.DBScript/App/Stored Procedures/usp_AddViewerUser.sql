Create PROCEDURE [App].[usp_AddViewerUser] 
@email nvarchar(256),
@CreatedBy nvarchar(256)
AS
BEGIN


	BEGIN TRANSACTION InsertUser

	BEGIN TRY

	Declare @roleId UNIQUEIDENTIFIER
	Declare @username nvarchar(256)
	Declare @password varchar(100)
	Declare @gUserID UNIQUEIDENTIFIER

	set @username=	(SELECT   SUBSTRING(@email,0,CHARINDEX('@',@email,0)))
			SET @roleId = (Select [RoleId] from app.[Role] where RoleName = 'Unassigned')
		
		IF(@password is null)
		BEGIN
			SET @password = '03241cbc0c2690dd807006b7a20a9976'
		END
		

		DECLARE @tUser TABLE (tUserID UNIQUEIDENTIFIER)
		Declare @newUserID uniqueidentifier;

		INSERT INTO App.[User] ([FirstName],[LastName],[Email],[Login],[Password],[ExpirationDate],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
		OUTPUT inserted.UserID INTO @tUser(tUserID)
		VALUES (@username,'',@email,@email,@password,'01/01/2030',1,@CreatedBy,GETDATE(),@CreatedBy,GETDATE())
		SELECT @newUserID = tUserID FROM @tUser; 	

		SET @gUserID = @newUserID;
		/*Insert UserRoleMap*/
		
		--INSERT INTO App.[UserRoleMap]([UserId],[RoleId],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
		--VALUES (@newUserID,@roleId,1,@CreatedBy,GETDATE(),@CreatedBy,GETDATE())

		Insert into app.userex(UserID,Color,TimeZone) 
		Values(@newUserID,'purple1','Pacific Standard Time')

		--Subscribe notification newly created user
		--INSERT INTO app.NotificationSubscription(NotificationID,StartDate,EndDate,UserID,Status,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate)
		--Select NotificationID,getdate(),null,UserID,1,@CreatedBy,GETDATE(),@CreatedBy,GETDATE() from App.[Notification] noti,app.[user] u
		--where noti.StatusID = 1 and userid = @newUserID

		SELECT 'User insertion - Successful'
	END TRY
	BEGIN CATCH
		SELECT 'User insertion - Failed. Error message: ' + ERROR_MESSAGE()
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION InsertUser
	END CATCH

	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION InsertUser



END