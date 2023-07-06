

CREATE PROCEDURE [App].[usp_AddUpdateModuleTabMaster] 
(
	@ModuleTabMasterID  int,
	@ModuleTabName  nvarchar(max),
	@ParentID  int  ,
	@StatusID  int,
	@CreatedBy  nvarchar(256)  ,
	@CreatedDate  datetime  ,
	@UpdatedBy  nvarchar(256)  ,
	@UpdatedDate  datetime  ,
	@SortOrder  int  ,
	@DisplayName  nvarchar(max)  ,
	@ModuleType  nvarchar(max)  

)	
AS
BEGIN

if(@ModuleTabMasterID = 0)
BEGIN
	INSERT INTO [App].[ModuleTabMaster]
           ([ModuleTabName]
           ,[ParentID]
           ,[StatusID]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate]
           ,[SortOrder]
           ,[DisplayName]
           ,[ModuleType])
     VALUES
			(
			@ModuleTabName,
			@ParentID,
			@StatusID,
			@CreatedBy,
			getdate(),
			@UpdatedBy,
			getdate(),
			@SortOrder,
			@DisplayName,
			@ModuleType  
			)
END
ELSE
BEgin

	UPDATE [App].[ModuleTabMaster]
	SET 
	ModuleTabName = @ModuleTabName,
	ParentID = @ParentID,
	StatusID = @StatusID,
	SortOrder = @SortOrder,
	DisplayName = @DisplayName,
	ModuleType = @ModuleType,
	UpdatedBy = @UpdatedBy ,
	UpdatedDate = @UpdatedDate 
	WHERE ModuleTabMasterID = @ModuleTabMasterID
    
	
END
	 


END

