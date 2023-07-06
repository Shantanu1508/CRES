
CREATE PROCEDURE [dbo].[usp_CopyDealFromSource]  --'15-0006','RRDataSet_QA','15-0006','2811 Orchard Parkway New','krishna','0'
@CREDealID nvarchar(256),
@Env nvarchar(256),
@NewCREDealID nvarchar(256),
@NewDealName nvarchar(256),
@UpdatedBy nvarchar(256),
@TotalCount INT OUTPUT 


AS
BEGIN
	SET NOCOUNT ON;

BEGIN TRY
BEGIN TRAN

--Check Source Environment
IF(@Env = 'QA') SET @Env=N'RRDataSet_QA'
IF(@Env = 'Integration') SET @Env=N'RRDataSet_IN'
IF(@Env = 'Acore') SET @Env=N'RRDataSet_Acore'
IF(@Env = 'Staging') SET @Env=N'RRDataSet_Staging'

--Check deal in source env
DECLARE @query nvarchar(256) = N'Select COUNT(CREDealID) from [CRE].[Deal] where CREDealID = '''+@CREDealID+''''
DECLARE @DealCount TABLE (Cnt int,ShardName nvarchar(max))
INSERT INTO @DealCount (Cnt,ShardName)
EXEC sp_execute_remote @data_source_name  = @Env, @stmt = @query

IF ((Select cnt from @DealCount) =  0) --Check if note exists in backshop database
BEGIN
	SET @TotalCount = 2;
--	RETURN;
END

ELSE
BEGIN
SET @TotalCount = (SELECT COUNT(CREDealID) From [CRE].[Deal] where CREDealID = @NewCREDealID)


IF (@TotalCount = 0) --Check if deal exists in source database
BEGIN

---===========================================================================================
--Importing Deal with Notes
DECLARE  @NewDealID nvarchar(256),
		 @c_accountid UNIQUEIDENTIFIER,
		 @c_NoteName nvarchar(256) ,
		 @c_CRENoteID nvarchar(256),
		 @c_NoteId UNIQUEIDENTIFIER,
		 @AnalysisIDDefault uniqueidentifier;
DECLARE  @insertedAccountID uniqueidentifier;
DECLARE  @insertedEventID uniqueidentifier;
DECLARE  @insertedNoteID uniqueidentifier;
DECLARE  @tAccount TABLE (tAccountID UNIQUEIDENTIFIER)
DECLARE  @tNote TABLE (tNewNoteId UNIQUEIDENTIFIER)
DECLARE  @tEvent TABLE (tNewEventId UNIQUEIDENTIFIER)
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
Declare @generatedBy nvarchar(MAX);


SET @generatedBy = (Select LookupID FROM [CORE].[Lookup] WHERE Name ='Imported' and ParentID=36);
Set @AnalysisIDDefault = (Select AnalysisID from core.Analysis where Name = 'Default');
---===========================================================================================
 
--Get tables data from source env 
EXEC [dbo].[usp_GetTableFromSource] @CREDealID,@Env

---===========================================================================================


 --Deal
 INSERT INTO [CRE].[Deal] 
 ( 
  DealName,
  CREDealID,
  DealType,
 LoanProgram,
 LoanPurpose,
 [Status],
 AppReceived,
 EstClosingDate,
 BorrowerRequest,
 RecommendedLoan,
 TotalFutureFunding,
 [Source],
 BrokerageFirm,
 BrokerageContact,
 Sponsor,
 Principal,
 NetWorth,
 Liquidity,
 ClientDealID,
 GeneratedBy,
 CreatedBy,
 CreatedDate,
 Updatedby,
 UpdatedDate,
 Totalcommitment,
 AdjustedTotalCommitment,
 AggregatedTotal,
 AssetManagerComment,
 AssetManager,
 DealCity,
 DealState,
 DealPropertyType,
 FullyExtMaturityDate,
 UnderwritingStatus,
 LinkedDealId,
 DealComment,
 SourceDealID,
 IsDeleted,
 AllowSizerUpload,
 AMUserID,
 AMTeamLeadUserID,
 AMSecondUserID,
 DealRule,
 Companyname,
 FirstName,
 Lastname,
 StreetName,
 ZipCodePostal,
 PayeeName,
 TelephoneNumber1,
 FederalID1,
 TaxEscrowConstant,
 InsEscrowConstant,
 CollectTaxEscrow,
 CollectInsEscrow,
 DealCityWells,
 DealStateWells,
 BoxDocumentLink,
 DealGroupID,
 EnableAutoSpread) 

 select 
  @NewDealName,
  @NewCREDealID,
  DealType,
 LoanProgram,
 LoanPurpose,
 [Status],
 AppReceived,
 EstClosingDate,
 BorrowerRequest,
 RecommendedLoan,
 TotalFutureFunding,
 [Source],
 BrokerageFirm,
 BrokerageContact,
 Sponsor,
 Principal,
 NetWorth,
 Liquidity,
 ClientDealID,
 @generatedBy as GeneratedBy,
 CreatedBy,
 CreatedDate,
 @UpdatedBy as Updatedby,
 getdate() as UpdatedDate,
 Totalcommitment,
 AdjustedTotalCommitment,
 AggregatedTotal,
 AssetManagerComment,
 AssetManager,
 DealCity,
 DealState,
 DealPropertyType,
 FullyExtMaturityDate,
 UnderwritingStatus,
 LinkedDealId,
 DealComment +'_'+ @NewCREDealID,
 SourceDealID,
 IsDeleted,
 AllowSizerUpload,
 AMUserID,
 AMTeamLeadUserID,
 AMSecondUserID,
 DealRule,
 Companyname,
 FirstName,
 Lastname,
 StreetName,
 ZipCodePostal,
 PayeeName,
 TelephoneNumber1,
 FederalID1,
 TaxEscrowConstant,
 InsEscrowConstant,
 CollectTaxEscrow,
 CollectInsEscrow,
 DealCityWells,
 DealStateWells,
 BoxDocumentLink,
 DealGroupID,
 EnableAutoSpread 
 FROM  ##tblDeal

SET @NewDealID = (SELECT DealID FROM [CRE].[Deal] WHERE CREDealID = @NewCREDealID)


 INSERT INTO [CRE].[Property] 
   (   
       [Deal_DealID]
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
      ,[UpdatedBy]
      ,[UpdatedDate]
      ,[ProjectName]
      ,[HOUSESTREET1]
      ,[VILLAGE]
      ,[ZIPCODE]
      ,[OwnerOccupied]
      ,[PROPDESCCODE]
      ,[SALESPRICE]
      ,[ConstructionDate]
      ,[NumberofStories]
      ,[MeasuredIn]
      ,[TotalSquareFeet]
      ,[TotalRentableSqFt]
      ,[TotalNumberofUnits]
      ,[OverallCondition]
      ,[RenovationDate]
      ,[NextInspectionDate]
      ,[GroundLease]
      ,[NumberOfTenants]
      ,[VacancyFactor]
      ,[Allocation]
      ,[LIENPosition]
      ,[CMSAProperyType]
      ,[PState]
      ,[country]
      ,[DealAllocationAmtPCT]
      ,[PropertyRollUpSW]
      ,[IsDeleted])

 SELECT
       @NewDealID
      ,pt.[PropertyName]
      ,pt.[Address]
      ,pt.[City]
      ,pt.[State]
      ,pt.[Zip]
      ,pt.[UWNCF]
      ,pt.[SQFT]
      ,pt.[PropertyType]
      ,pt.[AllocDebtPer]
      ,pt.[PropertySubtype]
      ,pt.[NumberofUnitsorSF]
      ,pt.[Occ]
      ,pt.[Class]
      ,pt.[YearBuilt]
      ,pt.[Renovated]
      ,pt.[Bldgs]
      ,pt.[Acres]
      ,pt.[CreatedBy]
      ,pt.[CreatedDate]
      ,@UpdatedBy as Updatedby
      ,getdate() as UpdatedDate
      ,pt.[ProjectName]
      ,pt.[HOUSESTREET1]
      ,pt.[VILLAGE]
      ,pt.[ZIPCODE]
      ,pt.[OwnerOccupied]
      ,pt.[PROPDESCCODE]
      ,pt.[SALESPRICE]
      ,pt.[ConstructionDate]
      ,pt.[NumberofStories]
      ,pt.[MeasuredIn]
      ,pt.[TotalSquareFeet]
      ,pt.[TotalRentableSqFt]
      ,pt.[TotalNumberofUnits]
      ,pt.[OverallCondition]
      ,pt.[RenovationDate]
      ,pt.[NextInspectionDate]
      ,pt.[GroundLease]
      ,pt.[NumberOfTenants]
      ,pt.[VacancyFactor]
      ,pt.[Allocation]
      ,pt.[LIENPosition]
      ,pt.[CMSAProperyType]
      ,pt.[PState]
      ,pt.[country]
      ,pt.[DealAllocationAmtPCT]
      ,pt.[PropertyRollUpSW]
      ,pt.[IsDeleted]
  FROM ##tblProperty pt

  --DealFunding
  INSERT INTO [CRE].[DealFunding] 
 ( 
       [DealID]
      ,[Date]
      ,[Amount]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
      ,[Comment]
      ,[PurposeID]
      ,[Applied]
      ,[DrawFundingId]
      ,[Issaved]
      ,[DealFundingRowno]
      ,[DeadLineDate]
      ,[LegalDeal_DealFundingID]
      ,[SubPurposeType]
      ,[EquityAmount]
      ,[RemainingFFCommitment]
      ,[RemainingEquityCommitment]
	   )

 SELECT
       @NewDealID
      ,dft.[Date]
      ,dft.[Amount]
      ,dft.[CreatedBy]
      ,dft.[CreatedDate]
      ,@UpdatedBy as Updatedby
      ,getdate() as UpdatedDate
      ,dft.[Comment]
      ,dft.[PurposeID]
      ,dft.[Applied]
      ,dft.[DrawFundingId]
      ,dft.[Issaved]
      ,dft.[DealFundingRowno]
      ,dft.[DeadLineDate]
      ,dft.[LegalDeal_DealFundingID]
      ,dft.[SubPurposeType]
      ,dft.[EquityAmount]
      ,dft.[RemainingFFCommitment]
      ,dft.[RemainingEquityCommitment]
  FROM ##tblDealFunding dft

  --Payrule
  INSERT INTO [CRE].[PayruleSetup]
 (    
       [DealID]
      ,[StripTransferFrom]
      ,[StripTransferTo]
      ,[Value]
      ,[RuleID]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
	   )

 SELECT
      @NewDealID
      ,pst.[StripTransferFrom]
      ,pst.[StripTransferTo]
      ,pst.[Value]
      ,pst.[RuleID]
      ,pst.[CreatedBy]
      ,pst.[CreatedDate]
      ,@UpdatedBy as Updatedby
      ,getdate() as UpdatedDate
  FROM ##tblPayrule pst

  --Note Cursor
  DECLARE copy_cursor CURSOR FOR 
  select AccountID,
         NoteName, 
         CRENoteID,
         NoteId  from ##tblNoteCursor


  OPEN copy_cursor  
  FETCH NEXT FROM copy_cursor into @c_accountid,  @c_NoteName, @c_CRENoteID, @c_NoteId

WHILE @@FETCH_STATUS = 0  
   Begin
   --Account
   INSERT INTO [Core].[Account]
 (     [AccountTypeID]
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
      ,[IsDeleted]
	   )
OUTPUT inserted.AccountID INTO @tAccount(tAccountID)
 SELECT
       '182'
      ,acct.[StatusID]
      ,acct.[Name] + '_'+ @NewCREDealID as [Name]
      ,acct.[StartDate]
      ,acct.[EndDate]
      ,acct.[BaseCurrencyID]
      ,acct.[PayFrequency]
      ,acct.[ClientNoteID]
      ,acct.[CreatedBy]
      ,acct.[CreatedDate]
      ,@UpdatedBy as Updatedby
      ,getdate() as UpdatedDate
      ,acct.[IsDeleted]
  FROM ##tblAccount acct where AccountID=@c_accountid and IsDeleted=0

  
SELECT @insertedAccountID = tAccountID FROM @tAccount;

--Note

INSERT INTO [CRE].[Note]
      (
 [Account_AccountID]
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
,[LienPriority]
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
--,[ExtendedMaturityScenario2]
--,[ExtendedMaturityScenario3]
,[ActualPayoffDate]
,[TotalCommitmentExtensionFeeisBasedOn]
,[UnusedFeeThresholdBalance]
,[UnusedFeePaymentFrequency]
,[lienposition]
,[priority]
,[Servicer]
,[FullInterestAtPPayoff]
,[NoteRule]
,[ClientID]
,[FinancingSourceID]
,[DebtTypeID]
,[BillingNotesID]
,[CapStack]
,[FundID]
,[PoolId]
,[TaxVendorLoanNumber]
,[TAXBILLSTATUS]
,[CURRTAXCONSTANT]
,[InsuranceBillStatusCode]
,[RESERVETYPE]
,[ResDescOwnName]
,[MONTHLYPAYMENTAMT]
,[IORPLANCODE]
,[NoDaysbeforeAssessment]
,[LateChargeRateorFee]
,[DefaultOfDaysto]
,[OddDaysIntAmount]
,[InterestRateFloor]
,[InterestRateCeiling]
,[Dayslookback]
,[WF_Companyname]
,[WF_FirstName]
,[WF_Lastname]
,[WF_StreetName]
,[WF_ZipCodePostal]
,[WF_PayeeName]
,[WF_TelephoneNumber1]
,[WF_FederalID1]
,[WF_City]
,[WF_State]
,[CurrentBls]
,[StubInterestRateOverride]
,[LiborDataAsofDate]
,[ServicerNameID]
,[BusinessdaylafrelativetoPMTDate]
,[DayoftheMonth]
,[InterestCalculationRuleForPaydowns]
,[PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate]
,[FundedAndOwnedByThirdParty]
,[InterestCalculationRuleForPaydownsAmort]
)

OUTPUT inserted.NoteID INTO @tNote(tNewNoteId)

select	 @insertedAccountID
        ,@NewDealID
        ,CRENoteID + '_' + @NewCREDealID
		,n.[ClientNoteID]
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
		,[LienPriority]
		,n.[CreatedBy]
		,n.[CreatedDate]
		,@UpdatedBy as Updatedby
        ,getdate() as UpdatedDate
		,[ServicerID]
		,[TotalCommitment]
		,[ClientName]
		,[Portfolio]
		,[Tag1]
		,[Tag2]
		,[Tag3]
		,[Tag4]
		--,[ExtendedMaturityScenario1]
		--,[ExtendedMaturityScenario2]
		--,[ExtendedMaturityScenario3]
		,[ActualPayoffDate]
		,[TotalCommitmentExtensionFeeisBasedOn]
		,[UnusedFeeThresholdBalance]
		,[UnusedFeePaymentFrequency]
		,[lienposition]
		,[priority]
		,[Servicer]
		,[FullInterestAtPPayoff]
		,[NoteRule]
		,[ClientID]
		,[FinancingSourceID]
		,[DebtTypeID]
		,[BillingNotesID]
		,[CapStack]
		,[FundID]
		,[PoolId]
		,[TaxVendorLoanNumber]
		,[TAXBILLSTATUS]
		,[CURRTAXCONSTANT]
		,[InsuranceBillStatusCode]
		,[RESERVETYPE]
		,[ResDescOwnName]
		,[MONTHLYPAYMENTAMT]
		,[IORPLANCODE]
		,[NoDaysbeforeAssessment]
		,[LateChargeRateorFee]
		,[DefaultOfDaysto]
		,[OddDaysIntAmount]
		,[InterestRateFloor]
		,[InterestRateCeiling]
		,[Dayslookback]
		,[WF_Companyname]
		,[WF_FirstName]
		,[WF_Lastname]
		,[WF_StreetName]
		,[WF_ZipCodePostal]
		,[WF_PayeeName]
		,[WF_TelephoneNumber1]
		,[WF_FederalID1]
		,[WF_City]
		,[WF_State]
		,[CurrentBls]
		,[StubInterestRateOverride]
		,[LiborDataAsofDate]
		,[ServicerNameID]
		,[BusinessdaylafrelativetoPMTDate]
		,[DayoftheMonth]
		,[InterestCalculationRuleForPaydowns]
		,[PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate]
		,[FundedAndOwnedByThirdParty]
		,[InterestCalculationRuleForPaydownsAmort]
		from ##tblNote n 
		inner join ##tblAccount acc on n.Account_AccountID=acc.AccountID
		where [Account_AccountID]=@c_accountid and acc.isdeleted=0

  SELECT @insertednoteID = tNewNoteId FROM @tNote;

--Note Details

--============================Cursor for all note detail schedule===========================

--Event
INSERT INTO [Core].[Event](
	   [AccountID]
      ,[Date]
      ,[EventTypeID]
      ,[EffectiveStartDate]
      ,[EffectiveEndDate]
      ,[SingleEventValue]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
      ,[StatusID])

SELECT DISTINCT
	   @insertedAccountID
      ,[Date]
      ,[EventTypeID]
      ,[EffectiveStartDate]
      ,[EffectiveEndDate]
      ,[SingleEventValue]
      ,[CreatedBy]
      ,[CreatedDate]
      ,@UpdatedBy as Updatedby
      ,getdate() as UpdatedDate
      ,[StatusID]
FROM ##tblEvent  where AccountID=@c_accountid 

--Maturity
IF EXISTS (SELECT EventTypeID FROM ##tblEvent WHERE EventTypeID=@Maturity)
BEGIN
INSERT INTO [Core].[Maturity](
 [EventId]
,[SelectedMaturityDate]
,[CreatedBy]
,[CreatedDate]
,[UpdatedBy]
,[UpdatedDate]
,MaturityDate
,MaturityType
,Approved
,IsAutoApproved
)

SELECT 
          (SELECT TOP 1
           EventId
           FROM CORE.[Event]  se
           WHERE se.[EffectiveStartDate] = CONVERT(date, e.EffectiveStartDate, 101)
           AND se.[EventTypeID] = @Maturity
           AND se.AccountID = @insertedAccountID),
           CONVERT(date, mt.SelectedMaturityDate, 101),         
		   mt.CreatedBy,
	       mt.[CreatedDate],
	      @UpdatedBy as Updatedby,
          getdate() as UpdatedDate,
		  mt.MaturityDate,
		  mt.MaturityType,
		  mt.Approved,
		  mt.IsAutoApproved
    FROM ##tblMaturity mt   
	inner join ##tblEvent e  on e.eventid =  mt.EventId
	inner join ##tblAccount acc on acc.AccountID =  e.AccountID
    WHERE acc.AccountID = @c_accountid AND e.EventTypeID = @Maturity
END

--RateSpreadSchedule
IF EXISTS (SELECT EventTypeID FROM ##tblEvent WHERE EventTypeID=@RateSpreadSchedule)
BEGIN
  INSERT INTO [Core].[RateSpreadSchedule] (
		EventId, 
		[Date], 
		ValueTypeID, 
		[Value], 
		IntCalcMethodID, 
		CreatedBy, 
		CreatedDate,
		UpdatedBy,
		UpdatedDate)


   SELECT 
		 (SELECT TOP 1
           EventId
           FROM CORE.[Event]  se
           WHERE se.[EffectiveStartDate] = CONVERT(date, e.EffectiveStartDate, 101)
           AND se.[EventTypeID] = @RateSpreadSchedule
           AND se.AccountID = @insertedAccountID),
           CONVERT(date, rs.[Date], 101),
           rs.ValueTypeID,
           rs.[Value],
           rs.IntCalcMethodID,
		   rs.CreatedBy,
	       rs.CreatedDate,
		   @UpdatedBy as Updatedby,
           getdate() as UpdatedDate
    FROM ##tblRateSpreadSchedule rs 
	inner join ##tblEvent e   on e.eventid =  rs.EventId
	inner join ##tblAccount acc  on acc.AccountID =  e.AccountID
    WHERE rs.[date] is not null and ValueTypeID IS NOT NULL
	and acc.AccountID = @c_accountid and e.EventTypeID = @RateSpreadSchedule
END


--PrepayAndAdditionalFeeSchedule
IF EXISTS (SELECT EventTypeID FROM ##tblEvent WHERE EventTypeID=@PrepayAndAdditionalFeeSchedule)
BEGIN
  INSERT INTO [Core].[PrepayAndAdditionalFeeSchedule] (
	   [EventID]
      ,[StartDate]
      ,[ValueTypeID]
      ,[Value]
      ,[IncludedLevelYield]
      ,[IncludedBasis]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
      ,[FeeName]
      ,[EndDate]
      ,[FeeAmountOverride]
      ,[BaseAmountOverride]
      ,[ApplyTrueUpFeature]
      ,[FeetobeStripped])


   SELECT 
		 (SELECT TOP 1
            EventId
           FROM CORE.[event] se 
           WHERE se.[EffectiveStartDate] = CONVERT(date, e.EffectiveStartDate, 101)
           AND se.[EventTypeID] = @PrepayAndAdditionalFeeSchedule
           AND se.AccountID = @insertedAccountID),
           CONVERT(date, pre.StartDate, 101),
           ValueTypeID,
           Value,
           IncludedLevelYield,
		   IncludedBasis,
		   pre.CreatedBy,
	       pre.CreatedDate,
	       @UpdatedBy as Updatedby,
           getdate() as UpdatedDate,
	FeeName,pre.EndDate,FeeAmountOverride,BaseAmountOverride,ApplyTrueUpFeature,FeetobeStripped
    FROM ##tblPrepayAndAdditionalFeeSchedule pre 
	inner join ##tblEvent e on e.eventid =  pre.EventId
	inner join ##tblAccount acc   on acc.AccountID =  e.AccountID
    WHERE pre.StartDate is not null and ValueTypeID IS NOT NULL
	and acc.AccountID = @c_accountid and e.EventTypeID = @PrepayAndAdditionalFeeSchedule
END




--FinancingFeeSchedule


IF EXISTS (SELECT EventTypeID FROM ##tblEvent WHERE EventTypeID=@FinancingFeeSchedule)
BEGIN
		INSERT INTO Core.FinancingFeeSchedule(
		 [EventId]
		,[Date]
		,[ValueTypeID]
		,[Value]
		,[CreatedBy]
		,[CreatedDate]
		,[UpdatedBy]
		,[UpdatedDate]
		)


		 
	   SELECT (SELECT TOP 1
             EventId
           FROM CORE.[event] se
           WHERE se.[EffectiveStartDate] = CONVERT(date, e.EffectiveStartDate, 101)
           AND se.[EventTypeID] = @FinancingFeeSchedule
           AND se.AccountID = @insertedAccountID),
           CONVERT(date, fs.Date, 101),
           ValueTypeID,
           [Value],          
		   fs.CreatedBy,
	       fs.CreatedDate,
	       @UpdatedBy as Updatedby,
           getdate() as UpdatedDate
    FROM ##tblFinancingFeeSchedule fs 
	inner join ##tblEvent e  on e.eventid =  fs.EventId
	inner join ##tblAccount acc on acc.AccountID =  e.AccountID
    WHERE fs.Date is not null and ValueTypeID IS NOT NULL
	and acc.AccountID = @c_accountid and e.EventTypeID = @FinancingFeeSchedule
END

--FinancingSchedule
IF EXISTS (SELECT EventTypeID FROM ##tblEvent WHERE EventTypeID=@FinancingSchedule)
BEGIN
		INSERT INTO Core.FinancingSchedule(
		[EventId]
      ,[Date]
      ,[ValueTypeID]
      ,[Value]
      ,[IndexTypeID]
      ,[IntCalcMethodID]
      ,[CurrencyCode]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
		)

SELECT (SELECT TOP 1
             EventId
           FROM CORE.[event] se 
           WHERE se.[EffectiveStartDate] = CONVERT(date, e.EffectiveStartDate, 101)
           AND se.[EventTypeID] = @FinancingSchedule
           AND se.AccountID = @insertedAccountID),
           CONVERT(date, fsh.Date, 101),
           ValueTypeID,
           Value,  
		   IndexTypeID, 
		   IntCalcMethodID,
		   CurrencyCode,        
		   fsh.CreatedBy,
	       fsh.CreatedDate,
	       @UpdatedBy as Updatedby,
          getdate() as UpdatedDate
    FROM ##tblFinancingSchedule fsh 
	inner join ##tblEvent e  on e.eventid =  fsh.EventId
	inner join ##tblAccount acc  on acc.AccountID =  e.AccountID
    WHERE fsh.Date is not null and ValueTypeID IS NOT NULL
	and acc.AccountID = @c_accountid and e.EventTypeID = @FinancingSchedule

END

--DeafultSchedule
IF EXISTS (SELECT EventTypeID FROM ##tblEvent WHERE EventTypeID=@DefaultSchedule)
BEGIN
 INSERT INTO core.DefaultSchedule(
       [EventId]
      ,[StartDate]
      ,[EndDate]
      ,[ValueTypeID]
      ,[Value]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
 )
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
		 dsh.CreatedBy,
		 dsh.CreatedDate,
		 @UpdatedBy as Updatedby,
          getdate() as UpdatedDate	
    FROM ##tblDefaultSchedule dsh  
	inner join ##tblEvent e on e.eventid =  dsh.EventId
	inner join ##tblAccount acc on acc.AccountID =  e.AccountID
    WHERE dsh.StartDate is not null and ValueTypeID IS NOT NULL
	and acc.AccountID = @c_accountid and  e.EventTypeID = @DefaultSchedule

	END

--PIKSchedule
IF EXISTS (SELECT EventTypeID FROM ##tblEvent WHERE EventTypeID=@PIKSchedule)
BEGIN
 INSERT INTO Core.PIKSchedule(
       [EventID]
      ,[SourceAccountID]
      ,[TargetAccountID]
      ,[AdditionalIntRate]
      ,[AdditionalSpread]
      ,[IndexFloor]
      ,[IntCompoundingRate]
      ,[IntCompoundingSpread]
      ,[StartDate]
      ,[EndDate]
      ,[IntCapAmt]
      ,[PurBal]
      ,[AccCapBal]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate])

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
		 PIK.CreatedBy,
		 PIK.CreatedDate,
		@UpdatedBy as Updatedby,
          getdate() as UpdatedDate
    FROM ##tblPIKSchedule PIK  with (NOLOCK)
	inner join ##tblEvent e  with (NOLOCK) on e.eventid =  PIK.EventId
	inner join ##tblAccount acc  with (NOLOCK) on acc.AccountID =  e.AccountID
    WHERE PIK.StartDate is not null 
	and acc.AccountID = @c_accountid and e.EventTypeID = @PIKSchedule
	END

--ServicingFeeSchedule
IF EXISTS (SELECT EventTypeID FROM ##tblEvent WHERE EventTypeID=@ServicingFeeSchedule)
BEGIN
 INSERT INTO Core.ServicingFeeSchedule(
       [EventId]
      ,[Date]
      ,[Value]
      ,[IsCapitalized]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
 )

 SELECT (SELECT TOP 1
             EventId
           FROM CORE.[event] se
           WHERE se.[EffectiveStartDate] = CONVERT(date, e.EffectiveStartDate, 101)
           AND se.[EventTypeID] = @ServicingFeeSchedule
           AND se.AccountID = @insertedAccountID),
           CONVERT(date, ser.Date, 101),
           Value,
		   IsCapitalized,		        
		   ser.CreatedBy,
		   ser.CreatedDate,
		   @UpdatedBy as Updatedby,
          getdate() as UpdatedDate
    FROM ##tblServicingFeeSchedule ser  
	inner join ##tblEvent e   on e.eventid =  ser.EventId
	inner join ##tblAccount acc   on acc.AccountID =  e.AccountID
    WHERE ser.Date is not null 
	and acc.AccountID = @c_accountid and e.EventTypeID = @ServicingFeeSchedule
END

--FundingSchedule
IF EXISTS (SELECT EventTypeID FROM ##tblEvent WHERE EventTypeID=@FundingSchedule)
BEGIN
INSERT INTO core.FundingSchedule ([EventId]
      ,[Date]
      ,[Value]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
      ,[PurposeID]
      ,[Applied]
      ,[DrawFundingId]
      ,[Comments]
      ,[Issaved]
      ,[DealFundingRowno]
      ,[DealFundingID]
      ,[WF_CurrentStatus])

	  SELECT (SELECT TOP 1
				EventId
			FROM CORE.[event] se
			WHERE se.[EffectiveStartDate] = CONVERT(date, e.EffectiveStartDate, 101)
			AND se.[EventTypeID] = @FundingSchedule and StatusID = 1
			AND se.AccountID = @insertedAccountID),
			CONVERT(date, fd.Date, 101),
			Value,	
			fd.CreatedBy,
			fd.CreatedDate,
			@UpdatedBy as Updatedby,
            getdate() as UpdatedDate,
			PurposeID,
			Applied,
		    DrawFundingId,
		    Comments,
			Issaved,	
		    DealFundingRowno
		   ,[DealFundingID]
          ,[WF_CurrentStatus]
	FROM ##tblFundingSchedule fd 
	inner join ##tblEvent e  on e.eventid =  fd.EventId
	inner join ##tblAccount acc on acc.AccountID =  e.AccountID
	WHERE fd.Date is not null 
	and e.StatusID = 1
	and acc.AccountID = @c_accountid and  e.EventTypeID = @FundingSchedule

  END


 --PIKScheduleDetail
IF EXISTS (SELECT EventTypeID FROM ##tblEvent WHERE EventTypeID=@PIKScheduleDetail)
BEGIN
INSERT INTO Core.PIKScheduleDetail(
       [EventId]
      ,[Date]
      ,[Value]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate])

SELECT (SELECT TOP 1
             EventId
           FROM CORE.[event] se  
           WHERE se.[EffectiveStartDate] = CONVERT(date, e.EffectiveStartDate, 101)
           AND se.[EventTypeID] = @PIKScheduleDetail
           AND se.AccountID = @insertedAccountID),
           CONVERT(date, piks.Date, 101),
           Value,		  	        
		   piks.[CreatedBy]
		  ,piks.[CreatedDate]
		  ,@UpdatedBy as Updatedby
          ,getdate() as UpdatedDate
    FROM ##tblPIKScheduleDetail piks 
	inner join ##tblEvent e  on e.eventid =  piks.EventId
	inner join ##tblAccount acc  on acc.AccountID =  e.AccountID
    WHERE piks.Date is not null 
	and acc.AccountID = @c_accountid and e.EventTypeID = @PIKScheduleDetail
END

 --LIBORSchedule
IF EXISTS (SELECT EventTypeID FROM ##tblEvent WHERE EventTypeID=@LIBORSchedule)
BEGIN
INSERT INTO Core.LIBORSchedule(
       [EventId]
      ,[Date]
      ,[Value]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate])

SELECT (SELECT TOP 1
             EventId
           FROM CORE.[event] se 
           WHERE se.[EffectiveStartDate] = CONVERT(date, e.EffectiveStartDate, 101)
           AND se.[EventTypeID] = @LIBORSchedule
           AND se.AccountID = @insertedAccountID),
           CONVERT(date, lb.Date, 101),
           Value,		  	        
		   lb.[CreatedBy],
		   lb.[CreatedDate],
		   @UpdatedBy as Updatedby,
           getdate() as UpdatedDate
    FROM ##tblLiborSchedule lb 
	inner join ##tblEvent e on e.eventid =  lb.EventId
	inner join ##tblAccount acc  on acc.AccountID =  e.AccountID
    WHERE lb.Date is not null 
	and acc.AccountID = @c_accountid and e.EventTypeID = @LIBORSchedule
END

--AmortSchedule
IF EXISTS (SELECT EventTypeID FROM ##tblEvent WHERE EventTypeID=@AmortSchedule)
BEGIN
INSERT INTO Core.AmortSchedule(
       [EventId]
      ,[Date]
      ,[Value]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
)

SELECT (SELECT TOP 1
             EventId
           FROM CORE.[event] se 
           WHERE se.[EffectiveStartDate] = CONVERT(date, e.EffectiveStartDate, 101)
           AND se.[EventTypeID] = @AmortSchedule
           AND se.AccountID = @insertedAccountID),
           CONVERT(date, ams.Date, 101),
           Value,		  	        
		  ams.[CreatedBy]
         ,ams.[CreatedDate]
         ,@UpdatedBy as Updatedby,
         getdate() as UpdatedDate
    FROM ##tblAmortSchedule ams 
	inner join ##tblEvent e  on e.eventid =  ams.EventId
	inner join ##tblAccount acc  on acc.AccountID =  e.AccountID
    WHERE ams.Date is not null 
	and acc.AccountID = @c_accountid and e.EventTypeID = @AmortSchedule
	END

--FeeCouponStripReceivable
IF EXISTS (SELECT EventTypeID FROM ##tblEvent WHERE EventTypeID=@FeeCouponStripReceivable)
BEGIN
INSERT INTO Core.FeeCouponStripReceivable(
       [EventId]
      ,[Date]
      ,[Value]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
      )

SELECT (SELECT TOP 1
             EventId
           FROM CORE.[event] se  
           WHERE se.[EffectiveStartDate] = CONVERT(date, e.EffectiveStartDate, 101)
           AND se.[EventTypeID] = @FeeCouponStripReceivable
           AND se.AccountID = @insertedAccountID),
           CONVERT(date, fc.Date, 101),
           Value,		  	        
		   fc.[CreatedBy]
          ,fc.[CreatedDate]
          ,@UpdatedBy as Updatedby
          ,getdate() as UpdatedDate
		  
    FROM ##tblFeeCouponStripReceivable fc  
	inner join ##tblEvent e   on e.eventid =  fc.EventId
	inner join ##tblAccount acc   on acc.AccountID =  e.AccountID
    WHERE fc.Date is not null 
	and acc.AccountID = @c_accountid and e.EventTypeID = @FeeCouponStripReceivable
	END

--Exceptions
INSERT INTO Core.Exceptions(
       [ObjectID]
      ,[ObjectTypeID]
      ,[FieldName]
      ,[Summary]
      ,[ActionLevelID]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
	  )

select @insertednoteID,ObjectTypeID,FieldName,Summary,ActionLevelID,CreatedBy,CreatedDate,@UpdatedBy as Updatedby,
          getdate() as UpdatedDate
from ##tblExceptions WHERE ObjectID=@c_NoteId

--FundingRules
INSERT INTO [CRE].[FundingRepaymentSequence](
       [NoteID]
      ,[SequenceNo]
      ,[SequenceType]
      ,[Value]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
)
select @insertednoteID
      ,SequenceNo
	  ,SequenceType
	  ,Value
	  ,CreatedBy
	  ,[CreatedDate]
	  ,@UpdatedBy as Updatedby
      ,getdate() as UpdatedDate
from ##tblFundingRepaymentSequence   where NoteID=@c_NoteId

--PayruleDistributions
INSERT INTO CRE.PayruleDistributions (
	TransactionDate
	,SourceNoteID
	,ReceiverNoteID
	,RuleID
	,Amount
	,CreatedBy
	,CreatedDate
	,UpdatedBy
	,UpdatedDate)  

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
	  ,nc.CreatedBy
	  ,nc.CreatedDate
	  ,@UpdatedBy as Updatedby
      ,getdate() as UpdatedDate
	 from CRE.NotePeriodicCalc nc
	 inner join CRE.PayruleSetup ps on ps.StripTransferFrom=nc.NoteID
	 where nc.NoteID=@c_NoteId


 update [CRE].[PayruleSetup] set striptransferfrom=@insertedNoteID where DealID=@NewDealID and striptransferfrom=@c_NoteId

 update [CRE].[PayruleSetup] set striptransferto=@insertedNoteID where DealID=@NewDealID and striptransferto=@c_NoteId


 
  EXEC usp_InsertUpdateFeeCouponStripReceivableForPayruleSetup @insertednoteID,CreatedBy,@AnalysisIDDefault
  
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
	,[CreatedDate]
	,@UpdatedBy as Updatedby
    ,getdate() as UpdatedDate
	FROM ##tblServicerDropDateSetup
	WHERE NoteID = @c_NoteId  
	


FETCH NEXT FROM copy_cursor into  @c_accountid,  @c_NoteName, @c_CRENoteID, @c_NoteId

	END	  
	CLOSE copy_cursor;  
	  DEALLOCATE copy_cursor; 

	  delete from [CRE].[PayruleSetup] where StripTransferFrom not in (select NoteID from cre.Note where DealID =@NewDealID) and dealid=@NewDealID
      delete from [CRE].[PayruleSetup] where StripTransferTo not in (select NoteID from cre.Note where DealID =@NewDealID) and dealid=@NewDealID

	 exec [dbo].[usp_QueueDealForCalculation] @NewDealID,@UpdatedBy,@AnalysisIDDefault,775

IF OBJECT_ID('tempdb..##tblDeal') IS NOT NULL             
DROP TABLE ##tblDeal; 
IF OBJECT_ID('tempdb..##tblProperty') IS NOT NULL             
DROP TABLE ##tblProperty           
 IF OBJECT_ID('tempdb..##tblDealFunding') IS NOT NULL             
DROP TABLE ##tblDealFunding          
IF OBJECT_ID('tempdb..##tblPayrule') IS NOT NULL             
DROP TABLE ##tblPayrule 
IF OBJECT_ID('tempdb..##tblNoteCursor') IS NOT NULL             
DROP TABLE ##tblNoteCursor         
IF OBJECT_ID('tempdb..##tblAccount') IS NOT NULL             
DROP TABLE ##tblAccount  
IF OBJECT_ID('tempdb..##tblNote') IS NOT NULL             
DROP TABLE ##tblNote 
IF OBJECT_ID('tempdb..##tblEvent ') IS NOT NULL             
DROP TABLE ##tblEvent 
IF OBJECT_ID('tempdb..##tblMaturity') IS NOT NULL             
DROP TABLE ##tblMaturity   
IF OBJECT_ID('tempdb..##tblRateSpreadSchedule') IS NOT NULL             
DROP TABLE ##tblRateSpreadSchedule     
IF OBJECT_ID('tempdb..##tblPrepayAndAdditionalFeeSchedule') IS NOT NULL             
DROP TABLE ##tblPrepayAndAdditionalFeeSchedule     
IF OBJECT_ID('tempdb..##tblFinancingFeeSchedule') IS NOT NULL             
DROP TABLE ##tblFinancingFeeSchedule     
IF OBJECT_ID('tempdb..##tblFinancingSchedule') IS NOT NULL             
DROP TABLE ##tblFinancingSchedule 
IF OBJECT_ID('tempdb..##tblDefaultSchedule') IS NOT NULL             
DROP TABLE ##tblDefaultSchedule     
IF OBJECT_ID('tempdb..##tblPIKSchedule') IS NOT NULL             
DROP TABLE ##tblPIKSchedule  
IF OBJECT_ID('tempdb..##tblServicingFeeSchedule') IS NOT NULL             
DROP TABLE ##tblServicingFeeSchedule  
IF OBJECT_ID('tempdb..##tblFundingSchedule') IS NOT NULL             
DROP TABLE ##tblFundingSchedule  
IF OBJECT_ID('tempdb..##tblPIKScheduleDetail') IS NOT NULL             
DROP TABLE ##tblPIKScheduleDetail 
IF OBJECT_ID('tempdb..##tblLiborSchedule') IS NOT NULL             
DROP TABLE ##tblLiborSchedule 
IF OBJECT_ID('tempdb..##tblAmortSchedule') IS NOT NULL             
DROP TABLE ##tblAmortSchedule 
IF OBJECT_ID('tempdb..##tblFeeCouponStripReceivable') IS NOT NULL             
DROP TABLE ##tblFeeCouponStripReceivable
IF OBJECT_ID('tempdb..##tblExceptions') IS NOT NULL             
DROP TABLE ##tblExceptions
IF OBJECT_ID('tempdb..##tblFundingRepaymentSequence') IS NOT NULL             
DROP TABLE ##tblFundingRepaymentSequence
IF OBJECT_ID('tempdb..##tblPayruleDistributions') IS NOT NULL             
DROP TABLE ##tblPayruleDistributions
 IF OBJECT_ID('tempdb..##tblServicerDropDateSetup') IS NOT NULL             
DROP TABLE ##tblServicerDropDateSetup




 
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
END
END
COMMIT TRAN
END TRY
BEGIN CATCH

	DECLARE @ErrorMessage NVARCHAR(4000);
	DECLARE @ErrorSeverity INT;
	DECLARE @ErrorState INT;

	SELECT @ErrorMessage = 'SQL error ' + ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(),  @ErrorState = ERROR_STATE();
	IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION;

	-- Use RAISERROR inside the CATCH block to return error
	-- information about the original error that caused
	-- execution to jump to the CATCH block.

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
	  
END CATCH
END




 
