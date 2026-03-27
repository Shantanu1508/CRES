
CREATE Procedure [CRE].[usp_UpdateTransactionEntryCash_NonCash] 
	@NoteID uniqueidentifier,  
	@AnalysisID uniqueidentifier  ,
	@accountingclosedate date = null,
	@MaturityUsedInCalc Date = null
AS  
BEGIN  
 SET NOCOUNT ON;  
   
  


IF(CAST(@accountingclosedate as date) <= CAST('1/1/1980' as date))
BEGIN
	SET @accountingclosedate = null
END


Declare @AccountID uniqueidentifier = (Select top 1 account_accountid from cre.note where noteid =@NoteID)


IF(@accountingclosedate IS NOT NULL)
BEGIN
	PRINT('Is not null')
	Update cre.transactionentry set  cre.transactionentry.Cash_NonCash = a.Cash_NonCash  
	From(  
		Select transactionentryID,  
		(CASE WHEN n.EnableM61Calculations = 3 THEN   
		(CASE WHEN te.[Type] = 'FundingOrRepayment' and ISNULL(te.PurposeType,'') in ('Capitalized Interest') THEN 'Non-Cash'  
		WHEN te.[Type] = 'FundingOrRepayment' and ISNULL(te.PurposeType,'') in ('Capital Expenditure','TI/LC','Opex','Force Funding','Amortization','Full Payoff','Property Release','Paydown','Additional Collateral Purchase','Other','Note Transfer','Debt Service/Opex') THEN 'Cash'  
		WHEN te.[Type] = 'FundingOrRepayment' and te.Amount < 0 THEN null   ---'Funding'   ----and ISNULL(te.PurposeType,'') not in ('Capitalized Interest','Note Transfer')   
		WHEN te.[Type] = 'FundingOrRepayment' and te.Amount > 0 THEN null  ----'Repayment'   ----and ISNULL(te.PurposeType,'') not in ('Capitalized Interest','Note Transfer')   
		ELSE tym.Cash_NonCash END  
		)  
		ELSE  
		(CASE WHEN (te.[Type] = 'FundingOrRepayment' and te.Cash_NonCash is not null) THEN te.Cash_NonCash  
		WHEN (te.[Type] = 'FundingOrRepayment' and te.Cash_NonCash is null and te.Amount < 0) THEN 'Funding'  
		WHEN (te.[Type] = 'FundingOrRepayment' and te.Cash_NonCash is null and te.Amount > 0) THEN 'Repayment'  
		ELSE tym.Cash_NonCash END  
		)  
		END  
		) as Cash_NonCash  
  
		FROM cre.transactionentry  te  
		 Inner join core.account acc on acc.accountid = te.AccountID
         Inner join cre.note n on n.account_accountid = acc.accountid

		--inner join Cre.Note n on n.NoteID=te.NoteID   
		left join cre.transactiontypes tym on LOWER(tym.TransactionName) = LOWER(te.Type)  
		where te.analysisid = @AnalysisID and n.noteid = @NoteID  
		and te.date > @accountingclosedate
		 and acc.AccounttypeID = 1
  
	)a  
	where  cre.transactionentry.transactionentryID = a.transactionentryID  
  
END
ELSE
BEGIN
	PRINT('null')
	Update cre.transactionentry set  cre.transactionentry.Cash_NonCash = a.Cash_NonCash  
	From(  
		Select transactionentryID,  
		(CASE WHEN n.EnableM61Calculations = 3 THEN   
		(CASE WHEN te.[Type] = 'FundingOrRepayment' and ISNULL(te.PurposeType,'') in ('Capitalized Interest') THEN 'Non-Cash'  
		WHEN te.[Type] = 'FundingOrRepayment' and ISNULL(te.PurposeType,'') in ('Capital Expenditure','TI/LC','Opex','Force Funding','Amortization','Full Payoff','Property Release','Paydown','Additional Collateral Purchase','Other','Note Transfer','Debt Service/Opex') THEN 'Cash'  
		WHEN te.[Type] = 'FundingOrRepayment' and te.Amount < 0 THEN null   ---'Funding'   ----and ISNULL(te.PurposeType,'') not in ('Capitalized Interest','Note Transfer')   
		WHEN te.[Type] = 'FundingOrRepayment' and te.Amount > 0 THEN null  ----'Repayment'   ----and ISNULL(te.PurposeType,'') not in ('Capitalized Interest','Note Transfer')   
		ELSE tym.Cash_NonCash END  
		)  
		ELSE  
		(CASE WHEN (te.[Type] = 'FundingOrRepayment' and te.Cash_NonCash is not null) THEN te.Cash_NonCash  
		WHEN (te.[Type] = 'FundingOrRepayment' and te.Cash_NonCash is null and te.Amount < 0) THEN 'Funding'  
		WHEN (te.[Type] = 'FundingOrRepayment' and te.Cash_NonCash is null and te.Amount > 0) THEN 'Repayment'  
		ELSE tym.Cash_NonCash END  
		)  
		END  
		) as Cash_NonCash  
  
		FROM cre.transactionentry  te  
		 Inner join core.account acc on acc.accountid = te.AccountID
         Inner join cre.note n on n.account_accountid = acc.accountid
		left join cre.transactiontypes tym on LOWER(tym.TransactionName) = LOWER(te.Type)  
		where te.analysisid = @AnalysisID and n.noteid = @NoteID  
		---and te.date > @accountingclosedate
  
	)a  
	where  cre.transactionentry.transactionentryID = a.transactionentryID  
END

  ----exec [CRE].[usp_UpdateTransactionEntryAllInCouponRate]   @NoteID,@AnalysisID
  exec [dbo].[usp_DeleteDuplicateTransaction_v1] @NoteID,@AnalysisID

  exec [CRE].[usp_UpdateTransactionEntryDecode] @NoteID,@AnalysisID

  exec [CRE].[usp_UpdateTransactionEntry_BalloonRepayAmount] @NoteID,@AnalysisID

  exec [dbo].[usp_UpdateTransactionEntry_ReferenceRateNote] @NoteID,@AnalysisID


  -----exec [CRE].[usp_UpdateNoteCalculatedWeightedSpread] @NoteID  ----called inside caclulator

	IF (@MaturityUsedInCalc is not null)
	BEGIN
		

		Update cre.transactionEntry set [Date] = @MaturityUsedInCalc  
		From(
			Select TransactionEntryAutoID from cre.transactionEntry where AccountID = @AccountID and AnalysisID = @AnalysisID  and [Date] > @MaturityUsedInCalc and [Type] <> 'ManagementFee'
		)a
		where cre.transactionEntry.TransactionEntryAutoID = a.TransactionEntryAutoID


		Update cre.transactionEntry set TransactionDateByRule = @MaturityUsedInCalc
		From(
			Select TransactionEntryAutoID from cre.transactionEntry where AccountID = @AccountID and AnalysisID = @AnalysisID  and TransactionDateByRule > @MaturityUsedInCalc and [Type] <> 'ManagementFee'
		)a
		where cre.transactionEntry.TransactionEntryAutoID = a.TransactionEntryAutoID
	END



END
GO

