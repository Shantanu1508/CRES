
CREATE PROCEDURE [VAL].[usp_InsertUpdateValueDeclineByPropertyType]
(
	@tbltype_ValueDeclineByPropertyType [val].[tbltype_ValueDeclineByPropertyType] READONLY
)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = (Select top 1 MarkedDate from @tbltype_ValueDeclineByPropertyType))

	Delete from [VAL].[ValueDeclineByPropertyType] Where MarkedDateMasterID=@MarkedDateMasterID;

	INSERT INTO [VAL].[ValueDeclineByPropertyType](MarkedDateMasterID,PropertyType,ValueDecline,[CreatedBy],[CreatedDate],[UpdateBy],[UpdatedDate])
	select @MarkedDateMasterID,PropertyType,ValueDecline,UserID,getdate(),UserID,getdate()
	From @tbltype_ValueDeclineByPropertyType

 	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END