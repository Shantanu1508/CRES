
-- Procedure
  ---[VAL].[usp_GetPricingGridFeeAssumptions]  '12/30/2022'
  
CREATE PROCEDURE [VAL].[usp_GetPricingGridFeeAssumptions] 
(
	@MarkedDate date
) 
AS    
BEGIN    
    
 SET NOCOUNT ON;    
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
     

	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = @MarkedDate)

	Select ValueType, Nonconstruction, Construction from [val].[PricingGridFeeAssumptions] Where MarkedDateMasterID = @MarkedDateMasterID
    
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
END