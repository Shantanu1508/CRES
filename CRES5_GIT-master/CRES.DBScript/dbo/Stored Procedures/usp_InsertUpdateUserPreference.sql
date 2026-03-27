-- Procedure
-- Procedure

CREATE PROCEDURE [dbo].[usp_InsertUpdateUserPreference]  
@UserId UNIQUEIDENTIFIER,
@ParentModuleName nvarchar(256),
@ModuleType		  nvarchar(256),
@ModuleName		  nvarchar(256),
@HTMLTagID		  nvarchar(256),
@IsActive		 bit,
@UpdatedBy  nvarchar(256)
AS
BEGIN
    SET NOCOUNT ON;


	IF(@ModuleType = 'Tab')
	BEGIN
		Delete From [App].[UserPreference] where [UserID] = @UserId and ParentModuleName = @ParentModuleName and ModuleType = @ModuleType

		INSERT INTO [App].[UserPreference]
		([UserID]
		,ParentModuleName 
		,ModuleType
		,ModuleName	
		,HTMLTagID
		,IsActive
		,[CreatedBy]
		,[CreatedDate]
		,[UpdatedBy]
		,[UpdatedDate])
		VALUES
		(@UserId
		,@ParentModuleName 
		,@ModuleType
		,@ModuleName	
		,@HTMLTagID
		,@IsActive
		,@UpdatedBy
		,GETDATE()
		,@UpdatedBy
		,GETDATE()
		)
	END


	
	IF(@ModuleType = 'Section')
	BEGIN
		Delete From [App].[UserPreference] where [UserID] = @UserId and ParentModuleName = @ParentModuleName and ModuleType = @ModuleType and HTMLTagID = @HTMLTagID

		INSERT INTO [App].[UserPreference]
		([UserID]
		,ParentModuleName 
		,ModuleType
		,ModuleName	
		,HTMLTagID
		,IsActive
		,[CreatedBy]
		,[CreatedDate]
		,[UpdatedBy]
		,[UpdatedDate])
		VALUES
		(@UserId
		,@ParentModuleName 
		,@ModuleType
		,@ModuleName	
		,@HTMLTagID
		,@IsActive
		,@UpdatedBy
		,GETDATE()
		,@UpdatedBy
		,GETDATE()
		)
	END

END
