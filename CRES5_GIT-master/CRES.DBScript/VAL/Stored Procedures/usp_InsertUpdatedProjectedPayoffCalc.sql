
CREATE PROCEDURE [VAL].[usp_InsertUpdatedProjectedPayoffCalc]
(
	@tbltype_ProjectedPayoffCalc [val].[tbltype_ProjectedPayoffCalc] READONLY
)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = (Select top 1 MarkedDate from @tbltype_ProjectedPayoffCalc))


	IF EXISTS(Select top 1 ControlID from @tbltype_ProjectedPayoffCalc)
	BEGIN
		Delete from [VAL].[ProjectedPayoffCalc] where MarkedDateMasterID = @MarkedDateMasterID


		INSERT INTO [VAL].[ProjectedPayoffCalc](MarkedDateMasterID,ControlID,DealName,Client,PropertyType,FullyExtendedMaturityDate,OpenDate,[CreatedBy],[CreatedDate],[UpdateBy],[UpdatedDate])	
		select @MarkedDateMasterID,ControlID,DealName,Client,PropertyType,FullyExtendedMaturityDate,OpenDate,UserID,getdate(),UserID,getdate()
		From @tbltype_ProjectedPayoffCalc

	END


 	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
