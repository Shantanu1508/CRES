
CREATE PROCEDURE [dbo].[usp_InsertUpdateLiabilityFundingSchedule]
(
	@tbltype_LiabilityFundingSchedule [dbo].[TableTypeLiabilityFundingSchedule] READONLY ,
	@UserID nvarchar(256)
)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
    DECLARE @AccountID UNIQUEIDENTIFIER
	SELECT TOP 1 @AccountID  = AccountID FROM @tbltype_LiabilityFundingSchedule

	 --- Delete 
	DELETE FROM CRE.LiabilityFundingSchedule 
		WHERE LiabilityFundingScheduleID IN (
		SELECT ts.LiabilityFundingScheduleID 
		FROM @tbltype_LiabilityFundingSchedule ts
		WHERE ts.IsDeleted = 1
	)
	
	---Insert Values
	INSERT into CRE.LiabilityFundingSchedule (LiabilityNoteAccountID
	,TransactionDate
	,TransactionAmount
	,GeneratedBy
	,Applied
	,Comments
	,AssetAccountID
	,AssetTransactionDate
	,AssetTransactionAmount
	,TransactionAdvanceRate
	,CumulativeAdvanceRate
	,AssetTransactionComment
	,RowNo
	,CreatedBy
	,CreatedDate
	,UpdatedBy
	,UpdatedDate
	,GeneratedByUserID
	,TransactionTypes
	,AccountID
	,EndingBalance
	,CalcType
	,[Status]
	)
	SELECT 
	 tmpLiab.LiabilityNoteAccountID
	,tmpLiab.TransactionDate
	,tmpLiab.TransactionAmount
	,tmpLiab.GeneratedBy
	,tmpLiab.Applied
	,tmpLiab.Comments
	,tmpLiab.AssetAccountID
	,tmpLiab.AssetTransactionDate
	,tmpLiab.AssetTransactionAmount
	,tmpLiab.TransactionAdvanceRate
	,tmpLiab.CumulativeAdvanceRate
	,tmpLiab.AssetTransactionComment
	,tmpLiab.RowNo
	,@UserID
	,GETDATE()
	,@UserID
	,GETDATE() 
	,tmpLiab.GeneratedByUserID
	,tmpLiab.TransactionTypes
	,tmpLiab.AccountID
	,tmpLiab.EndingBalance
	,tmpLiab.CalcType
	,tmpLiab.StatusID
	FROM 
	(
		SELECT 
		tliab.LiabilityFundingScheduleID
		,tliab.LiabilityNoteAccountID
		,tliab.TransactionDate
		,tliab.TransactionAmount
		,tliab.GeneratedBy
		,tliab.Applied
		,tliab.Comments
		,tliab.AssetAccountID
		,tliab.AssetTransactionDate
		,tliab.AssetTransactionAmount
		,tliab.TransactionAdvanceRate
		,tliab.CumulativeAdvanceRate
		,tliab.AssetTransactionComment
		,tliab.RowNo
		,tliab.GeneratedByUserID
		,tliab.TransactionTypes
		,tliab.AccountID
		,tliab.EndingBalance
		,tliab.CalcType
		,tliab.IsDeleted
		,tliab.StatusID
		FROM @tbltype_LiabilityFundingSchedule tliab
	 
	) tmpLiab
	left outer join  CRE.LiabilityFundingSchedule tliabFF on tliabFF.LiabilityFundingScheduleID = tmpLiab.LiabilityFundingScheduleID and tliabFF.LiabilityNoteAccountID = tmpLiab.LiabilityNoteAccountID
	where tliabFF.LiabilityFundingScheduleID is null and tliabFF.LiabilityNoteAccountID is null and ISNULL(tmpLiab.IsDeleted, 0) <> 1
	---and tliabFF.Subline_DebtAccountID is null




	---Update Values
	UPDATE CRE.LiabilityFundingSchedule
	Set 
	CRE.LiabilityFundingSchedule.LiabilityNoteAccountID = tmpLiab.LiabilityNoteAccountID ,
	CRE.LiabilityFundingSchedule.TransactionDate = tmpLiab.TransactionDate ,
	CRE.LiabilityFundingSchedule.TransactionAmount = tmpLiab.TransactionAmount ,
	CRE.LiabilityFundingSchedule.GeneratedBy = tmpLiab.GeneratedBy ,
	CRE.LiabilityFundingSchedule.Applied = tmpLiab.Applied ,
	CRE.LiabilityFundingSchedule.Comments = tmpLiab.Comments ,
	CRE.LiabilityFundingSchedule.AssetAccountID = tmpLiab.AssetAccountID ,
	CRE.LiabilityFundingSchedule.AssetTransactionDate = tmpLiab.AssetTransactionDate ,
	CRE.LiabilityFundingSchedule.AssetTransactionAmount = tmpLiab.AssetTransactionAmount ,
	CRE.LiabilityFundingSchedule.TransactionAdvanceRate = tmpLiab.TransactionAdvanceRate ,
	CRE.LiabilityFundingSchedule.CumulativeAdvanceRate = tmpLiab.CumulativeAdvanceRate ,
	CRE.LiabilityFundingSchedule.AssetTransactionComment = tmpLiab.AssetTransactionComment ,
	CRE.LiabilityFundingSchedule.RowNo = tmpLiab.RowNo ,
	CRE.LiabilityFundingSchedule.UpdatedBy= @UserID,
	CRE.LiabilityFundingSchedule.UpdatedDate=GETDATE(),
	CRE.LiabilityFundingSchedule.GeneratedByUserID = tmpLiab.GeneratedByUserID,
	CRE.LiabilityFundingSchedule.TransactionTypes = tmpLiab.TransactionTypes ,
	CRE.LiabilityFundingSchedule.AccountID = tmpLiab.AccountID ,
	CRE.LiabilityFundingSchedule.EndingBalance = tmpLiab.EndingBalance,
	CRE.LiabilityFundingSchedule.CalcType = tmpLiab.CalcType,
	CRE.LiabilityFundingSchedule.[Status] = tmpLiab.StatusID

	
	FROM (
		SELECT 
		tliab.LiabilityFundingScheduleID
		,tliab.LiabilityNoteAccountID
		,tliab.TransactionDate
		,tliab.TransactionAmount
		,tliab.GeneratedBy
		,tliab.Applied
		,tliab.Comments
		,tliab.AssetAccountID
		,tliab.AssetTransactionDate
		,tliab.AssetTransactionAmount
		,tliab.TransactionAdvanceRate
		,tliab.CumulativeAdvanceRate
		,tliab.AssetTransactionComment
		,tliab.RowNo
		,tliab.GeneratedByUserID
		,tliab.TransactionTypes
		,tliab.AccountID
		,tliab.EndingBalance
		,tliab.CalcType
		,tliab.IsDeleted
		,tliab.StatusID
		FROM @tbltype_LiabilityFundingSchedule tliab
	) tmpLiab
	Inner join  CRE.LiabilityFundingSchedule tliabFF on tliabFF.LiabilityFundingScheduleID = tmpLiab.LiabilityFundingScheduleID and tliabFF.LiabilityNoteAccountID = tmpLiab.LiabilityNoteAccountID
	where ISNULL(tmpLiab.IsDeleted, 0) <> 1
	---where tliabFF.Subline_DebtAccountID is null

	 

 	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
