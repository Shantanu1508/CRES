

CREATE PROCEDURE [App].[usp_AddUpdateFastFunction]
(
	@FunctionID UNIQUEIDENTIFIER,
	@FunctionName NVARCHAR(256),
	@FunctionType int,
	@CreatedBy NVARCHAR(256),
	@IsDefault bit,
	@NewFunctionID varchar(256) OUTPUT
) 
AS
BEGIN

DECLARE @tfunction TABLE (tfunctionId UNIQUEIDENTIFIER)

--FunctionType 1-add,2-update

if ((@IsDefault=1) or exists(select 1 from [App].[FastFunction] where FunctionName = @FunctionName and IsDefault=1))
	begin
		update [App].[FastFunction] set IsDefault=0
	end


INSERT INTO [App].[FastFunction]
           ([FunctionName]
           ,[FunctionType]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate]
		   ,IsDefault)
		   OUTPUT inserted.FunctionID INTO @tfunction(tfunctionId)
     VALUES
           (@FunctionName
           ,@FunctionType
           ,@CreatedBy
           ,getdate()
           ,@CreatedBy
           ,getdate()
		   ,@IsDefault)

		   SELECT @NewFunctionID = tfunctionId FROM @tfunction;

END


