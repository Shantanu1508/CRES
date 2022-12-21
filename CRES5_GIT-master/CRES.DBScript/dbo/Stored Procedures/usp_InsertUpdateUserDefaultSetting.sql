
CREATE PROCEDURE [dbo].[usp_InsertUpdateUserDefaultSetting]  
@UserId UNIQUEIDENTIFIER,
@Type nvarchar(Max),
@Value nvarchar(Max),
@UpdatedBy  nvarchar(Max)
AS
BEGIN
    SET NOCOUNT ON;

Declare @lookUpForDefaultType int = (Select LookupID from CORE.[Lookup] where name = @Type and ParentID = 55);

UPDATE [App].[UserDefaultSetting]
   SET [Value] = @Value
      ,[UpdatedBy] = @UpdatedBy
      ,[UpdatedDate] = GETDATE()
 WHERE Userid =@UserId and [Type] = @lookUpForDefaultType  

IF @@ROWCOUNT = 0 
BEGIN

	INSERT INTO [App].[UserDefaultSetting]
           ([UserID]
           ,[Type]
           ,[Value]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])
     VALUES
       	(@UserId,
			@lookUpForDefaultType,
			@Value,
			@UpdatedBy,
			GETDATE(),
			@UpdatedBy,
			GETDATE()
			)
END 


Delete from app.UserDefaultSetting where value = ''

END
