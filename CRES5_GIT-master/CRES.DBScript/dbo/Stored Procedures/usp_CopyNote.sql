  --[dbo].[usp_CopyNote] 'fdd8ec03-9d63-4512-9990-89c508983edc','2567CV1','e2f964ad-7a39-4b70-85f6-1bb93921a122','A-1 Note CV1','b0e6697b-3534-4c09-be0a-04473401ab93'
CREATE PROCEDURE [dbo].[usp_CopyNote]  
	@CopyDealId nvarchar(256) ,
	@CopyCRENewNoteID nvarchar(256) ,
	@ParentNoteID UNIQUEIDENTIFIER, 
	@CopyNoteName nvarchar(256) ,  
	@CreatedBy nvarchar(256)  ,
	@newnoteId varchar(256) OUTPUT   
AS  
BEGIN
  


 -- Declare @ParentNoteID UNIQUEIDENTIFIER='e2f964ad-7a39-4b70-85f6-1bb93921a122'
 --Declare @CopyNoteName nvarchar(256) ='A-1 Note CV2'
 -- Declare @CopyCRENewNoteID nvarchar(256)  ='2567CV2'
 -- Declare @ParentDealId nvarchar(256)='fdd8ec03-9d63-4512-9990-89c508983edc'
 --Declare @CreatedBy nvarchar(256) ='b0e6697b-3534-4c09-be0a-04473401ab93'

DECLARE @tAccount TABLE (tAccountID UNIQUEIDENTIFIER)
DECLARE @tNote TABLE (tNewNoteId UNIQUEIDENTIFIER)
Declare  @CopyNoteID UNIQUEIDENTIFIER
Declare @ParentAccountID UNIQUEIDENTIFIER  
Declare @CopyAccountID UNIQUEIDENTIFIER  
  
Declare @AnalysisIDDefault uniqueidentifier  
  
  

  --set @ParentAccountID = (Select top 1 Account_AccountID from cre.note where NoteID = @ParentNoteID)  
  --select @ParentAccountID

  
Declare  @BalanceTransactionSchedule  int  =5;  
Declare  @DefaultSchedule  int  =6;  
Declare  @FeeCouponSchedule  int  =7;  
Declare  @FinancingFeeSchedule  int  =8;  
Declare  @FinancingSchedule  int  =9;  
Declare  @FundingSchedule  int  =10;  
--Declare  @Maturity  int  =11;  
Declare  @MaturitySchedule  int  =11;  
Declare  @PIKSchedule  int  =12;  
Declare  @PrepayAndAdditionalFeeSchedule  int  =13;  
Declare  @RateSpreadSchedule  int  =14;  
Declare  @ServicingFeeSchedule  int  =15;  
Declare  @StrippingSchedule  int  =16;  
Declare  @PIKScheduleDetail  int  =17;  
Declare  @LIBORSchedule  int  =18;  
Declare  @AmortSchedule  int  =19;  
Declare  @FeeCouponStripReceivable  int  =20;   
  
SET @ParentAccountID = (Select top 1 Account_AccountID from cre.note where NoteID = @ParentNoteID)  
--SET @CopyAccountID = (Select top 1 Account_AccountID from cre.note where NoteID = @CopyNoteID)  
Set @AnalysisIDDefault = (Select AnalysisID from core.Analysis where Name = 'Default')  



INSERT INTO [Core].[Account]([AccountTypeID]
		  ,[StatusID]
		  ,[Name]
		  ,[StartDate]
		  ,[EndDate]
		  ,[BaseCurrencyID]
		  ,[PayFrequency]
		  ,[ClientNoteID]
		  ,[CreatedBy]
		  ,[CreatedDate]
		  ,[UpdatedBy]
		  ,[UpdatedDate]
		  ,IsDeleted)
		 OUTPUT inserted.AccountID INTO @tAccount(tAccountID)
			Select 1,  ---182,
				[StatusID],
				@CopyNoteName,		
				StartDate,
				EndDate,					
				BaseCurrencyID,
				PayFrequency,
				@CopyCRENewNoteID,			
				@CreatedBy,
				GETDATE(),
				@CreatedBy,
				GetDATE(),0 from [Core].[Account]  with (NOLOCK)  where AccountID=@ParentAccountID and IsDeleted=0

  SELECT @CopyAccountID = tAccountID FROM @tAccount;




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
      ,[SelectedMaturityDate]
      ,[InitialMaturityDate]
      ,[ExpectedMaturityDate]
      ,[FullyExtendedMaturityDate]
      ,[OpenPrepaymentDate]
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
      ,[GeneratedBy]
      ,[UseRuletoDetermineNoteFunding]
      ,[NoteFundingRule]
      ,[FundingPriority]
      ,[NoteBalanceCap]
      ,[RepaymentPriority]
      ,[NoofdaysrelPaymentDaterollnextpaymentcycle]
      ,[UseIndexOverrides]
      ,[IndexNameID]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
      ,[ServicerID]
      ,[TotalCommitment]
      ,[ClientName]
      ,[Portfolio]
      ,[Tag1]
      ,[Tag2]
      ,[Tag3]
      ,[Tag4]
      --,[ExtendedMaturityScenario1]
     -- ,[ExtendedMaturityScenario2]
     -- ,[ExtendedMaturityScenario3]
      ,[ActualPayoffDate]
      ,[TotalCommitmentExtensionFeeisBasedOn]
      ,[LienPriority]
	  ,[priority]
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
			,[StubInterestRateOverride]
			,ServicerNameID
			,BusinessdaylafrelativetoPMTDate
			,DayoftheMonth
			,InterestCalculationRuleForPaydowns
			,PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate
			,lienposition
			,InterestCalculationRuleForPaydownsAmort	
			,AdjustedTotalCommitment	
			,AggregatedTotal	
			,RoundingNote	
			,StraightLineAmortOverride	
			,RepaymentDayoftheMonth	
			,FutureFundingBillingCutoffDay	
			,CurtailmentBillingCutoffDay
			,UseRuletoDetermineAmortization
			,MKT_PRICE
			,OriginalTotalCommitment
			,StrategyCode
			,EnableM61Calculations
			,InitialRequiredEquity
		    ,InitialAdditionalEquity
			,CommitmentUsedInFFDistribution
			,ExtendedMaturityCurrent
			,FirstIndexDeterminationDateOverride
			,AccrualPeriodType
			,AccrualPeriodBusinessDayAdj
			,AccountingClose
            ,TaxVendorLoanNumber
			)
	   	OUTPUT inserted.NoteID INTO @tNote(tNewNoteId)
		select	@CopyAccountID
           ,@CopyDealId
           ,@CopyCRENewNoteID
		   ,@CopyNoteName
           ,[Comments]
      ,n.[InitialInterestAccrualEndDate]
      ,n.[AccrualFrequency]
      ,n.[DeterminationDateLeadDays]
      ,[DeterminationDateReferenceDayoftheMonth]
      ,n.[DeterminationDateInterestAccrualPeriod]
      ,n.[DeterminationDateHolidayList]
      ,n.[FirstPaymentDate]
      ,n.[InitialMonthEndPMTDateBiWeekly]
      ,n.[PaymentDateBusinessDayLag]
      ,n.[IOTerm]
      ,n.[AmortTerm]
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
      ,[SelectedMaturityDate]
      ,[InitialMaturityDate]
      ,[ExpectedMaturityDate]
      ,[FullyExtendedMaturityDate]
      ,[OpenPrepaymentDate]
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
      ,(select lookupID from core.lookup where Name='Copy Note')
      ,[UseRuletoDetermineNoteFunding]
      ,[NoteFundingRule]
      ,[FundingPriority]
      ,[NoteBalanceCap]
      ,[RepaymentPriority]
      ,[NoofdaysrelPaymentDaterollnextpaymentcycle]
      ,[UseIndexOverrides]
      ,[IndexNameID]
      ,n.[CreatedBy]
      ,n.[CreatedDate]
      ,n.[UpdatedBy]
      ,n.[UpdatedDate]
      ,[ServicerID]
      ,[TotalCommitment]
      ,[ClientName]
      ,[Portfolio]
      ,[Tag1]
      ,[Tag2]
      ,[Tag3]
      ,[Tag4]
     -- ,[ExtendedMaturityScenario1]
     -- ,[ExtendedMaturityScenario2]
     -- ,[ExtendedMaturityScenario3]
      ,[ActualPayoffDate]
      ,[TotalCommitmentExtensionFeeisBasedOn]
      ,[LienPriority]
	  ,[priority]
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
		,[StubInterestRateOverride]
		,ServicerNameID
		,BusinessdaylafrelativetoPMTDate
		,DayoftheMonth
		,InterestCalculationRuleForPaydowns
		,PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate
		,lienposition
		,InterestCalculationRuleForPaydownsAmort	
		,AdjustedTotalCommitment	
		,AggregatedTotal	
		,RoundingNote	
		,StraightLineAmortOverride	
		,RepaymentDayoftheMonth	
		,FutureFundingBillingCutoffDay	
		,CurtailmentBillingCutoffDay
		,UseRuletoDetermineAmortization
		,MKT_PRICE
		,OriginalTotalCommitment
		,StrategyCode
		,EnableM61Calculations
		,InitialRequiredEquity
		,InitialAdditionalEquity
		,CommitmentUsedInFFDistribution
		,ExtendedMaturityCurrent
		,FirstIndexDeterminationDateOverride
		,AccrualPeriodType
		,AccrualPeriodBusinessDayAdj
		,AccountingClose
        ,'NA' as TaxVendorLoanNumber
		from cre.note n with (NOLOCK)
		inner join Core.Account acc with (NOLOCK) on n.Account_AccountID=acc.AccountID
		where [Account_AccountID]=@ParentAccountID and acc.isdeleted=0

  SELECT @CopyNoteID = tNewNoteId FROM @tNote;
   SELECT @newnoteId = tNewNoteId FROM @tNote;
    
 INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue,StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)  
  SELECT DISTINCT  
    EffectiveStartDate,  
    @CopyAccountID,  
    GETDATE(),  
    EventTypeID,  
    SingleEventValue,  
    StatusID,  
    @CreatedBy,  
    GETDATE(),  
    @CreatedBy,  
    GETDATE()   
  FROM Core.Event  with (NOLOCK) where AccountID=@ParentAccountID and eventtypeid=@MaturitySchedule and StatusID = 1  
  
  
--1.MaturitySchedule   
  
 IF(@@ROWCOUNT > 0)  
 BEGIN  
INSERT INTO core.Maturity (EventId, SelectedMaturityDate, MaturityDate,MaturityType,Approved,CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)  
 SELECT (SELECT TOP 1  
             EventId  
           FROM CORE.[event] se with (NOLOCK)  
           WHERE se.[EffectiveStartDate] = CONVERT(date, e.EffectiveStartDate, 101)  
           AND se.[EventTypeID] = @MaturitySchedule and se.StatusID = 1  
           AND se.AccountID = @CopyAccountID),  
           CONVERT(date, mt.SelectedMaturityDate, 101),    
      CONVERT(date, mt.MaturityDate, 101),   
   mt.MaturityType,  
   mt.Approved,         
     @CreatedBy,  
   GETDATE(),  
   @CreatedBy,  
   GETDATE()   
    FROM Core.Maturity mt  with (NOLOCK)   
 inner join core.Event e   with (NOLOCK) on e.eventid =  mt.EventId  
 inner join core.Account acc   with (NOLOCK) on acc.AccountID =  e.AccountID  
    WHERE acc.AccountID = @ParentAccountID  and e.StatusID = 1 
  
 END  
  
  
 --2.RateSpreadSchedule  
   
 INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue,StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)   
  SELECT DISTINCT  
      EffectiveStartDate,  
      @CopyAccountID,  
      GETDATE(),  
      EventTypeID,  
      SingleEventValue,  
   StatusID,  
      @CreatedBy,  
   GETDATE(),  
   @CreatedBy,  
   GETDATE()   
   -- FROM Core.Event with (NOLOCK) where AccountID=@c_accountid and eventtypeid=@RateSpreadSchedule  
  FROM Core.Event  with (NOLOCK) where AccountID=@ParentAccountID and eventtypeid=@RateSpreadSchedule and StatusID = 1  
IF(@@ROWCOUNT > 0)  
BEGIN  
	INSERT INTO core.RateSpreadSchedule (EventId, Date, ValueTypeID, Value, IntCalcMethodID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate,IndexNameID)  
	Select EventId, Date, ValueTypeID, Value, IntCalcMethodID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate,IndexNameID 
	from (
		SELECT (SELECT TOP 1  
			EventId  
			FROM CORE.[event] se with (NOLOCK)   
			WHERE se.[EffectiveStartDate] = CONVERT(date, e.EffectiveStartDate, 101)  
			AND se.[EventTypeID] = 14 --and StatusID = 1  
			AND se.AccountID = @CopyAccountID) eventid,  
		CONVERT(date, rs.[Date], 101) [Date],  
		ValueTypeID,  
		Value,  
		IntCalcMethodID,  
		@CreatedBy as CreatedBy,  
		GETDATE() as Createddate,  
		@CreatedBy as UpdatedBy,  
		GETDATE() as Updateddate,
		rs.IndexNameID 
		FROM Core.RateSpreadSchedule rs with (NOLOCK)   
		inner join core.Event e  with (NOLOCK) on e.eventid =  rs.EventId  
		inner join core.Account acc  with (NOLOCK) on acc.AccountID =  e.AccountID  
		WHERE rs.[date] is not null and ValueTypeID IS NOT NULL  
		and acc.AccountID = @ParentAccountID
	)a
	where eventid is not null

   
END  
  
  
  
-- 3.PrepayAndAdditionalFeeSchedule  
  
  
  INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue,StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)  
     SELECT DISTINCT  
      EffectiveStartDate,  
      @CopyAccountID,  
      GETDATE(),  
      EventTypeID,  
      SingleEventValue,  
   StatusID,  
      @CreatedBy,  
   GETDATE(),  
   @CreatedBy,  
   GETDATE()   
  FROM Core.Event  with (NOLOCK) where AccountID=@ParentAccountID and eventtypeid=@PrepayAndAdditionalFeeSchedule  
  
    
IF(@@ROWCOUNT > 0)  
BEGIN  
   INSERT INTO core.PrepayAndAdditionalFeeSchedule (EventId, StartDate, ValueTypeID, Value, IncludedLevelYield, IncludedBasis, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate,FeeName,EndDate,FeeAmountOverride,BaseAmountOverride,ApplyTrueUpFeature,FeetobeStripped)  
     SELECT (SELECT TOP 1  
             EventId  
           FROM CORE.[event] se with (NOLOCK)   
           WHERE se.[EffectiveStartDate] = CONVERT(date, e.EffectiveStartDate, 101)  
           AND se.[EventTypeID] = @PrepayAndAdditionalFeeSchedule  
           AND se.AccountID = @CopyAccountID),  
           CONVERT(date, pre.StartDate, 101),  
           ValueTypeID,  
           Value,  
           IncludedLevelYield,  
     IncludedBasis,  
     @CreatedBy,  
   GETDATE(),  
   @CreatedBy,  
   GETDATE() ,  
 FeeName,pre.EndDate,FeeAmountOverride,BaseAmountOverride,ApplyTrueUpFeature,FeetobeStripped  
    FROM Core.PrepayAndAdditionalFeeSchedule pre with (NOLOCK)   
 inner join core.Event e  with (NOLOCK) on e.eventid =  pre.EventId  
 inner join core.Account acc  with (NOLOCK) on acc.AccountID =  e.AccountID  
    WHERE pre.StartDate is not null and ValueTypeID IS NOT NULL  
 and acc.AccountID = @ParentAccountID  
END  
  
    
  
-----4.Stripping  
  
  INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue,StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)  
   SELECT DISTINCT  
      EffectiveStartDate,  
      @CopyAccountID,  
      GETDATE(),  
      EventTypeID,  
      SingleEventValue,  
   StatusID,  
      @CreatedBy,  
   GETDATE(),  
   @CreatedBy,  
   GETDATE()   
    FROM Core.Event  with (NOLOCK) where AccountID=@ParentAccountID and eventtypeid=@StrippingSchedule  
  
    
IF(@@ROWCOUNT > 0)  
BEGIN  
  INSERT INTO core.StrippingSchedule (EventId, StartDate, ValueTypeID, Value, IncludedLevelYield, IncludedBasis, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)  
   SELECT (SELECT TOP 1  
             EventId  
           FROM CORE.[event] se with (NOLOCK)   
           WHERE se.[EffectiveStartDate] = CONVERT(date, e.EffectiveStartDate, 101)  
           AND se.[EventTypeID] = @StrippingSchedule  
           AND se.AccountID = @CopyAccountID),  
           CONVERT(date, st.StartDate, 101),  
           ValueTypeID,  
           Value,  
           IncludedLevelYield,  
     IncludedBasis,  
     @CreatedBy,  
   GETDATE(),  
   @CreatedBy,  
   GETDATE()   
    FROM Core.StrippingSchedule st with (NOLOCK)   
 inner join core.Event e on e.eventid =  st.EventId  
 inner join core.Account acc on acc.AccountID =  e.AccountID  
    WHERE st.StartDate is not null and ValueTypeID IS NOT NULL  
 and acc.AccountID = @ParentAccountID  
END  
  
  
   
----5.FinancingFeeSchedule  
  
INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue,StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)  
      SELECT DISTINCT  
      EffectiveStartDate,  
      @CopyAccountID,  
      GETDATE(),  
      EventTypeID,  
      SingleEventValue,  
   StatusID,  
      @CreatedBy,  
   GETDATE(),  
   @CreatedBy,  
   GETDATE()   
 FROM Core.Event  with (NOLOCK) where AccountID=@ParentAccountID and eventtypeid=@FinancingFeeSchedule  
  
  
IF(@@ROWCOUNT > 0)  
BEGIN  
    INSERT INTO core.FinancingFeeSchedule (EventId, Date, ValueTypeID, Value, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)  
    SELECT (SELECT TOP 1  
             EventId  
           FROM CORE.[event] se with (NOLOCK)   
           WHERE se.[EffectiveStartDate] = CONVERT(date, e.EffectiveStartDate, 101)  
           AND se.[EventTypeID] = @FinancingFeeSchedule  
           AND se.AccountID = @CopyAccountID),  
           CONVERT(date, fs.Date, 101),  
           ValueTypeID,  
           Value,            
     @CreatedBy,  
   GETDATE(),  
   @CreatedBy,  
   GETDATE()   
    FROM Core.FinancingFeeSchedule fs with (NOLOCK)   
 inner join core.Event e  with (NOLOCK) on e.eventid =  fs.EventId  
 inner join core.Account acc  with (NOLOCK) on acc.AccountID =  e.AccountID  
    WHERE fs.Date is not null and ValueTypeID IS NOT NULL  
 and acc.AccountID = @ParentAccountID  
  
END  
  
  
------6.FundingSchedule  

INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue,StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
  SELECT DISTINCT
      EffectiveStartDate,
      @CopyAccountID,
      GETDATE(),
      EventTypeID,
      SingleEventValue,
	  StatusID,
      @CreatedBy,
	  GETDATE(),
	  @CreatedBy,
	  GETDATE()	
 FROM Core.Event  with (NOLOCK) where AccountID=@ParentAccountID and eventtypeid=@FinancingSchedule
 
IF(@@ROWCOUNT > 0)
BEGIN
	INSERT INTO core.FinancingSchedule (EventId, Date, ValueTypeID, Value,IndexTypeID, IntCalcMethodID, CurrencyCode, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
	SELECT (SELECT TOP 1
             EventId
           FROM CORE.[event] se with (NOLOCK)
           WHERE se.[EffectiveStartDate] = CONVERT(date, e.EffectiveStartDate, 101)
           AND se.[EventTypeID] = @FinancingSchedule
           AND se.AccountID = @CopyAccountID),
           CONVERT(date, fsh.Date, 101),
           ValueTypeID,
           Value,  
		   IndexTypeID, 
		   IntCalcMethodID,
		   CurrencyCode,        
		   @CreatedBy,
	  GETDATE(),
	  @CreatedBy,
	  GETDATE()	
    FROM Core.FinancingSchedule fsh with (NOLOCK) 
	inner join core.Event e  with (NOLOCK) on e.eventid =  fsh.EventId
	inner join core.Account acc  with (NOLOCK) on acc.AccountID =  e.AccountID
    WHERE fsh.Date is not null and ValueTypeID IS NOT NULL
	and acc.AccountID = @ParentAccountID 

END

  
 ----7.DefaultSchedule  
  
  
INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue,StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)  
     SELECT DISTINCT  
      EffectiveStartDate,  
      @CopyAccountID,  
      GETDATE(),  
      EventTypeID,  
      SingleEventValue,  
   StatusID,  
      @CreatedBy,  
   GETDATE(),  
   @CreatedBy,  
   GETDATE()   
 FROM Core.Event  with (NOLOCK) where AccountID=@ParentAccountID and eventtypeid=@DefaultSchedule  
    
IF(@@ROWCOUNT > 0)  
BEGIN  
    INSERT INTO core.DefaultSchedule (EventId, StartDate,EndDate, ValueTypeID, Value, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)  
     SELECT (SELECT TOP 1  
             EventId  
           FROM CORE.[event] se  
           WHERE se.[EffectiveStartDate] = CONVERT(date, e.EffectiveStartDate, 101)  
           AND se.[EventTypeID] = @DefaultSchedule  
           AND se.AccountID = @CopyAccountID),  
           CONVERT(date, dsh.StartDate, 101),  
       CONVERT(date, dsh.EndDate, 101),  
           ValueTypeID,  
           Value,            
     @CreatedBy,  
   GETDATE(),  
   @CreatedBy,  
   GETDATE()   
    FROM Core.DefaultSchedule dsh  with (NOLOCK)  
 inner join core.Event e on e.eventid =  dsh.EventId  
 inner join core.Account acc on acc.AccountID =  e.AccountID  
    WHERE dsh.StartDate is not null and ValueTypeID IS NOT NULL  
 and acc.AccountID = @ParentAccountID  
  
  
  
 END  
  
----8.PIKSchedule  
  
INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue,StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)  
  SELECT DISTINCT  
      EffectiveStartDate,  
      @CopyAccountID,  
      GETDATE(),  
EventTypeID,  
      SingleEventValue,  
   StatusID,  
      @CreatedBy,  
   GETDATE(),  
   @CreatedBy,  
   GETDATE()   
 FROM Core.Event  with (NOLOCK) where AccountID=@ParentAccountID and eventtypeid=@PIKSchedule  
  
   
  IF(@@ROWCOUNT > 0)  
BEGIN  
INSERT INTO core.PIKSchedule (EventID,SourceAccountID,TargetAccountID,AdditionalIntRate,AdditionalSpread,IndexFloor,IntCompoundingRate,IntCompoundingSpread,StartDate,EndDate,IntCapAmt,PurBal,AccCapBal,CreatedBy, CreatedDate,UpdatedBy,UpdatedDate, [PIKReasonCodeID],[PIKComments],[PIKIntCalcMethodID],PeriodicRateCapAmount ,PeriodicRateCapPercent)  
     SELECT (SELECT TOP 1  
             EventId  
           FROM CORE.[event] se  
           WHERE se.[EffectiveStartDate] = CONVERT(date, e.EffectiveStartDate, 101)  
           AND se.[EventTypeID] = @PIKSchedule  
           AND se.AccountID = @CopyAccountID),  
          SourceAccountID,  
    TargetAccountID,  
    AdditionalIntRate,  
    AdditionalSpread,  
    IndexFloor,  
    IntCompoundingRate,  
    IntCompoundingSpread,  
    CONVERT(date, PIK.StartDate, 101),  
     CONVERT(date, PIK.EndDate, 101),    
    IntCapAmt,  
    PurBal,  
    AccCapBal,           
     @CreatedBy,  
   GETDATE(),  
   @CreatedBy,  
   GETDATE()  ,

	[PIKReasonCodeID],
	[PIKComments],
	[PIKIntCalcMethodID] ,
	PeriodicRateCapAmount ,
	PeriodicRateCapPercent
    FROM Core.PIKSchedule PIK  with (NOLOCK)  
 inner join core.Event e  with (NOLOCK) on e.eventid =  PIK.EventId  
 inner join core.Account acc  with (NOLOCK) on acc.AccountID =  e.AccountID  
    WHERE PIK.StartDate is not null   
 and acc.AccountID = @ParentAccountID  
 END  
  
  
-----9.ServicingFeeSchedule  
  
INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue,StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)  
 SELECT DISTINCT  
      EffectiveStartDate,  
      @CopyAccountID,  
      GETDATE(),  
      EventTypeID,  
      SingleEventValue,  
   StatusID,  
      @CreatedBy,  
   GETDATE(),  
   @CreatedBy,  
   GETDATE()   
 FROM Core.Event  with (NOLOCK) where AccountID=@ParentAccountID and eventtypeid=@ServicingFeeSchedule  
  
  
   IF(@@ROWCOUNT > 0)  
BEGIN  
 INSERT INTO core.ServicingFeeSchedule (EventId,Date,Value,IsCapitalized, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)  
    SELECT (SELECT TOP 1  
             EventId  
           FROM CORE.[event] se  
           WHERE se.[EffectiveStartDate] = CONVERT(date, e.EffectiveStartDate, 101)  
           AND se.[EventTypeID] = @ServicingFeeSchedule  
           AND se.AccountID = @CopyAccountID),  
           CONVERT(date, ser.Date, 101),  
           Value,  
     IsCapitalized,            
     @CreatedBy,  
   GETDATE(),  
   @CreatedBy,  
   GETDATE()   
    FROM Core.ServicingFeeSchedule ser  with (NOLOCK)  
 inner join core.Event e  with (NOLOCK) on e.eventid =  ser.EventId  
 inner join core.Account acc  with (NOLOCK) on acc.AccountID =  e.AccountID  
    WHERE ser.Date is not null   
 and acc.AccountID = @ParentAccountID  
END  
  
--END  
----10.FundingSchedule  
  
  
--INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue,StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)  
--    SELECT DISTINCT  
--      EffectiveStartDate,  
--      @CopyAccountID,  
--      GETDATE(),  
--      EventTypeID,  
--      SingleEventValue,  
--   StatusID,  
--      @CreatedBy,  
--   GETDATE(),  
--   @CreatedBy,  
--   GETDATE()   
-- FROM Core.Event  with (NOLOCK) where AccountID=@ParentAccountID and eventtypeid=@FundingSchedule and StatusID = 1  
   
  
  
--IF(@@ROWCOUNT > 0)  
--BEGIN  
-- INSERT INTO core.FundingSchedule (EventId, Date, Value,PurposeID,Applied,Issaved, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate,DrawFundingId,Comments,DealFundingRowno)  
-- SELECT (SELECT TOP 1  
--    EventId  
--   FROM CORE.[event] se  
--   WHERE se.[EffectiveStartDate] = CONVERT(date, e.EffectiveStartDate, 101)  
--   AND se.[EventTypeID] = @FundingSchedule and StatusID = 1  
--   AND se.AccountID = @CopyAccountID),  
--   CONVERT(date, fd.Date, 101),  
--   Value,   
--   PurposeID,  
--   Applied,  
--   Issaved,              
--   @CreatedBy,  
--  GETDATE(),  
--  @CreatedBy,  
--  GETDATE() ,  
--  DrawFundingId,  
--  Comments,  
--  DealFundingRowno  
  
-- FROM Core.FundingSchedule fd  with (NOLOCK)  
-- inner join core.Event e  with (NOLOCK) on e.eventid =  fd.EventId  
-- inner join core.Account acc  with (NOLOCK) on acc.AccountID =  e.AccountID  
-- WHERE fd.Date is not null   
-- and e.StatusID = 1  
-- and acc.AccountID = @ParentAccountID  
  
--  END  
  
  
  
----11.PIKScheduleDetail  
  
  
INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue,StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)  
    SELECT DISTINCT  
      EffectiveStartDate,  
      @CopyAccountID,  
      GETDATE(),  
      EventTypeID,  
      SingleEventValue,  
   StatusID,  
      @CreatedBy,  
   GETDATE(),  
   @CreatedBy,  
   GETDATE()   
 FROM Core.Event  with (NOLOCK) where AccountID=@ParentAccountID and eventtypeid=@PIKScheduleDetail  
  
    IF(@@ROWCOUNT > 0)  
BEGIN  
    INSERT INTO core.PIKScheduleDetail (EventId, Date, Value, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)  
     SELECT (SELECT TOP 1  
             EventId  
           FROM CORE.[event] se  with (NOLOCK)  
           WHERE se.[EffectiveStartDate] = CONVERT(date, e.EffectiveStartDate, 101)  
           AND se.[EventTypeID] = @PIKScheduleDetail  
           AND se.AccountID = @CopyAccountID),  
           CONVERT(date, piks.Date, 101),  
           Value,               
     @CreatedBy,  
   GETDATE(),  
   @CreatedBy,  
   GETDATE()   
    FROM Core.PIKScheduleDetail piks  with (NOLOCK)  
 inner join core.Event e  with (NOLOCK) on e.eventid =  piks.EventId  
 inner join core.Account acc  with (NOLOCK) on acc.AccountID =  e.AccountID  
    WHERE piks.Date is not null   
 and acc.AccountID = @ParentAccountID  
END  
  
----12.LIBORSchedule  
  
INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue,StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)  
      SELECT DISTINCT  
      EffectiveStartDate,  
      @CopyAccountID,  
      GETDATE(),  
      EventTypeID,  
      SingleEventValue,  
   StatusID,  
      @CreatedBy,  
   GETDATE(),  
   @CreatedBy,  
   GETDATE()   
 FROM Core.Event  with (NOLOCK) where AccountID=@ParentAccountID and eventtypeid=@LIBORSchedule  
  
    IF(@@ROWCOUNT > 0)  
 BEGIN  
    INSERT INTO core.LIBORSchedule (EventId, Date, Value, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)  
     SELECT (SELECT TOP 1  
             EventId  
           FROM CORE.[event] se  with (NOLOCK)  
           WHERE se.[EffectiveStartDate] = CONVERT(date, e.EffectiveStartDate, 101)  
           AND se.[EventTypeID] = @LIBORSchedule  
           AND se.AccountID = @CopyAccountID),  
           CONVERT(date, lb.Date, 101),  
           Value,               
     @CreatedBy,  
   GETDATE(),  
   @CreatedBy,  
   GETDATE()   
    FROM Core.LIBORSchedule lb  with (NOLOCK)  
 inner join core.Event e  with (NOLOCK) on e.eventid =  lb.EventId  
 inner join core.Account acc  with (NOLOCK) on acc.AccountID =  e.AccountID  
    WHERE lb.Date is not null   
 and acc.AccountID = @ParentAccountID  
 END  
--  ---13.AmortSchedule  
  
  
INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue,StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)  
       SELECT DISTINCT  
      EffectiveStartDate,  
      @CopyAccountID,  
      GETDATE(),  
      EventTypeID,  
      SingleEventValue,  
   StatusID,  
      @CreatedBy,  
   GETDATE(),  
   @CreatedBy,  
   GETDATE()   
 FROM Core.Event  with (NOLOCK) where AccountID=@ParentAccountID and eventtypeid=@AmortSchedule  
  
    IF(@@ROWCOUNT > 0)  
 BEGIN  
   INSERT INTO core.AmortSchedule (EventId, Date, Value, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate,DealAmortScheduleRowno)  
     SELECT (SELECT TOP 1  
             EventId  
           FROM CORE.[event] se  with (NOLOCK)  
           WHERE se.[EffectiveStartDate] = CONVERT(date, se.EffectiveStartDate, 101)  
           AND se.[EventTypeID] = @AmortSchedule  
           AND se.AccountID = @CopyAccountID),  
           CONVERT(date, ams.Date, 101),  
           Value,               
     @CreatedBy,  
   GETDATE(),  
   @CreatedBy,  
   GETDATE(),  
   DealAmortScheduleRowno  
    FROM Core.AmortSchedule ams  with (NOLOCK)  
 inner join core.Event e  with (NOLOCK) on e.eventid =  ams.EventId  
 inner join core.Account acc  with (NOLOCK) on acc.AccountID =  e.AccountID  
    WHERE ams.Date is not null   
 and acc.AccountID = @ParentAccountID  
 END  
  
  
--  --14.FeeCouponStripReceivable  
  
  
INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue,StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)  
      SELECT DISTINCT  
      EffectiveStartDate,  
      @CopyAccountID,  
      GETDATE(),  
      EventTypeID,  
      SingleEventValue,  
   StatusID,  
      @CreatedBy,  
   GETDATE(),  
   @CreatedBy,  
   GETDATE()   
 FROM Core.Event  with (NOLOCK) where AccountID=@ParentAccountID and eventtypeid=@FeeCouponStripReceivable  
  
    IF(@@ROWCOUNT > 0)  
 BEGIN  
   INSERT INTO core.FeeCouponStripReceivable (EventId, Date, Value, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)  
   SELECT (SELECT TOP 1  
             EventId  
           FROM CORE.[event] se  with (NOLOCK)  
           WHERE se.[EffectiveStartDate] = CONVERT(date, e.EffectiveStartDate, 101)  
           AND se.[EventTypeID] = @FeeCouponStripReceivable  
           AND se.AccountID = @CopyAccountID),  
           CONVERT(date, fc.Date, 101),  
           Value,               
     @CreatedBy,  
   GETDATE(),  
   @CreatedBy,  
   GETDATE()   
    FROM Core.FeeCouponStripReceivable fc  with (NOLOCK)  
 inner join core.Event e  with (NOLOCK) on e.eventid =  fc.EventId  
 inner join core.Account acc  with (NOLOCK) on acc.AccountID =  e.AccountID  
    WHERE fc.Date is not null   
 and acc.AccountID = @ParentAccountID  
 END  
  
  
 ------Market Price  
 --INSERT INTO CRE.NoteAttributesbyDate(  
 --    NoteID,  
 --    [Date],  
 --    [Value],  
 --    ValueTypeID,  
 --    CreatedBy,  
 --    CreatedDate,  
 --    UpdatedBy,  
 --    UpdatedDate,  
 --    GeneratedBy)  
 --  SELECT @CopyCRENewNoteID,  
 --  [Date],  
 --  [Value],  
 --  ValueTypeID,  
 --  CreatedBy,  
 --  CreatedDate,  
 --  UpdatedBy,  
 --  UpdatedDate,  
 --  GeneratedBy   
 -- FROM CRE.NoteAttributesbyDate  
 -- WHERE CRE.NoteAttributesbyDate.NoteID = (SELECT n.CRENoteID FROM CRE.Note n WHERE n.NoteID=@ParentNoteID)  
  
  
 ---Exceptions 111  
  
 INSERT INTO core.Exceptions (ObjectID,ObjectTypeID,FieldName,Summary,ActionLevelID,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate)  
 select @CopyNoteID,ObjectTypeID,FieldName,Summary,ActionLevelID,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate  
from core.Exceptions  
 WHERE ObjectID=@ParentNoteID  
  
  --Funding Rules  
  insert into [CRE].[FundingRepaymentSequence](NoteID,SequenceNo,SequenceType,Value,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate)  
  select @CopyNoteID,SequenceNo,SequenceType,Value,@CreatedBy,GETDATE(),@CreatedBy,GETDATE() from [CRE].[FundingRepaymentSequence]   where NoteID=@ParentNoteID  
  
  
  INSERT INTO CRE.PayruleDistributions (TransactionDate,SourceNoteID,ReceiverNoteID,RuleID,Amount,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate)    
 select   
   distinct nc.PeriodEndDate  
   ,@CopyNoteID  
   ,ps.StripTransferTo  
   ,ps.RuleID  
   ,case when ps.RuleID=163 then  
   (TotalCouponStrippedforthePeriod * ps.value)   
    when ps.RuleID=164 then  
   (ExitFeeStrippingExcldfromLevelYield *ps.value)  
  when ps.RuleID=165  then  
   (OriginationFeeStripping *ps.value)  
  when ps.RuleID=166 then  
   (AddlFeesStrippingExcldfromLevelYield*ps.value)  end as Amount  
   ,@CreatedBy  
   ,GETDATE()  
   ,@CreatedBy  
   ,GETDATE()  
  from CRE.NotePeriodicCalc nc  
  Inner Join core.Account acc on acc.AccountID = nc.AccountID
  Inner Join cre.note n on n.Account_AccountID = acc.AccountID
  inner join CRE.PayruleSetup ps on ps.StripTransferFrom=n.NoteID   
  where n.NoteID=@ParentNoteID  and acc.AccountTypeID = 1
  
  
  
  
   
  EXEC usp_InsertUpdateFeeCouponStripReceivableForPayruleSetup @CopyNoteID,@CreatedBy,@AnalysisIDDefault  
    
  EXEC [dbo].[usp_UpdateEffectiveDateAsClosingDateByNoteId] @CopyNoteID  
  
  
  
  --ServicerDropDateSetup  
 INSERT INTO [CRE].[ServicerDropDateSetup]  
 ([NoteID]  
 ,[ModeledPMTDropDate]  
 ,[PMTDropDateOverride]  
 ,[CreatedBy]  
 ,[CreatedDate]  
 ,[UpdatedBy]  
 ,[UpdatedDate])  
  
 SELECT @CopyNoteID as [NoteID]  
 ,[ModeledPMTDropDate]  
 ,[PMTDropDateOverride]  
 ,[CreatedBy]  
 ,getdate() as [CreatedDate]  
 ,[UpdatedBy]  
 ,getdate() as [UpdatedDate]  
 FROM [CRE].[ServicerDropDateSetup]  
 WHERE NoteID = @ParentNoteID  
  


   ----Add into searchitem table
	 Declare @LookupIdForNote int = (Select lookupid from core.Lookup where name = 'Note');

	EXEC [App].[usp_AddUpdateObject] @CopyNoteID,@LookupIdForNote ,'Kbaderia','Kbaderia'


	----Add critical exception if maturity missing
	IF NOT EXISTS(
		Select Distinct mat.MaturityID from [CORE].Maturity mat  
		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		where e.StatusID = 1 and acc.IsDeleted = 0
		and n.noteid = @newnoteId
	)
	BEGIN	
		--declare @TableTypeExceptions [TableTypeExceptions]
		--Insert into @TableTypeExceptions([ObjectID],[ObjectTypeText],[FieldName],[Summary],[ActionLevelText])
		--Select @newnoteId,'Note','Maturity scenarios List','Maturity scenario cannot be empty','Critical'

		--exec [dbo].[usp_InsertUpdateExceptions] @TableTypeExceptions,@UpdatedBy,@UpdatedBy 

		Delete from core.Exceptions where ObjectID=@newnoteId and [ObjectTypeID] = 182 and [FieldName] = 'Maturity scenarios List'

		INSERT into core.Exceptions ([ObjectID],[ObjectTypeID],[FieldName],[Summary],[ActionLevelID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
		Values(@newnoteId,182,'Maturity scenarios List','Maturity scenario cannot be empty',293,@CreatedBy,getdate(),@CreatedBy,getdate())
	END
	
  


	--IF EXISTS(Select top 1 TagMasterXIRRID from cre.TagMasterXIRR where [Name] = 'Portfolio Whole Loan')
	--BEGIN
	--	Declare @TagMasterXIRRID int = (Select top 1 TagMasterXIRRID from cre.TagMasterXIRR where [Name] = 'Portfolio Whole Loan')
	--	EXEC [dbo].[usp_InsertUpdateTagAccountMappingXIRR] @CopyAccountID,@TagMasterXIRRID,@CreatedBy
	--END


    ---Copy tags
	INSERT INTO [CRE].[TagAccountMappingXIRR]([AccountID],[TagMasterXIRRID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
	Select @CopyAccountID,[TagMasterXIRRID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate] From [CRE].[TagAccountMappingXIRR]
	Where AccountID = @ParentAccountID
	----==============


 -- ---========================================================================================
	--Declare @LastAccountingCloseDate date;

	--SET @LastAccountingCloseDate=(
	--	Select CAST(ISNULL(LastAccountingCloseDate,'1/1/1900') as Date) as LastAccountingCloseDate
	--	from(
	--		Select 
	--		d.DealID,n.noteid,p.CloseDate as LastAccountingCloseDate	
	--		,ROW_NUMBER() OVER (Partition BY d.dealid,n.noteid order by d.dealid,n.noteid,p.updateddate desc) rno
	--		from cre.deal d
	--		Inner join cre.note n on n.dealid = d.dealid
	--		Left join (
	--			Select dealid,CloseDate,updateddate
	--			from CORE.[Period]
	--			where CloseDate is not null
	--		)p on d.dealid = p.dealid 
	--		Where d.IsDeleted <> 1

	--		and n.noteid = @ParentNoteID
	--	)a
	--	where a.rno = 1
	--)

	--exec [dbo].[usp_DeleteDataByLastAccountingClosedate]  @newnoteId,@LastAccountingCloseDate
	-----========================================================================================

END  



