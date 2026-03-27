CREATE Procedure [dbo].[usp_GetFeeSchedulesConfigLiability]
@UserID NVarchar(255)

AS

BEGIN

	SET NOCOUNT ON;

	Select	
	FS.FeeTypeNameText,
	FS.FeeTypeNameID,
	FS.FeeTypeGuID,
	FS.FeePaymentFrequencyID,
	FS.FeeCoveragePeriodID,
	FS.FeeFunctionID,
	FS.TotalCommitmentID,
	FS.UnscheduledPaydownsID,
	FS.BalloonPaymentID,
	FS.LoanFundingsID,
	FS.ScheduledPrincipalAmortizationPaymentID,
	FS.CurrentLoanBalanceID,
	FS.InterestPaymentID,
	FS.FeeNameTransID,

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

	FF.FunctionNameID as LookupID,
	FF.FunctionNameText as [Name],
	IsUsedInCalc = Case when exists(select 1 from [CORE].PrepayAndAdditionalFeeScheduleLiability where ValueTypeID=FS.FeeTypeNameID) then 1 else 0 end,
	LFeeNameTransID.Name FeeNameTransText,

	ISNULL(ExcludeFromCashflowDownload,0) as ExcludeFromCashflowDownload,
	FS.FeeTypeNameText+ ' '+'Strip' as NameText,
	FS.FeeTypeNameID as ID,

	FS.InitialFundingID,
	LInitialFundingID.name as InitialFundingText,
	FS.M61AdjustedCommitmentID,
	LM61AdjustedCommitmentID.name as M61AdjustedCommitmentText,
	FS.PIKFundingID,
	LPIKFundingID.name as PIKFundingText,
	FS.PIKPrincipalPaymentID,
	LPIKPrincipalPaymentID.name as PIKPrincipalPaymentText,
	FS.CurtailmentID,
	LCurtailmentID.name as CurtailmentText,
	FS.UpsizeAmountID,
	LUpsizeAmountID.name as UpsizeAmountText,
	FS.UnfundedCommitmentID,
	LUnfundedCommitmentID.name as UnfundedCommitmentText

	from [CRE].[FeeSchedulesConfigLiability] FS
	LEFT JOIN [CORE].[Lookup] LFeePaymentFrequencyID ON LFeePaymentFrequencyID.LookupID = FS.FeePaymentFrequencyID AND LFeePaymentFrequencyID.ParentID=89 
	LEFT JOIN [CORE].[Lookup] LFeeCoveragePeriodID ON LFeeCoveragePeriodID.LookupID = FS.FeeCoveragePeriodID AND LFeeCoveragePeriodID.ParentID=90
	LEFT JOIN [CRE].[FeeFunctionsConfigLiability] FF ON FF.FunctionNameID = FS.FeeFunctionID
	LEFT JOIN [CORE].[Lookup] LTotalCommitmentID ON LTotalCommitmentID.LookupID = FS.TotalCommitmentID AND LTotalCommitmentID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LUnscheduledPaydownsID ON LUnscheduledPaydownsID.LookupID = FS.UnscheduledPaydownsID AND LUnscheduledPaydownsID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LBalloonPaymentID ON LBalloonPaymentID.LookupID = FS.BalloonPaymentID AND LBalloonPaymentID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LLoanFundingsID ON LLoanFundingsID.LookupID = FS.LoanFundingsID AND LLoanFundingsID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LScheduledPrincipalAmortizationPaymentID ON LScheduledPrincipalAmortizationPaymentID.LookupID = FS.ScheduledPrincipalAmortizationPaymentID AND LScheduledPrincipalAmortizationPaymentID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LCurrentLoanBalanceID ON LCurrentLoanBalanceID.LookupID = FS.CurrentLoanBalanceID AND LCurrentLoanBalanceID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LInterestPaymentID ON LInterestPaymentID.LookupID = FS.InterestPaymentID AND LInterestPaymentID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LFeeNameTransID ON LFeeNameTransID.LookupID = FS.FeeNameTransID AND LFeeNameTransID.ParentID=94
	LEFT JOIN [CORE].[Lookup] LInitialFundingID ON LInitialFundingID.LookupID = FS.InitialFundingID AND LInitialFundingID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LM61AdjustedCommitmentID ON LM61AdjustedCommitmentID.LookupID = FS.M61AdjustedCommitmentID AND LM61AdjustedCommitmentID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LPIKFundingID ON LPIKFundingID.LookupID = FS.PIKFundingID AND LPIKFundingID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LPIKPrincipalPaymentID ON LPIKPrincipalPaymentID.LookupID = FS.PIKPrincipalPaymentID AND LPIKPrincipalPaymentID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LCurtailmentID ON LCurtailmentID.LookupID = FS.CurtailmentID AND LCurtailmentID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LUpsizeAmountID ON LUpsizeAmountID.LookupID = FS.UpsizeAmountID AND LUpsizeAmountID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LUnfundedCommitmentID ON LUnfundedCommitmentID.LookupID = FS.UnfundedCommitmentID AND LUnfundedCommitmentID.ParentID=91
	
	where ISNULL(IsActive,1)  = 1
	order by FS.FeeTypeNameText
END

