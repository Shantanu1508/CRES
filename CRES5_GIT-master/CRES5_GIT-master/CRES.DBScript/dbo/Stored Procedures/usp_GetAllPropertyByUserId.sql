  

CREATE PROCEDURE [dbo].[usp_GetAllPropertyByUserId] 
(
   @DealId Varchar(500),
	@UserID UNIQUEIDENTIFIER,
    @PageIndex INT,
    @PageSize INT,
	@TotalCount INT OUTPUT 
)
	
AS
 BEGIN
 	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

 IF(@DealId IS NULL or  @DealId ='')
 BEGIN

		SELECT @TotalCount = COUNT(PropertyID) FROM CRE.Property WITH (ROWLOCK, HOLDLOCK);			 
	   
		SELECT PropertyID
		,Deal_DealID
		,PropertyName
		,DealName
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
		LEFT join cre.deal d on d.dealid = p.Deal_DealID
		  where d.IsDeleted = 0
		ORDER BY p.UpdatedDate DESC
		OFFSET (@PageIndex - 1)*@PageSize ROWS
		FETCH NEXT @PageSize ROWS ONLY

END
ELSE
BEGIN

		SELECT @TotalCount = COUNT(PropertyID) FROM CRE.Property WITH (ROWLOCK, HOLDLOCK);			 
	   
		SELECT PropertyID
		,Deal_DealID
		,PropertyName
		,DealName
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
		LEFT join cre.deal d on d.dealid = p.Deal_DealID
		where d.DealID = @DealId and d.IsDeleted = 0

		ORDER BY p.UpdatedDate DESC
		OFFSET (@PageIndex - 1)*@PageSize ROWS
		FETCH NEXT @PageSize ROWS ONLY
 END
 
	   	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
		  
  
END
 
