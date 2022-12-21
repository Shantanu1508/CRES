
Create PROCEDURE [dbo].[usp_GetNoteByCRENoteId]   --'2173' ,'245'
(
    @CRENoteId nvarchar(500),
	@ScenarioName nvarchar(500)
)
	
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	Declare @AcctgCloseDate date

	iF EXISTS (Select PeriodID from core.Period where IsDeleted <> 1)
	BEGIN
		SET @AcctgCloseDate = (Select MAX(EndDate) from core.[Period] where isdeleted <> 1)
	END
	ELSE
	BEGIN
		SET @AcctgCloseDate = (Select ClosingDate from cre.note where CRENoteId = @CRENoteId)
	END

   
     		SELECT n.NoteID
					,ac.Name
					,ac.StatusID 
					,ac.BaseCurrencyID
					,ac.StartDate
					,ac.EndDate
					,ac.PayFrequency
					,n.Account_AccountID
					,n.DealID
					,n.CRENoteID
					,n.ClientNoteID
					,n.Comments
					,n.InitialInterestAccrualEndDate
					,n.AccrualFrequency
					,n.DeterminationDateLeadDays
					,n.DeterminationDateReferenceDayoftheMonth
					,n.DeterminationDateInterestAccrualPeriod
					,n.DeterminationDateHolidayList
					,lDeterminationDateLeadDays.Name as DeterminationDateHolidayListText
					,n.FirstPaymentDate
					,n.InitialMonthEndPMTDateBiWeekly
					,n.PaymentDateBusinessDayLag
					,n.IOTerm
					,n.AmortTerm
					,n.PIKSeparateCompounding
					,n.MonthlyDSOverridewhenAmortizing
					,n.AccrualPeriodPaymentDayWhenNotEOMonth
					,n.FirstPeriodInterestPaymentOverride
					,n.FirstPeriodPrincipalPaymentOverride
					,n.FinalInterestAccrualEndDateOverride
					,n.AmortType
					,n.RateType
					,l.Name 'RateTypeText' 
					,n.ReAmortizeMonthly
					,n.ReAmortizeatPMTReset
					,n.StubPaidInArrears
					,n.RelativePaymentMonth
					,n.SettleWithAccrualFlag
					,n.InterestDueAtMaturity
					,n.RateIndexResetFreq
					,n.FirstRateIndexResetDate
					,n.LoanPurchase
					,n.AmortIntCalcDayCount
					,n.StubPaidinAdvanceYN
					,n.FullPeriodInterestDueatMaturity
					,n.ProspectiveAccountingMode
					,n.IsCapitalized
					,n.SelectedMaturityDateScenario
					,n.SelectedMaturityDate
					,n.InitialMaturityDate
					,n.ExpectedMaturityDate
					,n.FullyExtendedMaturityDate
					,n.OpenPrepaymentDate
					,n.CashflowEngineID
					,n.LoanType
					,n.Classification
					,n.SubClassification
					,n.GAAPDesignation
					,n.PortfolioID
					,n.GeographicLocation
					,n.PropertyType
					,n.RatingAgency
					,n.RiskRating
					,n.PurchasePrice
					,n.FutureFeesUsedforLevelYeild
					,n.TotalToBeAmortized
					,n.StubPeriodInterest
					,n.WDPAssetMultiple
					,n.WDPEquityMultiple
					,n.PurchaseBalance
					,n.DaysofAccrued
					,n.InterestRate
					,n.PurchasedInterestCalc
					,n.ModelFinancingDrawsForFutureFundings
					,n.NumberOfBusinessDaysLagForFinancingDraw
					,n.FinancingFacilityID
					,n.FinancingInitialMaturityDate
					,n.FinancingExtendedMaturityDate
					,n.FinancingPayFrequency
					,n.FinancingInterestPaymentDay
					,n.ClosingDate
					,n.InitialFundingAmount
					,n.Discount
					,n.OriginationFee
					,n.CapitalizedClosingCosts
					,n.PurchaseDate
					,n.PurchaseAccruedFromDate
					,n.PurchasedInterestOverride
					,n.DiscountRate
					,n.ValuationDate
					,n.FairValue
					,n.TaxAmortCheck
					,n.PIKWoCompCheck
					,n.DiscountRatePlus
					,n.FairValuePlus
					,n.DiscountRateMinus
					,n.FairValueMinus
					,n.InitialIndexValueOverride
					,n.IncludeServicingPaymentOverrideinLevelYield
					,n.OngoingAnnualizedServicingFee
					,n.IndexRoundingRule
					,n.RoundingMethod
					,lRoundingMethod.Name as RoundingMethodText
					,n.StubInterestPaidonFutureAdvances
					,n.CreatedBy
					,n.CreatedDate
					,n.UpdatedBy
					,n.UpdatedDate
					,n.StubIntOverride 
					,n.PurchasedIntOverride
					,n.ExitFeeFreePrepayAmt 
					,n.ExitFeeBaseAmountOverride 
					,n.ExitFeeAmortCheck				  
					,lBaseCurrency.Name AS LoanCurrency
					,lIncludeServicingPaymentOverrideinLevelYield.Name AS IncludeServicingPaymentOverrideinLevelYieldText
					,lPIKSeparateCompounding.Name AS PIKSeparateCompoundingText
					,lStubPaidinAdvanceYN.Name AS StubPaidinAdvanceYNText
					,lModelFinancingDrawsForFutureFundings.Name AS ModelFinancingDrawsForFutureFundingsText
					,lExitFeeAmortCheck.Name AS ExitFeeAmortCheckText 
					,n.FixedAmortScheduleCheck AS FixedAmortSchedule
					,lFixedAmortScheduleCheck.Name AS FixedAmortScheduleText
					,lLoanPurchase.Name as LoanPurchaseText
					,d.DealName
					,d.CREDealID
					,n.NoofdaysrelPaymentDaterollnextpaymentcycle
					,n.[UseIndexOverrides]
					,n.IndexNameID
					,lIndex.Name 'IndexNameText'
					,n.ServicerID
					,n.TotalCommitment
					,n.ClientName
					,n.Portfolio
					,n.Tag1
					,n.Tag2
					,n.Tag3
					,n.Tag4
					--,n.ExtendedMaturityScenario1
					--,n.ExtendedMaturityScenario2
					--,n.ExtendedMaturityScenario3
					,n.ActualPayoffDate				 
					,n.UnusedFeeThresholdBalance 
					,n.UnusedFeePaymentFrequency
					,@ScenarioName as  DefaultScenario
					,lSelectedMaturityDateScenario.Name as SelectedMaturityDateScenarioText
					,n.TotalCommitmentExtensionFeeisBasedOn,
					n.FullyExtendedMaturityDate,
					n.OpenPrepaymentDate,
					n.UnusedFeeThresholdBalance,
					n.UnusedFeePaymentFrequency	,				   		  
					n.InterestCalculationRuleForPaydowns,
					paydown.Name as InterestCalculationRuleForPaydownsText,
					pik.Name as PIKInterestAddedToBalanceBasedOnBusinessAdjustedDateText,
					n.PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate,
					n.BusinessdaylafrelativetoPMTDate,
					n.DayoftheMonth ,
					StubOnFF.name as StubInterestPaidonFutureAdvancesText
				  ,(select l.Name  from Core.AnalysisParameter ap left join Core.Lookup l ON ap.MaturityScenarioOverrideID=l.LookupID  where AnalysisID  in (select AnalysisID from Core.Analysis where Name =@ScenarioName)) as MaturityScenarioOverrideText

				,UseRuletoDetermineNoteFunding
			   ,lUseRuletoDetermineNoteFunding.Name as  UseRuletoDetermineNoteFundingText
			   ,n.Servicer
			   ,lServicer.Name as  ServicerText
			   ,lFullInterestAtPPayoff.Name as FullInterestAtPPayoffText 
			   ,n.FullInterestAtPPayoff 
			   ,@AcctgCloseDate as AcctgCloseDate
			   ,paydownamort.Name as InterestCalculationRuleForPaydownsAmortText			  
				
			
				,n.RoundingNote
				,lRoundingNote.name as RoundingNoteText
				,n.StraightLineAmortOverride
				,n.NoteTransferDate
				,n.ImpactCommitmentCalc

			  FROM CRE.Note n
			  INNER JOIN core.Account ac ON ac.AccountID = n.Account_AccountID
			  left join Core.Lookup l ON n.RateType=l.LookupID
			  left join Core.Lookup lIndex ON n.IndexNameID=lIndex.LookupID
			  left join Core.Lookup lBaseCurrency ON ac.BaseCurrencyID=lBaseCurrency.LookupID
              left join Core.Lookup lIncludeServicingPaymentOverrideinLevelYield ON n.IncludeServicingPaymentOverrideinLevelYield =lIncludeServicingPaymentOverrideinLevelYield.LookupID
			  left join Core.Lookup lPIKSeparateCompounding ON n.PIKSeparateCompounding=lPIKSeparateCompounding.LookupID
			  left join Core.Lookup lStubPaidinAdvanceYN ON n.StubPaidinAdvanceYN=lStubPaidinAdvanceYN.LookupID 
	          left join Core.Lookup lModelFinancingDrawsForFutureFundings ON n.ModelFinancingDrawsForFutureFundings=lModelFinancingDrawsForFutureFundings.LookupID
		      left join Core.Lookup lExitFeeAmortCheck ON n.ExitFeeAmortCheck=lExitFeeAmortCheck.LookupID
		      left join Core.Lookup lFixedAmortScheduleCheck ON n.FixedAmortScheduleCheck=lFixedAmortScheduleCheck.LookupID
			  left join Core.Lookup lLoanPurchase ON n.LoanPurchase=lLoanPurchase.LookupID
			  left join Core.Lookup lDeterminationDateLeadDays ON n.DeterminationDateHolidayList=lDeterminationDateLeadDays.LookupID			
			  left join Core.Lookup lRoundingMethod ON n.RoundingMethod=lRoundingMethod.LookupID			  
		      left join Core.Lookup lServicer ON n.Servicer=lServicer.LookupID
			  left join Core.Lookup lFullInterestAtPPayoff  ON n.FullInterestAtPPayoff=lFullInterestAtPPayoff.LookupID
			  left join Core.Lookup pik  ON n.PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate=pik.LookupID	
			  left join Core.Lookup paydown  ON n.InterestCalculationRuleForPaydowns=paydown.LookupID					  	  		   
			  left join Core.Lookup StubOnFF  ON n.StubInterestPaidonFutureAdvances=StubOnFF.LookupID						   
		      left join CRE.Deal d on d.DealID = n.DealID
			  left join Core.Lookup lSelectedMaturityDateScenario on n.SelectedMaturityDateScenario =lSelectedMaturityDateScenario.LookupID
			  left join Core.Lookup lUseRuletoDetermineNoteFunding ON n.UseRuletoDetermineNoteFunding=lUseRuletoDetermineNoteFunding.LookupID
			  left join Core.Lookup paydownamort  ON n.InterestCalculationRuleForPaydownsAmort=paydownamort.LookupID	
			  left join Core.Lookup lRoundingNote  ON n.RoundingNote=lRoundingNote.LookupID	
			  WHERE CRENoteID = @CRENoteId and ac.IsDeleted = 0

			  
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END

