  

CREATE PROCEDURE [dbo].[usp_GetPropertyByPropertyId] 
(
   @PropertyId Varchar(500)

)
	
AS

 
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

 IF(@PropertyId IS NULL or @PropertyId='00000000-0000-0000-0000-000000000000')

	  	 
	    Begin

	SELECT PropertyID
			  ,Deal_DealID
			  ,PropertyName
			  ,Address
			  ,City
			  ,State
			  ,Zip
			  ,UWNCF
			  ,SQFT
			  ,PropertyType
			  ,l1.Name PropertyTypeText
			  ,AllocDebtPer
			  ,PropertySubtype
			  ,l2.Name PropertySubtypeText
			  ,NumberofUnitsorSF
			  ,Occ
			  ,Class
			  ,YearBuilt
			  ,Renovated
			  ,Bldgs
			  ,Acres
			  ,p.CreatedBy
			  ,p.CreatedDate
			  ,p.UpdatedBy
			  ,p.UpdatedDate
		  FROM CRE.Property p 
		  LEFT JOIN core.Lookup l1 on p.PropertyType=l1.LookupID
		 LEFT join core.Lookup l2 on p.PropertySubtype=l2.LookupID
		  WHERE convert(varchar(500), p.PropertyID)  = @PropertyId

		END
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		END
