

CREATE PROCEDURE [dbo].[usp_AddUpdateNoteFromCalculatorService]
(
@UserID [uniqueidentifier],
@NoteID	[uniqueidentifier],
@Account_AccountID	[uniqueidentifier],
@DealID	[uniqueidentifier],
@CRENoteID	[nvarchar](256),
@ClientNoteID	[nvarchar](256),
@Comments	[nvarchar](256),
@InitialInterestAccrualEndDate	[date],
@AccrualFrequency	[int],
@DeterminationDateLeadDays	[int],
@DeterminationDateReferenceDayoftheMonth	[int],
@DeterminationDateInterestAccrualPeriod	[int],
@DeterminationDateHolidayList	[int],
@FirstPaymentDate	[date],
@InitialMonthEndPMTDateBiWeekly	[date],
@PaymentDateBusinessDayLag	[int],
@IOTerm	[int],
@AmortTerm	[int],
@PIKSeparateCompounding	[int],
@MonthlyDSOverridewhenAmortizing	[decimal](28,15),
@AccrualPeriodPaymentDayWhenNotEOMonth	[int],
@FirstPeriodInterestPaymentOverride	[decimal](28,15),
@FirstPeriodPrincipalPaymentOverride	[decimal](28,15),
@FinalInterestAccrualEndDateOverride	[date],
@AmortType	[int],
@RateType	[int],
@ReAmortizeMonthly	[int],
@ReAmortizeatPMTReset	[int],
@StubPaidInArrears	[int],
@RelativePaymentMonth	[int],
@SettleWithAccrualFlag	[int],
@InterestDueAtMaturity	[int],
@RateIndexResetFreq	[decimal](28,15),
@FirstRateIndexResetDate	[date],
@LoanPurchase	[int],
@AmortIntCalcDayCount	[int],
@StubPaidinAdvanceYN	[int],
@FullPeriodInterestDueatMaturity	[int],
@ProspectiveAccountingMode	[int],
@IsCapitalized	[int],
@SelectedMaturityDateScenario	[int],
@SelectedMaturityDate	[date],
@InitialMaturityDate	[date],
@ExpectedMaturityDate	[date],
@FullyExtendedMaturityDate [date],
--@OpenPrepaymentDate	[date],
@CashflowEngineID	[int],
@LoanType	[int],
@Classification	[int],
@SubClassification	[int],
@GAAPDesignation	[int],
@PortfolioID	[int],
@GeographicLocation	[int],
@PropertyType	[int],
@RatingAgency	[int],
@RiskRating	[int],
@PurchasePrice	[decimal](28,15),
@FutureFeesUsedforLevelYeild	[decimal](28,15),
@TotalToBeAmortized	[decimal](28,15),
@StubPeriodInterest	[decimal](28,15),
@WDPAssetMultiple	[decimal](28,15),
@WDPEquityMultiple	[decimal](28,15),
@PurchaseBalance	[decimal](28,15),
@DaysofAccrued	[int],
@InterestRate	[decimal](28,15),
@PurchasedInterestCalc	[decimal](28,15),
@ModelFinancingDrawsForFutureFundings	[decimal](28,15),
@NumberOfBusinessDaysLagForFinancingDraw	[int],
@FinancingFacilityID	[uniqueidentifier],
@FinancingInitialMaturityDate	[date],
@FinancingExtendedMaturityDate	[date],
@FinancingPayFrequency	[int],
@FinancingInterestPaymentDay	[int],
@ClosingDate	[date],
@InitialFundingAmount	[decimal](28,15),
@Discount	[decimal](28,15),
@OriginationFee	[decimal](28,15),
@CapitalizedClosingCosts	[decimal](28,15),
@PurchaseDate	[date],
@PurchaseAccruedFromDate	[decimal](28,15),
@PurchasedInterestOverride	[decimal](28,15),
@DiscountRate	[decimal](28,15),
@ValuationDate	[date],
@FairValue	[decimal](28,15),
@DiscountRatePlus	[decimal](28,15),
@FairValuePlus	[decimal](28,15),
@DiscountRateMinus	[decimal](28,15),
@FairValueMinus	[decimal](28,15),
@InitialIndexValueOverride	[decimal](28,15),
@IncludeServicingPaymentOverrideinLevelYield	[int],
@OngoingAnnualizedServicingFee	[decimal](28,15),
@IndexRoundingRule	[int],
@RoundingMethod	[int],
@StubInterestPaidonFutureAdvances	[int],
@TaxAmortCheck	[nvarchar](256),
@PIKWoCompCheck	[nvarchar](256),
@GAAPAmortCheck	[nvarchar](256),
@StubIntOverride	[decimal](28,15),
@PurchasedIntOverride	[decimal](28,15),
@ExitFeeFreePrepayAmt	[decimal](28,15),
@ExitFeeBaseAmountOverride	[decimal](28,15),
@ExitFeeAmortCheck	[int],
@FixedAmortScheduleCheck	[int],
@NoofdaysrelPaymentDaterollnextpaymentcycle [int] ,
@CreatedBy	[nvarchar](256),
@CreatedDate	[datetime],
@UpdatedBy	[nvarchar](256),
@UpdatedDate	[datetime],
--Account table
@name varchar(256),
@statusID int,
@BaseCurrencyID [int],
@StartDate [date],
@EndDate [date],
@PayFrequency [int],
--DROPDOWN FEILDS
@LoanCurrency  nvarchar(MAX),
@DeterminationDateHolidayListText  nvarchar(MAX),
@PIKSeparateCompoundingText  nvarchar(MAX),
@LoanPurchaseYNText  nvarchar(MAX),
@StubPaidinAdvanceYNText  nvarchar(MAX),
@ModelFinancingDrawsForFutureFundingsText  nvarchar(MAX),
@IncludeServicingPaymentOverrideinLevelYieldText  nvarchar(MAX),
@RoundingMethodText  nvarchar(MAX),
@StubOnFFText  nvarchar(MAX),
@ExitFeeAmortCheckText  nvarchar(MAX),
@FixedAmortScheduleText  nvarchar(MAX),
@TotalCommitmentExtensionFeeisBasedOn [decimal](28, 15) ,
---------------------------------------------
@newnoteId varchar(256) OUTPUT

)	
AS
BEGIN




IF(@NoteID='00000000-0000-0000-0000-000000000000')
BEGIN

DECLARE @tNote TABLE (tNewNoteId UNIQUEIDENTIFIER)

DECLARE @insertedAccountID uniqueidentifier;

DECLARE @tAccount TABLE (tAccountID UNIQUEIDENTIFIER)
INSERT INTO [Core].[Account]
( 
	[StatusID]
	,[Name]
	,[ClientNoteID]
	,BaseCurrencyID
	,StartDate
	,EndDate
	,PayFrequency
	,[AccountTypeID]
	,[CreatedBy]
	,[CreatedDate]
	,[UpdatedBy]
	,[UpdatedDate]
	,Isdeleted
)
OUTPUT inserted.AccountID INTO @tAccount(tAccountID)
VALUES
(
(Select LookupID from CORE.Lookup where Name = 'Active' and Parentid = 1),
--@statusID,
@name,
@CRENoteID,
(Select lookupid from CORE.lookup where name = @LoanCurrency),
@StartDate,
@EndDate,
@PayFrequency,
182,
@CreatedBy,
GETDATE(),
@UpdatedBy,
GetDATE(),0)


	  SELECT @insertedAccountID = tAccountID FROM @tAccount;

	INSERT INTO [CRE].[Note]
           ([Account_AccountID]
           ,[DealID]
           ,[CRENoteID]
           ,[ClientNoteID]
           ,[Comments]
           ,[InitialInterestAccrualEndDate]
           ,[AccrualFrequency]
           ,[DeterminationDateLeadDays]
           ,[DeterminationDateReferenceDayoftheMonth]
           ,[DeterminationDateInterestAccrualPeriod]
           ,[DeterminationDateHolidayList]
           ,[FirstPaymentDate]
           ,[InitialMonthEndPMTDateBiWeekly]
           ,[PaymentDateBusinessDayLag]
           ,[IOTerm]
           ,[AmortTerm]
           ,[PIKSeparateCompounding]
           ,[MonthlyDSOverridewhenAmortizing]
           ,[AccrualPeriodPaymentDayWhenNotEOMonth]
           ,[FirstPeriodInterestPaymentOverride]
           ,[FirstPeriodPrincipalPaymentOverride]
           ,[FinalInterestAccrualEndDateOverride]
           ,[AmortType]
           ,[RateType]
           ,[ReAmortizeMonthly]
           ,[ReAmortizeatPMTReset]
           ,[StubPaidInArrears]
           ,[RelativePaymentMonth]
           ,[SettleWithAccrualFlag]
           ,[InterestDueAtMaturity]
           ,[RateIndexResetFreq]
           ,[FirstRateIndexResetDate]
           ,[LoanPurchase]
           ,[AmortIntCalcDayCount]
           ,[StubPaidinAdvanceYN]
           ,[FullPeriodInterestDueatMaturity]
           ,[ProspectiveAccountingMode]
           ,[IsCapitalized]
           ,[SelectedMaturityDateScenario]
           ,[SelectedMaturityDate]
           ,[InitialMaturityDate]
           ,[ExpectedMaturityDate]
		   ,[FullyExtendedMaturityDate]
           --,[OpenPrepaymentDate]
           ,[CashflowEngineID]
           ,[LoanType]
           ,[Classification]
           ,[SubClassification]
           ,[GAAPDesignation]
           ,[PortfolioID]
           ,[GeographicLocation]
           ,[PropertyType]
           ,[RatingAgency]
           ,[RiskRating]
           ,[PurchasePrice]
           ,[FutureFeesUsedforLevelYeild]
           ,[TotalToBeAmortized]
           ,[StubPeriodInterest]
           ,[WDPAssetMultiple]
           ,[WDPEquityMultiple]
           ,[PurchaseBalance]
           ,[DaysofAccrued]
           ,[InterestRate]
           ,[PurchasedInterestCalc]
           ,[ModelFinancingDrawsForFutureFundings]
           ,[NumberOfBusinessDaysLagForFinancingDraw]
           ,[FinancingFacilityID]
           ,[FinancingInitialMaturityDate]
           ,[FinancingExtendedMaturityDate]
           ,[FinancingPayFrequency]
           ,[FinancingInterestPaymentDay]
           ,[ClosingDate]
           ,[InitialFundingAmount]
           ,[Discount]
           ,[OriginationFee]
           ,[CapitalizedClosingCosts]
           ,[PurchaseDate]
           ,[PurchaseAccruedFromDate]
           ,[PurchasedInterestOverride]
           ,[DiscountRate]
           ,[ValuationDate]
           ,[FairValue]
           ,[DiscountRatePlus]
           ,[FairValuePlus]
           ,[DiscountRateMinus]
           ,[FairValueMinus]
           ,[InitialIndexValueOverride]
           ,[IncludeServicingPaymentOverrideinLevelYield]
           ,[OngoingAnnualizedServicingFee]
           ,[IndexRoundingRule]
           ,[RoundingMethod]
           ,[StubInterestPaidonFutureAdvances]
           ,[TaxAmortCheck]
           ,[PIKWoCompCheck]
           ,[GAAPAmortCheck]
           ,[StubIntOverride]
           ,[PurchasedIntOverride]
           ,[ExitFeeFreePrepayAmt]
           ,[ExitFeeBaseAmountOverride]
           ,[ExitFeeAmortCheck]
           ,[FixedAmortScheduleCheck]
            ,[NoofdaysrelPaymentDaterollnextpaymentcycle]
			,[IndexNameID]	
			,TotalCommitmentExtensionFeeisBasedOn			
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])
		   	OUTPUT inserted.NoteID INTO @tNote(tNewNoteId)
     VALUES
	 (
	   @insertedAccountID	,
		@DealID	,
		@CRENoteID	,
		@CRENoteID,	--@ClientNoteID	
		@Comments	,
		@InitialInterestAccrualEndDate	,
		@AccrualFrequency	,
		@DeterminationDateLeadDays	,
		@DeterminationDateReferenceDayoftheMonth	,
		@DeterminationDateInterestAccrualPeriod	,
		(Select lookupid from CORE.lookup where name = @DeterminationDateHolidayListText and ParentID = 17),
		@FirstPaymentDate	,
		@InitialMonthEndPMTDateBiWeekly	,
		@PaymentDateBusinessDayLag	,
		@IOTerm	,
		@AmortTerm	,
		(Select lookupid from CORE.lookup where name = @PIKSeparateCompoundingText),
		@MonthlyDSOverridewhenAmortizing	,
		@AccrualPeriodPaymentDayWhenNotEOMonth	,
		@FirstPeriodInterestPaymentOverride	,
		@FirstPeriodPrincipalPaymentOverride	,
		@FinalInterestAccrualEndDateOverride	,
		@AmortType	,
		@RateType	,
		@ReAmortizeMonthly	,
		@ReAmortizeatPMTReset	,
		@StubPaidInArrears	,
		@RelativePaymentMonth	,
		@SettleWithAccrualFlag	,
		@InterestDueAtMaturity	,
		@RateIndexResetFreq	,
		@FirstRateIndexResetDate	,
		(Select lookupid from CORE.lookup where name = @LoanPurchaseYNText),
		@AmortIntCalcDayCount	,
		(Select lookupid from CORE.lookup where name = @StubPaidinAdvanceYNText),
		@FullPeriodInterestDueatMaturity	,
		@ProspectiveAccountingMode	,
		@IsCapitalized	,
		@SelectedMaturityDateScenario	,
		@SelectedMaturityDate	,
		@InitialMaturityDate	,
		@ExpectedMaturityDate	,
		@FullyExtendedMaturityDate,
		--@OpenPrepaymentDate	,
		@CashflowEngineID	,
		@LoanType	,
		@Classification	,
		@SubClassification	,
		@GAAPDesignation	,
		@PortfolioID	,
		@GeographicLocation	,
		@PropertyType	,
		@RatingAgency	,
		@RiskRating	,
		@PurchasePrice	,
		@FutureFeesUsedforLevelYeild	,
		@TotalToBeAmortized	,
		@StubPeriodInterest	,
		@WDPAssetMultiple	,
		@WDPEquityMultiple	,
		@PurchaseBalance	,
		@DaysofAccrued	,
		@InterestRate	,
		@PurchasedInterestCalc	,
		(Select lookupid from CORE.lookup where name = @ModelFinancingDrawsForFutureFundingsText),
		@NumberOfBusinessDaysLagForFinancingDraw	,
		@FinancingFacilityID	,
		@FinancingInitialMaturityDate	,
		@FinancingExtendedMaturityDate	,
		@FinancingPayFrequency	,
		@FinancingInterestPaymentDay	,
		@ClosingDate	,
		@InitialFundingAmount	,
		@Discount	,
		@OriginationFee	,
		@CapitalizedClosingCosts	,
		@PurchaseDate	,
		@PurchaseAccruedFromDate	,
		@PurchasedInterestOverride	,
		@DiscountRate	,
		@ValuationDate	,
		@FairValue	,
		@DiscountRatePlus	,
		@FairValuePlus	,
		@DiscountRateMinus	,
		@FairValueMinus	,
		@InitialIndexValueOverride	,
		(Select lookupid from CORE.lookup where name = @IncludeServicingPaymentOverrideinLevelYieldText),
		@OngoingAnnualizedServicingFee	,
		@IndexRoundingRule	,
		(Select lookupid from CORE.lookup where name = @RoundingMethodText)	,
		(Select lookupid from CORE.lookup where name = @StubOnFFText),
		@TaxAmortCheck	,
		@PIKWoCompCheck	,
		@GAAPAmortCheck	,
		@StubIntOverride	,
		@PurchasedIntOverride	,
		@ExitFeeFreePrepayAmt	,
		@ExitFeeBaseAmountOverride	,
		(Select lookupid from CORE.lookup where name = @ExitFeeAmortCheckText)	,
		(Select lookupid from CORE.lookup where name = @FixedAmortScheduleText)	,
        @NoofdaysrelPaymentDaterollnextpaymentcycle,
		(Select LookupID from CORE.[Lookup] where Name = '1M Libor'),	
	@TotalCommitmentExtensionFeeisBasedOn,
		@CreatedBy	,
		GETDATE(),
		@UpdatedBy	,
		GETDATE()	
)
  SELECT @newnoteId = tNewNoteId FROM @tNote;
END
ELSE
BEGIN

Set @Account_AccountID = (Select Account_AccountID from CRE.Note where NoteID= @NoteID)

UPDATE [Core].[Account]
   SET [AccountTypeID] = (Select LookupID from CORE.Lookup where name = 'Note')
      ,[StatusID] = @statusID
      ,[Name] = @name
      ,[ClientNoteID] = @CRENoteID
	  ,BaseCurrencyID = (Select lookupid from CORE.lookup where name = @LoanCurrency)
	  ,StartDate=@StartDate
	  ,EndDate=@EndDate
	  ,PayFrequency=@PayFrequency
      ,[UpdatedBy] = @UpdatedBy
      ,[UpdatedDate] = GETDATE()
	  ,Isdeleted = 0
 WHERE AccountID = @Account_AccountID


UPDATE CRE.Note SET
[CRENoteID]	 = 	@CRENoteID	,
[ClientNoteID] = 	@CRENoteID, --@ClientNoteID	,
[Comments]	 = 	@Comments	,
[InitialInterestAccrualEndDate]	 = 	@InitialInterestAccrualEndDate	,
[AccrualFrequency]	 = 	@AccrualFrequency	,
[DeterminationDateLeadDays]	 = 	@DeterminationDateLeadDays	,
[DeterminationDateReferenceDayoftheMonth]	 = 	@DeterminationDateReferenceDayoftheMonth	,
[DeterminationDateInterestAccrualPeriod]	 = 	@DeterminationDateInterestAccrualPeriod	,
[DeterminationDateHolidayList]	 = 	(Select lookupid from CORE.lookup where name = @DeterminationDateHolidayListText and ParentID = 17)	,
[FirstPaymentDate]	 = 	@FirstPaymentDate	,
[InitialMonthEndPMTDateBiWeekly]	 = 	@InitialMonthEndPMTDateBiWeekly	,
[PaymentDateBusinessDayLag]	 = 	@PaymentDateBusinessDayLag	,
[IOTerm]	 = 	@IOTerm	,
[AmortTerm]	 = 	@AmortTerm	,
[PIKSeparateCompounding]	 = 	(Select lookupid from CORE.lookup where name = @PIKSeparateCompoundingText)	,
[MonthlyDSOverridewhenAmortizing]	 = 	@MonthlyDSOverridewhenAmortizing	,
[AccrualPeriodPaymentDayWhenNotEOMonth] = 	@AccrualPeriodPaymentDayWhenNotEOMonth	,
[FirstPeriodInterestPaymentOverride] = 	@FirstPeriodInterestPaymentOverride	,
[FirstPeriodPrincipalPaymentOverride] = @FirstPeriodPrincipalPaymentOverride	,
[FinalInterestAccrualEndDateOverride]	 = 	@FinalInterestAccrualEndDateOverride	,
[AmortType]	 = 	@AmortType	,
[RateType]	 = 	@RateType	,
[ReAmortizeMonthly]	 = 	@ReAmortizeMonthly	,
[ReAmortizeatPMTReset]	 = 	@ReAmortizeatPMTReset	,
[StubPaidInArrears]	 = 	@StubPaidInArrears	,
[RelativePaymentMonth]	 = 	@RelativePaymentMonth	,
[SettleWithAccrualFlag]	 = 	@SettleWithAccrualFlag	,
[InterestDueAtMaturity]	 = 	@InterestDueAtMaturity	,
[RateIndexResetFreq]	 = 	@RateIndexResetFreq	,
[FirstRateIndexResetDate]	 = 	@FirstRateIndexResetDate	,
[LoanPurchase]	 = 	(Select lookupid from CORE.lookup where name = @LoanPurchaseYNText)	,
[AmortIntCalcDayCount]	 = 	@AmortIntCalcDayCount	,
[StubPaidinAdvanceYN]	 = 	(Select lookupid from CORE.lookup where name = @StubPaidinAdvanceYNText)	,
[FullPeriodInterestDueatMaturity]	 = 	@FullPeriodInterestDueatMaturity	,
[ProspectiveAccountingMode]	 = 	@ProspectiveAccountingMode	,
[IsCapitalized]	 = 	@IsCapitalized	,
[SelectedMaturityDateScenario]	 = 	@SelectedMaturityDateScenario	,
[SelectedMaturityDate]	 = 	@SelectedMaturityDate	,
[InitialMaturityDate]	 = 	@InitialMaturityDate	,
[ExpectedMaturityDate]	 = 	@ExpectedMaturityDate	,
FullyExtendedMaturityDate =@FullyExtendedMaturityDate,
--[OpenPrepaymentDate]	 = 	@OpenPrepaymentDate	,
[CashflowEngineID]	 = 	@CashflowEngineID	,
[LoanType]	 = 	@LoanType	,
[Classification]	 = 	@Classification	,
[SubClassification]	 = 	@SubClassification	,
[GAAPDesignation]	 = 	@GAAPDesignation	,
[PortfolioID]	 = 	@PortfolioID	,
[GeographicLocation]	 = 	@GeographicLocation	,
[PropertyType]	 = 	@PropertyType	,
[RatingAgency]	 = 	@RatingAgency	,
[RiskRating]	 = 	@RiskRating	,
[PurchasePrice]	 = 	@PurchasePrice	,
[FutureFeesUsedforLevelYeild]	 = 	@FutureFeesUsedforLevelYeild	,
[TotalToBeAmortized]	 = 	@TotalToBeAmortized	,
[StubPeriodInterest]	 = 	@StubPeriodInterest	,
[WDPAssetMultiple]	 = 	@WDPAssetMultiple	,
[WDPEquityMultiple]	 = 	@WDPEquityMultiple	,
[PurchaseBalance]	 = 	@PurchaseBalance	,
[DaysofAccrued]	 = 	@DaysofAccrued	,
[InterestRate]	 = 	@InterestRate	,
[PurchasedInterestCalc]	 = 	@PurchasedInterestCalc	,
[ModelFinancingDrawsForFutureFundings]	 = 	(Select lookupid from CORE.lookup where name = @ModelFinancingDrawsForFutureFundingsText)	,
[NumberOfBusinessDaysLagForFinancingDraw]	 = 	@NumberOfBusinessDaysLagForFinancingDraw	,
[FinancingFacilityID]	 = 	@FinancingFacilityID	,
[FinancingInitialMaturityDate]	 = 	@FinancingInitialMaturityDate	,
[FinancingExtendedMaturityDate]	 = 	@FinancingExtendedMaturityDate	,
[FinancingPayFrequency]	 = 	@FinancingPayFrequency	,
[FinancingInterestPaymentDay]	 = 	@FinancingInterestPaymentDay	,
[ClosingDate]	 = 	@ClosingDate	,
[InitialFundingAmount]	 = 	@InitialFundingAmount	,
[Discount]	 = 	@Discount	,
[OriginationFee]	 = 	@OriginationFee	,
[CapitalizedClosingCosts]	 = 	@CapitalizedClosingCosts	,
[PurchaseDate]	 = 	@PurchaseDate	,
[PurchaseAccruedFromDate]	 = 	@PurchaseAccruedFromDate	,
[PurchasedInterestOverride]	 = 	@PurchasedInterestOverride	,
[DiscountRate]	 = 	@DiscountRate	,
[ValuationDate]	 = 	@ValuationDate	,
[FairValue]	 = 	@FairValue	,
[DiscountRatePlus]	 = 	@DiscountRatePlus	,
[FairValuePlus]	 = 	@FairValuePlus	,
[DiscountRateMinus]	 = 	@DiscountRateMinus	,
[FairValueMinus]	 = 	@FairValueMinus	,
[InitialIndexValueOverride]	 = 	@InitialIndexValueOverride	,
[IncludeServicingPaymentOverrideinLevelYield]	 = 	(Select lookupid from CORE.lookup where name = @IncludeServicingPaymentOverrideinLevelYieldText)	,
[OngoingAnnualizedServicingFee]	 = 	@OngoingAnnualizedServicingFee	,
[IndexRoundingRule]	 = 	@IndexRoundingRule	,
[RoundingMethod]	 = 	(Select lookupid from CORE.lookup where name = @RoundingMethodText)	,
[StubInterestPaidonFutureAdvances]	 = 	(Select lookupid from CORE.lookup where name = @StubOnFFText)	,
[TaxAmortCheck]	 = 	@TaxAmortCheck	,
[PIKWoCompCheck]	 = 	@PIKWoCompCheck	,
[GAAPAmortCheck]	 = 	@GAAPAmortCheck	,
[StubIntOverride]	 = 	@StubIntOverride	,
[PurchasedIntOverride]	 = 	@PurchasedIntOverride	,
[ExitFeeFreePrepayAmt]	 = 	@ExitFeeFreePrepayAmt	,
[ExitFeeBaseAmountOverride]	 = 	@ExitFeeBaseAmountOverride	,
[ExitFeeAmortCheck]	 = 	(Select lookupid from CORE.lookup where name = @ExitFeeAmortCheckText)	,
[FixedAmortScheduleCheck]	 = 	(Select lookupid from CORE.lookup where name = @FixedAmortScheduleText)	,
[NoofdaysrelPaymentDaterollnextpaymentcycle] = @NoofdaysrelPaymentDaterollnextpaymentcycle,
TotalCommitmentExtensionFeeisBasedOn = @TotalCommitmentExtensionFeeisBasedOn,
[UpdatedBy]	 = 	@UpdatedBy	,
[UpdatedDate]	 = 	GETDATE()
WHERE NoteID = @NoteID


 SELECT @newnoteId = @NoteID

END



END

