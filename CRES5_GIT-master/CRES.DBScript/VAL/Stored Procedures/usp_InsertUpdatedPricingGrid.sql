CREATE PROCEDURE [VAL].[usp_InsertUpdatedPricingGrid]
(
	@tbltype_PricingGrid [val].[tbltype_PricingGrid] READONLY	
)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = (Select top 1 MarkedDate from @tbltype_PricingGrid))

	Delete from [VAL].[PricingGrid] Where MarkedDateMasterID = @MarkedDateMasterID;

	INSERT INTO [VAL].[PricingGrid](MarkedDateMasterID,PropertyType, DealType, AnoteLTV, AnoteSpread, ABwholeLoanLTV, ABwholeLoanSpread, EquityLTV, EquityYield,[CreatedBy],[CreatedDate],[UpdateBy],[UpdatedDate])
	select @MarkedDateMasterID,PropertyType, DealType, AnoteLTV, AnoteSpread, ABwholeLoanLTV, ABwholeLoanSpread, EquityLTV, EquityYield,UserID,getdate(),UserID,getdate()
	From @tbltype_PricingGrid

 	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
GO

