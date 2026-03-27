
CREATE PROCEDURE [DW].[usp_ImportTransactionEntryPivot]	
AS
BEGIN
	SET NOCOUNT ON;

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
	DECLARE @RowCount int


	---Truncate table [DW].[TransactionEntryPivotBI]

	Delete from [DW].[TransactionEntryPivotBI] where noteid in (Select Distinct NoteID from [DW].[L_TransactionEntryBI])
	 

	INSERT INTO [DW].[TransactionEntryPivotBI]
           ([NoteID]
           ,[AnalysisName]
           ,[Crenoteid]
           ,[Date]
           ,[FeeName]
           ,[ScheduledPrincipalPaid]
           ,[ExitFeeExcludedFromLevelYield]
           ,[Balloon]
           ,[Funding]
           ,[Repayment])

	Select NoteID,AnalysisName,Crenoteid,Date,FeeName,
	ScheduledPrincipalPaid,ExitFeeExcludedFromLevelYield,Balloon,Funding,Repayment
	From(
		Select 
	
		n.NoteID	
		,tr.AnalysisID
		,n.Crenoteid
		,tr.Date	
		,tr.Amount	
		,(CASE 
			WHEN tr.Type = 'FundingOrRepayment' and tr.Amount > 0 THEN 'Repayment' 
			WHEN tr.Type = 'FundingOrRepayment' and tr.Amount <= 0 THEN 'Funding'
			ELSE tr.Type
			END
		) as [Type]
		,tr.FeeName
		,an.Name as AnalysisName
		from cre.transactionentry tr
		Inner join core.account acc on acc.accountid = tr.AccountID
       Inner join cre.note n on n.account_accountid = acc.accountid
		--inner join cre.note n on n.noteid = tr.noteid
		inner join core.analysis an on an.AnalysisID = tr.AnalysisID

		inner join(
			Select Distinct NoteID from [DW].[L_TransactionEntryBI]
		)ltr on ltr.noteid = n.noteid

		where tr.[type] in ('ScheduledPrincipalPaid','ExitFeeExcludedFromLevelYield','Balloon','FundingOrRepayment')	

		

	)AS SourceTable 
	PIVOT  
	(  
		SUM(Amount)  
		FOR [Type] IN (ScheduledPrincipalPaid,ExitFeeExcludedFromLevelYield,Balloon,Funding,Repayment)  

	) AS PivotTable


	SET @RowCount = @@ROWCOUNT
	Print(char(9) +'usp_ImportTransactionEntryPivot - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

	

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END


