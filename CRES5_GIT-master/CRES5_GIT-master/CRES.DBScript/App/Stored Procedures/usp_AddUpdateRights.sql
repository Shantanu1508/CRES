

CREATE PROCEDURE [App].[usp_AddUpdateRights] 
(
	@RightsID UNIQUEIDENTIFIER,
	@RightsName [varchar](256),
	@StatusID [int],
	@CreatedBy [nvarchar](256) ,
	@CreatedDate [datetime] ,
	@UpdatedBy [nvarchar](256) ,
	@UpdatedDate [datetime] 

)	
AS
BEGIN

if(@RightsID='00000000-0000-0000-0000-000000000000')
BEGIN
	INSERT INTO [App].[Rights]
           ([RightsID]
           ,[RightsName]
           ,[StatusID]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])
     VALUES
			(@RightsID,
			@RightsName,
			@StatusID,
			@CreatedBy,
			getdate(),
			@UpdatedBy,
			getdate())
END
ELSE
BEgin

	UPDATE [App].[Rights]
	SET 
	RightsName = @RightsName,
	StatusID = @StatusID,
	UpdatedBy = @UpdatedBy ,
	UpdatedDate = @UpdatedDate 
	WHERE RightsID = @RightsID
    
	
END
	 


END

