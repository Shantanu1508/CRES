
CREATE PROCEDURE [VAL].[usp_InsertUpdatedSECMastHolding]
(
	@tbltype_SECMastHolding [val].[tbltype_SECMastHolding] READONLY

	--@PropertyName	nvarchar(256),
	--@LTValueDecline	decimal(28,15),
	--@UserID	nvarchar(256)	
)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	
	Declare @MarkedDateMasterID int;
	SET @MarkedDateMasterID = (Select MarkedDateMasterID from [VAL].[MarkedDateMaster] where MarkedDate = (Select top 1 MarkedDate from @tbltype_SECMastHolding))


	IF EXISTS(Select top 1 Ticker from @tbltype_SECMastHolding)
	BEGIN
		Delete from [VAL].[SECMastHolding] where MarkedDateMasterID = @MarkedDateMasterID


		INSERT INTO [VAL].[SECMastHolding](
		MarkedDateMasterID
		,Ticker
		,LoanID
		,Description	
		,FinancingSource	
		,NoteName	
		,Priority	
		,OriginationDate	
		,FullyExtendedMaturityDate	
		,PaymentDay	
		,InterestRate
		,InitialFunding
		,OriginalAmountofLoan
		,AdjustedCommitment
		,AmountofLoanOutstanding	
		,IndexFloor		
		,[CreatedBy]
		,[CreatedDate]
		,[UpdateBy]
		,[UpdatedDate])
	
	
		select @MarkedDateMasterID
		,Ticker
		,LoanID
		,Description	
		,FinancingSource	
		,NoteName	
		,Priority	
		,OriginationDate	
		,FullyExtendedMaturityDate	
		,PaymentDay	
		,InterestRate
		,InitialFunding
		,OriginalAmountofLoan
		,AdjustedCommitment
		,AmountofLoanOutstanding	
		,IndexFloor	
		,UserID
		,getdate()
		,UserID
		,getdate()
		From @tbltype_SECMastHolding
	END


 	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
