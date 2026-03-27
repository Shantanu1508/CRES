-- Procedure
CREATE PROCEDURE [dbo].[usp_InsertNoteSizerForVSTO]    
(    
 @CreDealID [nvarchar](256),    
 @CRENoteID [nvarchar](256),    
 @name varchar(256),    
 @ClosingDate [date],    
 @BaseCurrencyID [int],    
 @IsCapitalized [int],    
 @LoanType [int],    
 @PayFrequency [int],    
 @InitialMaturityDate [date],    
 @FullyExtendedMaturityDate [date],    
 @ExpectedMaturityDate [date],    
 @OpenPrepaymentDate [date],     
 @ActualPayoffDate date ,    
 @InitialInterestAccrualEndDate [date],    
 @AccrualFrequency [int],    
 @DeterminationDateLeadDays [int],    
 @DeterminationDateReferenceDayoftheMonth [int],    
 @DeterminationDateInterestAccrualPeriod [int],    
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
 @SettleWithAccrualFlag [int],    
 @RateIndexResetFreq [decimal](28,15),    
 @FirstRateIndexResetDate [date],    
 @LoanPurchase [int],    
 @AmortIntCalcDayCount [int],    
 @StubPaidinAdvanceYN [int],    
 @FullPeriodInterestDueatMaturity [int],    
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
 @ExitFeeFreePrepayAmt [decimal](28,15),       
 @ExitFeeAmortCheck [int],    
 @FixedAmortScheduleCheck [int],    
 @TotalCommitmentExtensionFeeisBasedOn [decimal](28, 15) ,    
 @priority int ,    
 @TotalCommitment  [decimal](28,15),    
 @IndexNameID int,    
 @BillingNotesID int,    
 @UpdatedBy [nvarchar](256),    
 @FutureFundingBillingCutoffDay int,    
 @CurtailmentBillingCutoffDay int,    
 @InterestCalculationRuleForPaydowns int,    
 @DebtTypeID int,    
 @CapStack int,    
 @LienPosition int =null ,    
 @InterestCalculationRuleForPaydownsAmort int = null,    
 @DayoftheMonth int = null,    
 @RepaymentDayoftheMonth int = null,    
 @FinancingSourceID int =null,   
 @ServicerNameID int=NULL,
 @NoteID nvarchar(256) OUTPUT    
)     
AS    
begin    
DECLARE @accountID varchar(256)    

SELECT @accountID = n.Account_AccountID 
FROM CRE.Note n inner join core.Account ac on ac.AccountID=n.Account_AccountID    
WHERE n.CRENoteID=@creNoteID   and ac.IsDeleted <> 1   
    
UPDATE [Core].[Account]    
   SET [AccountTypeID] = 1 --- 182     
      ,[Name] = @name          
   ,BaseCurrencyID=@BaseCurrencyID       
   ,PayFrequency=@PayFrequency    
      ,[UpdatedBy] = @UpdatedBy    
   ,IsDeleted =0    
      ,[UpdatedDate] = GETDATE()    
 WHERE AccountID = @accountID    
    
 update [CRE].[Note] set    
    
    ClosingDate    =@ClosingDate   ,    
   IsCapitalized    =@IsCapitalized   ,    
   LoanType    =@LoanType   ,    
   InitialMaturityDate    =@InitialMaturityDate   ,    
   FullyExtendedMaturityDate    =@FullyExtendedMaturityDate   ,    
   ExpectedMaturityDate    =@ExpectedMaturityDate   ,    
   OpenPrepaymentDate    =@OpenPrepaymentDate   ,      
   ActualPayoffDate    =@ActualPayoffDate   ,    
   InitialInterestAccrualEndDate    =@InitialInterestAccrualEndDate   ,    
   AccrualFrequency    =@AccrualFrequency   ,    
   DeterminationDateLeadDays    =@DeterminationDateLeadDays   ,    
   DeterminationDateReferenceDayoftheMonth    =@DeterminationDateReferenceDayoftheMonth   ,    
   DeterminationDateInterestAccrualPeriod    =@DeterminationDateInterestAccrualPeriod   ,    
   FirstPaymentDate    =@FirstPaymentDate   ,    
   InitialMonthEndPMTDateBiWeekly    =@InitialMonthEndPMTDateBiWeekly   ,    
   PaymentDateBusinessDayLag    =@PaymentDateBusinessDayLag   ,    
   IOTerm    =@IOTerm   ,    
   AmortTerm    =@AmortTerm   ,    
   PIKSeparateCompounding    =@PIKSeparateCompounding   ,    
   MonthlyDSOverridewhenAmortizing    =@MonthlyDSOverridewhenAmortizing   ,    
   AccrualPeriodPaymentDayWhenNotEOMonth    =@AccrualPeriodPaymentDayWhenNotEOMonth   ,    
   FirstPeriodInterestPaymentOverride    =@FirstPeriodInterestPaymentOverride   ,    
   FirstPeriodPrincipalPaymentOverride    =@FirstPeriodPrincipalPaymentOverride   ,    
   FinalInterestAccrualEndDateOverride    =@FinalInterestAccrualEndDateOverride   ,    
   AmortType    =@AmortType   ,    
   RateType    =@RateType   ,    
   ReAmortizeMonthly    =@ReAmortizeMonthly   ,    
   ReAmortizeatPMTReset    =@ReAmortizeatPMTReset   ,    
   StubPaidInArrears    =@StubPaidInArrears   ,    
   SettleWithAccrualFlag    =@SettleWithAccrualFlag   ,    
   RateIndexResetFreq    =@RateIndexResetFreq   ,    
   FirstIndexDeterminationDateOverride    =@FirstRateIndexResetDate   ,    
   LoanPurchase    =@LoanPurchase   ,    
   AmortIntCalcDayCount    =@AmortIntCalcDayCount   ,    
   StubPaidinAdvanceYN    =@StubPaidinAdvanceYN   ,    
   InterestDueAtMaturity    =@FullPeriodInterestDueatMaturity   ,    
   Classification    =@Classification   ,    
   SubClassification    =@SubClassification   ,    
   GAAPDesignation    =@GAAPDesignation   ,    
   PortfolioID    =@PortfolioID   ,    
   GeographicLocation    =@GeographicLocation   ,    
   PropertyType    =@PropertyType   ,    
   RatingAgency    =@RatingAgency   ,    
   RiskRating    =@RiskRating   ,    
   PurchasePrice    =@PurchasePrice   ,    
   FutureFeesUsedforLevelYeild  =@FutureFeesUsedforLevelYeild   ,    
   TotalToBeAmortized    =@TotalToBeAmortized   ,    
   StubPeriodInterest    =@StubPeriodInterest   ,    
   WDPAssetMultiple    =@WDPAssetMultiple   ,    
   WDPEquityMultiple    =@WDPEquityMultiple   ,    
   PurchaseBalance    =@PurchaseBalance   ,    
   DaysofAccrued    =@DaysofAccrued   ,    
   InterestRate    =@InterestRate   ,    
   PurchasedInterestCalc    =@PurchasedInterestCalc   ,    
   InitialFundingAmount    =@InitialFundingAmount   ,    
   Discount    =@Discount   ,    
   OriginationFee    =@OriginationFee   ,    
   CapitalizedClosingCosts    =@CapitalizedClosingCosts   ,    
   PurchaseDate    =@PurchaseDate   ,    
   PurchaseAccruedFromDate    =@PurchaseAccruedFromDate   ,    
   PurchasedInterestOverride    =@PurchasedInterestOverride   ,    
   DiscountRate    =@DiscountRate   ,    
   ValuationDate    =@ValuationDate   ,    
   FairValue    =@FairValue   ,    
   DiscountRatePlus =@DiscountRatePlus   ,    
   FairValuePlus    =@FairValuePlus   ,    
   DiscountRateMinus    =@DiscountRateMinus   ,    
   FairValueMinus    =@FairValueMinus   ,    
   InitialIndexValueOverride    =@InitialIndexValueOverride   ,    
   IncludeServicingPaymentOverrideinLevelYield    =@IncludeServicingPaymentOverrideinLevelYield   ,    
   OngoingAnnualizedServicingFee    =@OngoingAnnualizedServicingFee   ,    
   IndexRoundingRule    =@IndexRoundingRule   ,    
   RoundingMethod    =@RoundingMethod   ,    
   StubInterestPaidonFutureAdvances    =@StubInterestPaidonFutureAdvances   ,    
   TaxAmortCheck    =@TaxAmortCheck   ,    
   PIKWoCompCheck    =@PIKWoCompCheck   ,    
   GAAPAmortCheck    =@GAAPAmortCheck   ,    
   StubIntOverride    =@StubIntOverride   ,    
   ExitFeeFreePrepayAmt    =@ExitFeeFreePrepayAmt   ,       
   ExitFeeAmortCheck    =@ExitFeeAmortCheck   ,    
   FixedAmortScheduleCheck    =@FixedAmortScheduleCheck   ,    
   TotalCommitmentExtensionFeeisBasedOn    =@TotalCommitmentExtensionFeeisBasedOn  ,    
   [priority]= @priority,    
   TotalCommitment=@TotalCommitment,    
   OriginalTotalCommitment=@TotalCommitment,    
   IndexNameID=@IndexNameID,    
   UpdatedBy    =@UpdatedBy   ,    
   UpdatedDate    =getdate(),    
   BillingNotesID= @BillingNotesID,    
   FutureFundingBillingCutoffDay  = @FutureFundingBillingCutoffDay,     
   CurtailmentBillingCutoffDay= @CurtailmentBillingCutoffDay ,    
   InterestCalculationRuleForPaydowns = @InterestCalculationRuleForPaydowns ,    
   DebtTypeID = @DebtTypeID ,    
   CapStack = @CapStack,    
   LienPosition=@LienPosition,    
   InterestCalculationRuleForPaydownsAmort =@InterestCalculationRuleForPaydownsAmort,    
DayoftheMonth  =@DayoftheMonth,    
RepaymentDayoftheMonth =@RepaymentDayoftheMonth,  
FinancingSourceID=@FinancingSourceID,
ServicerNameID=@ServicerNameID
  
   where CRENoteID =@CRENoteID    
    
 IF @@ROWCOUNT =0     
BEGIN    
 declare @DealId nvarchar(256)=(select DealID from cre.Deal where creDealID=@creDealID and isdeleted <> 1)  
   
 IF NOT EXISTS(Select n.NoteID from CRE.Note n inner join Core.Account acc on acc.AccountID = n.Account_AccountID where CRENoteID = @CRENoteID and  DealID=@DealId and acc.IsDeleted <> 1)    
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
    ,PayFrequency    
    ,[AccountTypeID]    
    ,[CreatedBy]    
    ,[CreatedDate]    
    ,[UpdatedBy]    
    ,[UpdatedDate]    
 ,IsDeleted    
   )    
   OUTPUT inserted.AccountID INTO @tAccount(tAccountID)    
   VALUES    
   (    
   (Select LookupID from CORE.Lookup where Name = 'Active' and Parentid = 1),    
           
      @name,    
      @CRENoteID,    
      @BaseCurrencyID,        
      @PayFrequency,    
      1, ---182,    
      @UpdatedBy,    
      GETDATE(),    
      @UpdatedBy,    
      GetDATE(),    
   0    
   )    
    
    SELECT @insertedAccountID = tAccountID FROM @tAccount;    
    INSERT INTO [CRE].[Note]    
         ([Account_AccountID]    
       ,[DealID]    
       ,[CRENoteID]    
       ,[ClientNoteID]    
       ,[ClosingDate]    
       ,[IsCapitalized]    
       ,[LoanType]     
       ,[InitialMaturityDate]    
       ,[FullyExtendedMaturityDate]    
       ,[ExpectedMaturityDate]    
       ,[OpenPrepaymentDate]            
       ,ActualPayoffDate    
       ,[InitialInterestAccrualEndDate]    
       ,[AccrualFrequency]    
       ,[DeterminationDateLeadDays]    
       ,[DeterminationDateReferenceDayoftheMonth]    
       ,[DeterminationDateInterestAccrualPeriod]    
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
       ,[SettleWithAccrualFlag]            
       ,[RateIndexResetFreq]    
       ,[FirstIndexDeterminationDateOverride]    
       ,[LoanPurchase]    
       ,[AmortIntCalcDayCount]    
       ,[StubPaidinAdvanceYN]    
       ,[InterestDueAtMaturity]    
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
       ,[ExitFeeFreePrepayAmt]         
       ,[ExitFeeAmortCheck]    
       ,[FixedAmortScheduleCheck]    
       ,TotalCommitmentExtensionFeeisBasedOn    
  ,[priority]    
  ,TotalCommitment    
  ,IndexNameID    
       ,[CreatedBy]    
       ,[CreatedDate]    
       ,[UpdatedBy]    
       ,[UpdatedDate]    
  ,GeneratedBy    
  ,BillingNotesID    
  ,FutureFundingBillingCutoffDay     
  ,CurtailmentBillingCutoffDay     
  ,InterestCalculationRuleForPaydowns     
  ,DebtTypeID     
  ,CapStack    
  ,LienPosition    
  ,OriginalTotalCommitment    
  ,InterestCalculationRuleForPaydownsAmort     
  ,DayoftheMonth      
  ,RepaymentDayoftheMonth     
  ,FinancingSourceID  
  ,ServicerNameID
  ,EnableM61Calculations  
       )    
              
     VALUES    
     (    
       @insertedAccountID    
      ,@DealID    
      ,@CRENoteID    
      ,@CRENoteID    
      ,@ClosingDate    
      ,@IsCapitalized    
      ,@LoanType    
      ,@InitialMaturityDate    
      ,@FullyExtendedMaturityDate     
      ,@ExpectedMaturityDate    
      ,@OpenPrepaymentDate         
      ,@ActualPayoffDate     
      ,@InitialInterestAccrualEndDate    
      ,@AccrualFrequency    
      ,@DeterminationDateLeadDays    
      ,@DeterminationDateReferenceDayoftheMonth    
      ,@DeterminationDateInterestAccrualPeriod    
      ,@FirstPaymentDate    
      ,@InitialMonthEndPMTDateBiWeekly    
      ,@PaymentDateBusinessDayLag    
      ,@IOTerm    
      ,@AmortTerm    
      ,@PIKSeparateCompounding    
      ,@MonthlyDSOverridewhenAmortizing    
      ,@AccrualPeriodPaymentDayWhenNotEOMonth    
      ,@FirstPeriodInterestPaymentOverride    
      ,@FirstPeriodPrincipalPaymentOverride    
      ,@FinalInterestAccrualEndDateOverride    
      ,@AmortType    
      ,@RateType    
      ,@ReAmortizeMonthly    
      ,@ReAmortizeatPMTReset    
      ,@StubPaidInArrears           
      ,@SettleWithAccrualFlag          
      ,@RateIndexResetFreq    
      ,@FirstRateIndexResetDate    
      ,@LoanPurchase    
      ,@AmortIntCalcDayCount    
      ,@StubPaidinAdvanceYN    
      ,@FullPeriodInterestDueatMaturity    
      ,@Classification    
      ,@SubClassification    
      ,@GAAPDesignation    
      ,@PortfolioID    
      ,@GeographicLocation    
      ,@PropertyType    
      ,@RatingAgency    
      ,@RiskRating    
      ,@PurchasePrice    
      ,@FutureFeesUsedforLevelYeild    
      ,@TotalToBeAmortized    
      ,@StubPeriodInterest    
      ,@WDPAssetMultiple    
      ,@WDPEquityMultiple    
      ,@PurchaseBalance    
      ,@DaysofAccrued    
      ,@InterestRate    
      ,@PurchasedInterestCalc    
      ,@InitialFundingAmount    
      ,@Discount    
      ,@OriginationFee    
      ,@CapitalizedClosingCosts    
      ,@PurchaseDate    
      ,@PurchaseAccruedFromDate    
      ,@PurchasedInterestOverride    
      ,@DiscountRate    
      ,@ValuationDate    
      ,@FairValue    
      ,@DiscountRatePlus    
      ,@FairValuePlus    
      ,@DiscountRateMinus    
      ,@FairValueMinus    
      ,@InitialIndexValueOverride    
      ,@IncludeServicingPaymentOverrideinLevelYield    
      ,@OngoingAnnualizedServicingFee    
      ,@IndexRoundingRule    
      ,@RoundingMethod    
      ,@StubInterestPaidonFutureAdvances    
      ,@TaxAmortCheck    
      ,@PIKWoCompCheck    
      ,@GAAPAmortCheck    
      ,@StubIntOverride       
      ,@ExitFeeFreePrepayAmt                 
   ,@ExitFeeAmortCheck    
  ,@FixedAmortScheduleCheck    
  ,@TotalCommitmentExtensionFeeisBasedOn    
  ,@priority    
  ,@TotalCommitment    
  ,@IndexNameID    
  ,@UpdatedBy    
      ,GETDATE()    
      ,@UpdatedBy    
      ,GETDATE()    
   ,(select lookupid from Core.Lookup where ParentID= 36 and name ='By Sizer')    
   ,@BillingNotesID    
   ,@FutureFundingBillingCutoffDay     
   ,@CurtailmentBillingCutoffDay     
   ,@InterestCalculationRuleForPaydowns     
   ,@DebtTypeID     
   ,@CapStack    
   ,@LienPosition    
   ,@TotalCommitment    
   ,@InterestCalculationRuleForPaydownsAmort     
   ,@DayoftheMonth      
   ,@RepaymentDayoftheMonth    
   ,@FinancingSourceID  
   ,@ServicerNameID
   ,3   
   )          
    
  END    
    
    
    
END    
    
 declare @NewNoteID nvarchar(256)     
 --set @NewNoteID=(select NoteID from CRE.Note where ClientNoteID =@CRENoteID)    
 set @NoteID = (select n.NoteID from CRE.Note  n inner join core.Account acc on acc.AccountID = n.Account_AccountID
				WHERE acc.IsDeleted <> 1 and CRENoteID = @CRENoteID)    
    
    exec [App].[usp_AddUpdateObject] @NoteID,182,@UpdatedBy,@UpdatedBy    
    
    
 --Insert Maturity data    
 --exec [dbo].[usp_InsertUpdateMaturityScheduleFromSizer]  @NoteID,@ClosingDate,@InitialMaturityDate,@FullyExtendedMaturityDate,@ActualPayoffDate,@ExpectedMaturityDate,@OpenPrepaymentDate,@UpdatedBy    
    
    UPDATE CRE.Note SET CommitmentUsedInFFDistribution = InitialFundingAmount    
 WHERE NoteID = @NoteID and CommitmentUsedInFFDistribution is null    
    
    
END    
    
     
    