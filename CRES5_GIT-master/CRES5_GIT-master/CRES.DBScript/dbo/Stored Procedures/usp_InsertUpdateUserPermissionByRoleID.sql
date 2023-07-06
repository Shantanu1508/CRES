
CREATE PROCEDURE [dbo].[usp_InsertUpdateUserPermissionByRoleID] --'A91EAA7A-9E11-41F9-A094-850722FEB19D' ,'Deallist'

@tblUserPermission TableTypeUserPermission readonly,
@CreatedBy nvarchar(255),
@UpdatedBy nvarchar(255)
AS
BEGIN
    SET NOCOUNT ON;


	--Truncate table [dbo].[tempTableTypeUserPermission] 
	--INSERT INTO [dbo].[tempTableTypeUserPermission] (RoleID,ModuleTabMasterID,IsEdit,IsView,IsDelete)
	--Select RoleID,ModuleTabMasterID,IsEdit,IsView,IsDelete from @tblUserPermission
	----Where (IsEdit <> 0 or  IsView <> 0 or  IsDelete <> 0)


	Declare @RoleID uniqueidentifier;
	Set @RoleID = (Select Top 1 roleid from @tblUserPermission)

	--Delete Permission for that role
	Delete from app.ModuleTabRoleRightsMap where RoleRightsMapID in (Select RoleRightsMapID from app.RoleRightsMap where roleid = @roleid and RightsID in (Select RightsID from app.Rights))

	--======Insert RoleRightsMap if not exists for role====================
	Declare @RightsID_Edit UNIQUEIDENTIFIER = (Select RightsID from app.Rights where RightsName = 'Edit');
	Declare @RightsID_View UNIQUEIDENTIFIER = (Select RightsID from app.Rights where RightsName = 'View');
	Declare @RightsID_Delete UNIQUEIDENTIFIER = (Select RightsID from app.Rights where RightsName = 'Delete');

	IF NOT EXISTS(Select RoleRightsMapID from App.[RoleRightsMap] where RoleID = @RoleID and RightsID in (Select RightsID from app.Rights where RightsName = 'Edit'))
	BEGIN
		INSERT INTO [App].[RoleRightsMap] ([RoleID],[RightsID],[StatusID],[CreatedBy] ,[CreatedDate] ,[UpdatedBy],[UpdatedDate])
		Values(@RoleID,@RightsID_Edit,1,@CreatedBy,GETDATE(),@UpdatedBy,GETDATE())
	END
	IF NOT EXISTS(Select RoleRightsMapID from App.[RoleRightsMap] where RoleID = @RoleID and RightsID in (Select RightsID from app.Rights where RightsName = 'View'))
	BEGIN
		INSERT INTO [App].[RoleRightsMap] ([RoleID],[RightsID],[StatusID],[CreatedBy] ,[CreatedDate] ,[UpdatedBy],[UpdatedDate])
		Values(@RoleID,@RightsID_View,1,@CreatedBy,GETDATE(),@UpdatedBy,GETDATE())
	END
	IF NOT EXISTS(Select RoleRightsMapID from App.[RoleRightsMap] where RoleID = @RoleID and RightsID in (Select RightsID from app.Rights where RightsName = 'Delete'))
	BEGIN
		INSERT INTO [App].[RoleRightsMap] ([RoleID],[RightsID],[StatusID],[CreatedBy] ,[CreatedDate] ,[UpdatedBy],[UpdatedDate])
		Values(@RoleID,@RightsID_Delete,1,@CreatedBy,GETDATE(),@UpdatedBy,GETDATE())
	END
	--=========================================================================


	--======Insert ModuleTabRoleRightsMap for edit,view,delete====================

	Declare @RoleRightsMapID_Edit UNIQUEIDENTIFIER = (Select RoleRightsMapID from App.[RoleRightsMap] where RoleID = @RoleID and RightsID in (Select RightsID from app.Rights where RightsName = 'Edit'));
	Declare @RoleRightsMapID_View UNIQUEIDENTIFIER = (Select RoleRightsMapID from App.[RoleRightsMap] where RoleID = @RoleID and RightsID in (Select RightsID from app.Rights where RightsName = 'View'));
	Declare @RoleRightsMapID_Delete UNIQUEIDENTIFIER = (Select RoleRightsMapID from App.[RoleRightsMap] where RoleID = @RoleID and RightsID in (Select RightsID from app.Rights where RightsName = 'Delete'));

	INSERT INTO [App].[ModuleTabRoleRightsMap] ([RoleRightsMapID],[ModuleTabMasterID] ,[StatusID],[CreatedBy] ,[CreatedDate] ,[UpdatedBy] ,[UpdatedDate])
	Select RoleRightsMapID,ModuleTabMasterID,[Status],CreatedBy,CreatedDate,UpdatedBy,UpdatedDate from
	(
		Select @RoleRightsMapID_Edit as RoleRightsMapID,ModuleTabMasterID,1 as [Status],@CreatedBy as CreatedBy,GETDATE() as CreatedDate,@UpdatedBy as UpdatedBy,GETDATE() as UpdatedDate from @tblUserPermission  Where (IsEdit <> 0 or  IsView <> 0 or  IsDelete <> 0) and IsEdit = 1
		UNION
		Select @RoleRightsMapID_View as RoleRightsMapID,ModuleTabMasterID,1 as [Status],@CreatedBy as CreatedBy,GETDATE() as CreatedDate,@UpdatedBy as UpdatedBy,GETDATE() as UpdatedDate  from @tblUserPermission Where (IsEdit <> 0 or  IsView <> 0 or  IsDelete <> 0) and IsEdit <> 1 and IsView = 1 and IsDelete <> 1
		UNION
		Select @RoleRightsMapID_Delete as RoleRightsMapID,ModuleTabMasterID,1 as [Status],@CreatedBy as CreatedBy,GETDATE() as CreatedDate,@UpdatedBy as UpdatedBy,GETDATE() as UpdatedDate  from @tblUserPermission Where (IsEdit <> 0 or  IsView <> 0 or  IsDelete <> 0) and IsEdit <> 1 and IsView <> 1 and IsDelete = 1
	)a
	--=========================================================================


END
