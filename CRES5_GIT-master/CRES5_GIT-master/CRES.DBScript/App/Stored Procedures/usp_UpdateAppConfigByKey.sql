CREATE Procedure [App].[usp_UpdateAppConfigByKey]
	@userId [uniqueidentifier],
	@Key nvarchar(255),
	@Value nvarchar(255),
	@UpdatedBy nvarchar(256)
AS
BEGIN
	SET NOCOUNT ON;
	
	declare @rowCnt int;
	select @rowCnt = COunt([value]) from [App].[AppConfig] where [Key]=@Key
	IF @rowCnt=0 
		BEGIN
			Insert into [App].[AppConfig]([Key],[Value],CreatedBy,CreatedDate,UpdatedBy,UpdatedDate) 
			values(@Key,@Value,@userId,GETDATE(),@userId,GETDATE())
		END
	ELSE
		BEGIN
			IF(@Key='AllowBackshopFF')
			BEGIN
				Update [App].[AppConfig] set [Value]=@Value,UpdatedBy=@userId,UpdatedDate=GETDATE() where [Key] in ('AllowBackshopFF','AllowBackshopPIKPrincipal')
			END
			ELSE
			BEGIN
				Update [App].[AppConfig] set [Value]=@Value,UpdatedBy=@userId,UpdatedDate=GETDATE() where [Key]=@Key
			END
			
		END

		select 1
END

