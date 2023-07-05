

CREATE PROCEDURE [CRE].[usp_AddUpdateProperty] 
(
	@UserID UNIQUEIDENTIFIER,
	@Deal_DealId UNIQUEIDENTIFIER,
	@PropertyID UNIQUEIDENTIFIER ,	
	@PropertyName [nvarchar](256) ,
	@Address [nvarchar](256) ,
	@City [nvarchar](256) ,
	@State [int] ,
	@Zip [int] ,
	@UWNCF [decimal](28, 15) ,
	@SQFT [decimal](28, 15) ,
	@PropertyType [int] ,
	@AllocDebtPer [decimal](28, 15) ,
	@PropertySubtype [int] ,
	@NumberofUnitsorSF [int], 
	@Occ [decimal](28, 15) ,
	@Class [nvarchar](256) ,
	@YearBuilt [nvarchar](256) ,
	@Renovated [nvarchar](256) ,
	@Bldgs [int] ,
	@Acres [nvarchar](256) ,
	@CreatedBy [nvarchar](256) ,
	@CreatedDate [datetime] ,
	@UpdatedBy [nvarchar](256) ,
	@UpdatedDate [datetime] ,

	@NewPropertyID varchar(256) OUTPUT
)	
AS
BEGIN

if(@PropertyID='00000000-0000-0000-0000-000000000000')
BEgin

DECLARE @tProperty TABLE (tNewPropertyID UNIQUEIDENTIFIER)

INSERT INTO [CRE].[Property]
           ([Deal_DealID]
           ,[PropertyName]
           ,[Address]
           ,[City]
           ,[State]
           ,[Zip]
           ,[UWNCF]
           ,[SQFT]
           ,[PropertyType]
           ,[AllocDebtPer]
           ,[PropertySubtype]
           ,[NumberofUnitsorSF]
           ,[Occ]
           ,[Class]
           ,[YearBuilt]
           ,[Renovated]
           ,[Bldgs]
           ,[Acres]
           ,[CreatedBy]
           ,[CreatedDate]
		   ,[updatedby]
		   ,[UpdatedDate])  
		   
		   OUTPUT inserted.PropertyID INTO @tProperty(tNewPropertyID)
		           
     VALUES
           (@Deal_DealID
           ,@PropertyName
		   ,@Address
           ,@City
           ,@State
           ,@Zip
           ,@UWNCF
           ,@SQFT
           ,@PropertyType
           ,@AllocDebtPer
           ,@PropertySubtype
           ,@NumberofUnitsorSF
           ,@Occ
           ,@Class
           ,@YearBuilt
           ,@Renovated
		   ,@Bldgs
           ,@Acres
           ,@CreatedBy
           ,getdate()
		   ,@UpdatedBy
		   ,getdate())


		   SELECT @NewPropertyID = tNewPropertyID FROM @tProperty;
END
ELSE
BEgin

	UPDATE [CRE].[Property]
	SET 
	PropertyName = @PropertyName ,
	[Address] = @Address ,
	City = @City ,
	[State] = @State , 
	Zip = @Zip ,
	UWNCF = @UWNCF ,
	SQFT = @SQFT ,
	PropertyType = @PropertyType ,
	AllocDebtPer = @AllocDebtPer ,
	PropertySubtype = @PropertySubtype ,
	NumberofUnitsorSF = @NumberofUnitsorSF ,
	Occ = @Occ ,
	Class = @Class ,
	YearBuilt = @YearBuilt ,
	Renovated = @Renovated ,
	Bldgs = @Bldgs ,
	Acres = @Acres ,
	UpdatedBy = @UpdatedBy ,
	UpdatedDate = @UpdatedDate 
	WHERE PropertyID = @PropertyID
    
	
	SELECT @NewPropertyID = @PropertyID	
END
	 


END

