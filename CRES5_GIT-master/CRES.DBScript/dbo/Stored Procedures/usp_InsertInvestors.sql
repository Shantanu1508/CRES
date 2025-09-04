-- Procedure

CREATE PROCEDURE [dbo].[usp_InsertInvestors]
(
	@tbltype_Investors [TableTypeInvestors] READONLY,
	@EquityAccountID UNIQUEIDENTIFIER
)
AS
BEGIN
	Delete From [CRE].[LiabilityInvestor] where AccountID = @EquityAccountID
	
	INSERT INTO [CRE].[LiabilityInvestor] ([AccountID],[Investor],[EqDate],[Commitment],[SLDate],[Concentration],[ConCommit],[SLAdvance],[BorrowBase]) 
	SELECT @EquityAccountID, [Investor],[EqDate],[Commitment],[SLDate],[Concentration],[ConCommit],[SLAdvance],[BorrowBase] FROM @tbltype_Investors;

END