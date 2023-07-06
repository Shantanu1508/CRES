
CREATE PROCEDURE [dbo].[usp_InsertUpdateUserRoleMap] --'A91EAA7A-9E11-41F9-A094-850722FEB19D' ,'Deallist'

@UserId UNIQUEIDENTIFIER,
@RoleID UNIQUEIDENTIFIER

AS
BEGIN
    SET NOCOUNT ON;


UPDATE [App].[UserRoleMap]
   SET [RoleID] = @RoleID
      ,[StatusID] = 1
      ,[UpdatedBy] = @UserId
      ,[UpdatedDate] = GETDATE()
 WHERE UserID = @UserId and RoleID = @RoleID


IF @@ROWCOUNT = 0 
BEGIN

	INSERT INTO [App].[UserRoleMap]
           ([UserID]
           ,[RoleID]
           ,[StatusID]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])
     VALUES
			(@UserId,
			@RoleID,
			1,
			@UserId,
			GETDATE(),
			@UserId,
			GETDATE()
			)
END 



END
