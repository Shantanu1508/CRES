
------------------------------------------------------------
-- Author:		<NewCon Infosystem>
-- Create date: <11/05/2012>
------------------------------------------------------------
CREATE PROCEDURE [dbo].[usp_GetNoteRecordSet]	 
 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
      
select   
		de.ClientDealID as CreDealID	,
		CRENoteID	,
		ac.name	,
		ClosingDate	,
		BaseCurrencyID	,
		IsCapitalized	,
		LoanType	,
		PayFrequency	,
		InitialMaturityDate	,
		FullyExtendedMaturityDate	,
		ExpectedMaturityDate	,
		OpenPrepaymentDate	,

		tblExtendedMat.ExtendedMaturityScenario1 as ExtendedMaturityScenario1	,
		tblExtendedMat.ExtendedMaturityScenario2 as ExtendedMaturityScenario2	,
		tblExtendedMat.ExtendedMaturityScenario3 as ExtendedMaturityScenario3	,

		ActualPayoffDate	,
		InitialInterestAccrualEndDate	,
		AccrualFrequency	,
		DeterminationDateLeadDays	,
		DeterminationDateReferenceDayoftheMonth	,
		DeterminationDateInterestAccrualPeriod	,
		FirstPaymentDate	,
		InitialMonthEndPMTDateBiWeekly	,
		PaymentDateBusinessDayLag	,
		IOTerm	,
		AmortTerm	,
		PIKSeparateCompounding	,
		MonthlyDSOverridewhenAmortizing	,
		AccrualPeriodPaymentDayWhenNotEOMonth	,
		FirstPeriodInterestPaymentOverride	,
		FirstPeriodPrincipalPaymentOverride	,
		FinalInterestAccrualEndDateOverride	,
		AmortType	,
		RateType	,
		ReAmortizeMonthly	,
		ReAmortizeatPMTReset	,
		StubPaidInArrears	,
		SettleWithAccrualFlag	,
		RateIndexResetFreq	,
		FirstRateIndexResetDate	,
		LoanPurchase	,
		AmortIntCalcDayCount	,
		StubPaidinAdvanceYN	,
		FullPeriodInterestDueatMaturity	,
		Classification	,
		SubClassification	,
		GAAPDesignation	,
		PortfolioID	,
		GeographicLocation	,
		PropertyType	,
		RatingAgency	,
		RiskRating	,
		PurchasePrice	,
		FutureFeesUsedforLevelYeild	,
		TotalToBeAmortized	,
		StubPeriodInterest	,
		WDPAssetMultiple	,
		WDPEquityMultiple	,
		PurchaseBalance	,
		DaysofAccrued	,
		InterestRate	,
		PurchasedInterestCalc	,
		InitialFundingAmount	,
		Discount	,
		OriginationFee	,
		CapitalizedClosingCosts	,
		PurchaseDate	,
		PurchaseAccruedFromDate	,
		PurchasedInterestOverride	,
		DiscountRate	,
		ValuationDate	,
		FairValue	,
		DiscountRatePlus	,
		FairValuePlus	,
		DiscountRateMinus	,
		FairValueMinus	,
		InitialIndexValueOverride	,
		IncludeServicingPaymentOverrideinLevelYield	,
		OngoingAnnualizedServicingFee	,
		IndexRoundingRule	,
		RoundingMethod	,
		StubInterestPaidonFutureAdvances	,
		TaxAmortCheck	,
		PIKWoCompCheck	,
		GAAPAmortCheck	,
		StubIntOverride	,
		ExitFeeFreePrepayAmt	,
		ExitFeeBaseAmountOverride,
		ExitFeeAmortCheck	,
		FixedAmortScheduleCheck	,
		TotalCommitmentExtensionFeeisBasedOn	,
		[priority],
		note.TotalCommitment,
		IndexNameID,
		note.UpdatedBy	,
		BillingNotesID,
		BusinessdaylafrelativetoPMTDate,
		DayoftheMonth,
		RepaymentDayoftheMonth,
		InterestCalculationRuleForPaydowns,
		InterestCalculationRuleForPaydownsAmort,
		DebtTypeID, 
		CapStack,
		ServicerNameID

		 

from  CRE.Note note
inner join Core.Account ac on ac.AccountID = note.Account_AccountID
inner join CRE.Deal de  on de.dealid = note.dealid

left join(
	Select noteid,ExtendedMaturityScenario1,ExtendedMaturityScenario2,ExtendedMaturityScenario3,ExtendedMaturityScenario4,ExtendedMaturityScenario5,ExtendedMaturityScenario6,ExtendedMaturityScenario7,ExtendedMaturityScenario8,ExtendedMaturityScenario9,ExtendedMaturityScenario10
	From(
		Select  n.noteid,
		'ExtendedMaturityScenario' + CAST(ROW_NUMBER() Over(Partition BY Noteid order by noteid,MaturityDate) as nvarchar(256))  as MaturityType
		,mat.MaturityDate			
		from [CORE].Maturity mat  
		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
		INNER JOIN   
		(          
			Select   
			(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
			MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
			where EventTypeID = 11  and eve.StatusID = 1
			and acc.IsDeleted = 0  				
			GROUP BY n.Account_AccountID,EventTypeID    
		) sEvent    
		ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  and e.StatusID = 1
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 	
		where mat.MaturityType in (709)
		--and n.crenoteid = '2230'

	) AS SourceTable  
	PIVOT  
	(  
		MIN(MaturityDate)  
		FOR MaturityType IN (ExtendedMaturityScenario1,ExtendedMaturityScenario2,ExtendedMaturityScenario3,ExtendedMaturityScenario4,ExtendedMaturityScenario5,ExtendedMaturityScenario6,ExtendedMaturityScenario7,ExtendedMaturityScenario8,ExtendedMaturityScenario9,ExtendedMaturityScenario10)  
	) AS PivotTable

)tblExtendedMat on tblExtendedMat.noteid = note.noteid

where 1<>1



 
END


