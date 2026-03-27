-- Procedure
-- Procedure
-- Procedure

CREATE PROCEDURE [DW].[usp_ImportTransactionEntry]
	@BatchLogId int,@LastBatchStart datetime, @CurrentBatchStart datetime
AS
BEGIN
	SET NOCOUNT ON;

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 


	INSERT INTO [DW].BatchDetail (BatchLogId,LandingTableName,LandingStartTime)
	VALUES (@BatchLogId,'L_TransactionEntryBI',GETDATE())

		DECLARE @id int,@RowCount int
	SET @id = (SELECT @@IDENTITY)


	Truncate table [DW].[L_TransactionEntryBI]

	INSERT INTO [DW].[L_TransactionEntryBI]
	(TransactionEntryID,
	NoteID,
	Date ,
	Amount, 
	Type,
	CreatedBy ,
	CreatedDate, 
	UpdatedBy ,
	UpdatedDate ,
	TransactionEntryAutoID,
	AnalysisID,
	AnalysisName,
	FeeName,
	TransactionDateByRule,
	TransactionDateServicingLog,
	RemitDate,
	PaymentDateNotAdjustedforWorkingDay,
	[PurposeType],
	[Cash_NonCash],
	AccountID,
	AccountTypeID,
	AccountTypeBI,
	AllInCouponRate,
	accountingclosedate,
	AdjustmentType,
	IndexDeterminationDate,
	EndingBalance,
	DecodeName,
	Flag,
	ParentAccountId,
	BalloonRepayAmount,
	IndexValue,
	SpreadValue,
	OriginalIndex
		)
	Select
		TransactionEntryID,
		n.NoteID,
		Date ,
		Amount, 
		te.Type,
		te.CreatedBy ,
		te.CreatedDate, 
		te.UpdatedBy ,
		te.UpdatedDate ,
		te.TransactionEntryAutoID,		
		te.AnalysisID,
		an.[Name] as AnalysisName,
		te.FeeName,
		te.TransactionDateByRule,
		te.TransactionDateServicingLog,
		te.RemitDate,
		te.PaymentDateNotAdjustedforWorkingDay,
		te.[PurposeType],
		te.[Cash_NonCash],
		te.AccountID,
		acc.AccountTypeID,
		ac.name as AccountTypeBI,
		te.AllInCouponRate,
		te.accountingclosedate,
		te.AdjustmentType,
		te.IndexDeterminationDate,
		te.EndingBalance,
		te.DecodeName,
		te.Flag,
		te.ParentAccountId,
		te.BalloonRepayAmount,
		te.IndexValue,
		te.SpreadValue,
		te.OriginalIndex
		
		--,		
		--(CASE WHEN EnableM61Calculations = 3 THEN 
		--	(CASE WHEN [Type] = 'FundingOrRepayment' and ISNULL(PurposeType,'') in ('Capitalized Interest','Note Transfer') THEN 'Non-Cash'
		--	WHEN [Type] = 'FundingOrRepayment' and ISNULL(PurposeType,'') not in ('Capitalized Interest','Note Transfer') and amount < 0 THEN 'Funding'
		--	WHEN [Type] = 'FundingOrRepayment' and ISNULL(PurposeType,'') not in ('Capitalized Interest','Note Transfer') and amount > 0 THEN 'Repayment'
		--	ELSE tym.Cash_NonCash END
		--	)
		--ELSE
		--	(CASE WHEN ([Type] = 'FundingOrRepayment' and te.Cash_NonCash is not null) THEN te.Cash_NonCash
		--	WHEN ([Type] = 'FundingOrRepayment' and te.Cash_NonCash is null and amount < 0) THEN 'Funding'
		--	WHEN ([Type] = 'FundingOrRepayment' and te.Cash_NonCash is null and amount > 0) THEN 'Repayment'
		--	ELSE tym.Cash_NonCash END
		--)
		--END
		--) as [Cash_NonCash_BI]

		From cre.TransactionEntry te
		inner join core.account acc on acc.accountid = te.AccountID
		inner join cre.Note n on n.Account_AccountID = acc.AccountID
		left join core.Analysis an on an.AnalysisID = te.AnalysisID
		Left Join core.AccountCategory ac on ac.AccountCategoryID = acc.AccounttypeID
		where acc.isdeleted <> 1
		and TransactionEntryAutoID > (Select ISNULL(MAX(TransactionEntryAutoID),0) from [DW].[TransactionEntryBI])		


	 


SET @RowCount = @@ROWCOUNT
	Print(char(9) +'usp_ImportTransactionEntry - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

	UPDATE [DW].BatchDetail
	SET
	LandingEndTime = GETDATE(),
	LandingRecordCount = @RowCount
	WHERE BatchDetailId = @id

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END
GO