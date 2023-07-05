
CREATE PROCEDURE [dbo].[usp_InsertUpdateModuleTabRoleRightsMap] --'A91EAA7A-9E11-41F9-A094-850722FEB19D' ,'Deallist'

@RoleID UNIQUEIDENTIFIER,
@RightsID UNIQUEIDENTIFIER,
@ModuleTabMasterID int,
@UpdatedBy UNIQUEIDENTIFIER


AS
BEGIN
    SET NOCOUNT ON;


Declare @RoleRightsMapID UNIQUEIDENTIFIER = (Select RoleRightsMapID from App.[RoleRightsMap] where RoleID = @RoleID and RightsID = @RightsID);

UPDATE [App].[ModuleTabRoleRightsMap]
   SET [RoleRightsMapID] = @RoleRightsMapID
      ,[ModuleTabMasterID] = @ModuleTabMasterID
      ,[StatusID] = 1
      ,[UpdatedBy] = @UpdatedBy
      ,[UpdatedDate] = GETDATE()
 WHERE RoleRightsMapID = @RoleRightsMapID and ModuleTabMasterID = @ModuleTabMasterID


IF @@ROWCOUNT = 0 
BEGIN

	INSERT INTO [App].[ModuleTabRoleRightsMap]
           ([RoleRightsMapID]
           ,[ModuleTabMasterID]
           ,[StatusID]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])
     VALUES
			(@RoleRightsMapID,
			@ModuleTabMasterID,
			1,
			@UpdatedBy,
			GETDATE(),
			@UpdatedBy,
			GETDATE()
			)
END 




END
