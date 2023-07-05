CREATE Procedure [dbo].[usp_GetFeeFunctionsConfig]
@UserID NVarchar(255)
AS

BEGIN
	SET NOCOUNT ON;
	Select
	FF.FunctionNameID,
	FF.FunctionGuID,
	FF.FunctionNameText,
	LFunctionTypeID.Name as FunctionTypeText,
	LFunctionTypeID.LookupID as FunctionTypeID,
	LPaymentFrequencyID.Name as PaymentFrequencyText,
	LPaymentFrequencyID.LookupID as PaymentFrequencyID,
	LAccrualBasisID.Name as AccrualBasisText, 
	LAccrualBasisID.LookupID as AccrualBasisID,
	LAccrualStartDateID.Name as AccrualStartDateText, 
	LAccrualStartDateID.LookupID as AccrualStartDateID,
	LAccrualPeriodID.Name as AccrualPeriodText,
	LAccrualPeriodID.LookupID as AccrualPeriodID,
	FF.FunctionNameID as LookupID,
	FF.FunctionNameText as [Name],
	IsUsedInFeeSchedule = Case when exists(select 1 from [CRE].[FeeSchedulesConfig] where FeeFunctionID=FF.FunctionNameID) then 1 else 0 end	
	from [CRE].[FeeFunctionsConfig] FF
	LEFT JOIN [CORE].[Lookup] LFunctionTypeID ON LFunctionTypeID.LookupID = FF.FunctionTypeID AND LFunctionTypeID.ParentID=84 
	LEFT JOIN [CORE].[Lookup] LPaymentFrequencyID ON LPaymentFrequencyID.LookupID = FF.PaymentFrequencyID AND LPaymentFrequencyID.ParentID=85
	LEFT JOIN [CORE].[Lookup] LAccrualBasisID ON LAccrualBasisID.LookupID = FF.AccrualBasisID AND LAccrualBasisID.ParentID=86
	LEFT JOIN [CORE].[Lookup] LAccrualStartDateID ON LAccrualStartDateID.LookupID = FF.AccrualStartDateID AND LAccrualStartDateID.ParentID=87
	LEFT JOIN [CORE].[Lookup] LAccrualPeriodID ON LAccrualPeriodID.LookupID = FF.AccrualPeriodID AND LAccrualPeriodID.ParentID=88
END
