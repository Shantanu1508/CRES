
CREATE PROCEDURE [dbo].[usp_InsertUpdateLiabilityFundingScheduleAggregate]
(
	@tbltype_LiabilityFundingScheduleAggregate [dbo].[TableTypeLiabilityFundingScheduleAggregate] READONLY ,
	@UserID nvarchar(256)
)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	 DECLARE @AccountID UNIQUEIDENTIFIER
	 DECLARE @ParentAccountID UNIQUEIDENTIFIER
	

	SELECT TOP 1 @AccountID  = AccountID,@ParentAccountID = ParentAccountID FROM @tbltype_LiabilityFundingScheduleAggregate

	 --- Delete 
		DELETE FROM CRE.LiabilityFundingScheduleAggregate 
		WHERE LiabilityFundingScheduleAggregateID IN (
		SELECT ts.LiabilityFundingScheduleAggregateID 
		FROM @tbltype_LiabilityFundingScheduleAggregate ts
		WHERE ts.IsDeleted = 1
		)

	---Insert Values
	INSERT into CRE.LiabilityFundingScheduleAggregate (
	ParentAccountID
	,[AccountID]	
	,TransactionDate	
	,TransactionAmount
	,TransactionTypes
	,Applied
	,Comments
	,CreatedBy
	,CreatedDate
	,UpdatedBy
	,UpdatedDate
	,EndingBalance
	,CalcType
	,[Status]
	)
	SELECT 
	tmpLiab.ParentAccountID
	,tmpLiab.AccountID
	,tmpLiab.TransactionDate
	,tmpLiab.TransactionAmount
	,tmpLiab.TransactionTypes
	,tmpLiab.Applied
	,tmpLiab.Comments	
	,@UserID
	,GETDATE()
	,@UserID
	,GETDATE() 
	,tmpLiab.EndingBalance
	,tmpLiab.CalcType
	,tmpLiab.StatusID
	FROM 
	(
		SELECT 
		tliab.LiabilityFundingScheduleAggregateID
		,tliab.ParentAccountID
		,tliab.AccountID
		,tliab.TransactionDate
		,tliab.TransactionAmount
		,tliab.TransactionTypes
		,tliab.Applied
		,tliab.Comments		
		,tliab.EndingBalance
		,tliab.CalcType
		,tliab.IsDeleted
		,tliab.StatusID
		FROM @tbltype_LiabilityFundingScheduleAggregate tliab
	 
	) tmpLiab
	left outer join  CRE.LiabilityFundingScheduleAggregate tliabFF on tliabFF.LiabilityFundingScheduleAggregateID = tmpLiab.LiabilityFundingScheduleAggregateID and tliabFF.AccountID = tmpLiab.AccountID and tliabFF.ParentAccountID = tmpLiab.ParentAccountID
	where  tliabFF.LiabilityFundingScheduleAggregateID is null and tliabFF.AccountID is null and ISNULL(tmpLiab.IsDeleted, 0) <> 1
	


	---Update Values
	UPDATE CRE.LiabilityFundingScheduleAggregate
	Set 
	CRE.LiabilityFundingScheduleAggregate.AccountID = tmpLiab.AccountID ,
	CRE.LiabilityFundingScheduleAggregate.TransactionDate = tmpLiab.TransactionDate ,
	CRE.LiabilityFundingScheduleAggregate.TransactionAmount = tmpLiab.TransactionAmount ,
	CRE.LiabilityFundingScheduleAggregate.TransactionTypes = tmpLiab.TransactionTypes ,
	CRE.LiabilityFundingScheduleAggregate.Applied = tmpLiab.Applied ,
	CRE.LiabilityFundingScheduleAggregate.Comments = tmpLiab.Comments ,
	CRE.LiabilityFundingScheduleAggregate.UpdatedBy= @UserID,
	CRE.LiabilityFundingScheduleAggregate.UpdatedDate=GETDATE(),
	CRE.LiabilityFundingScheduleAggregate.EndingBalance = tmpLiab.EndingBalance,
	CRE.LiabilityFundingScheduleAggregate.CalcType = tmpLiab.CalcType,
	CRE.LiabilityFundingScheduleAggregate.[Status] = tmpLiab.StatusID
	
	
	FROM (
		SELECT tliab.ParentAccountID
		,tliab.LiabilityFundingScheduleAggregateID
		,tliab.AccountID
		,tliab.TransactionDate
		,tliab.TransactionAmount
		,tliab.TransactionTypes
		,tliab.Applied
		,tliab.Comments
		,tliab.EndingBalance
		,tliab.CalcType
		,tliab.IsDeleted
		,tliab.StatusID
		FROM @tbltype_LiabilityFundingScheduleAggregate tliab
	) tmpLiab
	Inner join  CRE.LiabilityFundingScheduleAggregate tliabFF on tliabFF.LiabilityFundingScheduleAggregateID = tmpLiab.LiabilityFundingScheduleAggregateID and tliabFF.AccountID = tmpLiab.AccountID and tliabFF.ParentAccountID = tmpLiab.ParentAccountID
	where ISNULL(tmpLiab.IsDeleted, 0) <> 1

 	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
