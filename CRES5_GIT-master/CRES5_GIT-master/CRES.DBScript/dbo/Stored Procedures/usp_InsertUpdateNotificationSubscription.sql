
CREATE PROCEDURE [dbo].[usp_InsertUpdateNotificationSubscription]
(
 @NotificationSubscriptionID uniqueidentifier
,@Notification_NotificationID uniqueidentifier
,@User_UserID uniqueidentifier
,@CreatedBy varchar(256)
,@UpdatedBy varchar(256)
,@Status bit 
,@NewNotificationSubscriptionID nvarchar(256) output
 )
 AS
 BEGIN

if(@NotificationSubscriptionID='00000000-0000-0000-0000-000000000000' or @NotificationSubscriptionID is null)
	BEGIN

		DECLARE @tNotificationSubscription TABLE (tNewNotificationSubscriptionID UNIQUEIDENTIFIER)
		INSERT INTO App.NotificationSubscription
				   (NotificationID
				   ,UserID
				   ,StartDate
				   ,CreatedBy
				   ,CreatedDate
				   ,UpdatedBy
				   ,UpdatedDate
				   ,[Status]
				   )
				   OUTPUT inserted.NotificationSubscriptionID INTO @tNotificationSubscription(tNewNotificationSubscriptionID)
			 VALUES
				   (@Notification_NotificationID
				   ,@User_UserID
				   ,GETDATE()
				   ,@CreatedBy
				   ,GETDATE()
				   ,@UpdatedBy
				   ,GETDATE()
				   ,@Status
				   )

				   SELECT @NewNotificationSubscriptionID = tNewNotificationSubscriptionID FROM @tNotificationSubscription;
				  
	END
	ELSE
	BEGIN
		UPDATE App.NotificationSubscription SET 
				    NotificationID = @Notification_NotificationID
				   ,UserID = @User_UserID
				   ,UpdatedBy = @UpdatedBy
				   ,UpdatedDate = GETDATE()
				   ,EndDate= GETDATE()
				   ,[Status] = @Status
				   WHERE NotificationSubscriptionID = @NotificationSubscriptionID
				   SELECT @NewNotificationSubscriptionID = @NotificationSubscriptionID


				--   DECLARE @tNotificationSubscription TABLE (tNewNotificationSubscriptionID UNIQUEIDENTIFIER)
		INSERT INTO App.NotificationSubscription
				   (NotificationID
				   ,UserID
				   ,StartDate
				   ,CreatedBy
				   ,CreatedDate
				   ,UpdatedBy
				   ,UpdatedDate
				   ,[Status]
				   )
				   OUTPUT inserted.NotificationSubscriptionID INTO @tNotificationSubscription(tNewNotificationSubscriptionID)
			 VALUES
				   (@Notification_NotificationID
				   ,@User_UserID
				   ,GETDATE()
				   ,@CreatedBy
				   ,GETDATE()
				   ,@UpdatedBy
				   ,GETDATE()
				   ,@Status
				   )

				   SELECT @NewNotificationSubscriptionID = tNewNotificationSubscriptionID FROM @tNotificationSubscription;
	END
	   
END
