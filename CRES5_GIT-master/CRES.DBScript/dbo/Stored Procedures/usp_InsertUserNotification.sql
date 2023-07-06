 --dbo.[usp_InsertUserNotification] '45696c0f-a73d-4f2d-afbf-ccaa7718a707','EditTask','f022ec7d-f8ab-4bc8-a993-85ce725b3f5d'
CREATE PROCEDURE [dbo].[usp_InsertUserNotification]  
 -- Add the parameters for the stored procedure here  
 @UserId nvarchar(256) ,
 @ActionName nvarchar(256),
 @objectID UNIQUEIDENTIFIER  
AS  
BEGIN  
 
 SET NOCOUNT ON;  
 
 Declare @Status int = (Select LookupID from core.[lookup] where Name ='Active' and ParentID = 1)
 Declare @ObjectTypeId int;
 Declare @NotificationID UNIQUEIDENTIFIER = null;
 Declare @GeneratedBy int;

IF(@ActionName = 'adddeal')
BEGIN
	SET @ObjectTypeId = (Select LookupID from core.[lookup] where Name ='Deal' and ParentID = 27)
	SET @NotificationID = (Select NotificationID from App.[Notification] where StatusID = @Status and Name ='Add Deal')
	SET @GeneratedBy = (Select LookupID from CORE.Lookup where ParentID = 36 and name = 'System Generated')
END

IF(@ActionName = 'editdeal')
BEGIN

	SET @ObjectTypeId = (Select LookupID from core.[lookup] where Name ='Deal' and ParentID = 27)
	SET @NotificationID = (Select NotificationID from App.[Notification] where StatusID = @Status and Name ='Edit Deal')
	SET @GeneratedBy = (Select LookupID from CORE.Lookup where ParentID = 36 and name = 'System Generated')
END

IF(@ActionName = 'addnote')
BEGIN
	SET @ObjectTypeId = (Select LookupID from core.[lookup] where Name ='Note' and ParentID = 27)
	SET @NotificationID = (Select NotificationID from App.[Notification] where StatusID = @Status and Name ='Add Note')
	SET @GeneratedBy = (Select LookupID from CORE.Lookup where ParentID = 36 and name = 'System Generated')
END

IF(@ActionName = 'editnote')
BEGIN

	SET @ObjectTypeId = (Select LookupID from core.[lookup] where Name ='Note' and ParentID = 27)
	SET @NotificationID = (Select NotificationID from App.[Notification] where StatusID = @Status and Name ='Edit Note')
	SET @GeneratedBy = (Select LookupID from CORE.Lookup where ParentID = 36 and name = 'System Generated')
END


IF(@ActionName = 'adddealbackshop')
BEGIN
	SET @ObjectTypeId = (Select LookupID from core.[lookup] where Name ='Deal' and ParentID = 27)
	SET @NotificationID = (Select NotificationID from App.[Notification] where StatusID = @Status and Name ='Add Deal')
	SET @GeneratedBy = (Select LookupID from CORE.Lookup where ParentID = 36 and name = 'By BackShop')
END

IF(@ActionName = 'editdealbackshop')
BEGIN

	SET @ObjectTypeId = (Select LookupID from core.[lookup] where Name ='Deal' and ParentID = 27)
	SET @NotificationID = (Select NotificationID from App.[Notification] where StatusID = @Status and Name ='Edit Deal')
	SET @GeneratedBy = (Select LookupID from CORE.Lookup where ParentID = 36 and name = 'By BackShop')
END

IF(@ActionName = 'AddTask')
BEGIN

	SET @ObjectTypeId = (Select LookupID from core.[lookup] where Name ='Task' and ParentID = 27)
	SET @NotificationID = (Select NotificationID from App.[Notification] where StatusID = @Status and Name ='AddTask')
	SET @GeneratedBy = (Select LookupID from CORE.Lookup where ParentID = 36 and name =  'System Generated')
END

IF(@ActionName = 'EditTask')
BEGIN

	SET @ObjectTypeId = (Select LookupID from core.[lookup] where Name ='Task' and ParentID = 27)
	SET @NotificationID = (Select NotificationID from App.[Notification] where StatusID = @Status and Name ='EditTask')
	SET @GeneratedBy = (Select LookupID from CORE.Lookup where ParentID = 36 and name =  'System Generated')
END
--print @ObjectTypeId
--Print @NotificationID 
--print @GeneratedBy 
--print @UserId

--Insert Into UserNotification
 IF(@NotificationID is not null)
 BEGIN
	 IF(@ActionName <> 'AddTask' or @ActionName <> 'EditTask')
BEGIN
	INSERT INTO [App].[UserNotification]
	([NotificationSubscriptionID]
	,[ViewedTime]
	,[CleanTime]
	,[ObjectId]
	,[ObjectTypeId]
	,[GeneratedBy]
	,[CreatedBy]
	,[CreatedDate]
	,[UpdatedBy]
	,[UpdatedDate])	
		   
	Select 
	NotificationSubscriptionID,
	null,
	null,
	@objectID,
	@ObjectTypeId,
	@GeneratedBy,
	@UserId,
	getdate(),
	@UserId,
	getdate()
	from app.NotificationSubscription ns
	where ns.EndDate is null and ns.Status = @Status
	and NotificationID = @NotificationID
	and ns.UserID <> @UserId
 END
 ELSE
BEGIN
	INSERT INTO [App].[UserNotification]
	([NotificationSubscriptionID]
	,[ViewedTime]
	,[CleanTime]
	,[ObjectId]
	,[ObjectTypeId]
	,[GeneratedBy]
	,[CreatedBy]
	,[CreatedDate]
	,[UpdatedBy]
	,[UpdatedDate])	
		   
	Select 
	ts.TaskID,
	null,
	null,
	@objectID,
	@ObjectTypeId,
	@GeneratedBy,
	@UserId,
	getdate(),
	@UserId,
	getdate()
	from app.TaskSubscribedUser ts
	where ts.TaskID= @objectID
 END


END
END
