--[dbo].[usp_DeleteModuleByID] 'b0e6697b-3534-4c09-be0a-04473401ab93',"Deal",'f4c26166-9808-480c-ba65-a259331e796b',0
CREATE PROCEDURE [dbo].[usp_InsertActivityLog] --'1479'
(
	@ParentModuleID Uniqueidentifier,
	@ParentModuleTypeID int,
	@ModuleID Uniqueidentifier,
	@LookupID int,
	@DisplayMessage nvarchar(max),
	@CreatedBy Uniqueidentifier,
	@ModuleIDInt int=null
)
AS
BEGIN

INSERT INTO [App].[ActivityLog]
           ([ParentModuleID]
		   ,[ParentModuleTypeID]
		   ,[ModuleID]
           ,[ActivityType]
           ,[DisplayMessage]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate]
           ,[ModuleIDInt]
		   )
     VALUES
           (@ParentModuleID
		   ,@ParentModuleTypeID
		   ,@ModuleID
           ,@LookupID
           ,@DisplayMessage
           ,@CreatedBy
           ,GETDATE()
           ,@CreatedBy
           ,GETDATE()
           ,@ModuleIDInt
		   )

END
GO

