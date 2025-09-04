-- Procedure
  ---[VAL].[usp_GetPricingGrid]  '11/30/2025'
  
CREATE PROCEDURE [VAL].[usp_GetPricingGrid] 
(
	@MarkedDate date
) 
AS    
BEGIN    
    
 SET NOCOUNT ON;    
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
     

	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = @MarkedDate)
	/*IF @MarkedDateMasterID IS NULL
	BEGIN
		SET @MarkedDateMasterID = (Select Top 1 MarkedDateMasterID from [VAL].[PricingGrid] ORDER BY MarkedDateMasterID Desc)
	END
	*/

	Select 
		Case When PropertyType IS NULL OR PropertyType = '' Then NULL ELSE AnoteLTV END as AnoteLTV, 
		Case When PropertyType IS NULL OR PropertyType = '' Then NULL ELSE AnoteSpread END as AnoteSpread, 
		Case When PropertyType IS NULL OR PropertyType = '' Then NULL ELSE ABwholeLoanLTV END as ABwholeLoanLTV, 
		Case When PropertyType IS NULL OR PropertyType = '' Then NULL ELSE ABwholeLoanSpread END as ABwholeLoanSpread, 
		Case When PropertyType IS NULL OR PropertyType = '' Then NULL ELSE EquityLTV END as EquityLTV, 
		Case When PropertyType IS NULL OR PropertyType = '' Then NULL ELSE EquityYield END as EquityYield
	from [val].[PricingGrid] Where MarkedDateMasterID = @MarkedDateMasterID
    
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
END
GO

