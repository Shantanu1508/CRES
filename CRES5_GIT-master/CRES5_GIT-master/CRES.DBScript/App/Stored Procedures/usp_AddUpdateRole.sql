

CREATE PROCEDURE [App].[usp_AddUpdateRole] 
(
	@RoleID UNIQUEIDENTIFIER,
	@RoleName [varchar](256),
	@StatusID [int],
	@CreatedBy [nvarchar](256) ,
	@CreatedDate [datetime] ,
	@UpdatedBy [nvarchar](256) ,
	@UpdatedDate [datetime] 

)	
AS
BEGIN

if(@RoleID='00000000-0000-0000-0000-000000000000')
BEGIN
	INSERT INTO [App].[Role]
           ([RoleName]
           ,[StatusID]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])
     VALUES
			(@RoleName,
			@StatusID,
			@CreatedBy,
			getdate(),
			@UpdatedBy,
			getdate())
END
ELSE
BEgin

	UPDATE [App].[Role]
	SET 
	RoleName = @RoleName,
	StatusID = @StatusID,
	UpdatedBy = @UpdatedBy ,
	UpdatedDate = @UpdatedDate 
	WHERE RoleID = @RoleID
    
	
END
	 


END

