CREATE Procedure [CRE].[usp_UpdateTransactionEntryCash_NonCash]
	@NoteID uniqueidentifier,
	@AnalysisID uniqueidentifier
AS
BEGIN
	SET NOCOUNT ON;
	

	Update cre.transactionentry set  cre.transactionentry.Cash_NonCash = a.Cash_NonCash
	From(
		Select transactionentryID,
		(CASE WHEN n.EnableM61Calculations = 3 THEN 
			(CASE WHEN te.[Type] = 'FundingOrRepayment' and ISNULL(te.PurposeType,'') in ('Capitalized Interest','Note Transfer') THEN 'Non-Cash'
			WHEN te.[Type] = 'FundingOrRepayment' and ISNULL(te.PurposeType,'') not in ('Capitalized Interest','Note Transfer') and te.Amount < 0 THEN 'Funding'
			WHEN te.[Type] = 'FundingOrRepayment' and ISNULL(te.PurposeType,'') not in ('Capitalized Interest','Note Transfer') and te.Amount > 0 THEN 'Repayment'
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
		inner join Cre.Note n on n.NoteID=te.NoteID	
		left join cre.transactiontypes tym on LOWER(tym.TransactionName) = LOWER(te.Type)
		where te.analysisid = @AnalysisID and te.noteid = @NoteID

	)a
	where  cre.transactionentry.transactionentryID = a.transactionentryID

END

