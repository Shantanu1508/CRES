

CREATE PROCEDURE [VAL].[usp_InsertUpdatedPricingGridFeeAssumptions]
(
	@tbltype_PricingGridFeeAssumptions [val].[tbltype_PricingGridFeeAssumptions] READONLY	
)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = (Select top 1 MarkedDate from @tbltype_PricingGridFeeAssumptions))

	Delete from [VAL].[PricingGridFeeAssumptions] Where MarkedDateMasterID = @MarkedDateMasterID;

	INSERT INTO [VAL].[PricingGridFeeAssumptions](MarkedDateMasterID,ValueType, Nonconstruction, Construction,[CreatedBy],[CreatedDate],[UpdateBy],[UpdatedDate])
	select @MarkedDateMasterID,ValueType, Nonconstruction, Construction,UserID,getdate(),UserID,getdate()
	From @tbltype_PricingGridFeeAssumptions

 	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END