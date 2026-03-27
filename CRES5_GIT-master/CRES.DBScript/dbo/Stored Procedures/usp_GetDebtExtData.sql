CREATE PROCEDURE [dbo].[usp_GetDebtExtData] 
	@DebtAccountID UNIQUEIDENTIFIER, 
	@AdditionalAccountID UNIQUEIDENTIFIER
AS
BEGIN

Select
		DebtExtID,
		DebtAccountID,
		AdditionalAccountID,
		PaymentFrequency,	 
		AccrualEndDateBusinessDayLag,
		AccrualFrequency, 
		Roundingmethod,            
		IndexRoundingRule,          
		FinanacingSpreadRate,       
		IntActMethod,               
		DefaultIndexName,           
		TargetAdvanceRate, 
		pmtdtaccper  ,
        ResetIndexDaily  ,
		DeterminationDateHolidayList
		FROM [CRE].[DebtExt]
		Where DebtAccountID=@DebtAccountID and AdditionalAccountID = @AdditionalAccountID

END