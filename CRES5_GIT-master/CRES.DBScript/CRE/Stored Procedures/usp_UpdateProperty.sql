

CREATE PROCEDURE [CRE].[usp_UpdateProperty] 
(
	@UserID UNIQUEIDENTIFIER,
	@PropertyID [uniqueidentifier] ,
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
	@UpdatedBy [nvarchar](256) ,
	@UpdatedDate [datetime] 
)	
AS
BEGIN

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
    
	RETURN @@RowCount

END

