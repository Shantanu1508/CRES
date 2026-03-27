CREATE PROCEDURE [dbo].[usp_InsertUpdateDealLevelLiabilityFunding]
(
	@tbltype_DealLevelLiabilityFunding [dbo].[TableTypeDealLevelLiabilityFundingSchedule] READONLY ,
	@UserID nvarchar(256)
)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	 --- Delete 
	DELETE FROM CRE.[LiabilityFundingScheduleDeal]
		WHERE LiabilityFundingScheduleDealID IN (
		SELECT ts.LiabilityFundingScheduleDealID 
		FROM @tbltype_DealLevelLiabilityFunding ts
		WHERE ts.IsDeleted = 1
	)

	INSERT into [CRE].[LiabilityFundingScheduleDeal]
	(
	[AccountID],[DealAccountID],[TransactionDate],[TransactionAmount],[TransactionTypes],[EndingBalance],[GeneratedByUserID],[Applied],
	[Comments],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],[Status]
	)
	SELECT AccountID,DealAccountID,TransactionDate,TransactionAmount,TransactionTypes,EndingBalance,GeneratedByUserID,Applied,Comments,@UserID, GetDate(),@UserID, GetDate(),[StatusID]
	FROM @tbltype_DealLevelLiabilityFunding t where ISNULL(t.LiabilityFundingScheduleDealID,0) = 0 and ISNULL(t.IsDeleted, 0) <> 1


	UPDATE temp
	Set 
	temp.[AccountID] = tmpLiab.AccountID,
	temp.[DealAccountID] = tmpLiab.DealAccountID,
	temp.[TransactionDate] = tmpLiab.TransactionDate,
	temp.[TransactionAmount] = tmpLiab.TransactionAmount,
	temp.[TransactionTypes] = tmpLiab.TransactionTypes,
	temp.[EndingBalance] = tmpLiab.EndingBalance,
	temp.[GeneratedByUserID] = tmpLiab.GeneratedByUserID,
	temp.[Applied] = tmpLiab.Applied,
	temp.[Comments] = tmpLiab.Comments,
	temp.[UpdatedBy] = @UserID,
	temp.[UpdatedDate] = GetDate(),
	temp.[Status] = tmpLiab.StatusID
	
	FROM [CRE].[LiabilityFundingScheduleDeal] temp 
	INNER JOIN  @tbltype_DealLevelLiabilityFunding tmpLiab 
	ON tmpLiab.LiabilityFundingScheduleDealID = temp.LiabilityFundingScheduleDealID
	where ISNULL(tmpLiab.IsDeleted, 0) <> 1

END