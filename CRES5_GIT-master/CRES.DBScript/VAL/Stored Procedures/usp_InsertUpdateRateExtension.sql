
CREATE PROCEDURE [VAL].[usp_InsertUpdateRateExtension]
(
	@tbltype_RateExtension [val].[tbltype_RateExtension] READONLY
)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = (Select top 1 MarkedDate from @tbltype_RateExtension))

	Delete from [VAL].[RateExtension] Where MarkedDateMasterID=@MarkedDateMasterID;

	INSERT INTO [VAL].[RateExtension](MarkedDateMasterID,[Value],[CreatedBy],[CreatedDate],[UpdateBy],[UpdatedDate])
	select @MarkedDateMasterID,[Value],UserID,getdate(),UserID,getdate()
	From @tbltype_RateExtension

 	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END