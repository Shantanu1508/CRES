
CREATE PROCEDURE [DW].[usp_ImportFeeBaseAmountDetermination]
	
AS
BEGIN
	SET NOCOUNT ON;

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
	DECLARE @RowCount int


	Truncate table [DW].[FeeBaseAmountDeterminationBI]
	

	INSERT INTO [DW].[FeeBaseAmountDeterminationBI]
			   ([FeeTypeName]
			   ,[FeePaymentFrequency]
			   ,[FeeCoveragePeriod]
			   ,[FeeFunction]
			   ,[TotalCommitment]
			   ,[UnscheduledPaydowns]
			   ,[BalloonPayment]
			   ,[LoanFundings]
			   ,[ScheduledPrincipalAmortizationPayment]
			   ,[CurrentLoanBalance]
			   ,[InterestPayment]
			   ,[FeeNameTrans])
	Select	
	FS.FeeTypeNameText,
	LFeePaymentFrequencyID.Name as FeePaymentFrequencyText,
	LFeeCoveragePeriodID.Name as FeeCoveragePeriodText,
	FF.FunctionNameText as FeeFunctionText,
	LTotalCommitmentID.Name as TotalCommitmentText,
	LUnscheduledPaydownsID.Name as UnscheduledPaydownsText,
	LBalloonPaymentID.Name as BalloonPaymentText,
	LLoanFundingsID.Name as LoanFundingsText,
	LScheduledPrincipalAmortizationPaymentID.Name as ScheduledPrincipalAmortizationPaymentText,
	LCurrentLoanBalanceID.Name as CurrentLoanBalanceText,
	LInterestPaymentID.Name as InterestPaymentText,
	LFeeNameTransID.Name FeeNameTransText

	from [CRE].[FeeSchedulesConfig] FS
	LEFT JOIN [CORE].[Lookup] LFeePaymentFrequencyID ON LFeePaymentFrequencyID.LookupID = FS.FeePaymentFrequencyID AND LFeePaymentFrequencyID.ParentID=89 
	LEFT JOIN [CORE].[Lookup] LFeeCoveragePeriodID ON LFeeCoveragePeriodID.LookupID = FS.FeeCoveragePeriodID AND LFeeCoveragePeriodID.ParentID=90
	LEFT JOIN [CRE].[FeeFunctionsConfig] FF ON FF.FunctionNameID = FS.FeeFunctionID
	LEFT JOIN [CORE].[Lookup] LTotalCommitmentID ON LTotalCommitmentID.LookupID = FS.TotalCommitmentID AND LTotalCommitmentID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LUnscheduledPaydownsID ON LUnscheduledPaydownsID.LookupID = FS.UnscheduledPaydownsID AND LUnscheduledPaydownsID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LBalloonPaymentID ON LBalloonPaymentID.LookupID = FS.BalloonPaymentID AND LBalloonPaymentID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LLoanFundingsID ON LLoanFundingsID.LookupID = FS.LoanFundingsID AND LLoanFundingsID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LScheduledPrincipalAmortizationPaymentID ON LScheduledPrincipalAmortizationPaymentID.LookupID = FS.ScheduledPrincipalAmortizationPaymentID AND LScheduledPrincipalAmortizationPaymentID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LCurrentLoanBalanceID ON LCurrentLoanBalanceID.LookupID = FS.CurrentLoanBalanceID AND LCurrentLoanBalanceID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LInterestPaymentID ON LInterestPaymentID.LookupID = FS.InterestPaymentID AND LInterestPaymentID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LFeeNameTransID ON LFeeNameTransID.LookupID = FS.FeeNameTransID AND LFeeNameTransID.ParentID=94



	SET @RowCount = @@ROWCOUNT
	Print(char(9) +'usp_ImportFeeBaseAmountDetermination - ROWCOUNT = '+cast(@RowCount  as varchar(100)));

	

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END


