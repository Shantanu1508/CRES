
CREATE PROCEDURE [App].[usp_AddUpdateUser] --'FB72E3DF-47FB-485D-9DDD-C833C923D9D6','Srashti','Jin','vbaapure@newconinfosystems.com','vbalapure',null,null,2,'C7CA5FF2-0203-44B7-AFB4-26552C8EBF0F','v'
	@userId [uniqueidentifier],
	@firstName nvarchar(256),
	@lastName nvarchar(256),
	@email nvarchar(256),
	@login nvarchar(256),
	@password nvarchar(256)= null,
	@expirationDate date,
	@statusId int,
	@roleId varchar(256) = null,
	@ContactNo1 varchar(256) = null,
	@updatedBy nvarchar(256),
	@TimeZone nvarchar(256)  = null
AS
BEGIN



IF(@TimeZone is null)
BEGIN
	SET @TimeZone = 'Azores Standard Time'
END



Declare @gUserID UNIQUEIDENTIFIER;
	 
	IF(@userId='00000000-0000-0000-0000-000000000000')
	BEGIN
		BEGIN TRANSACTION InsertUser

		BEGIN TRY
			/*Insert User*/
			IF(@roleId = '')
			BEGIN
				SET @roleId = (Select [RoleId] from app.[Role] where RoleName = 'Admin')
			END
			IF(@password is null)
			BEGIN
				SET @password = '03241cbc0c2690dd807006b7a20a9976'
			END
			

			DECLARE @tUser TABLE (tUserID UNIQUEIDENTIFIER)
			Declare @newUserID uniqueidentifier;

			INSERT INTO App.[User] ([FirstName],[LastName],[Email],[Login],[Password],[ExpirationDate],[StatusID],[ContactNo1],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
			OUTPUT inserted.UserID INTO @tUser(tUserID)
			VALUES (@firstName,@lastName,@email,@login,@password,'01/01/2030',1,@ContactNo1,@updatedBy,GETDATE(),@updatedBy,GETDATE())
			SELECT @newUserID = tUserID FROM @tUser; 	

			SET @gUserID = @newUserID;
			/*Insert UserRoleMap*/
			
			INSERT INTO App.[UserRoleMap]([UserId],[RoleId],[StatusID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
			VALUES (@newUserID,@roleId,@statusId,@updatedBy,GETDATE(),@updatedBy,GETDATE())

			--Subscribe notification newly created user
			INSERT INTO app.NotificationSubscription(NotificationID,StartDate,EndDate,UserID,Status,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate)
			Select NotificationID,getdate(),null,UserID,1,@updatedBy,GETDATE(),@updatedBy,GETDATE() from App.[Notification] noti,app.[user] u
			where noti.StatusID = 1 and userid = @newUserID

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

	ELSE
	BEGIN
	BEGIN TRANSACTION UpdateUser

		BEGIN TRY

			SET @gUserID = @userId;

			/*Update User*/
			Update App.[User] set
			[FirstName] = @firstName,
			[LastName] = @lastName,
			[Email] = @email,
			[Login] = @login,
			--[Password] = @password,
			[ExpirationDate] = '01/01/2030',
			[StatusID] = @statusId,
			[ContactNo1] = @ContactNo1,
			[UpdatedBy] = @updatedBy,
			[UpdatedDate]=GETDATE()
			where UserId = @userId
			
			/*Update UserRoleMap*/
			Update App.[UserRoleMap] set 
			RoleId = @roleId
			where UserId = @userId

			
			SELECT 'User update - Successful'
		END TRY
		BEGIN CATCH
			SELECT 'User update - Failed. Error message: ' + ERROR_MESSAGE()
			IF @@TRANCOUNT > 0
				ROLLBACK TRANSACTION UpdateUser
		END CATCH

		IF @@TRANCOUNT > 0
			COMMIT TRANSACTION UpdateUser

	END





	/*Insert into App.UserEx Table*/
	IF NOT EXISTS(Select UserID from app.UserEx  where UserID = @gUserID)
	BEGIN
			Declare @color nvarchar(max);

			DECLARE @tblColor TABLE
			(
				Color nvarchar(max)
			)
			insert into @tblColor (Color) Values ('CadetBlue')
			insert into @tblColor (Color) Values ('YellowGreen')
			insert into @tblColor (Color) Values ('wheat1')
			insert into @tblColor (Color) Values ('VioletRed')
			insert into @tblColor (Color) Values ('turquoise3')
			insert into @tblColor (Color) Values ('thistle3')
			insert into @tblColor (Color) Values ('SteelBlue')
			insert into @tblColor (Color) Values ('tan1')
			insert into @tblColor (Color) Values ('SlateGray3')
			insert into @tblColor (Color) Values ('SlateBlue')
			insert into @tblColor (Color) Values ('SkyBlue')
			insert into @tblColor (Color) Values ('salmon')
			insert into @tblColor (Color) Values ('purple1')
			insert into @tblColor (Color) Values ('plum')
			insert into @tblColor (Color) Values ('OliveDrab')
			insert into @tblColor (Color) Values ('MediumSlateBlue')

			Select  TOP 1 @color = color from @tblColor ORDER BY NEWID()

			INSERT INTO [APP].[UserEx](UserID,Color)Values(@gUserID,@color)
		
	END

	Update app.[UserEx] set TimeZone = @TimeZone where UserId = @gUserID



END
