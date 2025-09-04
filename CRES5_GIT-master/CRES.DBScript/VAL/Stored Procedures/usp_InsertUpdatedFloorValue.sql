
CREATE PROCEDURE [VAL].[usp_InsertUpdatedFloorValue]
(
	@MarkedDate date,
	@IndexTypeName	nvarchar(256),
	@CurrentMarketLoanFloor	decimal(28,15),
	@Term	decimal(28,15),
	@LoanFloor	decimal(28,15),
	@UserID	nvarchar(256)	
)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
		
	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = @MarkedDate)


	INSERT INTO [VAL].[FloorValue](MarkedDateMasterID,IndexTypeName,CurrentMarketLoanFloor,Term,LoanFloor,[CreatedBy],[CreatedDate],[UpdateBy],[UpdatedDate])
	VALUES(@MarkedDateMasterID,@IndexTypeName,@CurrentMarketLoanFloor,@Term,@LoanFloor,@UserID,getdate(),@UserID,getdate())


	 

 	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
