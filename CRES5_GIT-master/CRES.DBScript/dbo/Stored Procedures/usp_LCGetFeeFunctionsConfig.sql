
CREATE PROCEDURE [dbo].[usp_LCGetFeeFunctionsConfig] 
	
AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF;
   
   select 
	FF.FunctionNameText,
	LFunctionTypeID.Name as FunctionTypeText,	 
	LPaymentFrequencyID.Name as PaymentFrequencyText, 
	LAccrualBasisID.Name as AccrualBasisText,  
	LAccrualStartDateID.Name as AccrualStartDateText,  
	LAccrualPeriodID.Name as AccrualPeriodText

	from [CRE].[FeeFunctionsConfig] FF
	LEFT JOIN [CORE].[Lookup] LFunctionTypeID ON LFunctionTypeID.LookupID = FF.FunctionTypeID AND LFunctionTypeID.ParentID=84 
	LEFT JOIN [CORE].[Lookup] LPaymentFrequencyID ON LPaymentFrequencyID.LookupID = FF.PaymentFrequencyID AND LPaymentFrequencyID.ParentID=85
	LEFT JOIN [CORE].[Lookup] LAccrualBasisID ON LAccrualBasisID.LookupID = FF.AccrualBasisID AND LAccrualBasisID.ParentID=86
	LEFT JOIN [CORE].[Lookup] LAccrualStartDateID ON LAccrualStartDateID.LookupID = FF.AccrualStartDateID AND LAccrualStartDateID.ParentID=87
	LEFT JOIN [CORE].[Lookup] LAccrualPeriodID ON LAccrualPeriodID.LookupID = FF.AccrualPeriodID AND LAccrualPeriodID.ParentID=88
 

END
