
CREATE PROCEDURE [dbo].[usp_InsertUpdateRoleRightsMap] --'A91EAA7A-9E11-41F9-A094-850722FEB19D' ,'Deallist'

@UserId UNIQUEIDENTIFIER,
@RoleID UNIQUEIDENTIFIER,
@RightsID UNIQUEIDENTIFIER


AS
BEGIN
    SET NOCOUNT ON;

UPDATE [App].[RoleRightsMap]
   SET [RightsID] = @RightsID
      ,[StatusID] = 1
      ,[UpdatedBy] = @UserId
      ,[UpdatedDate] = GETDATE()
 WHERE  RoleID = @RoleID and RightsID =@RightsID


IF @@ROWCOUNT = 0 
BEGIN


INSERT INTO [App].[RoleRightsMap]
           ([RoleID]
           ,[RightsID]
           ,[StatusID]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])
     VALUES
			(@RoleID,
			@RightsID,
			1,
			@UserId,
			GETDATE(),
			@UserId,
			GETDATE()
			)
END 



END
