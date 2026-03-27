-- Procedure
  ---[VAL].[usp_GetPricingGridMappingMaster]  '11/30/2023'
  
CREATE PROCEDURE [VAL].[usp_GetPricingGridMappingMaster] 
(
	@MarkedDate date
) 
AS    
BEGIN    
    
	SET NOCOUNT ON;    
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
     

	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = @MarkedDate)

	SELECT DealTypeName,'' as emptycol,DealTypeMapping FROM [VAL].[PricingGridMappingMaster] Where MarkedDateMasterID = @MarkedDateMasterID
	
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED  

END