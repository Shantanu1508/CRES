
CREATE PROCEDURE [VAL].[usp_InsertUpdatePricingGridMappingMaster]
(
	@tbltype_PricingGridMappingMaster [val].[tbltype_PricingGridMappingMaster] READONLY
)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = (Select top 1 MarkedDate from @tbltype_PricingGridMappingMaster))

	Delete from [VAL].[PricingGridMappingMaster] Where MarkedDateMasterID=@MarkedDateMasterID;

	INSERT INTO [VAL].[PricingGridMappingMaster](MarkedDateMasterID,DealTypeName,DealTypeMapping,[CreatedBy],[CreatedDate],[UpdateBy],[UpdatedDate])
	select @MarkedDateMasterID,DealTypeName,DealTypeMapping,UserID,getdate(),UserID,getdate()
	From @tbltype_PricingGridMappingMaster

 	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END