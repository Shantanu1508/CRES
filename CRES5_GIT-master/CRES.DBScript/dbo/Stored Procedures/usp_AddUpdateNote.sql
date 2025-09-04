CREATE PROCEDURE [dbo].[usp_AddUpdateNote]      
(      
@UserID [uniqueidentifier],      
@NoteID [uniqueidentifier],      
@Account_AccountID [uniqueidentifier],      
@DealID [uniqueidentifier],      
@CRENoteID [nvarchar](256),      
@ClientNoteID [nvarchar](256),      
@Comments [nvarchar](256),      
@InitialInterestAccrualEndDate [date],      
@AccrualFrequency [int],      
@DeterminationDateLeadDays [int],      
@DeterminationDateReferenceDayoftheMonth [int],      
@DeterminationDateInterestAccrualPeriod [int],      
@DeterminationDateHolidayList [int],      
@FirstPaymentDate [date],      
@InitialMonthEndPMTDateBiWeekly [date],      
@PaymentDateBusinessDayLag [int],      
@IOTerm [int],      
@AmortTerm [int],      
@PIKSeparateCompounding [int],      
@MonthlyDSOverridewhenAmortizing [decimal](28,15),      
@AccrualPeriodPaymentDayWhenNotEOMonth [int],      
@FirstPeriodInterestPaymentOverride [decimal](28,15),      
@FirstPeriodPrincipalPaymentOverride [decimal](28,15),      
@FinalInterestAccrualEndDateOverride [date],      
@AmortType [int],      
@RateType [int],      
@ReAmortizeMonthly [int],      
@ReAmortizeatPMTReset [int],      
@StubPaidInArrears [int],      
@RelativePaymentMonth [int],      
@SettleWithAccrualFlag [int],      
@InterestDueAtMaturity [int],      
@RateIndexResetFreq [decimal](28,15),      
@FirstRateIndexResetDate [date],      
@LoanPurchase [int],      
@AmortIntCalcDayCount [int],      
@StubPaidinAdvanceYN [int],      
@FullPeriodInterestDueatMaturity [int],      
@ProspectiveAccountingMode [int],      
@IsCapitalized [int],      
@SelectedMaturityDateScenario [int],  
      
--@SelectedMaturityDate [date],     
--@InitialMaturityDate [date],      
--@ExpectedMaturityDate [date],      
--@FullyExtendedMaturityDate [date],      
--@OpenPrepaymentDate [date],      
@CashflowEngineID [int],      
@LoanType [int],      
@Classification [int],      
@SubClassification [int],      
@GAAPDesignation [int],      
@PortfolioID [int],      
@GeographicLocation [int],      
@PropertyType [int],      
@RatingAgency [int],      
@RiskRating [int],      
@PurchasePrice [decimal](28,15),      
@FutureFeesUsedforLevelYeild [decimal](28,15),      
@TotalToBeAmortized [decimal](28,15),      
@StubPeriodInterest [decimal](28,15),      
@WDPAssetMultiple [decimal](28,15),      
@WDPEquityMultiple [decimal](28,15),      
@PurchaseBalance [decimal](28,15),      
@DaysofAccrued [int],      
@InterestRate [decimal](28,15),      
@PurchasedInterestCalc [decimal](28,15),      
@ModelFinancingDrawsForFutureFundings [decimal](28,15),      
@NumberOfBusinessDaysLagForFinancingDraw [int],      
@FinancingFacilityID [uniqueidentifier],      
@FinancingInitialMaturityDate [date],      
@FinancingExtendedMaturityDate [date],      
@FinancingPayFrequency [int],      
@FinancingInterestPaymentDay [int],      
@ClosingDate [date],      
@InitialFundingAmount [decimal](28,15),      
@Discount [decimal](28,15),      
@OriginationFee [decimal](28,15),      
@CapitalizedClosingCosts [decimal](28,15),      
@PurchaseDate [date],      
@PurchaseAccruedFromDate [decimal](28,15),      
@PurchasedInterestOverride [decimal](28,15),      
@DiscountRate [decimal](28,15),      
@ValuationDate [date],      
@FairValue [decimal](28,15),      
@DiscountRatePlus [decimal](28,15),      
@FairValuePlus [decimal](28,15),      
@DiscountRateMinus [decimal](28,15),      
@FairValueMinus [decimal](28,15),      
@InitialIndexValueOverride [decimal](28,15),      
@IncludeServicingPaymentOverrideinLevelYield [int],      
@OngoingAnnualizedServicingFee [decimal](28,15),      
@IndexRoundingRule [int],      
@RoundingMethod [int],      
@StubInterestPaidonFutureAdvances [int],      
@TaxAmortCheck [nvarchar](256),      
@PIKWoCompCheck [nvarchar](256),      
@GAAPAmortCheck [nvarchar](256),      
@StubIntOverride [decimal](28,15),      
--@PurchasedIntOverride [decimal](28,15),      
@ExitFeeFreePrepayAmt [decimal](28,15),      
@ExitFeeBaseAmountOverride [decimal](28,15),      
@ExitFeeAmortCheck [int],      
@FixedAmortScheduleCheck [int],      
@NoofdaysrelPaymentDaterollnextpaymentcycle  [int] ,      
@CreatedBy [nvarchar](256),      
@CreatedDate [datetime],      
@UpdatedBy [nvarchar](256),      
@UpdatedDate [datetime],      
--Account table      
@name varchar(256),    @statusID int,      
@BaseCurrencyID [int],      
@StartDate [date],      
@EndDate [date],      
@PayFrequency [int],      
@UseIndexOverrides[bit],      
@IndexNameID int,      
@ServicerID [nvarchar](256),      
-- @TotalCommitment [decimal](28, 15) ,      
@ClientName nvarchar(256)  ,      
@Portfolio nvarchar(256)  ,      
@Tag1 nvarchar(256)  ,      
@Tag2 nvarchar(256)  ,      
@Tag3 nvarchar(256)  ,      
@Tag4 nvarchar(256) ,       
--@ExtendedMaturityScenario1 date ,      
--@ExtendedMaturityScenario2 date ,      
--@ExtendedMaturityScenario3 date ,      
@ActualPayoffDate date ,      
@TotalCommitmentExtensionFeeisBasedOn [decimal](28, 15) ,      
@UnusedFeeThresholdBalance  [decimal](28, 15) ,      
@UnusedFeePaymentFrequency  [int],      
@Servicer int,      
@FullInterestAtPPayoff int,      
@newnoteId varchar(256) OUTPUT,      
@ClientID int,      
@FundId int,      
@FinancingSourceID int,      
@DebtTypeID int,      
@BillingNotesID int,      
@CapStack int,      
@PoolID int,      
@StubInterestRateOverride [decimal](28,15),      
@LiborDataAsofDate [datetime],      
@ServicerNameID int ,      
@BusinessdaylafrelativetoPMTDate int ,      
@DayoftheMonth int ,      
@InterestCalculationRuleForPaydowns int ,      
@PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate int,      
@InterestCalculationRuleForPaydownsAmort int,      
      
@RoundingNote int,      
@StraightLineAmortOverride [decimal](28,15),      
--@AdjustedTotalCommitment [decimal](28, 15) ,      
--@AggregatedTotal [decimal](28, 15) ,      
@RepaymentDayoftheMonth int,      
@MarketPrice  [decimal](28, 15),      
@StrategyCode  int,      
--@OriginalTotalCommitment decimal(28,15),      
@NoteTransferDate [date],      
@EnableM61Calculations int,      
      
@InitialRequiredEquity decimal(28,15),      
@InitialAdditionalEquity decimal(28,15) ,    
@OriginationFeePercentageRP decimal(28,15)  ,  
@ImpactCommitmentCalc int,  
@FirstIndexDeterminationDateOverride date,  
@AccrualPeriodType int,  
@AccrualPeriodBusinessDayAdj int  ,
@AccountingClose int,
@InterestCalculationRuleForPIKPaydowns int ,
@UPBAtForeclosure decimal(28,15)  ,
@FullIOTermFlag int,
@NoteType int,
@InterestOnlyNote int,
@ConstantPaymentMethod int,
@PaymentDateAccrualPeriod int
)       
AS      
BEGIN      
      
Declare @InActive as nvarchar(256);      
Declare @Active as nvarchar(256);      
set @InActive=(select LookupID from core.lookup where name ='InActive' and ParentID=1);      
set @Active=(select LookupID from core.lookup where name ='Active' and ParentID=1);      
      
      
if(@DeterminationDateHolidayList is null)       
 Set @DeterminationDateHolidayList = 142; --UK      
      
if(@EnableM61Calculations is null)       
 Set @EnableM61Calculations = 3; --Y      
       
      
Declare @Saved_EnableM61Calculations int = (Select top 1 EnableM61Calculations from CRE.Note  where CRENoteID = @CRENoteID)      
      
if(@Saved_EnableM61Calculations is null)       
 Set @Saved_EnableM61Calculations = 3; --Y      
      
      
IF(@NoteID='00000000-0000-0000-0000-000000000000')      
BEGIN      
IF NOT EXISTS(Select * from CRE.Note  where CRENoteID = @CRENoteID and  DealID=@DealId)      
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
 ,isdeleted      
)      
OUTPUT inserted.AccountID INTO @tAccount(tAccountID)      
VALUES      
(      
(Select LookupID from CORE.Lookup where Name = 'Active' and Parentid = 1),      
  --@statusID,      
  @name,      
  @CRENoteID,      
  @BaseCurrencyID,      
  @StartDate,      
  @EndDate,      
  @PayFrequency,      
  1, --182,      
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
           --,[PIKSeparateCompounding]      
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
           --,[SelectedMaturityDate]      
           --,[InitialMaturityDate]      
          -- ,[ExpectedMaturityDate]      
   --,FullyExtendedMaturityDate      
          -- ,[OpenPrepaymentDate]      
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
          -- ,[PurchasedIntOverride]      
           ,[ExitFeeFreePrepayAmt]      
           ,[ExitFeeBaseAmountOverride]      
           ,[ExitFeeAmortCheck]      
           ,[FixedAmortScheduleCheck]         
   ,[NoofdaysrelPaymentDaterollnextpaymentcycle]      
   ,[UseIndexOverrides]      
   ,[IndexNameID]      
   ,[ServicerID]      
   --,[TotalCommitment]      
   ,ClientName      
   ,Portfolio      
   ,Tag1      
   ,Tag2      
   ,Tag3      
   ,Tag4      
   --,ExtendedMaturityScenario1      
   --,ExtendedMaturityScenario2      
   --,ExtendedMaturityScenario3      
   ,ActualPayoffDate      
   ,TotalCommitmentExtensionFeeisBasedOn      
   ,UnusedFeeThresholdBalance       
             ,UnusedFeePaymentFrequency      
    ,Servicer      
    ,FullInterestAtPPayoff      
   ,ClientID       
   ,FundId       
   ,FinancingSourceID      
   ,DebtTypeID       
   ,BillingNotesID       
   ,CapStack       
   ,PoolID      
   ,[CreatedBy]      
   ,[CreatedDate]      
   ,[UpdatedBy]      
   ,[UpdatedDate]      
   ,[StubInterestRateOverride]      
   ,ServicerNameID      
   ,BusinessdaylafrelativetoPMTDate      
   ,DayoftheMonth      
   ,InterestCalculationRuleForPaydowns      
   ,PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate      
   ,InterestCalculationRuleForPaydownsAmort         
   ,RoundingNote      
   ,StraightLineAmortOverride         
   --,AdjustedTotalCommitment      
   --,AggregatedTotal       
   ,RepaymentDayoftheMonth      
   ,MKT_PRICE      
   ,StrategyCode      
   --,OriginalTotalCommitment      
   ,NoteTransferDate      
   ,EnableM61Calculations      
   ,InitialRequiredEquity      
   ,InitialAdditionalEquity     
   ,OriginationFeePercentageRP    
   ,ImpactCommitmentCalc  
   ,FirstIndexDeterminationDateOverride  
   ,AccrualPeriodType  
 ,AccrualPeriodBusinessDayAdj  
 ,AccountingClose
 ,InterestCalculationRuleForPIKPaydowns  
 ,TaxVendorLoanNumber
 ,UPBAtForeclosure
 ,NoteType
 ,ClosingDateBK
 ,[InterestOnlyNote]
 ,[ConstantPaymentMethod]
 ,[PaymentDateAccrualPeriod]
   )      
      OUTPUT inserted.NoteID INTO @tNote(tNewNoteId)      
     VALUES      
  (      
    @insertedAccountID ,      
  @DealID ,      
  @CRENoteID ,      
  @ClientNoteID ,      
  @Comments ,      
  @InitialInterestAccrualEndDate ,      
  @AccrualFrequency ,      
  @DeterminationDateLeadDays ,      
  @DeterminationDateReferenceDayoftheMonth ,      
  @DeterminationDateInterestAccrualPeriod ,      
  @DeterminationDateHolidayList ,      
  @FirstPaymentDate ,      
  @InitialMonthEndPMTDateBiWeekly ,      
  @PaymentDateBusinessDayLag ,      
  @IOTerm ,      
  @AmortTerm ,      
 -- @PIKSeparateCompounding ,      
  @MonthlyDSOverridewhenAmortizing ,      
  @AccrualPeriodPaymentDayWhenNotEOMonth ,      
  @FirstPeriodInterestPaymentOverride ,      
  @FirstPeriodPrincipalPaymentOverride ,      
  @FinalInterestAccrualEndDateOverride ,      
  @AmortType ,      
  @RateType ,      
  @ReAmortizeMonthly ,      
  @ReAmortizeatPMTReset ,      
  @StubPaidInArrears ,      
  @RelativePaymentMonth ,      
  @SettleWithAccrualFlag ,      
  @InterestDueAtMaturity ,      
  @RateIndexResetFreq ,      
  @FirstRateIndexResetDate ,      
  @LoanPurchase ,      
  @AmortIntCalcDayCount ,      
  @StubPaidinAdvanceYN ,      
  @FullPeriodInterestDueatMaturity ,      
  @ProspectiveAccountingMode ,      
  @IsCapitalized ,      
  @SelectedMaturityDateScenario ,      
 -- @SelectedMaturityDate ,      
 -- @InitialMaturityDate ,      
 -- @ExpectedMaturityDate ,      
 -- @FullyExtendedMaturityDate,      
  --@OpenPrepaymentDate ,      
  @CashflowEngineID ,      
  @LoanType ,      
  @Classification ,      
  @SubClassification ,      
  @GAAPDesignation ,      
  @PortfolioID ,      
  @GeographicLocation ,      
  @PropertyType ,      
  @RatingAgency ,      
  @RiskRating ,      
  @PurchasePrice ,      
  @FutureFeesUsedforLevelYeild ,      
  @TotalToBeAmortized ,      
  @StubPeriodInterest ,      
  @WDPAssetMultiple ,      
  @WDPEquityMultiple ,      
  @PurchaseBalance ,      
  @DaysofAccrued ,      
  @InterestRate ,      
  @PurchasedInterestCalc ,      
  @ModelFinancingDrawsForFutureFundings ,      
  @NumberOfBusinessDaysLagForFinancingDraw ,      
  @FinancingFacilityID ,      
  @FinancingInitialMaturityDate ,      
  @FinancingExtendedMaturityDate ,      
  @FinancingPayFrequency ,      
  @FinancingInterestPaymentDay ,      
  @ClosingDate ,      
  @InitialFundingAmount ,      
  @Discount ,      
  @OriginationFee ,      
  @CapitalizedClosingCosts ,      
  @PurchaseDate ,      
  @PurchaseAccruedFromDate ,      
  @PurchasedInterestOverride ,      
  @DiscountRate ,      
  @ValuationDate ,      
  @FairValue ,      
  @DiscountRatePlus ,      
  @FairValuePlus ,      
  @DiscountRateMinus ,      
  @FairValueMinus ,      
  case when @InitialIndexValueOverride=0 then Null else @InitialIndexValueOverride End,      
  @IncludeServicingPaymentOverrideinLevelYield ,      
  @OngoingAnnualizedServicingFee ,      
  @IndexRoundingRule ,      
  @RoundingMethod ,      
  @StubInterestPaidonFutureAdvances ,      
  @TaxAmortCheck ,      
  @PIKWoCompCheck ,      
  @GAAPAmortCheck ,      
  @StubIntOverride ,      
  --@PurchasedIntOverride ,      
  @ExitFeeFreePrepayAmt ,      
  @ExitFeeBaseAmountOverride ,      
  @ExitFeeAmortCheck ,      
  @FixedAmortScheduleCheck ,      
  @NoofdaysrelPaymentDaterollnextpaymentcycle,      
  @UseIndexOverrides,      
  isnull(@IndexNameID,((Select LookupID from CORE.[Lookup] where Name = '1M Libor'))),      
  @ServicerID,      
  --@TotalCommitment,      
  @ClientName,      
  @Portfolio,      
  @Tag1,      
  @Tag2,      
  @Tag3,      
  @Tag4,      
  --@ExtendedMaturityScenario1,      
  --@ExtendedMaturityScenario2,      
  --@ExtendedMaturityScenario3,      
  @ActualPayoffDate,      
  @TotalCommitmentExtensionFeeisBasedOn,      
  @UnusedFeeThresholdBalance ,      
        @UnusedFeePaymentFrequency,      
  @Servicer,      
  @FullInterestAtPPayoff,      
  @ClientID,      
  @FundId,      
  @FinancingSourceID,      
  @DebtTypeID,      
  @BillingNotesID,      
  @CapStack,      
  @PoolID,      
  @CreatedBy ,      
  GETDATE(),      
  @UpdatedBy ,      
  GETDATE(),      
  @StubInterestRateOverride,      
  @ServicerNameID,      
  @BusinessdaylafrelativetoPMTDate,      
  @DayoftheMonth,      
  @InterestCalculationRuleForPaydowns,      
  ISNULL(@PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate,4),      
  @InterestCalculationRuleForPaydownsAmort,      
  @RoundingNote,      
  @StraightLineAmortOverride,      
  --@AdjustedTotalCommitment,      
     --@AggregatedTotal,      
     @RepaymentDayoftheMonth,      
  @MarketPrice ,      
  @StrategyCode ,      
  --@OriginalTotalCommitment      
  @NoteTransferDate        
  ,@EnableM61Calculations      
  ,@InitialRequiredEquity      
  ,@InitialAdditionalEquity     
  ,@OriginationFeePercentageRP  
  ,@ImpactCommitmentCalc    
  ,@FirstIndexDeterminationDateOverride  
  ,ISNULL(@AccrualPeriodType,811)  
 ,ISNULL(@AccrualPeriodBusinessDayAdj,813)  
 ,@AccountingClose
 ,@InterestCalculationRuleForPIKPaydowns
 ,'NA'
 ,@UPBAtForeclosure
 ,@NoteType
 ,@ClosingDate
 ,@InterestOnlyNote
 ,@ConstantPaymentMethod
 ,@PaymentDateAccrualPeriod
)      
        
    SELECT @newnoteId = tNewNoteId FROM @tNote;   
  
----=========Update column ============  
UPDATE CRE.Note SET CommitmentUsedInFFDistribution = (CASE WHEN CommitmentUsedInFFDistribution is null THEN OriginalTotalCommitment ELSE CommitmentUsedInFFDistribution END) WHERE NoteID = @newnoteId;  
    
   Exec [dbo].[usp_InsertUserNotification]  @CreatedBy,'addnote',@newnoteId      
      
      
   ----Delete FF from backshop if note does not have FF in M61      
   --exec [usp_DeleteFundingScheduleInBackShop] @CRENoteID      
       
      
END      
ELSE      
BEGIN      
 SELECT @newnoteId = @NoteID;      
END      
      
END      
ELSE      
BEGIN      
      
      
UPDATE [Core].[Account]      
   SET [AccountTypeID] = 1 ---((Select AccountCategoryID from [Core].[AccountCategory] where name = 'CRE Loan (Note)')) ---(Select LookupID from CORE.Lookup where name = 'Note')      
      ,[StatusID] = @statusID      
      ,[Name] = @name      
      ,[ClientNoteID] = @CRENoteID      
   ,BaseCurrencyID=@BaseCurrencyID      
   ,StartDate=@StartDate      
   ,EndDate=@EndDate      
   ,PayFrequency=@PayFrequency      
      ,[UpdatedBy] = @UpdatedBy      
      ,[UpdatedDate] = GETDATE()      
   ,Isdeleted = 0      
 WHERE AccountID = @Account_AccountID      
      
   Update CRE.Note SET ClosingDateBK = ClosingDate Where NoteID = @NoteID;

UPDATE CRE.Note SET      
     [CRENoteID]  =  @CRENoteID ,      
     [ClientNoteID] =  @CRENoteID ,      
     [Comments]  =  @Comments ,      
     [InitialInterestAccrualEndDate]  =  @InitialInterestAccrualEndDate ,      
     [AccrualFrequency]  =  @AccrualFrequency ,      
     [DeterminationDateLeadDays]  =  @DeterminationDateLeadDays ,      
     [DeterminationDateReferenceDayoftheMonth]  =  @DeterminationDateReferenceDayoftheMonth ,      
     [DeterminationDateInterestAccrualPeriod]  =  @DeterminationDateInterestAccrualPeriod ,      
     [DeterminationDateHolidayList]  =  @DeterminationDateHolidayList ,      
     [FirstPaymentDate]  =  @FirstPaymentDate ,      
     [InitialMonthEndPMTDateBiWeekly]  =  @InitialMonthEndPMTDateBiWeekly ,      
     [PaymentDateBusinessDayLag]  =  @PaymentDateBusinessDayLag ,      
     [IOTerm]  =  @IOTerm ,      
     [AmortTerm]  =  @AmortTerm ,      
     --[PIKSeparateCompounding]  =  @PIKSeparateCompounding ,      
     [MonthlyDSOverridewhenAmortizing]  =  @MonthlyDSOverridewhenAmortizing ,      
     [AccrualPeriodPaymentDayWhenNotEOMonth] =  @AccrualPeriodPaymentDayWhenNotEOMonth ,      
     [FirstPeriodInterestPaymentOverride] =  @FirstPeriodInterestPaymentOverride ,      
     [FirstPeriodPrincipalPaymentOverride] = @FirstPeriodPrincipalPaymentOverride ,      
     [FinalInterestAccrualEndDateOverride]  =  @FinalInterestAccrualEndDateOverride ,      
     [AmortType]  =  @AmortType ,      
     [RateType]  =  @RateType ,      
     [ReAmortizeMonthly]  =  @ReAmortizeMonthly ,      
     [ReAmortizeatPMTReset]  =  @ReAmortizeatPMTReset ,      
     [StubPaidInArrears]  =  @StubPaidInArrears ,      
     [RelativePaymentMonth]  =  @RelativePaymentMonth ,      
     [SettleWithAccrualFlag]  =  @SettleWithAccrualFlag ,      
     [InterestDueAtMaturity]  =  @InterestDueAtMaturity ,      
     [RateIndexResetFreq]  =  @RateIndexResetFreq ,      
     [FirstRateIndexResetDate]  =  @FirstRateIndexResetDate ,      
     [LoanPurchase]  =  @LoanPurchase ,      
     [AmortIntCalcDayCount]  =  @AmortIntCalcDayCount ,      
     [StubPaidinAdvanceYN]  =  @StubPaidinAdvanceYN ,      
  [FullPeriodInterestDueatMaturity]  =  @FullPeriodInterestDueatMaturity ,      
     [ProspectiveAccountingMode]  =  @ProspectiveAccountingMode ,      
     [IsCapitalized]  =  @IsCapitalized ,      
     [SelectedMaturityDateScenario]  =  @SelectedMaturityDateScenario ,      
    --[SelectedMaturityDate]  =  @SelectedMaturityDate ,      
    -- [InitialMaturityDate]  =  @InitialMaturityDate ,      
    -- [ExpectedMaturityDate]  =  @ExpectedMaturityDate ,      
    -- FullyExtendedMaturityDate=@FullyExtendedMaturityDate,      
     --[OpenPrepaymentDate]  =  @OpenPrepaymentDate ,      
     [CashflowEngineID]  =  @CashflowEngineID ,      
     [LoanType]  =  @LoanType ,      
     [Classification]  =  @Classification ,      
     [SubClassification]  =  @SubClassification ,      
     [GAAPDesignation]  =  @GAAPDesignation ,      
     [PortfolioID]  =  @PortfolioID ,      
     [GeographicLocation]  =  @GeographicLocation ,      
     [PropertyType]  =  @PropertyType ,      
     [RatingAgency]  =  @RatingAgency ,      
     [RiskRating]  =  @RiskRating ,      
     [PurchasePrice]  =  @PurchasePrice ,      
     [FutureFeesUsedforLevelYeild]  =  @FutureFeesUsedforLevelYeild ,      
     [TotalToBeAmortized]  =  @TotalToBeAmortized ,      
     [StubPeriodInterest]  =  @StubPeriodInterest ,      
     [WDPAssetMultiple]  =  @WDPAssetMultiple ,      
     [WDPEquityMultiple]  =  @WDPEquityMultiple ,      
     [PurchaseBalance]  =  @PurchaseBalance ,      
     [DaysofAccrued]  =  @DaysofAccrued ,      
     [InterestRate]  =  @InterestRate ,      
     [PurchasedInterestCalc]  =  @PurchasedInterestCalc ,      
     [ModelFinancingDrawsForFutureFundings]  =  @ModelFinancingDrawsForFutureFundings ,      
     [NumberOfBusinessDaysLagForFinancingDraw]  =  @NumberOfBusinessDaysLagForFinancingDraw ,      
     [FinancingFacilityID]  =  @FinancingFacilityID ,      
     [FinancingInitialMaturityDate]  =  @FinancingInitialMaturityDate ,      
     [FinancingExtendedMaturityDate]  =  @FinancingExtendedMaturityDate ,      
     [FinancingPayFrequency]  =  @FinancingPayFrequency ,      
     [FinancingInterestPaymentDay]  =  @FinancingInterestPaymentDay ,      
     [ClosingDate]  =  @ClosingDate ,      
     [InitialFundingAmount]  =  @InitialFundingAmount ,      
     [Discount]  =  @Discount ,      
     [OriginationFee]  =  @OriginationFee ,      
     [CapitalizedClosingCosts]  =  @CapitalizedClosingCosts ,      
     [PurchaseDate]  =  @PurchaseDate ,      
     [PurchaseAccruedFromDate]  =  @PurchaseAccruedFromDate ,      
     [PurchasedInterestOverride]  =  @PurchasedInterestOverride ,      
     [DiscountRate]  =  @DiscountRate ,      
     [ValuationDate]  =  @ValuationDate ,      
     [FairValue]  =  @FairValue ,      
     [DiscountRatePlus]  =  @DiscountRatePlus ,      
     [FairValuePlus]  =  @FairValuePlus ,      
     [DiscountRateMinus]  =  @DiscountRateMinus ,      
     [FairValueMinus]  =  @FairValueMinus ,      
     [InitialIndexValueOverride]  =  case when @InitialIndexValueOverride=0 then Null else @InitialIndexValueOverride End,      
     [IncludeServicingPaymentOverrideinLevelYield]  =  @IncludeServicingPaymentOverrideinLevelYield ,      
     [OngoingAnnualizedServicingFee]  =  @OngoingAnnualizedServicingFee ,      
     [IndexRoundingRule]  =  @IndexRoundingRule ,      
     [RoundingMethod]  =  @RoundingMethod ,      
     [StubInterestPaidonFutureAdvances]  =  @StubInterestPaidonFutureAdvances ,      
     [TaxAmortCheck]  =  @TaxAmortCheck ,      
     [PIKWoCompCheck]  =  @PIKWoCompCheck ,      
     [GAAPAmortCheck]  =  @GAAPAmortCheck ,      
     [StubIntOverride]  =  @StubIntOverride ,      
     --[PurchasedIntOverride]  =  @PurchasedIntOverride ,      
     [ExitFeeFreePrepayAmt]  =  @ExitFeeFreePrepayAmt ,      
     [ExitFeeBaseAmountOverride]  =  @ExitFeeBaseAmountOverride ,      
     [ExitFeeAmortCheck]  =  @ExitFeeAmortCheck ,      
     [FixedAmortScheduleCheck]  =  @FixedAmortScheduleCheck ,      
                    [NoofdaysrelPaymentDaterollnextpaymentcycle] = @NoofdaysrelPaymentDaterollnextpaymentcycle,      
     [UseIndexOverrides]=@UseIndexOverrides,      
     [IndexNameID]=@IndexNameID,      
     [ServicerID]=@ServicerID,      
     --[TotalCommitment]=@TotalCommitment,      
     ClientName=@ClientName,      
     Portfolio= @Portfolio,      
     Tag1=@Tag1,      
     Tag2=@Tag2,      
     Tag3=@Tag3,      
     Tag4=@Tag4,      
     --ExtendedMaturityScenario1=   @ExtendedMaturityScenario1,      
     --ExtendedMaturityScenario2=@ExtendedMaturityScenario2,      
     --ExtendedMaturityScenario3=@ExtendedMaturityScenario3,      
     ActualPayoffDate=@ActualPayoffDate,      
     TotalCommitmentExtensionFeeisBasedOn = @TotalCommitmentExtensionFeeisBasedOn,      
     UnusedFeeThresholdBalance  = @UnusedFeeThresholdBalance,      
                    UnusedFeePaymentFrequency=@UnusedFeePaymentFrequency,      
     Servicer=@Servicer,      
     [FullInterestAtPPayoff] = @FullInterestAtPPayoff,      
     ClientID =@ClientID ,      
     FundId =@FundId ,      
     FinancingSourceID=@FinancingSourceID,      
     DebtTypeID =@DebtTypeID ,      
     BillingNotesID =@BillingNotesID ,      
     CapStack =@CapStack ,      
     PoolID =@PoolID ,      
     [UpdatedBy]  =  @UpdatedBy ,      
     [UpdatedDate]  =  GETDATE(),      
     StubInterestRateOverride = @StubInterestRateOverride,      
     ServicerNameID = @ServicerNameID,      
     BusinessdaylafrelativetoPMTDate = @BusinessdaylafrelativetoPMTDate,      
     DayoftheMonth = @DayoftheMonth,      
     InterestCalculationRuleForPaydowns = @InterestCalculationRuleForPaydowns,      
     PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate = ISNULL(@PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate,4),      
     InterestCalculationRuleForPaydownsAmort = @InterestCalculationRuleForPaydownsAmort ,           
     RoundingNote = @RoundingNote,      
     StraightLineAmortOverride = @StraightLineAmortOverride,      
     --AdjustedTotalCommitment = @AdjustedTotalCommitment,      
     --AggregatedTotal = @AggregatedTotal,       
     RepaymentDayoftheMonth = @RepaymentDayoftheMonth      
     ,MKT_PRICE=@MarketPrice      
     ,StrategyCode=@StrategyCode       
     --,OriginalTotalCommitment = @OriginalTotalCommitment      
     ,NoteTransferDate=@NoteTransferDate      
     ,EnableM61Calculations = @EnableM61Calculations      
     ,InitialRequiredEquity = @InitialRequiredEquity      
     ,InitialAdditionalEquity = @InitialAdditionalEquity          
     ,OriginationFeePercentageRP = @OriginationFeePercentageRP   
  ,ImpactCommitmentCalc  =  @ImpactCommitmentCalc   
  ,FirstIndexDeterminationDateOverride = @FirstIndexDeterminationDateOverride   
   ,AccrualPeriodType = ISNULL(@AccrualPeriodType,811)  
    ,AccrualPeriodBusinessDayAdj = ISNULL(@AccrualPeriodBusinessDayAdj,813)  
	,AccountingClose = @AccountingClose	
	,InterestCalculationRuleForPIKPaydowns=@InterestCalculationRuleForPIKPaydowns
	,UPBAtForeclosure =@UPBAtForeclosure
	,FullIOTermFlag=@FullIOTermFlag
	,NoteType = @NoteType
	,InterestOnlyNote = @InterestOnlyNote
    ,ConstantPaymentMethod = @ConstantPaymentMethod
	,PaymentDateAccrualPeriod = @PaymentDateAccrualPeriod
  
     WHERE NoteID = @NoteID   
    
 ----=========Update column ============  
UPDATE CRE.Note SET CommitmentUsedInFFDistribution = (CASE WHEN CommitmentUsedInFFDistribution is null THEN OriginalTotalCommitment ELSE CommitmentUsedInFFDistribution END) WHERE NoteID = @NoteID;  
--UPDATE CRE.Note SET CommitmentUsedInFFDistribution = (CASE WHEN ISNULL(CommitmentUsedInFFDistribution,0) <> 0 THEN CommitmentUsedInFFDistribution ELSE OriginalTotalCommitment END)   
--WHERE NoteID = @NoteID   
       
--Update UseRuletoDetermineNoteFunding if note is mak=rked as Inactive      
       
update n      
set n.UseRuletoDetermineNoteFunding=(select LookupID from core.lookup where name ='N' and ParentID=2)       
from [CRE].[Note] n      
inner join Core.Account acc on acc.AccountID=n.Account_AccountID       
where acc.StatusID=(select LookupID from core.lookup where name ='Inactive' and ParentID=1)      
      
Exec [dbo].[usp_InsertUserNotification]  @UpdatedBy,'editnote',@NoteID      
      
      
      
      
----@EnableM61Calculations      
IF(@Saved_EnableM61Calculations <> @EnableM61Calculations)      
BEGIN      
 Exec [usp_InsertTransactionEntryFromTransactionEntryManual] @NoteID,@CreatedBy      
END      
      
  
IF(@EnableM61Calculations = 4)      
BEGIN      
 Exec [dbo].[usp_DeleteTransactionForEnableM61CalculationsByNoteID]  @NoteID      
  
    EXEC [dbo].[usp_InsertExceptionsOfCalculatorComponent] @NoteID,null,@CreatedBy  
END      
         
      
      
      
--EXEC [dbo].[usp_UpdateEffectiveDateAsClosingDateByNoteId] @NoteID      
--Delete FF from backshop if note does not have FF in M61      
--exec [usp_DeleteFundingScheduleInBackShop] @CRENoteID      
      
      
 SELECT @newnoteId = @NoteID      
  
END      
      
                 
      
END
GO

