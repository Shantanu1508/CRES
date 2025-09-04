
CREATE PROCEDURE [VAL].[usp_InsertUpdatedMarkedDateMaster]
(
	@MarkedDate	Date,
	@UserID nvarchar(256)
)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	

	IF EXISTS(Select 1 from [VAL].[MarkedDateMaster] where MarkedDate = @MarkedDate)
	BEGIN
		Update [VAL].[MarkedDateMaster] set [UpdateBy] = @UserID,[UpdatedDate] = getdate() where MarkedDate = @MarkedDate		
	END
	ELSE
	BEGIN
		INSERT INTO [VAL].[MarkedDateMaster](MarkedDate,[CreatedBy],[CreatedDate],[UpdateBy],[UpdatedDate])
		VALUES(@MarkedDate,@UserID,getdate(),@UserID,getdate())
	END
	


 	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
