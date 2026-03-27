-- Procedure

CREATE PROCEDURE [dbo].[usp_CopyDeal]

@Tabletypenote [TableTypeNote] READONLY,
@CREDealID nvarchar(256),
@DealName  nvarchar(256),
@CreatedBy nvarchar(256),
@DelegatedUserID nvarchar(256) = null

AS
BEGIN
    SET NOCOUNT ON;



IF not EXISTS(Select * from CRE.Deal  where CREDealID = @CREDealID and DealName=@DealName and IsDeleted=0)
BEGIN

	DECLARE @NewDealID nvarchar(256) ,
	 @c_accountid UNIQUEIDENTIFIER,
     @c_NoteName nvarchar(256) ,
	 @c_CRENoteID nvarchar(256),
	 @c_NoteId UNIQUEIDENTIFIER,
	 @AnalysisIDDefault uniqueidentifier

Declare  @BalanceTransactionSchedule  int  =5;
Declare  @DefaultSchedule  int  =6;
Declare  @FeeCouponSchedule  int  =7;
Declare  @FinancingFeeSchedule  int  =8;
Declare  @FinancingSchedule  int  =9;
Declare  @FundingSchedule  int  =10;
Declare  @Maturity  int  =11;
Declare  @PIKSchedule  int  =12;
Declare  @PrepayAndAdditionalFeeSchedule  int  =13;
Declare  @RateSpreadSchedule  int  =14;
Declare  @ServicingFeeSchedule  int  =15;
Declare  @StrippingSchedule  int  =16;
Declare  @PIKScheduleDetail  int  =17;
Declare  @LIBORSchedule  int  =18;
Declare  @AmortSchedule  int  =19;
Declare  @FeeCouponStripReceivable  int  =20;  
 
DECLARE @tDeal TABLE (tNewDealId UNIQUEIDENTIFIER)
DECLARE @tAccount TABLE (tAccountID UNIQUEIDENTIFIER)
DECLARE @tNote TABLE (tNewNoteId UNIQUEIDENTIFIER)
DECLARE @tEvent TABLE (tNewEventId UNIQUEIDENTIFIER)
DECLARE @insertedAccountID uniqueidentifier;
DECLARE @insertedEventID uniqueidentifier;
DECLARE @insertedNoteID uniqueidentifier;
DECLARE @SourceDealID uniqueidentifier;

Set @AnalysisIDDefault = (Select AnalysisID from core.Analysis where Name = 'Default')
select @SourceDealID=dealid  from cre.Note where noteid=(select top 1 Noteid from @Tabletypenote)
---Deal----

---=====Insert into Account table=====
DECLARE @insertedAccountID_deal uniqueidentifier;      
      
DECLARE @tAccount_deal TABLE (tAccountID_deal UNIQUEIDENTIFIER)      

INSERT INTO [Core].[Account] ([StatusID],[Name],[AccountTypeID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],isdeleted)      
OUTPUT inserted.AccountID INTO @tAccount_deal(tAccountID_deal)      
VALUES(1,@DealName,10,@CreatedBy,GETDATE(),@CreatedBy,GetDATE(),0)      

SELECT @insertedAccountID_deal = tAccountID_deal FROM @tAccount_deal;      
-------------------------------------------


INSERT INTO CRE.Deal([DealName]
      ,[CREDealID]
      ,[DealType]
      ,[LoanProgram]
      ,[LoanPurpose]
      ,[Status]
      ,[AppReceived]
      ,[EstClosingDate]
      ,[BorrowerRequest]
      ,[RecommendedLoan]
      ,[TotalFutureFunding]
      ,[Source]
      ,[BrokerageFirm]
      ,[BrokerageContact]
      ,[Sponsor]
      ,[Principal]
      ,[NetWorth]
      ,[Liquidity]
      ,[ClientDealID]
      ,[GeneratedBy]
      ,[TotalCommitment]
      ,[AdjustedTotalCommitment]
      ,[AggregatedTotal]
      ,[AssetManagerComment]
      ,[AssetManager]
      ,[DealCity]
      ,[DealState]
      ,[DealPropertyType]
      ,[FullyExtMaturityDate]
      ,[UnderwritingStatus]
      ,[LinkedDealID]
	  ,AllowSizerUpload
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
      ,[DealComment]
	  ,SourceDealID
	  ,isDeleted
	  ,AMUserID
	  ,AMTeamLeadUserID
	  ,AMSecondUserID
	  ,DealRule
	  ,BoxDocumentLink
	  ,DealGroupID
	  ,EnableAutoSpread
	  ,AmortizationMethod
	,ReduceAmortizationForCurtailments
	,BusinessDayAdjustmentForAmort
	,NoteDistributionMethod
	,PeriodicStraightLineAmortOverride
	,FixedPeriodicPayment
	,EquityAmount
	,RemainingAmount
	,DealTypeMasterID
	,EnableAutospreadRepayments
	,AutoUpdateFromUnderwriting
	,ExpectedFullRepaymentDate
	,RepaymentAutoSpreadMethodID
	,RepaymentStartDate
	,EarliestPossibleRepaymentDate
	,Blockoutperiod
	,PossibleRepaymentdayofthemonth
	,Repaymentallocationfrequency
	,AutoPrepayEffectiveDate
	,LatestPossibleRepaymentDate
	,KnownFullPayoffDate
	,BalanceAware
	,EnableAutoDistributePrincipalWriteoff
	,AccountID
	,InquiryDate
	,MSA_NAME
	,BSState
	,PropertyTypeMajorID
	,CalcEngineType
	) 
 OUTPUT inserted.DealID INTO @tDeal(tNewDealId)
Select 
		@DealName
      ,@CREDealID
      ,[DealType]
      ,[LoanProgram]
      ,[LoanPurpose]
      ,[Status]
      ,[AppReceived]
      ,[EstClosingDate]
      ,[BorrowerRequest]
      ,[RecommendedLoan]
      ,[TotalFutureFunding]
      ,[Source]
      ,[BrokerageFirm]
      ,[BrokerageContact]
      ,[Sponsor]
      ,[Principal]
      ,[NetWorth]
      ,[Liquidity]
      ,[ClientDealID]
      ,(select lookupID from core.lookup where Name='Copy Deal')
      ,[TotalCommitment]
      ,[AdjustedTotalCommitment]
      ,[AggregatedTotal]
      ,[AssetManagerComment]
      ,[AssetManager]
      ,[DealCity]
      ,[DealState]
      ,[DealPropertyType]
      ,[FullyExtMaturityDate]
      ,[UnderwritingStatus]
      ,nullif(LinkedDealID,'')
	  ,AllowSizerUpload
      ,@CreatedBy
      ,Getdate()
      ,@CreatedBy
     ,Getdate()
      ,[DealComment]
	  ,@SourceDealID
	  ,0
	  ,AMUserID
	,AMTeamLeadUserID
	,AMSecondUserID
	,DealRule
	,BoxDocumentLink
	,DealGroupID
	,EnableAutoSpread
	,AmortizationMethod
	,ReduceAmortizationForCurtailments
	,BusinessDayAdjustmentForAmort
	,NoteDistributionMethod
	,PeriodicStraightLineAmortOverride
	,FixedPeriodicPayment
	,EquityAmount
	,RemainingAmount
	,DealTypeMasterID
	,EnableAutospreadRepayments
	,AutoUpdateFromUnderwriting
	,ExpectedFullRepaymentDate
	,RepaymentAutoSpreadMethodID
	,RepaymentStartDate
	,EarliestPossibleRepaymentDate
	,Blockoutperiod
	,PossibleRepaymentdayofthemonth
	,Repaymentallocationfrequency
	,AutoPrepayEffectiveDate
	,LatestPossibleRepaymentDate
	,KnownFullPayoffDate
	,BalanceAware
	,EnableAutoDistributePrincipalWriteoff
	,@insertedAccountID_deal
	,InquiryDate
	,MSA_NAME
	,BSState
	,PropertyTypeMajorID
	,CalcEngineType

 from CRE.Deal with (NOLOCK) where DealID=(SELECT TOP 1 (DealID) FROM @Tabletypenote) and IsDeleted=0

   SELECT @NewDealID = tNewDealId FROM @tDeal;


   ---Property

   INSERT INTO [CRE].[Property]
           ([Deal_DealID]
           ,[PropertyName]
           ,[Address]
           ,[City]
           ,[State]
           ,[Zip]
           ,[UWNCF]
           ,[SQFT]
           ,[PropertyType]
           ,[AllocDebtPer]
           ,[PropertySubtype]
           ,[NumberofUnitsorSF]
           ,[Occ]
           ,[Class]
           ,[YearBuilt]
           ,[Renovated]
           ,[Bldgs]
           ,[Acres]
           ,[CreatedBy]
           ,[CreatedDate]
		   ,[updatedby]
		   ,[UpdatedDate])  		
		select @NewDealID
           ,[PropertyName]
           ,[Address]
           ,[City]
           ,[State]
           ,[Zip]
           ,[UWNCF]
           ,[SQFT]
           ,[PropertyType]
           ,[AllocDebtPer]
           ,[PropertySubtype]
           ,[NumberofUnitsorSF]
           ,[Occ]
           ,[Class]
           ,[YearBuilt]
           ,[Renovated]
           ,[Bldgs]
           ,[Acres]
           ,[CreatedBy]
           ,[CreatedDate]
		   ,[updatedby]
		   ,[UpdatedDate]   
		 from [CRE].[Property]  with (NOLOCK) where [Deal_DealID]=(SELECT TOP 1 (DealID) FROM @Tabletypenote)


	INSERT INTO CRE.DealFunding
	(
		DealID,	
		[Date],	
		Amount,	
		Comment,	
		PurposeID,	
		Applied,	
		DrawFundingId,	
		Issaved,	
		DealFundingRowno,	
		DeadLineDate,	
		LegalDeal_DealFundingID,	
		EquityAmount,	
		RemainingFFCommitment,	
		RemainingEquityCommitment,	
		SubPurposeType,
		CreatedBy,	
		CreatedDate	,
		UpdatedBy,	
		UpdatedDate,
		RequiredEquity,
		AdditionalEquity,
		GeneratedBy,
		NonCommitmentAdj,	
		GeneratedByUserID,
		AdjustmentType

	)
	select 	
	@NewDealID,
	Date,
	Amount,
	Comment,
	PurposeID,
	Applied,
	DrawFundingId,
	Issaved,
	DealFundingRowno,
	DeadLineDate,
	LegalDeal_DealFundingID,	
	EquityAmount,	
	RemainingFFCommitment,	
	RemainingEquityCommitment,	
	SubPurposeType,
	@CreatedBy,
	Getdate(),
	@CreatedBy,
	Getdate(),
	RequiredEquity,
	AdditionalEquity,
	GeneratedBy,
	NonCommitmentAdj,	
	GeneratedByUserID,
	AdjustmentType
	from [CRE].[DealFunding]  with (NOLOCK)   where dealid=(SELECT TOP 1 (DealID) FROM @Tabletypenote)

		 --insert into [CRE].[DealFunding] (DealID,Date,Amount,Comment,PurposeID,CreatedBy,CreatedDate,UpdatedBy,	UpdatedDate)
		 --	select 	@NewDealID,Date,Amount,Comment,PurposeID,@CreatedBy,Getdate(),@CreatedBy,Getdate() from [CRE].[DealFunding]  with (NOLOCK)   where dealid=(SELECT TOP 1 (DealID) FROM @Tabletypenote)


			insert into [CRE].[PayruleSetup](DealID,StripTransferFrom,StripTransferTo,Value,RuleID,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate)
			select @NewDealID,StripTransferFrom,StripTransferTo,Value,RuleID,@CreatedBy,Getdate(),@CreatedBy,Getdate() from [CRE].[PayruleSetup]  with (NOLOCK)  where dealid=(SELECT TOP 1 (DealID) FROM @Tabletypenote)

-- AutpSpread--

Insert INTO [CRE].[AutoSpreadRule]
(
	 DealID	
	,PurposeType	
	,PurposeSubType	
	,DebtAmount	
	,EquityAmount	
	,StartDate	
	,EndDate	
	,DistributionMethod	
	,FrequencyFactor	
	,Comment	
	,CreatedBy	
	,CreatedDate	
	,UpdatedBy	
	,UpdatedDate,
	RequiredEquity
	,AdditionalEquity
)
SELECT
     @NewDealID
	,PurposeType	
	,PurposeSubType	
	,DebtAmount	
	,EquityAmount	
	,StartDate	
	,EndDate	
	,DistributionMethod	
	,FrequencyFactor	
	,Comment
	,@CreatedBy
	,Getdate()
	,@CreatedBy
	,Getdate() 
	,RequiredEquity
	,AdditionalEquity
FROM [CRE].[AutoSpreadRule] where DealID = (SELECT TOP 1 (DealID) FROM @Tabletypenote)

-- NoteAdjustedCommitmentMaster
--INSERT INTO CRE.NoteAdjustedCommitmentMaster 
--		(
--			 DealID
--			,[Date]
--			,[Type]
--			,Comments	
--			,DealAdjustmentHistory	
--			,AdjustedCommitment	
--			,TotalCommitment	
--			,AggregatedCommitment	
--			,CreatedBy	
--			,CreatedDate	
--			,UpdatedBy	
--			,UpdatedDate
--			,TotalRequiredEquity
--			,TotalAdditionalEquity
--		)
--SELECT 
--			 @NewDealID
--			,[Date]
--			,[Type]
--			,Comments	
--			,DealAdjustmentHistory	
--			,AdjustedCommitment	
--			,TotalCommitment	
--			,AggregatedCommitment	
--			,@CreatedBy
--			,getdate()	
--			,@CreatedBy
--			,getdate()
--			,TotalRequiredEquity
--			,TotalAdditionalEquity
--	FROM CRE.NoteAdjustedCommitmentMaster where DealID = (SELECT TOP 1 (DealID) FROM @Tabletypenote)

----DealAmortizationSchedule
	INSERT INTO  cre.dealamortizationschedule(
			DealID,
			Date,
			Amount,
			CreatedBy,
			CreatedDate,
			UpdatedBy,
			UpdatedDate,
			DealAmortScheduleRowno
			)
	SELECT	@NewDealID,
			Date,
			Amount,
			CreatedBy,
			CreatedDate,
			UpdatedBy,
			UpdatedDate,
			DealAmortScheduleRowno
	FROM  cre.dealamortizationschedule where DealID = (SELECT TOP 1 (DealID) FROM @Tabletypenote)

	---DealProjectedPayOffAccounting
	INSERT INTO  cre.DealProjectedPayOffAccounting(
			DealID,
			AsOfDate,
			CumulativeProbability,
			CreatedBy,
			CreatedDate,
			UpdatedBy,
			UpdatedDate
			)
	SELECT	@NewDealID,
			AsOfDate,
			CumulativeProbability,
			CreatedBy,
			CreatedDate,
			UpdatedBy,
			UpdatedDate
	FROM  cre.DealProjectedPayOffAccounting where DealID = (SELECT TOP 1 (DealID) FROM @Tabletypenote)




	INSERT INTO [CRE].[WLDealPotentialImpairmentMaster](
			DealID,
			Date,
			Amount,
			AdjustmentType,
			Comment,
			Applied,
			CreatedBy,
			CreatedDate,
			UpdatedBy,
			UpdatedDate,
			RowNo
			)
	SELECT	@NewDealID,
			Date,
			Amount,
			AdjustmentType,
			Comment,
			Applied,
			CreatedBy,
			CreatedDate,
			UpdatedBy,
			UpdatedDate,
			RowNo
	FROM [CRE].[WLDealPotentialImpairmentMaster] where DealID = (SELECT TOP 1 (DealID) FROM @Tabletypenote)


	INSERT INTO [CRE].[WLDealAccounting](
			DealID,
			StartDate,
			EndDate,
			TypeID,
			Comment,
			CreatedBy,
			CreatedDate,
			UpdatedBy,
			UpdatedDate
			)
	SELECT	@NewDealID,
			StartDate,
			EndDate,
			TypeID,
			Comment,
			CreatedBy,
			CreatedDate,
			UpdatedBy,
			UpdatedDate
	FROM [CRE].[WLDealAccounting] where DealID = (SELECT TOP 1 (DealID) FROM @Tabletypenote)

   -- Note--
  DECLARE copy_cursor CURSOR FOR 
   select AccountID,NoteId,CRENoteID,name from @Tabletypenote 


  OPEN copy_cursor  
  FETCH NEXT FROM copy_cursor into   @c_accountid,@c_NoteId,@c_CRENoteID,@c_NoteName

WHILE @@FETCH_STATUS = 0  
   Begin
  
  SET @c_NoteId = (Select n.noteid from cre.note n inner join core.Account acc on acc.AccountID = n.Account_AccountID	where acc.AccountID = @c_accountid and acc.IsDeleted=0)

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
				@c_NoteName,		
				StartDate,
				EndDate,					
				BaseCurrencyID,
				PayFrequency,
				ClientNoteID,			
				@CreatedBy,
				GETDATE(),
				@CreatedBy,
				GetDATE(),0 from [Core].[Account]  with (NOLOCK)  where AccountID=@c_accountid and IsDeleted=0

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
		select	@insertedAccountID
           ,@NewDealID
           ,@c_CRENoteID
		   ,@c_NoteName
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
      ,(select lookupID from core.lookup where Name='Copy Deal')
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
		where [Account_AccountID]=@c_accountid and acc.isdeleted=0

  SELECT @insertednoteID = tNewNoteId FROM @tNote;
---Note Details

--============================Cursor for all note detail schedule===========================


 INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue,StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
    SELECT DISTINCT
      EffectiveStartDate,
      @insertedAccountID,
      GETDATE(),
      EventTypeID,
      SingleEventValue,
	  StatusID,
      @CreatedBy,
	  GETDATE(),
	  @CreatedBy,
	  GETDATE()	
  FROM Core.Event  with (NOLOCK) where AccountID=@c_accountid and eventtypeid=@Maturity and StatusID = 1

	


INSERT INTO core.Maturity (EventId, SelectedMaturityDate, MaturityDate,MaturityType,Approved,CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
 SELECT (SELECT TOP 1
             EventId
           FROM CORE.[event] se with (NOLOCK)
           WHERE se.[EffectiveStartDate] = CONVERT(date, e.EffectiveStartDate, 101)
           AND se.[EventTypeID] = @Maturity
           AND se.AccountID = @insertedAccountID
		   and se.StatusID = 1
		   ),

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
    WHERE acc.AccountID = @c_accountid
	and e.StatusID = 1
	






--2.RateSpreadSchedule


	INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue,StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate) 
  SELECT DISTINCT
      EffectiveStartDate,
      @insertedAccountID,
      GETDATE(),
      EventTypeID,
      SingleEventValue,
	  StatusID,
      @CreatedBy,
	  GETDATE(),
	  @CreatedBy,
	  GETDATE()	
    FROM Core.Event with (NOLOCK) where AccountID=@c_accountid and eventtypeid=@RateSpreadSchedule
  
IF(@@ROWCOUNT > 0)
BEGIN
  INSERT INTO core.RateSpreadSchedule (EventId, Date, ValueTypeID, Value, IntCalcMethodID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate,IndexNameID,DeterminationDateHolidayList)
   SELECT (SELECT TOP 1
             EventId
           FROM CORE.[event] se with (NOLOCK) 
           WHERE se.[EffectiveStartDate] = CONVERT(date, e.EffectiveStartDate, 101)
           AND se.[EventTypeID] = @RateSpreadSchedule
           AND se.AccountID = @insertedAccountID),
           CONVERT(date, rs.[Date], 101),
           ValueTypeID,
           Value,
           IntCalcMethodID,
		   @CreatedBy,
	  GETDATE(),
	  @CreatedBy,
	  GETDATE()	,
	  rs.IndexNameID,
	  rs.DeterminationDateHolidayList
    FROM Core.RateSpreadSchedule rs with (NOLOCK) 
	inner join core.Event e  with (NOLOCK) on e.eventid =  rs.EventId
	inner join core.Account acc  with (NOLOCK) on acc.AccountID =  e.AccountID
    WHERE rs.[date] is not null and ValueTypeID IS NOT NULL
	and acc.AccountID = @c_accountid
	
END

-- 3.PrepayAndAdditionalFeeSchedule


		INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue,StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
	    SELECT DISTINCT
      EffectiveStartDate,
      @insertedAccountID,
      GETDATE(),
      EventTypeID,
      SingleEventValue,
	  StatusID,
      @CreatedBy,
	  GETDATE(),
	  @CreatedBy,
	  GETDATE()	
		FROM Core.Event  with (NOLOCK) where AccountID=@c_accountid and eventtypeid=@PrepayAndAdditionalFeeSchedule

		
IF(@@ROWCOUNT > 0)
BEGIN
		 INSERT INTO core.PrepayAndAdditionalFeeSchedule (EventId, StartDate, ValueTypeID, Value, IncludedLevelYield, IncludedBasis, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate,FeeName,EndDate,FeeAmountOverride,BaseAmountOverride,ApplyTrueUpFeature,FeetobeStripped)
		   SELECT (SELECT TOP 1
             EventId
           FROM CORE.[event] se with (NOLOCK) 
           WHERE se.[EffectiveStartDate] = CONVERT(date, e.EffectiveStartDate, 101)
           AND se.[EventTypeID] = @PrepayAndAdditionalFeeSchedule
           AND se.AccountID = @insertedAccountID),
           CONVERT(date, pre.StartDate, 101),
           ValueTypeID,
           Value,
           IncludedLevelYield,
		   IncludedBasis,
		   @CreatedBy,
	  GETDATE(),
	  @CreatedBy,
	  GETDATE()	,
	FeeName,pre.EndDate,FeeAmountOverride,BaseAmountOverride,ApplyTrueUpFeature,FeetobeStripped
    FROM Core.PrepayAndAdditionalFeeSchedule pre with (NOLOCK) 
	inner join core.Event e  with (NOLOCK) on e.eventid =  pre.EventId
	inner join core.Account acc  with (NOLOCK) on acc.AccountID =  e.AccountID
    WHERE pre.StartDate is not null and ValueTypeID IS NOT NULL
	and acc.AccountID = @c_accountid
END

		

-----4.Stripping


		INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue,StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
 	 SELECT DISTINCT
      EffectiveStartDate,
      @insertedAccountID,
      GETDATE(),
      EventTypeID,
      SingleEventValue,
	  StatusID,
      @CreatedBy,
	  GETDATE(),
	  @CreatedBy,
	  GETDATE()	
    FROM Core.Event  with (NOLOCK) where AccountID=@c_accountid and eventtypeid=@StrippingSchedule

		
IF(@@ROWCOUNT > 0)
BEGIN
		INSERT INTO core.StrippingSchedule (EventId, StartDate, ValueTypeID, Value, IncludedLevelYield, IncludedBasis, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
		 SELECT (SELECT TOP 1
             EventId
           FROM CORE.[event] se with (NOLOCK) 
           WHERE se.[EffectiveStartDate] = CONVERT(date, e.EffectiveStartDate, 101)
           AND se.[EventTypeID] = @StrippingSchedule
           AND se.AccountID = @insertedAccountID),
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
	and acc.AccountID = @c_accountid
END


	
----5.FinancingFeeSchedule



INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue,StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
      SELECT DISTINCT
      EffectiveStartDate,
      @insertedAccountID,
      GETDATE(),
      EventTypeID,
      SingleEventValue,
	  StatusID,
      @CreatedBy,
	  GETDATE(),
	  @CreatedBy,
	  GETDATE()	
 FROM Core.Event  with (NOLOCK) where AccountID=@c_accountid and eventtypeid=@FinancingFeeSchedule


IF(@@ROWCOUNT > 0)
BEGIN
	   INSERT INTO core.FinancingFeeSchedule (EventId, Date, ValueTypeID, Value, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
	   SELECT (SELECT TOP 1
             EventId
           FROM CORE.[event] se with (NOLOCK) 
           WHERE se.[EffectiveStartDate] = CONVERT(date, e.EffectiveStartDate, 101)
           AND se.[EventTypeID] = @FinancingFeeSchedule
           AND se.AccountID = @insertedAccountID),
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
	and acc.AccountID = @c_accountid

END

----6.FinancingSchedule


INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue,StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
  SELECT DISTINCT
      EffectiveStartDate,
      @insertedAccountID,
      GETDATE(),
      EventTypeID,
      SingleEventValue,
	  StatusID,
      @CreatedBy,
	  GETDATE(),
	  @CreatedBy,
	  GETDATE()	
 FROM Core.Event  with (NOLOCK) where AccountID=@c_accountid and eventtypeid=@FinancingSchedule
 
IF(@@ROWCOUNT > 0)
BEGIN
	   INSERT INTO core.FinancingSchedule (EventId, Date, ValueTypeID, Value,IndexTypeID, IntCalcMethodID, CurrencyCode, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
	SELECT (SELECT TOP 1
             EventId
           FROM CORE.[event] se with (NOLOCK)
           WHERE se.[EffectiveStartDate] = CONVERT(date, e.EffectiveStartDate, 101)
           AND se.[EventTypeID] = @FinancingSchedule
           AND se.AccountID = @insertedAccountID),
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
	and acc.AccountID = @c_accountid

END


----7.DefaultSchedule


INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue,StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
     SELECT DISTINCT
      EffectiveStartDate,
      @insertedAccountID,
      GETDATE(),
      EventTypeID,
      SingleEventValue,
	  StatusID,
      @CreatedBy,
	  GETDATE(),
	  @CreatedBy,
	  GETDATE()	
 FROM Core.Event  with (NOLOCK) where AccountID=@c_accountid and eventtypeid=@DefaultSchedule
  
IF(@@ROWCOUNT > 0)
BEGIN
	   INSERT INTO core.DefaultSchedule (EventId, StartDate,EndDate, ValueTypeID, Value, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
	   	SELECT (SELECT TOP 1
             EventId
           FROM CORE.[event] se
           WHERE se.[EffectiveStartDate] = CONVERT(date, e.EffectiveStartDate, 101)
           AND se.[EventTypeID] = @DefaultSchedule
           AND se.AccountID = @insertedAccountID),
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
	and acc.AccountID = @c_accountid


	END

----8.PIKSchedule

INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue,StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
  SELECT DISTINCT
      EffectiveStartDate,
      @insertedAccountID,
      GETDATE(),
      EventTypeID,
      SingleEventValue,
	  StatusID,
      @CreatedBy,
	  GETDATE(),
	  @CreatedBy,
	  GETDATE()	
 FROM Core.Event  with (NOLOCK) where AccountID=@c_accountid and eventtypeid=@PIKSchedule


  IF(@@ROWCOUNT > 0)
BEGIN
INSERT INTO core.PIKSchedule (EventID,SourceAccountID,TargetAccountID,AdditionalIntRate,AdditionalSpread,IndexFloor,IntCompoundingRate,IntCompoundingSpread,StartDate,EndDate,IntCapAmt,PurBal,AccCapBal,CreatedBy, CreatedDate,UpdatedBy,UpdatedDate, [PIKReasonCodeID],[PIKComments],[PIKIntCalcMethodID],PeriodicRateCapAmount ,PeriodicRateCapPercent, PIKPercentage, PIKSetUp,PIKSeparateCompounding)
	   	SELECT (SELECT TOP 1
             EventId
           FROM CORE.[event] se
           WHERE se.[EffectiveStartDate] = CONVERT(date, e.EffectiveStartDate, 101)
           AND se.[EventTypeID] = @PIKSchedule
           AND se.AccountID = @insertedAccountID),
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
			GETDATE()	,
			
			[PIKReasonCodeID],
			[PIKComments],
			[PIKIntCalcMethodID],
			PeriodicRateCapAmount ,
			PeriodicRateCapPercent,
			PIKPercentage,
			PIKSetUp,
			pik.PIKSeparateCompounding
    FROM Core.PIKSchedule PIK  with (NOLOCK)
	inner join core.Event e  with (NOLOCK) on e.eventid =  PIK.EventId
	inner join core.Account acc  with (NOLOCK) on acc.AccountID =  e.AccountID
    WHERE PIK.StartDate is not null 
	and acc.AccountID = @c_accountid
	END


-----9.ServicingFeeSchedule

INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue,StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
 SELECT DISTINCT
      EffectiveStartDate,
      @insertedAccountID,
      GETDATE(),
      EventTypeID,
      SingleEventValue,
	  StatusID,
      @CreatedBy,
	  GETDATE(),
	  @CreatedBy,
	  GETDATE()	
 FROM Core.Event  with (NOLOCK) where AccountID=@c_accountid and eventtypeid=@ServicingFeeSchedule


   IF(@@ROWCOUNT > 0)
BEGIN
 INSERT INTO core.ServicingFeeSchedule (EventId,Date,Value,IsCapitalized, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
   	SELECT (SELECT TOP 1
             EventId
           FROM CORE.[event] se
           WHERE se.[EffectiveStartDate] = CONVERT(date, e.EffectiveStartDate, 101)
           AND se.[EventTypeID] = @ServicingFeeSchedule
           AND se.AccountID = @insertedAccountID),
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
	and acc.AccountID = @c_accountid
END

--END
----10.FundingSchedule


INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue,StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
    SELECT DISTINCT
      EffectiveStartDate,
      @insertedAccountID,
      GETDATE(),
      EventTypeID,
      SingleEventValue,
	  StatusID,
      @CreatedBy,
	  GETDATE(),
	  @CreatedBy,
	  GETDATE()	
 FROM Core.Event  with (NOLOCK) where AccountID=@c_accountid and eventtypeid=@FundingSchedule and StatusID = 1
 


IF(@@ROWCOUNT > 0)
BEGIN		

	INSERT INTO core.FundingSchedule (EventId, Date, Value,PurposeID,Applied,Issaved, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate,DrawFundingId,Comments,DealFundingRowno,WF_CurrentStatus,GeneratedBy,AdjustmentType,DealFundingID)
	SELECT (SELECT TOP 1
				EventId
			FROM CORE.[event] se
			WHERE se.[EffectiveStartDate] = CONVERT(date, e.EffectiveStartDate, 101)
			AND se.[EventTypeID] = @FundingSchedule and StatusID = 1
			AND se.AccountID = @insertedAccountID),
			CONVERT(date, fd.Date, 101),
			Value,	
			PurposeID,
			Applied,
			Issaved,	  	        
			@CreatedBy,
		GETDATE(),
		@CreatedBy,
		GETDATE()	,
		DrawFundingId,
		Comments,
		fd.DealFundingRowno,
		WF_CurrentStatus,
		GeneratedBy,
		AdjustmentType,
		df.DealFundingID

	FROM Core.FundingSchedule fd  with (NOLOCK)
	inner join core.Event e  with (NOLOCK) on e.eventid =  fd.EventId
	inner join core.Account acc  with (NOLOCK) on acc.AccountID =  e.AccountID
	left join (      
		select Distinct DealFundingID,DealFundingRowno       
		from cre.DealFunding df where dealid = @NewDealID 
		and df.DealFundingRowno is not null      
	)df on df.DealFundingRowno = fd.DealFundingRowno  
	WHERE fd.Date is not null 
	and e.StatusID = 1
	and acc.AccountID = @c_accountid

  END



----11.PIKScheduleDetail


INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue,StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
    SELECT DISTINCT
      EffectiveStartDate,
      @insertedAccountID,
      GETDATE(),
      EventTypeID,
      SingleEventValue,
	  StatusID,
      @CreatedBy,
	  GETDATE(),
	  @CreatedBy,
	  GETDATE()	
 FROM Core.Event  with (NOLOCK) where AccountID=@c_accountid and eventtypeid=@PIKScheduleDetail

    IF(@@ROWCOUNT > 0)
BEGIN
	   INSERT INTO core.PIKScheduleDetail (EventId, Date, Value, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
	   	SELECT (SELECT TOP 1
             EventId
           FROM CORE.[event] se  with (NOLOCK)
           WHERE se.[EffectiveStartDate] = CONVERT(date, e.EffectiveStartDate, 101)
           AND se.[EventTypeID] = @PIKScheduleDetail
           AND se.AccountID = @insertedAccountID),
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
	and acc.AccountID = @c_accountid
END

----12.LIBORSchedule

INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue,StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
      SELECT DISTINCT
      EffectiveStartDate,
      @insertedAccountID,
      GETDATE(),
      EventTypeID,
      SingleEventValue,
	  StatusID,
      @CreatedBy,
	  GETDATE(),
	  @CreatedBy,
	  GETDATE()	
 FROM Core.Event  with (NOLOCK) where AccountID=@c_accountid and eventtypeid=@LIBORSchedule

    IF(@@ROWCOUNT > 0)
	BEGIN
	   INSERT INTO core.LIBORSchedule (EventId, Date, Value, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
	   	SELECT (SELECT TOP 1
             EventId
           FROM CORE.[event] se  with (NOLOCK)
           WHERE se.[EffectiveStartDate] = CONVERT(date, e.EffectiveStartDate, 101)
           AND se.[EventTypeID] = @LIBORSchedule
           AND se.AccountID = @insertedAccountID),
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
	and acc.AccountID = @c_accountid
	END
--		---13.AmortSchedule


INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue,StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
       SELECT DISTINCT
      EffectiveStartDate,
      @insertedAccountID,
      GETDATE(),
      EventTypeID,
      SingleEventValue,
	  StatusID,
      @CreatedBy,
	  GETDATE(),
	  @CreatedBy,
	  GETDATE()	
 FROM Core.Event  with (NOLOCK) where AccountID=@c_accountid and eventtypeid=@AmortSchedule

    IF(@@ROWCOUNT > 0)
	BEGIN
   INSERT INTO core.AmortSchedule (EventId, Date, Value, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate,DealAmortScheduleRowno)
    	SELECT (SELECT TOP 1
             EventId
           FROM CORE.[event] se  with (NOLOCK)
           WHERE se.[EffectiveStartDate] = CONVERT(date, se.EffectiveStartDate, 101)
           AND se.[EventTypeID] = @AmortSchedule
           AND se.AccountID = @insertedAccountID),
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
	and acc.AccountID = @c_accountid
	END


--		--14.FeeCouponStripReceivable


INSERT INTO Core.Event (EffectiveStartDate, AccountID, Date, EventTypeID, SingleEventValue,StatusID, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
      SELECT DISTINCT
      EffectiveStartDate,
      @insertedAccountID,
      GETDATE(),
      EventTypeID,
      SingleEventValue,
	  StatusID,
      @CreatedBy,
	  GETDATE(),
	  @CreatedBy,
	  GETDATE()	
 FROM Core.Event  with (NOLOCK) where AccountID=@c_accountid and eventtypeid=@FeeCouponStripReceivable

    IF(@@ROWCOUNT > 0)
	BEGIN
   INSERT INTO core.FeeCouponStripReceivable (EventId, Date, Value, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
   SELECT (SELECT TOP 1
             EventId
           FROM CORE.[event] se  with (NOLOCK)
           WHERE se.[EffectiveStartDate] = CONVERT(date, e.EffectiveStartDate, 101)
           AND se.[EventTypeID] = @FeeCouponStripReceivable
           AND se.AccountID = @insertedAccountID),
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
	and acc.AccountID = @c_accountid
	END

	-- 15NoteAdjustedCommitmentDetail
--	INSERT INTO CRE.NoteAdjustedCommitmentDetail
--		(
--			NoteAdjustedCommitmentMasterID,
--			NoteID,
--			[Value],
--			CreatedBy,
--			CreatedDate,
--			UpdatedBy,
--			UpdatedDate,
--			[Type],
--			DealID,
--			NoteTotalCommitment,
--			NoteAdjustedTotalCommitment,
--			NoteAggregatedTotalCommitment
--		)
--	SELECT
--			(SELECT NoteAdjustedCommitmentMasterID FROM CRE.NoteAdjustedCommitmentMaster WHERE DealId = @NewDealID and Type=na.[Type]),
--			@insertednoteID,
--			[Value],
--			@CreatedBy,
--			getdate(),
--			@CreatedBy,
--			getdate(),
--		    [Type],
--			@NewDealID,
--			NoteTotalCommitment,
--			NoteAdjustedTotalCommitment,
--			NoteAggregatedTotalCommitment
--FROM CRE.NoteAdjustedCommitmentDetail na
--WHERE NoteID = @c_NoteId

----NoteTransactionDetail
--INSERT INTO CRE.NoteTransactionDetail(
--			NoteID,
--			TransactionDate,
--			TransactionType,
--			Amount,
--			RelatedtoModeledPMTDate,
--			ModeledPayment,
--			AmountOutstandingafterCurrentPayment,
--			ServicingAmount, 
--			CalculatedAmount,
--			Delta,
--			M61Value,
--			ServicerValue,
--			Ignore,
--			OverrideValue,
--			comments,
--			PostedDate,
--			ServicerMasterID,
--			Deleted,
--			CreatedBy,
--			CreatedDate,
--			UpdatedBy,
--			UpdatedDate,
--			TransactionTypeText,
--			TranscationReconciliationID,
--			RemittanceDate,
--			Exception,
--			Adjustment,
--			ActualDelta,
--			OverrideReason,
--			BerAddlint,
--			TransactionEntryAmount
--				)
--	SELECT 
--			@insertednoteID,
--			TransactionDate,
--			TransactionType,
--			Amount,
--			RelatedtoModeledPMTDate,
--			ModeledPayment,
--			AmountOutstandingafterCurrentPayment,
--			ServicingAmount, 
--			CalculatedAmount,
--			Delta,
--			M61Value,
--			ServicerValue,
--			Ignore,
--			OverrideValue,
--			comments,
--			PostedDate,
--			ServicerMasterID,
--			Deleted,
--			@CreatedBy,
--			getdate(),
--			@CreatedBy,
--			getdate(),
--			TransactionTypeText,
--			TranscationReconciliationID,
--			RemittanceDate,
--			Exception,
--			Adjustment,
--			ActualDelta,
--			OverrideReason,
--			BerAddlint,
--			TransactionEntryAmount
--	FROM CRE.NoteTransactionDetail
--	WHERE NoteID = @c_NoteId


	------Market Price
	--INSERT INTO CRE.NoteAttributesbyDate(
	--				NoteID,
	--				[Date],
	--				[Value],
	--				ValueTypeID,
	--				CreatedBy,
	--				CreatedDate,
	--				UpdatedBy,
	--				UpdatedDate,
	--				GeneratedBy)
 --  SELECT	@c_CRENoteID,
	--		[Date],
	--		[Value],
	--		ValueTypeID,
	--		CreatedBy,
	--		CreatedDate,
	--		UpdatedBy,
	--		UpdatedDate,
	--		GeneratedBy	
 -- FROM CRE.NoteAttributesbyDate
 -- WHERE CRE.NoteAttributesbyDate.NoteID = (SELECT n.CRENoteID FROM CRE.Note n WHERE n.NoteID=@c_NoteId)


	---Exceptions 111

	INSERT INTO core.Exceptions (ObjectID,ObjectTypeID,FieldName,Summary,ActionLevelID,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate)
	select @insertednoteID,ObjectTypeID,FieldName,Summary,ActionLevelID,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate
from core.Exceptions
	WHERE ObjectID=@c_NoteId

		--Funding Rules
		insert into [CRE].[FundingRepaymentSequence](NoteID,SequenceNo,SequenceType,Value,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate)
		select @insertednoteID,SequenceNo,SequenceType,Value,@CreatedBy,GETDATE(),@CreatedBy,GETDATE() from [CRE].[FundingRepaymentSequence]   where NoteID=@c_NoteId


		INSERT INTO CRE.PayruleDistributions (TransactionDate,SourceNoteID,ReceiverNoteID,RuleID,Amount,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate)  
	select 
	  distinct nc.PeriodEndDate
	  ,@insertednoteID
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
	 Inner join core.account acc on acc.accountid = nc.AccountID
    Inner join cre.note n on n.account_accountid = acc.accountid
	 inner join CRE.PayruleSetup ps on ps.StripTransferFrom=n.NoteID 
	 where n.NoteID=@c_NoteId 
	 and acc.AccounttypeID = 1


 update [CRE].[PayruleSetup] set striptransferfrom=@insertedNoteID where DealID=@NewDealID and striptransferfrom=@c_NoteId

 update [CRE].[PayruleSetup] set striptransferto=@insertedNoteID where DealID=@NewDealID and striptransferto=@c_NoteId


 
  EXEC usp_InsertUpdateFeeCouponStripReceivableForPayruleSetup @insertednoteID,@CreatedBy,@AnalysisIDDefault
  
  EXEC [dbo].[usp_UpdateEffectiveDateAsClosingDateByNoteId] @insertednoteID



  --ServicerDropDateSetup
	INSERT INTO [CRE].[ServicerDropDateSetup]
	([NoteID]
	,[ModeledPMTDropDate]
	,[PMTDropDateOverride]
	,[CreatedBy]
	,[CreatedDate]
	,[UpdatedBy]
	,[UpdatedDate])

	SELECT @insertednoteID as [NoteID]
	,[ModeledPMTDropDate]
	,[PMTDropDateOverride]
	,[CreatedBy]
	,getdate() as [CreatedDate]
	,[UpdatedBy]
	,getdate() as [UpdatedDate]
	FROM [CRE].[ServicerDropDateSetup]
	WHERE NoteID = @c_NoteId


	INSERT INTO [CRE].[FundingRepaymentSequenceWriteOff](
			DealID,
			NoteID,
			PriorityOverride,
			CreatedBy,
			CreatedDate,
			UpdatedBy,
			UpdatedDate
			)
	SELECT	@NewDealID,
			@insertednoteID as [NoteID],
			PriorityOverride,
			CreatedBy,
			getdate() as [CreatedDate],
			UpdatedBy,
			getdate() as [UpdatedDate]
	FROM [CRE].[FundingRepaymentSequenceWriteOff] where NoteID = @c_NoteId


	INSERT INTO [CRE].[WLDealPotentialImpairmentDetail](
	        WLDealPotentialImpairmentMasterID,
			NoteID,
			Value,
			CreatedBy,
			CreatedDate,
			UpdatedBy,
			UpdatedDate,
			RowNo
			)
	SELECT	pm.WLDealPotentialImpairmentMasterID,
			@insertednoteID as [NoteID],
			Value,
			pd.CreatedBy,
			pd.CreatedDate,
			pd.UpdatedBy,
			pd.UpdatedDate,
			pd.RowNo
	FROM [CRE].[WLDealPotentialImpairmentDetail] pd
	Left JOIN [CRE].WLDealPotentialImpairmentMaster pm on pm.RowNo = pd.RowNo
	where pd.NoteID = @c_NoteId


		----Add critical exception if maturity missing
	IF NOT EXISTS(
		Select Distinct mat.MaturityID from [CORE].Maturity mat  
		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		where e.StatusID = 1 and acc.IsDeleted = 0
		and n.noteid = @insertednoteID
	)
	BEGIN	
		--declare @TableTypeExceptions [TableTypeExceptions]
		--Insert into @TableTypeExceptions([ObjectID],[ObjectTypeText],[FieldName],[Summary],[ActionLevelText])
		--Select @newnoteId,'Note','Maturity scenarios List','Maturity scenario cannot be empty','Critical'

		--exec [dbo].[usp_InsertUpdateExceptions] @TableTypeExceptions,@UpdatedBy,@UpdatedBy 

		Delete from core.Exceptions where ObjectID=@insertednoteID and [ObjectTypeID] = 182 and [FieldName] = 'Maturity scenarios List'

		INSERT into core.Exceptions ([ObjectID],[ObjectTypeID],[FieldName],[Summary],[ActionLevelID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
		Values(@insertednoteID,182,'Maturity scenarios List','Maturity scenario cannot be empty',293,@CreatedBy,getdate(),@CreatedBy,getdate())
	END


	--IF EXISTS(Select top 1 TagMasterXIRRID from cre.TagMasterXIRR where [Name] = 'Portfolio Whole Loan')
	--BEGIN
	--	Declare @TagMasterXIRRID int = (Select top 1 TagMasterXIRRID from cre.TagMasterXIRR where [Name] = 'Portfolio Whole Loan')
	--	EXEC [dbo].[usp_InsertUpdateTagAccountMappingXIRR] @insertedAccountID,@TagMasterXIRRID,@CreatedBy
	--END

	-----Copy tags
	--DECLARE @TagMasterIDs NVARCHAR(MAX);
	--SELECT @TagMasterIDs= COALESCE(@TagMasterIDs, '')  + CAST(TagMasterXIRRID as nvarchar(256)) + ','
	--FROM  [CRE].[TagAccountMappingXIRR] where AccountID = @c_accountid
	
	--SET @TagMasterIDs = (SELECT LEFT(@TagMasterIDs,len(@TagMasterIDs)-1))

	--IF (@TagMasterIDs is not null)
	--BEGIN
	--	EXEC [dbo].[usp_InsertUpdateTagAccountMappingXIRR] @insertedAccountID,@TagMasterIDs,@CreatedBy
	--END

	INSERT INTO [CRE].[TagAccountMappingXIRR]([AccountID],[TagMasterXIRRID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
	Select @insertedAccountID,[TagMasterXIRRID],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate] From [CRE].[TagAccountMappingXIRR]
	Where AccountID = @c_accountid

	----==============



  FETCH NEXT FROM copy_cursor into   @c_accountid,@c_NoteId,@c_CRENoteID,@c_NoteName
	END
	  CLOSE copy_cursor;  
	  DEALLOCATE copy_cursor;  

	END
	delete from [CRE].[PayruleSetup] where StripTransferFrom not in (select NoteID from cre.Note where DealID =@NewDealID) and dealid=@NewDealID
	delete from [CRE].[PayruleSetup] where StripTransferTo not in (select NoteID from cre.Note where DealID =@NewDealID) and dealid=@NewDealID

	
	 ----Add into searchitem table
	 Declare @LookupIdForNote int = (Select lookupid from core.Lookup where name = 'Note');
Declare @LookupIdForDeal int= (Select lookupid from core.Lookup where name = 'Deal');
	PRINT('Start - Add into search item table')
	DECLARE @DealIDt nvarchar(256) = @NewDealID
	exec [App].[usp_AddUpdateObject] @DealIDt,@LookupIdForDeal,null,null

	-----Save Note----------------------------
	Declare @ObjectIDNote UNIQUEIDENTIFIER
 
	IF CURSOR_STATUS('global','CursorNote')>=-1
	BEGIN
		DEALLOCATE CursorNote
	END

	DECLARE CursorNote CURSOR 
	for
	(
		Select NoteID from cre.Note where dealid = @DealIDt
	)


	OPEN CursorNote 

	FETCH NEXT FROM CursorNote
	INTO @ObjectIDNote

	WHILE @@FETCH_STATUS = 0
	BEGIN

		EXEC [App].[usp_AddUpdateObject] @ObjectIDNote,@LookupIdForNote ,'Kbaderia','Kbaderia'
					 
	FETCH NEXT FROM CursorNote
	INTO @ObjectIDNote
	END
	CLOSE CursorNote   
	DEALLOCATE CursorNote
	PRINT('END - Add into search item table')


	--InitiateWork Workflow
	exec [dbo].[usp_InitiateWorkFlowForDeal] @NewDealID,@CreatedBy,@DelegatedUserID
	exec [dbo].[usp_QueueDealForCalculation] @NewDealID,@CreatedBy,@AnalysisIDDefault ,775
END
GO

