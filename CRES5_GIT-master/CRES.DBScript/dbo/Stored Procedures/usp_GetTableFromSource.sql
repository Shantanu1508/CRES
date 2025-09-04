--[dbo].[usp_GetTableFromSource]  '19-0422','RemoteReference_CopyDealOtherSrc'

CREATE PROCEDURE [dbo].[usp_GetTableFromSource]
@CREDealID nvarchar(256),
@Env nvarchar(256)
AS
BEGIN
	SET NOCOUNT ON;


DECLARE @queryDeal nvarchar(MAX) = N'
Select 
d.DealID,
d.DealName,
d.CREDealID,
d.DealType,
d.LoanProgram,
d.LoanPurpose,
d.Status,
d.AppReceived,
d.EstClosingDate,
d.BorrowerRequest,
d.RecommendedLoan,
d.TotalFutureFunding,
d.Source,
d.BrokerageFirm,
d.BrokerageContact,
d.Sponsor,
d.Principal,
d.NetWorth,
d.Liquidity,
d.ClientDealId,
d.GeneratedBy,
d.CreatedBy,
d.CreatedDate,
d.Updatedby,
d.UpdatedDate,
d.Totalcommitment,
d.AdjustedTotalCommitment,
d.AggregatedTotal,
d.AssetManagerComment,
d.AssetManager,
d.DealCity,
d.DealState,
d.DealPropertyType,
d.FullyExtMaturityDate,
d.UnderwritingStatus,
d.LinkedDealId,
d.DealComment,
d.SourceDealID,
d.IsDeleted,
d.AllowSizerUpload,
d.AMUserID,
d.AMTeamLeadUserID,
d.AMSecondUserID,
d.DealRule,
d.Companyname,
d.FirstName,
d.Lastname,
d.StreetName,
d.ZipCodePostal,
d.PayeeName,
d.TelephoneNumber1,
d.FederalID1,
d.TaxEscrowConstant,
d.InsEscrowConstant,
d.CollectTaxEscrow,
d.CollectInsEscrow,
d.DealCityWells,
d.DealStateWells,
d.BoxDocumentLink,
d.DealGroupID,
d.EnableAutoSpread

,d.AmortizationMethod
,d.ReduceAmortizationForCurtailments
,d.BusinessDayAdjustmentForAmort
,d.NoteDistributionMethod
,d.PeriodicStraightLineAmortOverride
,d.FixedPeriodicPayment
,d.EquityAmount
,d.RemainingAmount
,d.DealTypeMasterID
,d.EnableAutospreadRepayments
,d.AutoUpdateFromUnderwriting
,d.ExpectedFullRepaymentDate
,d.RepaymentAutoSpreadMethodID
,d.RepaymentStartDate
,d.EarliestPossibleRepaymentDate
,d.Blockoutperiod
,d.PossibleRepaymentdayofthemonth
,d.Repaymentallocationfrequency
,d.AutoPrepayEffectiveDate
,d.LatestPossibleRepaymentDate
,d.KnownFullPayoffDate
,d.CalcEngineType
FROM [CRE].[Deal] d
WHERE  d.CREDealID = '''+@CREDealID+''' 
'  

--Property 
 DECLARE @propquery nvarchar(MAX) = N'
Select 
 p.[PropertyID]
,p.[Deal_DealID]
,p.[PropertyName]
,p.[Address]
,p.[City]
,p.[State]
,p.[Zip]
,p.[UWNCF]
,p.[SQFT]
,p.[PropertyType]
,p.[AllocDebtPer]
,p.[PropertySubtype]
,p.[NumberofUnitsorSF]
,p.[Occ]
,p.[Class]
,p.[YearBuilt]
,p.[Renovated]
,p.[Bldgs]
,p.[Acres]
,p.[CreatedBy]
,p.[CreatedDate]
,p.[UpdatedBy]
,p.[UpdatedDate]
,p.[ProjectName]
,p.[HOUSESTREET1]
,p.[VILLAGE]
,p.[ZIPCODE]
,p.[OwnerOccupied]
,p.[PROPDESCCODE]
,p.[SALESPRICE]
,p.[ConstructionDate]
,p.[NumberofStories]
,p.[MeasuredIn]
,p.[TotalSquareFeet]
,p.[TotalRentableSqFt]
,p.[TotalNumberofUnits]
,p.[OverallCondition]
,p.[RenovationDate]
,p.[NextInspectionDate]
,p.[GroundLease]
,p.[NumberOfTenants]
,p.[VacancyFactor]
,p.[Allocation]
,p.[LIENPosition]
,p.[CMSAProperyType]
,p.[PState]
,p.[country]
,p.[DealAllocationAmtPCT]
,p.[PropertyRollUpSW] 
,p.[IsDeleted]
 FROM [CRE].[Property] p
 inner join [CRE].[Deal] d on d.DealId = p.[Deal_DealID] 
 WHERE  d.CREDealID = '''+@CREDealID+''' 
'

--DealFunding
   DECLARE @dealfundingquery nvarchar(MAX) = N'
Select 
       df.[DealFundingID]
      ,df.[DealID]
      ,df.[Date]
      ,df.[Amount]
      ,df.[CreatedBy]
      ,df.[CreatedDate]
      ,df.[UpdatedBy]
      ,df.[UpdatedDate]
      ,df.[Comment]
      ,df.[PurposeID]
      ,df.[Applied]
      ,df.[DrawFundingId]
      ,df.[Issaved]
      ,df.[DealFundingRowno]
      ,df.[DeadLineDate]
      ,df.[LegalDeal_DealFundingID]
      ,df.[SubPurposeType]
      ,df.[EquityAmount]
      ,df.[RemainingFFCommitment]
      ,df.[RemainingEquityCommitment]
	  ,df.RequiredEquity 
		,df.AdditionalEquity
  FROM [CRE].[DealFunding] df 
inner join [CRE].[Deal] d on d.DealId = df.[DealID]
 WHERE  d.CREDealID = '''+@CREDealID+''' 
'  
 --PayruleSetup
   DECLARE @payrulequery nvarchar(MAX) = N'
Select 
       ps.[PayruleSetupID]
      ,ps.[DealID]
      ,ps.[StripTransferFrom]
      ,ps.[StripTransferTo]
      ,ps.[Value]
      ,ps.[RuleID]
      ,ps.[CreatedBy]
      ,ps.[CreatedDate]
      ,ps.[UpdatedBy]
      ,ps.[UpdatedDate]
  FROM [CRE].[PayruleSetup] ps
 inner join [CRE].[Deal] d on d.DealId = ps.[DealID]
  WHERE  d.CREDealID = '''+@CREDealID+''' 
' 

 --AutoSpreadRuleSetup
DECLARE @AutoSpreadRulequery nvarchar(MAX) = N'
Select 
ps.[AutoSpreadRuleID]
,ps.[DealID]
,ps.[PurposeType] 
,ps.[PurposeSubType]
,ps.[DebtAmount]
,ps.[EquityAmount]
,ps.[StartDate] 
,ps.[EndDate] 
,ps.[DistributionMethod]
,ps.[FrequencyFactor] 
,ps.[Comment] 
,ps.[CreatedBy] 
,ps.[CreatedDate] 
,ps.[UpdatedBy] 
,ps.[UpdatedDate] 
,ps.[RequiredEquity]
,ps.[AdditionalEquity]
FROM [CRE].[AutoSpreadRule] ps
inner join [CRE].[Deal] d on d.DealId = ps.[DealID]
WHERE  d.CREDealID = '''+@CREDealID+''' 
' 

 --DealAmortizationSchedule
DECLARE @DealAmortizationSchedulequery nvarchar(MAX) = N'
Select 
 ps.[DealAmortizationScheduleID]    
,ps.[DealID]                        
,ps.[Date]                          
,ps.[Amount]                        
,ps.[CreatedBy]                     
,ps.[CreatedDate]                   
,ps.[UpdatedBy]                     
,ps.[UpdatedDate]                   
,ps.[DealAmortizationScheduleAutoID]
,ps.[DealAmortScheduleRowno]
FROM [CRE].[DealAmortizationSchedule] ps
inner join [CRE].[Deal] d on d.DealId = ps.[DealID]
WHERE  d.CREDealID = '''+@CREDealID+''' 
' 

 --DealProjectedPayOffAccounting
DECLARE @DealProjectedPayOffAccountingquery nvarchar(MAX) = N'
Select 
ps.DealProjectedPayOffAccountingID
,ps.DealID
,ps.AsOfDate
,ps.CumulativeProbability
,ps.[CreatedBy] 
,ps.[CreatedDate]
,ps.[UpdatedBy]
,ps.[UpdatedDate]  
FROM [CRE].[DealProjectedPayOffAccounting] ps
inner join [CRE].[Deal] d on d.DealId = ps.[DealID]
WHERE  d.CREDealID = '''+@CREDealID+''' 
' 

DECLARE @WLDealPotentialImpairmentMasterquery nvarchar(MAX) = N'
 Select
			pm.DealID,
			pm.Date,
			pm.Amount,
			pm.AdjustmentType,
			pm.Comment,
			pm.Applied,
			pm.CreatedBy,
			pm.CreatedDate,
			pm.UpdatedBy,
			pm.UpdatedDate,
			pm.RowNo
	FROM [CRE].[WLDealPotentialImpairmentMaster] pm
	inner join [CRE].[Deal] d on d.DealId = pm.[DealID]
    WHERE  d.CREDealID = '''+@CREDealID+'''
'

DECLARE @WLDealAccountingquery nvarchar(MAX) = N'
Select
			da.DealID,
			da.StartDate,
			da.EndDate,
			da.TypeID,
			da.Comment,
			da.CreatedBy,
			da.CreatedDate,
			da.UpdatedBy,
			da.UpdatedDate
	FROM [CRE].[WLDealAccounting] da
	inner join [CRE].[Deal] d on d.DealId = da.[DealID]
    WHERE  d.CREDealID = '''+@CREDealID+'''
'

--NoteCursor
DECLARE @cursorquery nvarchar(MAX) = N'
  select acc.AccountID,acc.name,n.CRENoteID, n.NoteId 
  from [CRE].[Note] n 
  inner join [Core].[Account] acc ON acc.AccountID = n.Account_AccountID
  inner join [CRE].[Deal] d ON n.DealID = d.DealID  
  WHERE  d.CREDealID = '''+@CREDealID+''' '


  --Account Table
   DECLARE @accountquery nvarchar(MAX) = N'
     Select 
      acc.[AccountID]
       ,182
      ,acc.[StatusID]
      ,acc.[Name] 
      ,acc.[StartDate]
      ,acc.[EndDate]
      ,acc.[BaseCurrencyID]
      ,acc.[PayFrequency]
      ,acc.[ClientNoteID]
      ,acc.[CreatedBy]
      ,acc.[CreatedDate]
      ,acc.[UpdatedBy]
      ,acc.[UpdatedDate]
      ,acc.[IsDeleted]
  FROM [Core].[Account] acc
  inner join [CRE].[Note] n  ON  n.Account_AccountID = acc.AccountID 
  inner join [CRE].[Deal] d ON d.DealID = n.[DealID]
  WHERE d.CREDealID = '''+@CREDealID+''' 
' 

--Note

DECLARE @notequery1 nvarchar(MAX) = N'Select 
	   n.[NoteID]
      ,n.[Account_AccountID]
      ,n.[DealID]
      ,n.[CRENoteID]
      ,n.[ClientNoteID]
      ,n.[Comments]
      ,n.[InitialInterestAccrualEndDate]
      ,n.[AccrualFrequency]
      ,n.[DeterminationDateLeadDays]
      ,n.[DeterminationDateReferenceDayoftheMonth]
      ,n.[DeterminationDateInterestAccrualPeriod]
      ,n.[DeterminationDateHolidayList]
      ,n.[FirstPaymentDate]
      ,n.[InitialMonthEndPMTDateBiWeekly]
      ,n.[PaymentDateBusinessDayLag]
      ,n.[IOTerm]
      ,n.[AmortTerm]
      ,n.[PIKSeparateCompounding]
      ,n.[MonthlyDSOverridewhenAmortizing]
      ,n.[AccrualPeriodPaymentDayWhenNotEOMonth]
      ,n.[FirstPeriodInterestPaymentOverride]
      ,n.[FirstPeriodPrincipalPaymentOverride]
      ,n.[FinalInterestAccrualEndDateOverride]
      ,n.[AmortType]
      ,n.[RateType]
      ,n.[ReAmortizeMonthly]
      ,n.[ReAmortizeatPMTReset]
      ,n.[StubPaidInArrears]
      ,n.[RelativePaymentMonth]
      ,n.[SettleWithAccrualFlag]
      ,n.[InterestDueAtMaturity]
      ,n.[RateIndexResetFreq]
      ,n.[FirstRateIndexResetDate]
      ,n.[LoanPurchase]
      ,n.[AmortIntCalcDayCount]
      ,n.[StubPaidinAdvanceYN]
      ,n.[FullPeriodInterestDueatMaturity]
      ,n.[ProspectiveAccountingMode]
      ,n.[IsCapitalized]
      ,n.[SelectedMaturityDateScenario]
      ,n.[SelectedMaturityDate]
      ,n.[InitialMaturityDate]
      ,n.[ExpectedMaturityDate]
      ,n.[FullyExtendedMaturityDate]
      ,n.[OpenPrepaymentDate]
      ,n.[CashflowEngineID]
      ,n.[LoanType]
      ,n.[Classification]
      ,n.[SubClassification]
      ,n.[GAAPDesignation]
      ,n.[PortfolioID]
      ,n.[GeographicLocation]
      ,n.[PropertyType]
      ,n.[RatingAgency]
      ,n.[RiskRating]
      ,n.[PurchasePrice]
      ,n.[FutureFeesUsedforLevelYeild]
      ,n.[TotalToBeAmortized]
      ,n.[StubPeriodInterest]
      ,n.[WDPAssetMultiple]
      ,n.[WDPEquityMultiple]
      ,n.[PurchaseBalance]
      ,n.[DaysofAccrued]
      ,n.[InterestRate]
      ,n.[PurchasedInterestCalc]
      ,n.[ModelFinancingDrawsForFutureFundings]
      ,n.[NumberOfBusinessDaysLagForFinancingDraw]
      ,n.[FinancingFacilityID]
      ,n.[FinancingInitialMaturityDate]
      ,n.[FinancingExtendedMaturityDate]
      ,n.[FinancingPayFrequency]
      ,n.[FinancingInterestPaymentDay]
      ,n.[ClosingDate]
      ,n.[InitialFundingAmount]
      ,n.[Discount]
      ,n.[OriginationFee]
      ,n.[CapitalizedClosingCosts]
      ,n.[PurchaseDate]
      ,n.[PurchaseAccruedFromDate]
      ,n.[PurchasedInterestOverride]
      ,n.[DiscountRate]
      ,n.[ValuationDate]
      ,n.[FairValue]
      ,n.[DiscountRatePlus]
      ,n.[FairValuePlus]
      ,n.[DiscountRateMinus]
      ,n.[FairValueMinus]
      ,n.[InitialIndexValueOverride]
      ,n.[IncludeServicingPaymentOverrideinLevelYield]
      ,n.[OngoingAnnualizedServicingFee]
      ,n.[IndexRoundingRule]
      ,n.[RoundingMethod]
      ,n.[StubInterestPaidonFutureAdvances]
      ,n.[TaxAmortCheck]
      ,n.[PIKWoCompCheck]
      ,n.[GAAPAmortCheck]
      ,n.[StubIntOverride]
      ,n.[PurchasedIntOverride]
      ,n.[ExitFeeFreePrepayAmt]
      ,n.[ExitFeeBaseAmountOverride]
      ,n.[ExitFeeAmortCheck]
      ,n.[FixedAmortScheduleCheck]
      ,n.[GeneratedBy]
      ,n.[UseRuletoDetermineNoteFunding]
      ,n.[NoteFundingRule]
      ,n.[FundingPriority]
      ,n.[NoteBalanceCap]
      ,n.[RepaymentPriority]
      ,n.[NoofdaysrelPaymentDaterollnextpaymentcycle]
      ,n.[UseIndexOverrides]
      ,n.[IndexNameID]
      ,n.[LienPriority]
      ,n.[CreatedBy]
      ,n.[CreatedDate]
      ,n.[UpdatedBy]
      ,n.[UpdatedDate]
      ,n.[ServicerID]
      ,n.[TotalCommitment]
      ,n.[ClientName]
      ,n.[Portfolio]'
	  
	 
DECLARE @notequery2 nvarchar(MAX) = N'
	  ,n.[Tag1]
      ,n.[Tag2]
	  ,n.[Tag3]
      ,n.[Tag4]
	 -- ,n.[ExtendedMaturityScenario1]
     -- ,n.[ExtendedMaturityScenario2]
     -- ,n.[ExtendedMaturityScenario3]
      ,n.[ActualPayoffDate]
      ,n.[TotalCommitmentExtensionFeeisBasedOn]
      ,n.[UnusedFeeThresholdBalance]
      ,n.[UnusedFeePaymentFrequency]
      ,n.[lienposition]
      ,n.[priority]
      ,n.[Servicer]
      ,n.[FullInterestAtPPayoff]
      ,n.[NoteRule]
      ,n.[ClientID]
      ,n.[FinancingSourceID]
      ,n.[DebtTypeID]
      ,n.[BillingNotesID]
      ,n.[CapStack]
      ,n.[FundID]
      ,n.[PoolId]
      ,n.[TaxVendorLoanNumber]
      ,n.[TAXBILLSTATUS]
      ,n.[CURRTAXCONSTANT]
      ,n.[InsuranceBillStatusCode]
      ,n.[RESERVETYPE]
      ,n.[ResDescOwnName]
      ,n.[MONTHLYPAYMENTAMT]
      ,n.[IORPLANCODE]
      ,n.[NoDaysbeforeAssessment]
      ,n.[LateChargeRateorFee]
      ,n.[DefaultOfDaysto]
      ,n.[OddDaysIntAmount]
      ,n.[InterestRateFloor]
      ,n.[InterestRateCeiling]
      ,n.[Dayslookback]
      ,n.[WF_Companyname]
      ,n.[WF_FirstName]
      ,n.[WF_Lastname]
      ,n.[WF_StreetName]
      ,n.[WF_ZipCodePostal]
      ,n.[WF_PayeeName]
      ,n.[WF_TelephoneNumber1]
      ,n.[WF_FederalID1]
      ,n.[WF_City]
      ,n.[WF_State]
      ,n.[CurrentBls]
      ,n.[StubInterestRateOverride]
      ,n.[LiborDataAsofDate]
      ,n.[ServicerNameID]
      ,n.[BusinessdaylafrelativetoPMTDate]
      ,n.[DayoftheMonth]
      ,n.[InterestCalculationRuleForPaydowns]
      ,n.[PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate]
      ,n.[FundedAndOwnedByThirdParty]
      ,n.[InterestCalculationRuleForPaydownsAmort]

	,n.AdjustedTotalCommitment	
	,n.AggregatedTotal	
	,n.RoundingNote	
	,n.StraightLineAmortOverride	
	,n.RepaymentDayoftheMonth	
	,n.FutureFundingBillingCutoffDay	
	,n.CurtailmentBillingCutoffDay
	,n.UseRuletoDetermineAmortization
	,n.MKT_PRICE
	,n.OriginalTotalCommitment
	,n.StrategyCode
	,n.EnableM61Calculations
	,n.InitialRequiredEquity
	,n.InitialAdditionalEquity
	,n.CommitmentUsedInFFDistribution
	,n.FirstIndexDeterminationDateOverride
  FROM [CRE].[Note] n
  inner join [CRE].[Deal] d  ON  d.DealID = n.DealID 
  where d.CREDealID = '''+@CREDealID+''' 
  
	 '
DECLARE @noteaccountquery nvarchar(MAX) = N'
SELECT acc.AccountID,n.NoteID
FROM [Core].[Account] acc
inner join [CRE].[Note] n ON n.[Account_AccountID] = acc.AccountID
inner join [CRE].[Deal] d on d.DealID = n.DealID
WHERE d.CREDealID = '''+@CREDealID+'''
'
 
---Note Details

--==============Cursor for all note detail schedule=========
--Event
DECLARE @eventquery nvarchar(MAX) = N'
       SELECT
       e.[EventID]
      ,e.[AccountID]
      ,e.[Date]
      ,e.[EventTypeID]
      ,e.[EffectiveStartDate]
      ,e.[EffectiveEndDate]
      ,e.[SingleEventValue]
      ,e.[CreatedBy]
      ,e.[CreatedDate]
      ,e.[UpdatedBy]
      ,e.[UpdatedDate]
      ,e.[StatusID]
FROM [Core].[Event] e
inner join [Core].[Account] acc on acc.AccountID = e.AccountID
inner join [CRE].[Note] n ON n.[Account_AccountID] = acc.AccountID
inner join [CRE].[Deal] d on d.DealID = n.DealID
WHERE d.CREDealID = '''+@CREDealID+'''
and isnull(e.statusid,1)= 1
'

--Maturity

DECLARE @maturityquery nvarchar(MAX) = N'
     SELECT
	   m.[MaturityID]
      ,m.[EventId]
      ,m.[SelectedMaturityDate]
      ,m.[CreatedBy]
      ,m.[CreatedDate]
      ,m.[UpdatedBy]
      ,m.[UpdatedDate]
	  ,m.MaturityDate
	  ,m.MaturityType
	  ,m.Approved
	  ,m.IsAutoApproved
  FROM [Core].[Maturity] m
  inner join core.Event e  on e.eventid =  m.EventId
  inner join core.Account acc on acc.AccountID =  e.AccountID
  inner join [CRE].[Note] n ON n.[Account_AccountID] = acc.AccountID
  inner join [CRE].[Deal] d on d.DealID = n.DealID
  WHERE d.CREDealID = '''+@CREDealID+''' AND e.EventTypeID=11
'

--RateSpreadSchedule
DECLARE @ratespreadschedulequery nvarchar(MAX) = N'
     SELECT
	   r.[RateSpreadScheduleID]
      ,r.[EventId]
      ,r.[Date]
      ,r.[ValueTypeID]
      ,r.[Value]
      ,r.[IntCalcMethodID]
      ,r.[CreatedBy]
      ,r.[CreatedDate]
      ,r.[UpdatedBy]
      ,r.[UpdatedDate]
      ,r.[RateOrSpreadToBeStripped]
      ,r.IndexNameID
	  ,r.DeterminationDateHolidayList
  FROM [Core].[RateSpreadSchedule] r
  inner join core.Event e  on e.eventid =  r.EventId
  inner join core.Account acc on acc.AccountID =  e.AccountID
  inner join [CRE].[Note] n ON n.[Account_AccountID] = acc.AccountID
  inner join [CRE].[Deal] d on d.DealID = n.DealID
  WHERE d.CREDealID = '''+@CREDealID+''' AND e.EventTypeID=14
'

--PrepayAndAdditionalFeeSchedule
DECLARE @prepayandadditionalfeeschedulequery nvarchar(MAX) = N'
SELECT
       p.[PrepayAndAdditionalFeeScheduleID]
      ,p.[EventID]
      ,p.[StartDate]
      ,p.[ValueTypeID]
      ,p.[Value]
      ,p.[IncludedLevelYield]
      ,p.[IncludedBasis]
      ,p.[CreatedBy]
      ,p.[CreatedDate]
      ,p.[UpdatedBy]
      ,p.[UpdatedDate]
      ,p.[FeeName]
      ,p.[EndDate]
      ,p.[FeeAmountOverride]
      ,p.[BaseAmountOverride]
      ,p.[ApplyTrueUpFeature]
      ,p.[FeetobeStripped]
  FROM [Core].[PrepayAndAdditionalFeeSchedule] p
  inner join core.Event e  on e.eventid =  p.EventId
  inner join core.Account acc on acc.AccountID =  e.AccountID
  inner join [CRE].[Note] n ON n.[Account_AccountID] = acc.AccountID
  inner join [CRE].[Deal] d on d.DealID = n.DealID
  WHERE d.CREDealID = '''+@CREDealID+''' AND e.EventTypeID=13
'

--FinancingFeeSchedule
DECLARE @financingfeeschedulequery nvarchar(MAX) = N'
 SELECT
       f.[FinancingFeeScheduleID]
      ,f.[EventId]
      ,f.[Date]
      ,f.[ValueTypeID]
      ,f.[Value]
      ,f.[CreatedBy]
      ,f.[CreatedDate]
      ,f.[UpdatedBy]
      ,f.[UpdatedDate]
  FROM [Core].[FinancingFeeSchedule] f
  inner join core.Event e  on e.eventid =  f.EventId
  inner join core.Account acc on acc.AccountID =  e.AccountID
  inner join [CRE].[Note] n ON n.[Account_AccountID] = acc.AccountID
  inner join [CRE].[Deal] d on d.DealID = n.DealID
  WHERE d.CREDealID = '''+@CREDealID+''' AND e.EventTypeID=8
'
--FinancingSchedule
DECLARE @financingschedulequery nvarchar(MAX) = N'
 SELECT
       fs.[FinancingScheduleID]
      ,fs.[EventId]
      ,fs.[Date]
      ,fs.[ValueTypeID]
      ,fs.[Value]
      ,fs.[IndexTypeID]
      ,fs.[IntCalcMethodID]
      ,fs.[CurrencyCode]
      ,fs.[CreatedBy]
      ,fs.[CreatedDate]
      ,fs.[UpdatedBy]
      ,fs.[UpdatedDate]
  FROM [Core].[FinancingSchedule] fs
  inner join core.Event e  on e.eventid =  fs.EventId
  inner join core.Account acc on acc.AccountID =  e.AccountID
  inner join [CRE].[Note] n ON n.[Account_AccountID] = acc.AccountID
  inner join [CRE].[Deal] d on d.DealID = n.DealID
  WHERE d.CREDealID = '''+@CREDealID+''' AND e.EventTypeID=9
 '

 --DefaultSchedule
 DECLARE @defaultschedulequery nvarchar(MAX) = N'
 SELECT
       ds.[DefaultScheduleID]
      ,ds.[EventId]
      ,ds.[StartDate]
      ,ds.[EndDate]
      ,ds.[ValueTypeID]
      ,ds.[Value]
      ,ds.[CreatedBy]
      ,ds.[CreatedDate]
      ,ds.[UpdatedBy]
      ,ds.[UpdatedDate]
  FROM [Core].[DefaultSchedule] ds
  inner join core.Event e  on e.eventid =  ds.EventId
  inner join core.Account acc on acc.AccountID =  e.AccountID
  inner join [CRE].[Note] n ON n.[Account_AccountID] = acc.AccountID
  inner join [CRE].[Deal] d on d.DealID = n.DealID
  WHERE d.CREDealID = '''+@CREDealID+''' AND e.EventTypeID=6
 '
 --PIKSchedule
  DECLARE @pikschedulequery nvarchar(MAX) = N'
 SELECT
       ps.[PIKScheduleID]
      ,ps.[EventID]
      ,ps.[SourceAccountID]
      ,ps.[TargetAccountID]
      ,ps.[AdditionalIntRate]
      ,ps.[AdditionalSpread]
      ,ps.[IndexFloor]
      ,ps.[IntCompoundingRate]
      ,ps.[IntCompoundingSpread]
      ,ps.[StartDate]
      ,ps.[EndDate]
      ,ps.[IntCapAmt]
      ,ps.[PurBal]
      ,ps.[AccCapBal]
      ,ps.[CreatedBy]
      ,ps.[CreatedDate]
      ,ps.[UpdatedBy]
      ,ps.[UpdatedDate],
	  ps.[PIKReasonCodeID],
	  ps.[PIKComments],
	  ps.[PIKIntCalcMethodID],
	  ps.PeriodicRateCapAmount ,
	  ps.PeriodicRateCapPercent,
	  ps.PIKPercentage,
	  ps.PIKSetUp,
	  ps.PIKSeparateCompounding
  FROM [Core].[PIKSchedule] ps
  inner join core.Event e  on e.eventid =  ps.EventId
  inner join core.Account acc on acc.AccountID =  e.AccountID
  inner join [CRE].[Note] n ON n.[Account_AccountID] = acc.AccountID
  inner join [CRE].[Deal] d on d.DealID = n.DealID
  WHERE d.CREDealID = '''+@CREDealID+''' AND e.EventTypeID=12
 '
 --ServicingFeeSchedule
  DECLARE @servicingfeeschedulequery nvarchar(MAX) = N'
 SELECT
       sfs.[ServicingFeeScheduleID]
      ,sfs.[EventId]
      ,sfs.[Date]
      ,sfs.[Value]
      ,sfs.[IsCapitalized]
      ,sfs.[CreatedBy]
      ,sfs.[CreatedDate]
      ,sfs.[UpdatedBy]
      ,sfs.[UpdatedDate]
  FROM [Core].[ServicingFeeSchedule] sfs
 inner join core.Event e  on e.eventid =  sfs.EventId
  inner join core.Account acc on acc.AccountID =  e.AccountID
  inner join [CRE].[Note] n ON n.[Account_AccountID] = acc.AccountID
  inner join [CRE].[Deal] d on d.DealID = n.DealID
  WHERE d.CREDealID = '''+@CREDealID+''' AND e.EventTypeID=15
 '

 --FundingSchedule
  DECLARE @fundingschedulequery nvarchar(MAX) = N'
  SELECT
       funds.[FundingScheduleID]
      ,funds.[EventId]
      ,funds.[Date]
      ,funds.[Value]
      ,funds.[CreatedBy]
      ,funds.[CreatedDate]
      ,funds.[UpdatedBy]
      ,funds.[UpdatedDate]
      ,funds.[PurposeID]
      ,funds.[Applied]
      ,funds.[DrawFundingId]
      ,funds.[Comments]
      ,funds.[Issaved]
      ,funds.[DealFundingRowno]
      ,funds.[DealFundingID]
      ,funds.[WF_CurrentStatus]
	  ,funds.GeneratedBy
  FROM [Core].[FundingSchedule] funds
  inner join core.Event e  on e.eventid =  funds.EventId
  inner join core.Account acc on acc.AccountID =  e.AccountID
  inner join [CRE].[Note] n ON n.[Account_AccountID] = acc.AccountID
  inner join [CRE].[Deal] d on d.DealID = n.DealID
  WHERE d.CREDealID = '''+@CREDealID+''' AND e.EventTypeID=10
 '

--PIKScheduleDetail
DECLARE @pikscheduledetailquery nvarchar(MAX) = N'
  SELECT   pd.[PIKScheduleDetailID]
		  ,pd.[EventId]
		  ,pd.[Date]
		  ,pd.[Value]
		  ,pd.[CreatedBy]
		  ,pd.[CreatedDate]
		  ,pd.[UpdatedBy]
		  ,pd.[UpdatedDate]
  FROM [Core].[PIKScheduleDetail] pd
  inner join core.Event e  on e.eventid =  pd.EventId
  inner join core.Account acc on acc.AccountID =  e.AccountID
  inner join [CRE].[Note] n ON n.[Account_AccountID] = acc.AccountID
  inner join [CRE].[Deal] d on d.DealID = n.DealID
  WHERE d.CREDealID = '''+@CREDealID+''' AND e.EventTypeID=17
 '

--LIBORSchedule
DECLARE @liborschedulequery nvarchar(MAX) = N'
SELECT
       ls.[LIBORScheduleID]
      ,ls.[EventId]
      ,ls.[Date]
      ,ls.[Value]
      ,ls.[CreatedBy]
      ,ls.[CreatedDate]
      ,ls.[UpdatedBy]
      ,ls.[UpdatedDate]
	  FROM [Core].[LIBORSchedule] ls
  inner join core.Event e  on e.eventid =  ls.EventId
  inner join core.Account acc on acc.AccountID =  e.AccountID
  inner join [CRE].[Note] n ON n.[Account_AccountID] = acc.AccountID
  inner join [CRE].[Deal] d on d.DealID = n.DealID
  WHERE d.CREDealID = '''+@CREDealID+''' AND e.EventTypeID=18
 '
--AmortSchedule
DECLARE @amortschedulequery nvarchar(MAX) = N'
SELECT
       ams.[AmortScheduleID]
      ,ams.[EventId]
      ,ams.[Date]
      ,ams.[Value]
      ,ams.[CreatedBy]
      ,ams.[CreatedDate]
      ,ams.[UpdatedBy]
      ,ams.[UpdatedDate]
  FROM [Core].[AmortSchedule] ams
  inner join core.Event e  on e.eventid =  ams.EventId
  inner join core.Account acc on acc.AccountID =  e.AccountID
  inner join [CRE].[Note] n ON n.[Account_AccountID] = acc.AccountID
  inner join [CRE].[Deal] d on d.DealID = n.DealID
  WHERE d.CREDealID = '''+@CREDealID+''' AND e.EventTypeID=19
 '
 --FeeCouponStripReceivable
 DECLARE @feecouponstripreceivablequery nvarchar(MAX) = N'
SELECT
       fcs.[FeeCouponStripReceivableID]
      ,fcs.[EventId]
      ,fcs.[Date]
      ,fcs.[Value]
      ,fcs.[CreatedBy]
      ,fcs.[CreatedDate]
      ,fcs.[UpdatedBy]
      ,fcs.[UpdatedDate]
      ,fcs.[SourceNoteId]
      ,fcs.[StrippedAmount]
      ,fcs.[RuleTypeID]
      ,fcs.[FeeName]
      ,fcs.[AnalysisID]
  FROM [Core].[FeeCouponStripReceivable] fcs
  inner join core.Event e  on e.eventid =  fcs.EventId
  inner join core.Account acc on acc.AccountID =  e.AccountID
  inner join [CRE].[Note] n ON n.[Account_AccountID] = acc.AccountID
  inner join [CRE].[Deal] d on d.DealID = n.DealID
  WHERE d.CREDealID = '''+@CREDealID+''' AND e.EventTypeID=20
 '

 ---Exceptions 111
 DECLARE @exceptionsquery nvarchar(MAX) = N'
SELECT
       ex.[ExceptionID]
      ,ex.[ObjectID]
      ,ex.[ObjectTypeID]
      ,ex.[FieldName]
      ,ex.[Summary]
      ,ex.[ActionLevelID]
      ,ex.[CreatedBy]
      ,ex.[CreatedDate]
      ,ex.[UpdatedBy]
      ,ex.[UpdatedDate]
  FROM [Core].[Exceptions] ex
  inner join [CRE].[Note] n ON n.[NoteID] = ex.[ObjectID]
  inner join [CRE].[Deal] d on d.DealID = n.DealID
  WHERE d.CREDealID = '''+@CREDealID+''' 
 '

 --FundingRepaymentSequence
 DECLARE @fundingrulesquery nvarchar(MAX) = N'
SELECT
       frs.[FundingRepaymentSequenceID]
      ,frs.[NoteID]
      ,frs.[SequenceNo]
      ,frs.[SequenceType]
      ,frs.[Value]
      ,frs.[CreatedBy]
      ,frs.[CreatedDate]
      ,frs.[UpdatedBy]
      ,frs.[UpdatedDate]
 FROM [CRE].[FundingRepaymentSequence] frs
  inner join [CRE].[Note] n ON n.[NoteID] = frs.[NoteID]
  inner join [CRE].[Deal] d on d.DealID = n.DealID
  WHERE d.CREDealID = '''+@CREDealID+''' 
'

--PayruleDistributions
DECLARE @payruleditributionsquery nvarchar(MAX) = N'
 select 
	   prd.[PayruleDistributionsID]
      ,prd.[SourceNoteID]
      ,prd.[ReceiverNoteID]
      ,prd.[TransactionDate]
      ,prd.[Amount]
      ,prd.[RuleID]
      ,prd.[CreatedBy]
      ,prd.[CreatedDate]
      ,prd.[UpdatedBy]
      ,prd.[UpdatedDate]
      ,prd.[FeeName]
      ,prd.[AnalysisID]
  FROM [CRE].[PayruleDistributions] prd
  inner join [CRE].[Note] n ON n.[NoteID] = prd.[SourceNoteID]
  inner join [CRE].[Deal] d on d.DealID = n.DealID
  WHERE d.CREDealID = '''+@CREDealID+''' 
'
--ServicerDropDateSetup
DECLARE @servicerdropdatesetupquery  nvarchar(MAX) = N'
 select 
       sdds.[ServicerDropDateSetupID]
      ,sdds.[NoteID]
      ,sdds.[ModeledPMTDropDate]
      ,sdds.[PMTDropDateOverride]
      ,sdds.[CreatedBy]
      ,sdds.[CreatedDate]
      ,sdds.[UpdatedBy]
      ,sdds.[UpdatedDate]
  FROM [CRE].[ServicerDropDateSetup] sdds
  inner join [CRE].[Note] n ON n.[NoteID] = sdds.[NoteID]
  inner join [CRE].[Deal] d on d.DealID = n.DealID
  WHERE d.CREDealID = '''+@CREDealID+''' 
 '

DECLARE @FundingRepaymentSequenceWriteOffquery nvarchar(MAX) = N'
Select
			fr.DealID,
			fr.NoteID,
			fr.PriorityOverride,
			fr.CreatedBy,
			fr.CreatedDate,
			fr.UpdatedBy,
			fr.UpdatedDate
			
	FROM [CRE].[FundingRepaymentSequenceWriteOff] fr
	inner join [CRE].[Note] n ON n.[NoteID] = fr.[NoteID]
    inner join [CRE].[Deal] d on d.DealID = n.DealID
    WHERE d.CREDealID = '''+@CREDealID+'''
'

DECLARE @WLDealPotentialImpairmentDetailquery nvarchar(MAX) = N'
Select
	        pd.WLDealPotentialImpairmentMasterID,
			pd.NoteID,
			pd.Value,
			pd.CreatedBy,
			pd.CreatedDate,
			pd.UpdatedBy,
			pd.UpdatedDate,
			pd.RowNo
	FROM [CRE].[WLDealPotentialImpairmentDetail] pd
	Left JOIN [CRE].WLDealPotentialImpairmentMaster pm on pm.RowNo = pd.RowNo
	inner join [CRE].[Note] n ON n.[NoteID] = pd.[NoteID]
    inner join [CRE].[Deal] d on d.DealID = n.DealID
    WHERE d.CREDealID = '''+@CREDealID+'''
'

 DECLARE @NoteTransactionDetailquery nvarchar(MAX) = N'
Select [NoteTransactionDetailID]              
,nt.[NoteID]   
,nt.[TransactionDate]                      
,nt.[TransactionType]                      
,nt.[Amount]   
,nt.[RelatedtoModeledPMTDate]              
,nt.[ModeledPayment]                       
,nt.[AmountOutstandingafterCurrentPayment] 
,nt.[CreatedBy]
,nt.[CreatedDate]                          
,nt.[UpdatedBy]
,nt.[UpdatedDate]                          
,nt.[ServicingAmount]                      
,nt.[CalculatedAmount]                     
,nt.[Delta]    
,nt.[M61Value] 
,nt.[ServicerValue]                        
,nt.[Ignore]   
,nt.[OverrideValue]                        
,nt.[comments] 
,nt.[PostedDate]                           
,nt.[ServicerMasterID]                     
,nt.[Deleted]  
,nt.[TransactionTypeText]                  
,nt.[TranscationReconciliationID]          
,nt.[RemittanceDate]                       
,nt.[Exception]
,nt.[Adjustment]                           
,nt.[ActualDelta]  
,nt.[OverrideReason]                       
,nt.[BerAddlint]                           
,nt.[TransactionEntryAmount]               
,nt.[Orig_ServicerMasterID]                
,nt.[InterestAdj]                          
,nt.[AddlInterest]                         
,nt.[TotalInterest]                        
,nt.[WriteOffAmount]		
From cre.NoteTransactionDetail nt
inner join [CRE].[Note] n ON n.noteid = nt.noteid
inner join [CRE].[Deal] d on d.DealID = n.DealID
WHERE d.CREDealID = '''+@CREDealID+'''
'


 DECLARE @NoteAdjustedCommitmentMasterquery nvarchar(MAX) = N'
Select  
 nt.DealID
,nt.[Date]
,nt.[Type]
,nt.Comments	
,nt.DealAdjustmentHistory	
,nt.AdjustedCommitment	
,nt.TotalCommitment	
,nt.AggregatedCommitment	
,nt.CreatedBy	
,nt.CreatedDate	
,nt.UpdatedBy	
,nt.UpdatedDate
,nt.TotalRequiredEquity
,nt.TotalAdditionalEquity
,nt.Rowno	
,nt.TotalEquityatClosing
From cre.NoteAdjustedCommitmentMaster nt
inner join [CRE].[Deal] d on d.DealID = nt.DealID
WHERE d.CREDealID = '''+@CREDealID+'''
'



DECLARE @NoteAdjustedCommitmentDetailquery nvarchar(MAX) = N'
Select 
nt.NoteID,
nt.[Value],
nt.CreatedBy,
nt.CreatedDate,
nt.UpdatedBy,
nt.UpdatedDate,
nt.[Type],
nt.DealID,
nt.NoteTotalCommitment,
nt.NoteAdjustedTotalCommitment,
nt.NoteAggregatedTotalCommitment,
nt.Rowno
From cre.NoteAdjustedCommitmentDetail nt
inner join [CRE].[Deal] d on d.DealID = nt.DealID
WHERE d.CREDealID = '''+@CREDealID+'''
'
--============================================================================

--Deal
IF OBJECT_ID('tempdb..##tblDeal') IS NOT NULL             
DROP TABLE ##tblDeal           
            
create table ##tblDeal    
(
    [DealID] [UNIQUEIDENTIFIER]  NULL,
	[DealName] [nvarchar](256) NULL,
	[CREDealID] [nvarchar](256) NULL,
	[DealType] [int] NULL,
	[LoanProgram] [int] NULL,
	[LoanPurpose] [int] NULL,
	[Status] [int] NULL,
	[AppReceived] [date] NULL,
	[EstClosingDate] [date] NULL,
	[BorrowerRequest] [nvarchar](256) NULL,
	[RecommendedLoan] [decimal](28, 15) NULL,
	[TotalFutureFunding] [decimal](28, 15) NULL,
	[Source] [int] NULL,
	[BrokerageFirm] [nvarchar](256) NULL,
	[BrokerageContact] [nvarchar](256) NULL,
	[Sponsor] [nvarchar](256) NULL,
	[Principal] [nvarchar](256) NULL,
	[NetWorth] [decimal](28, 15) NULL,
	[Liquidity] [decimal](28, 15) NULL,
	[ClientDealID] [nvarchar](256) NULL,
	[GeneratedBy] [int] NULL,
	[CreatedBy] [nvarchar](256) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[UpdatedDate] [datetime] NULL,
	[TotalCommitment] [decimal](28, 15) NULL,
	[AdjustedTotalCommitment] [decimal](28, 15) NULL,
	[AggregatedTotal] [decimal](28, 15) NULL,
	[AssetManagerComment] [nvarchar](max) NULL,
	[AssetManager] [nvarchar](256) NULL,
	[DealCity] [nvarchar](256) NULL,
	[DealState] [nvarchar](256) NULL,
	[DealPropertyType] [nvarchar](256) NULL,
	[FullyExtMaturityDate] [date] NULL,
	[UnderwritingStatus] [int] NULL,
	[LinkedDealID] [nvarchar](256) NULL,
	[DealComment] [nvarchar](max) NULL,
	[SourceDealID] [uniqueidentifier] NULL,
	[IsDeleted] [bit] NULL,
	[AllowSizerUpload] [int] NULL,
	[AMUserID] [uniqueidentifier] NULL,
	[AMTeamLeadUserID] [nvarchar](256) NULL,
	[AMSecondUserID] [nvarchar](256) NULL,
	[DealRule] [nvarchar](2000) NULL,
	[Companyname] [nvarchar](256) NULL,
	[FirstName] [nvarchar](256) NULL,
	[Lastname] [nvarchar](256) NULL,
	[StreetName] [nvarchar](256) NULL,
	[ZipCodePostal] [nvarchar](256) NULL,
	[PayeeName] [nvarchar](256) NULL,
	[TelephoneNumber1] [nvarchar](256) NULL,
	[FederalID1] [nvarchar](max) NULL,
	[TaxEscrowConstant] [decimal](28, 15) NULL,
	[InsEscrowConstant] [decimal](28, 15) NULL,
	[CollectTaxEscrow] [nvarchar](256) NULL,
	[CollectInsEscrow] [nvarchar](256) NULL,
	[DealCityWells] [nvarchar](256) NULL,
	[DealStateWells] [nvarchar](256) NULL,
	[BoxDocumentLink] [nvarchar](500) NULL,
	[DealGroupID] [nvarchar](256) NULL,
	[EnableAutoSpread] [bit] NULL,

	[AmortizationMethod]                INT              NULL,							
	[ReduceAmortizationForCurtailments] INT              NULL,							
	[BusinessDayAdjustmentForAmort]     INT              NULL,							
	[NoteDistributionMethod]            INT              NULL,							
	[PeriodicStraightLineAmortOverride] DECIMAL (28, 15) NULL,							
	[FixedPeriodicPayment]              DECIMAL (28, 15) NULL,							
	[EquityAmount]                      DECIMAL (28, 15) NULL,							
	[RemainingAmount]                   DECIMAL (28, 15) NULL,							
	[DealTypeMasterID]                  INT              NULL,							
	EnableAutoSpreadRepayments			BIT				null,
	AutoUpdateFromUnderwriting			BIT				null,
	[ExpectedFullRepaymentDate]			DATE             NULL,				
	RepaymentAutoSpreadMethodID			int				null,
	RepaymentStartDate					DATE             NULL,		
	EarliestPossibleRepaymentDate		DATE             NULL,					
	Blockoutperiod						int				null,
	PossibleRepaymentdayofthemonth		int				null,	
	Repaymentallocationfrequency		int				null,	
	AutoPrepayEffectiveDate				DATE             NULL,			
	LatestPossibleRepaymentDate			DATE             NULL,				
	[KnownFullPayoffDate]				DATE             NULL,	
	CalcEngineType                      int null,
	ShardName nvarchar(max)  NULL 
)

--Property
IF OBJECT_ID('tempdb..##tblProperty') IS NOT NULL             
DROP TABLE ##tblProperty           
            
create table ##tblProperty    
(
    [PropertyID] [uniqueidentifier] NOT NULL,
	[Deal_DealID] [uniqueidentifier] NOT NULL,
	[PropertyName] [nvarchar](256) NULL,
	[Address] [nvarchar](256) NULL,
	[City] [nvarchar](256) NULL,
	[State] [int] NULL,
	[Zip] [int] NULL,
	[UWNCF] [decimal](28, 15) NULL,
	[SQFT] [decimal](28, 15) NULL,
	[PropertyType] [int] NULL,
	[AllocDebtPer] [decimal](28, 15) NULL,
	[PropertySubtype] [int] NULL,
	[NumberofUnitsorSF] [int] NULL,
	[Occ] [decimal](28, 15) NULL,
	[Class] [nvarchar](256) NULL,
	[YearBuilt] [nvarchar](256) NULL,
	[Renovated] [nvarchar](256) NULL,
	[Bldgs] [int] NULL,
	[Acres] [nvarchar](256) NULL,
	[CreatedBy] [nvarchar](256) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[UpdatedDate] [datetime] NULL,
	[ProjectName] [nvarchar](256) NULL,
	[HOUSESTREET1] [nvarchar](256) NULL,
	[VILLAGE] [nvarchar](256) NULL,
	[ZIPCODE] [nvarchar](256) NULL,
	[OwnerOccupied] [nvarchar](256) NULL,
	[PROPDESCCODE] [nvarchar](256) NULL,
	[SALESPRICE] [int] NULL,
	[ConstructionDate] [datetime] NULL,
	[NumberofStories] [decimal](28, 15) NULL,
	[MeasuredIn] [nvarchar](256) NULL,
	[TotalSquareFeet] [decimal](28, 15) NULL,
	[TotalRentableSqFt] [decimal](28, 15) NULL,
	[TotalNumberofUnits] [decimal](28, 15) NULL,
	[OverallCondition] [nvarchar](256) NULL,
	[RenovationDate] [datetime] NULL,
	[NextInspectionDate] [date] NULL,
	[GroundLease] [nvarchar](256) NULL,
	[NumberOfTenants] [int] NULL,
	[VacancyFactor] [decimal](28, 15) NULL,
	[Allocation] [decimal](28, 15) NULL,
	[LIENPosition] [int] NULL,
	[CMSAProperyType] [nvarchar](256) NULL,
	[PState] [nvarchar](256) NULL,
	[country] [nvarchar](256) NULL,
	[DealAllocationAmtPCT] [float] NULL,
	[PropertyRollUpSW] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[ShardName] nvarchar(max)  NULL 
)

--DealFunding
IF OBJECT_ID('tempdb..##tblDealFunding') IS NOT NULL             
DROP TABLE ##tblDealFunding          
            
create table ##tblDealFunding   
(
    [DealFundingID] [uniqueidentifier] NOT NULL,
	[DealID] [uniqueidentifier] NOT NULL,
	[Date] [date] NULL,
	[Amount] [decimal](28, 15) NULL,
	[CreatedBy] [nvarchar](256) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[UpdatedDate] [datetime] NULL,
	[Comment] [nvarchar](max) NULL,
	[PurposeID] [int] NULL,
	[Applied] [bit] NULL,
	[DrawFundingId] [nvarchar](256) NULL,
	[Issaved] [bit] NULL,
	[DealFundingRowno] [int] NULL,
	[DeadLineDate] [date] NULL,
	[LegalDeal_DealFundingID] [uniqueidentifier] NULL,
	[SubPurposeType] [nvarchar](256) NULL,
	[EquityAmount] [decimal](28, 15) NULL,
	[RemainingFFCommitment] [decimal](28, 15) NULL,
	[RemainingEquityCommitment] [decimal](28, 15) NULL,
	[RequiredEquity]            DECIMAL (28, 15) NULL,
	[AdditionalEquity]          DECIMAL (28, 15) NULL,
	[ShardName] nvarchar(max)  NULL 
)
--Payrule
IF OBJECT_ID('tempdb..##tblPayrule') IS NOT NULL             
DROP TABLE ##tblPayrule          
            
create table ##tblPayrule    
(
    [PayruleSetupID] [uniqueidentifier] NOT NULL,
	[DealID] [uniqueidentifier] NOT NULL,
	[StripTransferFrom] [uniqueidentifier] NULL,
	[StripTransferTo] [uniqueidentifier] NULL,
	[Value] [decimal](28, 15) NULL,
	[RuleID] [int] NULL,
	[CreatedBy] [nvarchar](256) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[UpdatedDate] [datetime] NULL,
	[ShardName] nvarchar(max)  NULL 
)



--AutpSpread
IF OBJECT_ID('tempdb..##tblAutoSpreadRule') IS NOT NULL             
DROP TABLE ##tblAutoSpreadRule        
            
create table ##tblAutoSpreadRule
(
    [AutoSpreadRuleID]   UNIQUEIDENTIFIER NOT NULL,
    [DealID]             UNIQUEIDENTIFIER NOT NULL,
    [PurposeType]        INT              NULL,
    [PurposeSubType]     NVARCHAR (256)   NULL,
    [DebtAmount]         DECIMAL (28, 15) NULL,
    [EquityAmount]       DECIMAL (28, 15) NULL,
    [StartDate]          DATE             NULL,
    [EndDate]            DATE             NULL,
    [DistributionMethod] INT              NULL,
    [FrequencyFactor]    INT              NULL,
    [Comment]            NVARCHAR (256)   NULL,
    [CreatedBy]          NVARCHAR (256)   NULL,
    [CreatedDate]        DATETIME         NULL,
    [UpdatedBy]          NVARCHAR (256)   NULL,
    [UpdatedDate]        DATETIME         NULL,
    [RequiredEquity]     DECIMAL (28, 15) NULL,
    [AdditionalEquity]   DECIMAL (28, 15) NULL,
	[ShardName] nvarchar(max)  NULL 
)



--DealAmortizationSchedule
IF OBJECT_ID('tempdb..##tblDealAmortizationSchedule') IS NOT NULL             
DROP TABLE ##tblDealAmortizationSchedule   
            
create table ##tblDealAmortizationSchedule
(
    [DealAmortizationScheduleID]     UNIQUEIDENTIFIER NOT NULL,
    [DealID]                         UNIQUEIDENTIFIER NOT NULL,
    [Date]                           DATE             NULL,
    [Amount]                         DECIMAL (28, 15) NULL,
    [CreatedBy]                      NVARCHAR (256)   NULL,
    [CreatedDate]                    DATETIME         NULL,
    [UpdatedBy]                      NVARCHAR (256)   NULL,
    [UpdatedDate]                    DATETIME         NULL,
    [DealAmortizationScheduleAutoID] INT             NOT NULL,
    [DealAmortScheduleRowno]         INT              NULL,
	[ShardName] nvarchar(max)  NULL 
)


--DealAmortizationSchedule
IF OBJECT_ID('tempdb..##tblDealProjectedPayOffAccounting') IS NOT NULL             
DROP TABLE ##tblDealProjectedPayOffAccounting   
 
create table ##tblDealProjectedPayOffAccounting
(
    DealProjectedPayOffAccountingID     INT  NOT NULL,
	DealID	UNIQUEIDENTIFIER null,	
	AsOfDate Date null,
	CumulativeProbability decimal(28,15) null,
	[CreatedBy]                 NVARCHAR (256)   NULL,
    [CreatedDate]               DATETIME         NULL,
    [UpdatedBy]                 NVARCHAR (256)   NULL,
    [UpdatedDate]               DATETIME         NULL,
	[ShardName] nvarchar(max)  NULL 

)

--WLDealPotentialImpairmentMaster
IF OBJECT_ID('tempdb..##tblWLDealPotentialImpairmentMaster') IS NOT NULL             
DROP TABLE ##tblWLDealPotentialImpairmentMaster

create table ##tblWLDealPotentialImpairmentMaster(
			DealID           UNIQUEIDENTIFIER null,
			Date             DATE             NULL,
			Amount           DECIMAL (28, 15) NULL,
			AdjustmentType   INT  NUll,
			Comment          NVARCHAR (MAX)   NULL,
			Applied          BIT              NULL,
			CreatedBy        NVARCHAR (256)   NULL,
			CreatedDate      DATETIME         NULL,
			UpdatedBy        NVARCHAR (256)   NULL,
			UpdatedDate      DATETIME         NULL,
			RowNo            INT  NUll,
			[ShardName] nvarchar(max)  NULL
			)

--WLDealAccounting
IF OBJECT_ID('tempdb..##tblWLDealAccounting') IS NOT NULL             
DROP TABLE ##tblWLDealAccounting

create table ##tblWLDealAccounting(
			DealID        UNIQUEIDENTIFIER null,
			StartDate     DATE             NULL,
			EndDate       DATE             NULL,
			TypeID        INT              NULL,
			Comment       NVARCHAR (MAX)   NULL,
			CreatedBy     NVARCHAR (256)   NULL,
			CreatedDate   DATETIME         NULL,
			UpdatedBy     NVARCHAR (256)   NULL,
			UpdatedDate   DATETIME         NULL,
			[ShardName] nvarchar(max)  NULL
			)

--NoteCursor
IF OBJECT_ID('tempdb..##tblNoteCursor') IS NOT NULL             
DROP TABLE ##tblNoteCursor         
            
create table ##tblNoteCursor
(		AccountID [uniqueidentifier] NOT NULL,
		 NoteName nvarchar(256) NULL,
		 CRENoteID nvarchar(256) NULL,
		 NoteId [uniqueidentifier] NOT NULL ,
		ShardName nvarchar(max)  NULL 
  )  


  --Account
  IF OBJECT_ID('tempdb..##tblAccount') IS NOT NULL             
DROP TABLE ##tblAccount        
            
create table ##tblAccount
(
    [AccountID] [uniqueidentifier] NOT NULL,
	[AccountTypeID] [int] NULL,
	[StatusID] [int] NULL,
	[Name] [nvarchar](256) NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[BaseCurrencyID] [int] NULL,
	[PayFrequency] [int] NULL,
	[ClientNoteID] [nvarchar](256) NULL,
	[CreatedBy] [nvarchar](256) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[UpdatedDate] [datetime] NULL,
	[IsDeleted] [bit] NULL,
	[ShardName] nvarchar(max)  NULL 
)    

--Note
IF OBJECT_ID('tempdb..##tblNote') IS NOT NULL             
DROP TABLE ##tblNote        
            
create table ##tblNote
(   [NoteID] [uniqueidentifier] NOT NULL,
	[Account_AccountID] [uniqueidentifier] NOT NULL,
	[DealID] [uniqueidentifier] NOT NULL,
	[CRENoteID] [nvarchar](256) NULL,
	[ClientNoteID] [nvarchar](256) NULL,
	[Comments] [nvarchar](256) NULL,
	[InitialInterestAccrualEndDate] [date] NULL,
	[AccrualFrequency] [int] NULL,
	[DeterminationDateLeadDays] [int] NULL,
	[DeterminationDateReferenceDayoftheMonth] [int] NULL,
	[DeterminationDateInterestAccrualPeriod] [int] NULL,
	[DeterminationDateHolidayList] [int] NULL,
	[FirstPaymentDate] [date] NULL,
	[InitialMonthEndPMTDateBiWeekly] [date] NULL,
	[PaymentDateBusinessDayLag] [int] NULL,
	[IOTerm] [int] NULL,
	[AmortTerm] [int] NULL,
	[PIKSeparateCompounding] [int] NULL,
	[MonthlyDSOverridewhenAmortizing] [decimal](28, 15) NULL,
	[AccrualPeriodPaymentDayWhenNotEOMonth] [int] NULL,
	[FirstPeriodInterestPaymentOverride] [decimal](28, 15) NULL,
	[FirstPeriodPrincipalPaymentOverride] [decimal](28, 15) NULL,
	[FinalInterestAccrualEndDateOverride] [date] NULL,
	[AmortType] [int] NULL,
	[RateType] [int] NULL,
	[ReAmortizeMonthly] [int] NULL,
	[ReAmortizeatPMTReset] [int] NULL,
	[StubPaidInArrears] [int] NULL,
	[RelativePaymentMonth] [int] NULL,
	[SettleWithAccrualFlag] [int] NULL,
	[InterestDueAtMaturity] [int] NULL,
	[RateIndexResetFreq] [decimal](28, 15) NULL,
	[FirstRateIndexResetDate] [date] NULL,
	[LoanPurchase] [int] NULL,
	[AmortIntCalcDayCount] [int] NULL,
	[StubPaidinAdvanceYN] [int] NULL,
	[FullPeriodInterestDueatMaturity] [int] NULL,
	[ProspectiveAccountingMode] [int] NULL,
	[IsCapitalized] [int] NULL,
	[SelectedMaturityDateScenario] [int] NULL,
	[SelectedMaturityDate] [date] NULL,
	[InitialMaturityDate] [date] NULL,
	[ExpectedMaturityDate] [date] NULL,
	[FullyExtendedMaturityDate] [date] NULL,
	[OpenPrepaymentDate] [date] NULL,
	[CashflowEngineID] [int] NULL,
	[LoanType] [int] NULL,
	[Classification] [int] NULL,
	[SubClassification] [int] NULL,
	[GAAPDesignation] [int] NULL,
	[PortfolioID] [int] NULL,
	[GeographicLocation] [int] NULL,
	[PropertyType] [int] NULL,
	[RatingAgency] [int] NULL,
	[RiskRating] [int] NULL,
	[PurchasePrice] [decimal](28, 15) NULL,
	[FutureFeesUsedforLevelYeild] [decimal](28, 15) NULL,
	[TotalToBeAmortized] [decimal](28, 15) NULL,
	[StubPeriodInterest] [decimal](28, 15) NULL,
	[WDPAssetMultiple] [decimal](28, 15) NULL,
	[WDPEquityMultiple] [decimal](28, 15) NULL,
	[PurchaseBalance] [decimal](28, 15) NULL,
	[DaysofAccrued] [int] NULL,
	[InterestRate] [decimal](28, 15) NULL,
	[PurchasedInterestCalc] [decimal](28, 15) NULL,
	[ModelFinancingDrawsForFutureFundings] [int] NULL,
	[NumberOfBusinessDaysLagForFinancingDraw] [int] NULL,
	[FinancingFacilityID] [uniqueidentifier] NULL,
	[FinancingInitialMaturityDate] [date] NULL,
	[FinancingExtendedMaturityDate] [date] NULL,
	[FinancingPayFrequency] [int] NULL,
	[FinancingInterestPaymentDay] [int] NULL,
	[ClosingDate] [date] NULL,
	[InitialFundingAmount] [decimal](28, 15) NULL,
	[Discount] [decimal](28, 15) NULL,
	[OriginationFee] [decimal](28, 15) NULL,
	[CapitalizedClosingCosts] [decimal](28, 15) NULL,
	[PurchaseDate] [date] NULL,
	[PurchaseAccruedFromDate] [decimal](28, 15) NULL,
	[PurchasedInterestOverride] [decimal](28, 15) NULL,
	[DiscountRate] [decimal](28, 15) NULL,
	[ValuationDate] [date] NULL,
	[FairValue] [decimal](28, 15) NULL,
	[DiscountRatePlus] [decimal](28, 15) NULL,
	[FairValuePlus] [decimal](28, 15) NULL,
	[DiscountRateMinus] [decimal](28, 15) NULL,
	[FairValueMinus] [decimal](28, 15) NULL,
	[InitialIndexValueOverride] [decimal](28, 15) NULL,
	[IncludeServicingPaymentOverrideinLevelYield] [int] NULL,
	[OngoingAnnualizedServicingFee] [decimal](28, 15) NULL,
	[IndexRoundingRule] [int] NULL,
	[RoundingMethod] [int] NULL,
	[StubInterestPaidonFutureAdvances] [int] NULL,
	[TaxAmortCheck] [nvarchar](256) NULL,
	[PIKWoCompCheck] [nvarchar](256) NULL,
	[GAAPAmortCheck] [nvarchar](256) NULL,
	[StubIntOverride] [decimal](28, 15) NULL,
	[PurchasedIntOverride] [decimal](28, 15) NULL,
	[ExitFeeFreePrepayAmt] [decimal](28, 15) NULL,
	[ExitFeeBaseAmountOverride] [decimal](28, 15) NULL,
	[ExitFeeAmortCheck] [int] NULL,
	[FixedAmortScheduleCheck] [int] NULL,
	[GeneratedBy] [int] NULL,
	[UseRuletoDetermineNoteFunding] [int] NULL,
	[NoteFundingRule] [int] NULL,
	[FundingPriority] [int] NULL,
	[NoteBalanceCap] [decimal](28, 15) NULL,
	[RepaymentPriority] [int] NULL,
	[NoofdaysrelPaymentDaterollnextpaymentcycle] [int] NULL,
	[UseIndexOverrides] [bit] NULL,
	[IndexNameID] [int] NULL,
	[LienPriority] [int] NULL,
	[CreatedBy] [nvarchar](256) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[UpdatedDate] [datetime] NULL,
	[ServicerID] [nvarchar](256) NULL,
	[TotalCommitment] [decimal](28, 15) NULL,
	[ClientName] [nvarchar](256) NULL,
	[Portfolio] [nvarchar](256) NULL,
	[Tag1] [nvarchar](256) NULL,
	[Tag2] [nvarchar](256) NULL,
	[Tag3] [nvarchar](256) NULL,
	[Tag4] [nvarchar](256) NULL,
	--[ExtendedMaturityScenario1] [date] NULL,
	--[ExtendedMaturityScenario2] [date] NULL,
	--[ExtendedMaturityScenario3] [date] NULL,
	[ActualPayoffDate] [date] NULL,
	[TotalCommitmentExtensionFeeisBasedOn] [decimal](28, 15) NULL,
	[UnusedFeeThresholdBalance] [decimal](28, 15) NULL,
	[UnusedFeePaymentFrequency] [int] NULL,
	[lienposition] [int] NULL,
	[priority] [int] NULL,
	[Servicer] [int] NULL,
	[FullInterestAtPPayoff] [int] NULL,
	[NoteRule] [nvarchar](2000) NULL,
	[ClientID] [int] NULL,
	[FinancingSourceID] [int] NULL,
	[DebtTypeID] [int] NULL,
	[BillingNotesID] [int] NULL,
	[CapStack] [int] NULL,
	[FundID] [int] NULL,
	[PoolId] [int] NULL,
	[TaxVendorLoanNumber] [nvarchar](256) NULL,
	[TAXBILLSTATUS] [nvarchar](256) NULL,
	[CURRTAXCONSTANT] [int] NULL,
	[InsuranceBillStatusCode] [nvarchar](256) NULL,
	[RESERVETYPE] [nvarchar](256) NULL,
	[ResDescOwnName] [nvarchar](256) NULL,
	[MONTHLYPAYMENTAMT] [int] NULL,
	[IORPLANCODE] [nvarchar](256) NULL,
	[NoDaysbeforeAssessment] [decimal](28, 15) NULL,
	[LateChargeRateorFee] [decimal](28, 15) NULL,
	[DefaultOfDaysto] [decimal](28, 15) NULL,
	[OddDaysIntAmount] [decimal](28, 15) NULL,
	[InterestRateFloor] [decimal](28, 15) NULL,
	[InterestRateCeiling] [decimal](28, 15) NULL,
	[Dayslookback] [nvarchar](256) NULL,
	[WF_Companyname] [nvarchar](256) NULL,
	[WF_FirstName] [nvarchar](256) NULL,
	[WF_Lastname] [nvarchar](256) NULL,
	[WF_StreetName] [nvarchar](256) NULL,
	[WF_ZipCodePostal] [nvarchar](256) NULL,
	[WF_PayeeName] [nvarchar](256) NULL,
	[WF_TelephoneNumber1] [nvarchar](256) NULL,
	[WF_FederalID1] [nvarchar](max) NULL,
	[WF_City] [nvarchar](256) NULL,
	[WF_State] [nvarchar](256) NULL,
	[CurrentBls] [decimal](28, 15) NULL,
	[StubInterestRateOverride] [decimal](28, 15) NULL,
	[LiborDataAsofDate] [datetime] NULL,
	[ServicerNameID] [int] NULL,
	[BusinessdaylafrelativetoPMTDate] [int] NULL,
	[DayoftheMonth] [int] NULL,
	[InterestCalculationRuleForPaydowns] [int] NULL,
	[PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate] [int] NULL,
	[FundedAndOwnedByThirdParty] [bit] NULL,
	[InterestCalculationRuleForPaydownsAmort] [int] NULL,

	[AdjustedTotalCommitment]                              DECIMAL (28, 15) NULL,							
	[AggregatedTotal]                                      DECIMAL (28, 15) NULL,							
	[RoundingNote]                                         INT              NULL,							
	[StraightLineAmortOverride]                            DECIMAL (28, 15) NULL,							
	[RepaymentDayoftheMonth]                               INT              NULL,							
	[FutureFundingBillingCutoffDay]                        INT              NULL,							
	[CurtailmentBillingCutoffDay]                          INT              NULL,							
	[UseRuletoDetermineAmortization]                       INT              NULL,							
	[MKT_PRICE]                                            DECIMAL (28, 15) NULL,							
	[OriginalTotalCommitment]                              DECIMAL (28, 15) NULL,							
	[StrategyCode]                                         INT              NULL,							
	[EnableM61Calculations]                                INT              NULL,							
	[InitialRequiredEquity]                                DECIMAL (28, 15) NULL,							
	[InitialAdditionalEquity]                              DECIMAL (28, 15) NULL,							
	[CommitmentUsedInFFDistribution]					   DECIMAL (28, 15) NULL,	
	FirstIndexDeterminationDateOverride	Date null,
    [ShardName] nvarchar(max)  NULL 
)


---Note Details

--============================Cursor for all note detail schedule===========================
--Event
IF OBJECT_ID('tempdb..##tblEvent ') IS NOT NULL             
DROP TABLE ##tblEvent       
            
create table ##tblEvent 
(
EventID uniqueidentifier  NOT NULL ,
AccountID uniqueidentifier  NOT NULL,
[Date] date   NULL,
EventTypeID int   NULL,
EffectiveStartDate date   NULL,
EffectiveEndDate date   NULL,
SingleEventValue decimal(28,15)   NULL,
CreatedBy      	nvarchar(256)  NULL,
CreatedDate      	datetime NULL,
UpdatedBy      	nvarchar(256) NULL,
UpdatedDate      	datetime null,
[StatusID] int null,
[ShardName] nvarchar(max)  NULL 
)

--Maturity
IF OBJECT_ID('tempdb..##tblMaturity') IS NOT NULL             
DROP TABLE ##tblMaturity     
            
create table ##tblMaturity
(
MaturityID	uniqueidentifier  NOT NULL,
EventId	uniqueidentifier not null,
SelectedMaturityDate date   NULL,
CreatedBy      	nvarchar(256) null,
CreatedDate      	datetime null,
UpdatedBy      	nvarchar(256) null,
UpdatedDate      	datetime null,
MaturityDate  date   NULL,
MaturityType int null,
Approved int null,
IsAutoApproved bit null,
[ShardName] nvarchar(max)  NULL 
)

--RateSpreadSchedule
IF OBJECT_ID('tempdb..##tblRateSpreadSchedule') IS NOT NULL             
DROP TABLE ##tblRateSpreadSchedule     
            
create table ##tblRateSpreadSchedule
(
RateSpreadScheduleID	uniqueidentifier  NOT NULL,
EventId	uniqueidentifier not null,
[Date] date   NULL,
ValueTypeID int   NULL,
[Value] decimal(28,12)   NULL,
IntCalcMethodID int   NULL,
CreatedBy      	nvarchar(256) null,
CreatedDate      	datetime null,
UpdatedBy      	nvarchar(256) null,
UpdatedDate      	datetime null,
RateOrSpreadToBeStripped decimal(28,15),
IndexNameID int,
DeterminationDateHolidayList int,
[ShardName] nvarchar(max)  NULL
)

--PrepayAndAdditionalFeeSchedule
IF OBJECT_ID('tempdb..##tblPrepayAndAdditionalFeeSchedule') IS NOT NULL             
DROP TABLE ##tblPrepayAndAdditionalFeeSchedule     
            
create table ##tblPrepayAndAdditionalFeeSchedule
(
PrepayAndAdditionalFeeScheduleID uniqueidentifier  NOT NULL,
EventID uniqueidentifier  NOT NULL,
StartDate date   NULL, 
ValueTypeID int   NULL,
[Value] decimal(28,12)   NULL,
IncludedLevelYield   decimal(28,12) NULL DEFAULT ((0)),
IncludedBasis   decimal(28,12) NULL DEFAULT ((0)),
[CreatedBy] [nvarchar](256) NULL,
[CreatedDate] [datetime] NULL,
[UpdatedBy] [nvarchar](256) NULL,
[UpdatedDate] [datetime] NULL,
FeeName [nvarchar](256) NULL,
EndDate date   NULL, 
FeeAmountOverride decimal(28,12) NULL,
BaseAmountOverride decimal(28,12) NULL,
ApplyTrueUpFeature int null,
FeetobeStripped decimal(28,12) NULL,
[ShardName] nvarchar(max)  NULL
)


--FinancingFeeSchedule
IF OBJECT_ID('tempdb..##tblFinancingFeeSchedule') IS NOT NULL             
DROP TABLE ##tblFinancingFeeSchedule     
            
create table ##tblFinancingFeeSchedule
(FinancingFeeScheduleID	uniqueidentifier  NOT NULL,
EventId	uniqueidentifier not null,
[Date] date   NULL,
ValueTypeID int   NULL,
[Value] decimal(28,12)   NULL,
CreatedBy      	nvarchar(256) null,
CreatedDate      	datetime null,
UpdatedBy      	nvarchar(256) null,
UpdatedDate      	datetime null,
[ShardName] nvarchar(max)  NULL
)

--FinancingSchedule
IF OBJECT_ID('tempdb..##tblFinancingSchedule') IS NOT NULL             
DROP TABLE ##tblFinancingSchedule     
            
create table ##tblFinancingSchedule(
FinancingScheduleID	uniqueidentifier  NOT NULL,
EventId	uniqueidentifier not null,
[Date] date  NULL,
ValueTypeID int  NULL,
[Value] decimal(28,12)  NULL,
IndexTypeID int  NULL,
IntCalcMethodID int   NULL,
CurrencyCode int  null,
CreatedBy      	nvarchar(256) null,
CreatedDate      	datetime null,
UpdatedBy      	nvarchar(256) null,
UpdatedDate      	datetime null,
[ShardName] nvarchar(max)  NULL
)

--DefaultSchedule
IF OBJECT_ID('tempdb..##tblDefaultSchedule') IS NOT NULL             
DROP TABLE ##tblDefaultSchedule     
            
create table ##tblDefaultSchedule(
DefaultScheduleID	uniqueidentifier  NOT NULL,
EventId	uniqueidentifier not null,
StartDate date   NULL,
EndDate date   NULL,
ValueTypeID int   NULL,
Value decimal(28,12)   NULL,
CreatedBy      	nvarchar(256) null,
CreatedDate      	datetime null,
UpdatedBy      	nvarchar(256) null,
UpdatedDate      	datetime null,
[ShardName] nvarchar(max)  NULL
)

--PIKSchedule
IF OBJECT_ID('tempdb..##tblPIKSchedule') IS NOT NULL             
DROP TABLE ##tblPIKSchedule    
            
create table ##tblPIKSchedule(
PIKScheduleID uniqueidentifier  NOT NULL,
EventID uniqueidentifier  NOT NULL,
SourceAccountID uniqueidentifier   NULL,
TargetAccountID uniqueidentifier   NULL,
AdditionalIntRate decimal(28,15)   NULL,
AdditionalSpread decimal(28,15)   NULL,
IndexFloor decimal(28,15)   NULL,
IntCompoundingRate decimal(28,15)   NULL,
IntCompoundingSpread decimal(28,15)   NULL,
StartDate date   NULL,
EndDate date   NULL,
IntCapAmt decimal(28,15)   NULL,
PurBal decimal(28,15)   NULL,
AccCapBal decimal(28,15)   NULL,
[CreatedBy] [nvarchar](256) NULL,
[CreatedDate] [datetime] NULL,
[UpdatedBy] [nvarchar](256) NULL,
[UpdatedDate] [datetime] NULL,
[PIKReasonCodeID]      INT              NULL,
[PIKComments]          NVARCHAR (MAX)   NULL,
[PIKIntCalcMethodID]          INT              NULL,
PeriodicRateCapAmount decimal(28,15),
PeriodicRateCapPercent decimal(28,15),
[PIKPercentage]    DECIMAL (28, 15) NULL,
[PIKSetUp]         INT              NULL,
PIKSeparateCompounding int null,
[ShardName] nvarchar(max)  NULL
)

--ServicingFeeSchedule
IF OBJECT_ID('tempdb..##tblServicingFeeSchedule') IS NOT NULL             
DROP TABLE ##tblServicingFeeSchedule  
            
create table ##tblServicingFeeSchedule(
ServicingFeeScheduleID	uniqueidentifier  NOT NULL,
EventId	uniqueidentifier  null,
Date date   NULL,
Value decimal(28,12)   NULL,
IsCapitalized int   NULL,
CreatedBy      	nvarchar(256) null,
CreatedDate      	datetime null,
UpdatedBy      	nvarchar(256) null,
UpdatedDate      	datetime null,
[ShardName] nvarchar(max)  NULL
)

--FundingSchedule
IF OBJECT_ID('tempdb..##tblFundingSchedule') IS NOT NULL             
DROP TABLE ##tblFundingSchedule  
            
create table ##tblFundingSchedule(
FundingScheduleID	uniqueidentifier  NOT NULL,
EventId	uniqueidentifier not null,
Date	date null,
Value	decimal(28,15)null,
CreatedBy  nvarchar(256) null,
CreatedDate   datetime null,
UpdatedBy   nvarchar(256) null,
UpdatedDate    datetime null,
PurposeID int null,
Applied bit null,
DrawFundingId nvarchar(256) null,
Comments nvarchar(max) null,
Issaved bit null DEFAULT 0 ,
DealFundingRowno int null ,
DealFundingID UNIQUEIDENTIFIER null,
WF_CurrentStatus nvarchar(256) null,
[ShardName] nvarchar(max)  NULL,
GeneratedBy nvarchar(256) null
)

--PIKScheduleDetail
IF OBJECT_ID('tempdb..##tblPIKScheduleDetail') IS NOT NULL             
DROP TABLE ##tblPIKScheduleDetail 
            
create table ##tblPIKScheduleDetail(
PIKScheduleDetailID	uniqueidentifier  NOT NULL,
EventId	uniqueidentifier not null,
[Date]	date null,
Value	decimal(28,15)null,
CreatedBy      	nvarchar(256) null,
CreatedDate      	datetime null,
UpdatedBy      	nvarchar(256) null,
UpdatedDate      	datetime null,
[ShardName] nvarchar(max)  NULL
)

--LIBORSchedule
IF OBJECT_ID('tempdb..##tblLiborSchedule') IS NOT NULL             
DROP TABLE ##tblLiborSchedule 
            
create table ##tblLiborSchedule(
LIBORScheduleID	uniqueidentifier  NOT NULL,
EventId	uniqueidentifier not null,
[Date]	date null,
Value	decimal(28,15)null,
CreatedBy      	nvarchar(256) null,
CreatedDate      	datetime null,
UpdatedBy      	nvarchar(256) null,
UpdatedDate      	datetime null,
[ShardName] nvarchar(max)  NULL
)

--AmortSchedule
IF OBJECT_ID('tempdb..##tblAmortSchedule') IS NOT NULL             
DROP TABLE ##tblAmortSchedule 
            
create table ##tblAmortSchedule(
AmortScheduleID	uniqueidentifier  NOT NULL,
EventId	uniqueidentifier not null,
[Date]	date null,
[Value]	decimal(28,15)null,
CreatedBy      	nvarchar(256) null,
CreatedDate      	datetime null,
UpdatedBy      	nvarchar(256) null,
UpdatedDate      	datetime null,
[ShardName] nvarchar(max)  NULL
)

--FeeCouponStripReceivable
IF OBJECT_ID('tempdb..##tblFeeCouponStripReceivable') IS NOT NULL             
DROP TABLE ##tblFeeCouponStripReceivable
            
create table ##tblFeeCouponStripReceivable(
FeeCouponStripReceivableID	uniqueidentifier  NOT NULL,
EventId	uniqueidentifier not null,
[Date]	date null,
[Value]	decimal(28,15)null,
CreatedBy      	nvarchar(256) null,
CreatedDate      	datetime null,
UpdatedBy      	nvarchar(256) null,
UpdatedDate      	datetime null,
SourceNoteId	uniqueidentifier  null,
StrippedAmount	decimal(28,15) null,
RuleTypeID int null,
FeeName nvarchar(256) null,
AnalysisID	uniqueidentifier  null,
[ShardName] nvarchar(max)  NULL
)

 ---Exceptions 111
IF OBJECT_ID('tempdb..##tblExceptions') IS NOT NULL             
DROP TABLE ##tblExceptions
            
create table ##tblExceptions(
 [ExceptionID] [uniqueidentifier] NOT NULL,
 [ObjectID] [uniqueidentifier] NOT NULL,
 [ObjectTypeID] [INT] NOT NULL,
 [FieldName] nvarchar(256) NULL,
 [Summary] nvarchar(MAX),
 [ActionLevelID] [int]  NULL,
 [CreatedBy] [nvarchar](256) NULL,
 [CreatedDate] [datetime] NULL,
 [UpdatedBy] [nvarchar](256) NULL,
 [UpdatedDate] [datetime] NULL,
 [ShardName] nvarchar(max)  NULL
)

--FundingRules
IF OBJECT_ID('tempdb..##tblFundingRepaymentSequence') IS NOT NULL             
DROP TABLE ##tblFundingRepaymentSequence
            
create table ##tblFundingRepaymentSequence(
FundingRepaymentSequenceID	uniqueidentifier  NOT NULL,
NoteID	uniqueidentifier	NOT NULL,
SequenceNo int	  NULL,
SequenceType int	  NULL,
Value decimal(28, 15) 	  NULL,
CreatedBy 	nvarchar(256) 	  NULL,
CreatedDate 	datetime 	  NULL,
UpdatedBy 	nvarchar(256) 	  NULL,
UpdatedDate 	datetime 	  NULL,
[ShardName] nvarchar(max)  NULL
)

--PayRuleDistributions
IF OBJECT_ID('tempdb..##tblPayruleDistributions') IS NOT NULL             
DROP TABLE ##tblPayruleDistributions
            
create table ##tblPayruleDistributions(
    [PayruleDistributionsID] [uniqueidentifier] NOT NULL,
	[SourceNoteID] [uniqueidentifier] NULL,
	[ReceiverNoteID] [uniqueidentifier] NULL,
	TransactionDate  [datetime] NULL,
	Amount decimal (28,15) null,
	[RuleID] [int] NULL,
	[CreatedBy] [nvarchar](256) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [nvarchar](256) NULL,
	[UpdatedDate] [datetime] NULL,
	[FeeName] [nvarchar](256) NULL,
 	AnalysisID	uniqueidentifier  null,
    [ShardName] nvarchar(max)  NULL
)


 --ServicerDropDateSetup
 IF OBJECT_ID('tempdb..##tblServicerDropDateSetup') IS NOT NULL             
DROP TABLE ##tblServicerDropDateSetup
            
create table ##tblServicerDropDateSetup(
ServicerDropDateSetupID	uniqueidentifier  NOT NULL,
NoteID uniqueidentifier  NOT NULL,
ModeledPMTDropDate date  null,
PMTDropDateOverride date  null,
CreatedBy      	nvarchar(256) NULL,
CreatedDate      	datetime NULL,
UpdatedBy      	nvarchar(256) NULL,
UpdatedDate      	datetime NULL,
[ShardName] nvarchar(max)  NULL
)


--FundingRepaymentSequenceWriteOff
IF OBJECT_ID('tempdb..##tblFundingRepaymentSequenceWriteOff') IS NOT NULL             
DROP TABLE ##tblFundingRepaymentSequenceWriteOff

create table ##tblFundingRepaymentSequenceWriteOff(
			DealID            uniqueidentifier  NOT NULL,
			NoteID            uniqueidentifier  NOT NULL,
			PriorityOverride  INT              NULL,
			CreatedBy         nvarchar(256) NULL,
			CreatedDate       datetime NULL,
			UpdatedBy         nvarchar(256) NULL,
			UpdatedDate       datetime NULL,
			[ShardName] nvarchar(max)  NULL
			)



--WLDealPotentialImpairmentDetail
IF OBJECT_ID('tempdb..##tblWLDealPotentialImpairmentDetail') IS NOT NULL             
DROP TABLE ##tblWLDealPotentialImpairmentDetail

create table ##tblWLDealPotentialImpairmentDetail(
	        WLDealPotentialImpairmentMasterID  INT          NOT NULL,
			NoteID                             uniqueidentifier  NOT NULL,
			Value                              decimal(28,15) NULL,
			CreatedBy                          nvarchar(256) NULL,
			CreatedDate                        datetime NULL,
			UpdatedBy                          nvarchar(256) NULL,
			UpdatedDate                        datetime NULL,
			RowNo                              INT      NULL,
			[ShardName] nvarchar(max)  NULL
			)

 --NoteTransactionDetail
IF OBJECT_ID('tempdb..##tblNoteTransactionDetail') IS NOT NULL             
	DROP TABLE ##tblNoteTransactionDetail

CREATE TABLE ##tblNoteTransactionDetail (
    [NoteTransactionDetailID]              UNIQUEIDENTIFIER NOT NULL,
    [NoteID]                               UNIQUEIDENTIFIER NOT NULL,
    [TransactionDate]                      DATE             NULL,
    [TransactionType]                      INT              NULL,
    [Amount]                               DECIMAL (28, 15) NULL,
    [RelatedtoModeledPMTDate]              DATE             NULL,
    [ModeledPayment]                       DECIMAL (28, 15) NULL,
    [AmountOutstandingafterCurrentPayment] DECIMAL (28, 15) NULL,
    [CreatedBy]                            NVARCHAR (256)   NULL,
    [CreatedDate]                          DATETIME         NULL,
    [UpdatedBy]                            NVARCHAR (256)   NULL,
    [UpdatedDate]                          DATETIME         NULL,
    [ServicingAmount]                      DECIMAL (28, 15) NULL,
    [CalculatedAmount]                     DECIMAL (28, 15) NULL,
    [Delta]                                DECIMAL (28, 15) NULL,
    [M61Value]                             BIT               NULL,
    [ServicerValue]                        BIT               NULL,
    [Ignore]                               BIT               NULL,
    [OverrideValue]                        DECIMAL (28, 15) NULL,
    [comments]                             NVARCHAR (MAX)   NULL,
    [PostedDate]                           DATETIME         NULL,
    [ServicerMasterID]                     INT              NULL,
    [Deleted]                              BIT              NULL,
    [TransactionTypeText]                  NVARCHAR (256)   NULL,
    [TranscationReconciliationID]          UNIQUEIDENTIFIER NULL,
    [RemittanceDate]                       DATETIME         NULL,
    [Exception]                            NVARCHAR (256)   NULL,
    [Adjustment]                           DECIMAL (28, 15) NULL,
    [ActualDelta]                          DECIMAL (28, 15) NULL,    
    [OverrideReason]                       INT              NULL,
    [BerAddlint]                           DECIMAL (28, 15) NULL,
    [TransactionEntryAmount]               DECIMAL (28, 15) NULL,
    [Orig_ServicerMasterID]                INT              NULL,
    [InterestAdj]                          DECIMAL (28, 15) NULL,
    [AddlInterest]                         DECIMAL (28, 15) NULL,
    [TotalInterest]                        DECIMAL (28, 15) NULL,
    [WriteOffAmount]						DECIMAL (28, 15) NULL,
	[ShardName] nvarchar(max)  NULL
	)



 --NoteAdjustedCommitmentMaster
IF OBJECT_ID('tempdb..##tblNoteAdjustedCommitmentMaster') IS NOT NULL             
	DROP TABLE ##tblNoteAdjustedCommitmentMaster

CREATE TABLE ##tblNoteAdjustedCommitmentMaster (
[DealID]                           UNIQUEIDENTIFIER NOT NULL,
[Date]                             DATE             NULL,
[Type]                             INT              NULL,
[Comments]                         NVARCHAR (256)   NULL,
[DealAdjustmentHistory]            DECIMAL (28, 15) NULL,
[AdjustedCommitment]               DECIMAL (28, 15) NULL,
[TotalCommitment]                  DECIMAL (28, 15) NULL,
[AggregatedCommitment]             DECIMAL (28, 15) NULL,
[CreatedBy]                        NVARCHAR (256)   NULL,
[CreatedDate]                      DATETIME         NULL,
[UpdatedBy]                        NVARCHAR (256)   NULL,
[UpdatedDate]                      DATETIME         NULL,
[TotalRequiredEquity]              DECIMAL (28, 15) NULL,
[TotalAdditionalEquity]            DECIMAL (28, 15) NULL,   
Rowno int null,
[TotalEquityatClosing]             DECIMAL (28, 15) NULL,
[ShardName] nvarchar(max)  NULL
)


 --NoteAdjustedCommitmentDetail
IF OBJECT_ID('tempdb..##tblNoteAdjustedCommitmentDetail') IS NOT NULL             
	DROP TABLE ##tblNoteAdjustedCommitmentDetail

CREATE TABLE ##tblNoteAdjustedCommitmentDetail (
[NoteID]                         UNIQUEIDENTIFIER NULL,
[Value]                          DECIMAL (28, 15) NULL,
[CreatedBy]                      NVARCHAR (256)   NULL,
[CreatedDate]                    DATETIME         NULL,
[UpdatedBy]                      NVARCHAR (256)   NULL,
[UpdatedDate]                    DATETIME         NULL,
[Type]                           INT              NULL,
[DealID]                         UNIQUEIDENTIFIER NULL,
[NoteTotalCommitment]            DECIMAL (28, 15) NULL,
[NoteAdjustedTotalCommitment]    DECIMAL (28, 15) NULL,
[NoteAggregatedTotalCommitment]  DECIMAL (28, 15) NULL,
Rowno int null,
[ShardName] nvarchar(max)  NULL
)
--============================================================================
 --Deal
INSERT INTO ##tblDeal
(DealID, 
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
 EnableAutoSpread

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
,CalcEngineType
,ShardName
 )
 EXEC sp_execute_remote @data_source_name  = @Env, @stmt = @queryDeal

 --Property
 INSERT INTO ##tblProperty(
       [PropertyID]
      ,[Deal_DealID]
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
      ,[IsDeleted]
	  ,[ShardName]
)
EXEC sp_execute_remote @data_source_name  = @Env, @stmt = @propquery
 
 --DealFunding
 INSERT INTO ##tblDealFunding(
	   [DealFundingID]
      ,[DealID]
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
	  ,[RequiredEquity]
		,[AdditionalEquity]
	  ,[ShardName]
)
EXEC sp_execute_remote @data_source_name  = @Env, @stmt = @dealfundingquery

--Payrulesetup
INSERT INTO ##tblPayrule(
       [PayruleSetupID]
      ,[DealID]
      ,[StripTransferFrom]
      ,[StripTransferTo]
      ,[Value]
      ,[RuleID]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
	  ,[ShardName]
)
EXEC sp_execute_remote @data_source_name  = @Env, @stmt = @payrulequery




INSERT INTO ##tblAutoSpreadRule(
[AutoSpreadRuleID]
,[DealID]
,[PurposeType] 
,[PurposeSubType]
,[DebtAmount]
,[EquityAmount]
,[StartDate] 
,[EndDate] 
,[DistributionMethod]
,[FrequencyFactor] 
,[Comment] 
,[CreatedBy] 
,[CreatedDate] 
,[UpdatedBy] 
,[UpdatedDate] 
,[RequiredEquity]
,[AdditionalEquity]
,[ShardName]
)
EXEC sp_execute_remote @data_source_name  = @Env, @stmt = @AutoSpreadRulequery



INSERT INTO ##tblDealAmortizationSchedule(
[DealAmortizationScheduleID]    
,[DealID]                        
,[Date]                          
,[Amount]                        
,[CreatedBy]                     
,[CreatedDate]                   
,[UpdatedBy]                     
,[UpdatedDate]                   
,[DealAmortizationScheduleAutoID]
,[DealAmortScheduleRowno]
,[ShardName]
)
EXEC sp_execute_remote @data_source_name  = @Env, @stmt = @DealAmortizationSchedulequery



INSERT INTO ##tblDealProjectedPayOffAccounting(
DealProjectedPayOffAccountingID
,DealID
,AsOfDate
,CumulativeProbability
,[CreatedBy] 
,[CreatedDate]
,[UpdatedBy]
,[UpdatedDate]  
,[ShardName]
)
EXEC sp_execute_remote @data_source_name  = @Env, @stmt = @DealProjectedPayOffAccountingquery


INSERT INTO ##tblWLDealPotentialImpairmentMaster(
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
			,[ShardName]
			)
EXEC sp_execute_remote @data_source_name  = @Env, @stmt = @WLDealPotentialImpairmentMasterquery

INSERT INTO ##tblWLDealAccounting(
			DealID,
			StartDate,
			EndDate,
			TypeID,
			Comment,
			CreatedBy,
			CreatedDate,
			UpdatedBy,
			UpdatedDate
			,[ShardName]
			)
EXEC sp_execute_remote @data_source_name  = @Env, @stmt = @WLDealAccountingquery




--NoteCursor
INSERT INTO ##tblNoteCursor (
  AccountID,
  NoteName, 
  CRENoteID,
  NoteId ,
  ShardName
  )
  EXEC sp_execute_remote @data_source_name  = @Env, @stmt = @cursorquery


  --Account
  INSERT INTO ##tblAccount(
	   [AccountID]
      ,[AccountTypeID]
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
	  ,[ShardName]
)
EXEC sp_execute_remote @data_source_name  = @Env, @stmt = @accountquery

--Note

Declare @temp nvarchar(max) 
SET @temp = @notequery1 + @notequery2

INSERT INTO ##tblNote(
 [NoteID]
,[Account_AccountID]
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
,FirstIndexDeterminationDateOverride
,[ShardName]
)
EXEC sp_execute_remote @data_source_name  = @Env, @stmt = @temp

 
-----Note Details

----============================Cursor for all note detail schedule===========================


--Event
INSERT INTO ##tblEvent(
	   [EventID]
      ,[AccountID]
      ,[Date]
      ,[EventTypeID]
      ,[EffectiveStartDate]
      ,[EffectiveEndDate]
      ,[SingleEventValue]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
      ,[StatusID]
	  ,[ShardName]
)
EXEC sp_execute_remote @data_source_name  = @Env, @stmt = @eventquery

--Maturity
INSERT INTO ##tblMaturity(
 [MaturityID]
,[EventId]
,[SelectedMaturityDate]
,[CreatedBy]
,[CreatedDate]
,[UpdatedBy]
,[UpdatedDate]
,MaturityDate
,MaturityType
,Approved
,IsAutoApproved
,[ShardName]
)
EXEC sp_execute_remote @data_source_name  = @Env, @stmt = @maturityquery

--RateSpreadSchedule
INSERT INTO ##tblRateSpreadSchedule(
 [RateSpreadScheduleID]
,[EventId]
,[Date]
,[ValueTypeID]
,[Value]
,[IntCalcMethodID]
,[CreatedBy]
,[CreatedDate]
,[UpdatedBy]
,[UpdatedDate]
,[RateOrSpreadToBeStripped]
,IndexNameID
,DeterminationDateHolidayList
,[ShardName]
)
EXEC sp_execute_remote @data_source_name  = @Env, @stmt = @ratespreadschedulequery

--PrepayAndAdditionalFeeSchedule
INSERT INTO ##tblPrepayAndAdditionalFeeSchedule(
       [PrepayAndAdditionalFeeScheduleID]
      ,[EventID]
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
      ,[FeetobeStripped]
	  ,[ShardName])
EXEC sp_execute_remote @data_source_name  = @Env, @stmt = @prepayandadditionalfeeschedulequery


--FinancingFeeSchedule
INSERT INTO ##tblFinancingFeeSchedule(
       [FinancingFeeScheduleID]
      ,[EventId]
      ,[Date]
      ,[ValueTypeID]
      ,[Value]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
      ,[ShardName])
EXEC sp_execute_remote @data_source_name  = @Env, @stmt = @financingfeeschedulequery

--FinancingSchedule
INSERT INTO ##tblFinancingSchedule(
       [FinancingScheduleID]
      ,[EventId]
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
      ,[ShardName])
EXEC sp_execute_remote @data_source_name  = @Env, @stmt = @financingschedulequery

--DeafultSchedule
INSERT INTO ##tblDefaultSchedule(
       [DefaultScheduleID]
      ,[EventId]
      ,[StartDate]
      ,[EndDate]
      ,[ValueTypeID]
      ,[Value]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
      ,[ShardName])
EXEC sp_execute_remote @data_source_name  = @Env, @stmt = @defaultschedulequery

--PIKSchedule
INSERT INTO ##tblPIKSchedule(
       [PIKScheduleID]
      ,[EventID]
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
      ,[UpdatedDate]
	  ,[PIKReasonCodeID]
	  ,[PIKComments]
	  ,[PIKIntCalcMethodID]
	  ,PeriodicRateCapAmount 
	  ,PeriodicRateCapPercent
	  ,PIKPercentage
	  ,PIKSetUp
	  ,PIKSeparateCompounding
      ,[ShardName])
EXEC sp_execute_remote @data_source_name  = @Env, @stmt = @pikschedulequery


--ServicingFeeSchedule
INSERT INTO ##tblServicingFeeSchedule(
       [ServicingFeeScheduleID]
      ,[EventId]
      ,[Date]
      ,[Value]
      ,[IsCapitalized]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
      ,[ShardName])
EXEC sp_execute_remote @data_source_name  = @Env, @stmt = @servicingfeeschedulequery

--FundingSchedule
INSERT INTO ##tblFundingSchedule(
       [FundingScheduleID]
      ,[EventId]
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
      ,[WF_CurrentStatus]
	  ,GeneratedBy
      ,[ShardName])
EXEC sp_execute_remote @data_source_name  = @Env, @stmt = @fundingschedulequery

--PIKScheduleDetail
INSERT INTO ##tblPIKScheduleDetail(
       [PIKScheduleDetailID]
      ,[EventId]
      ,[Date]
      ,[Value]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
      ,[ShardName])
EXEC sp_execute_remote @data_source_name  = @Env, @stmt = @pikscheduledetailquery

--LIBORSchedule
INSERT INTO ##tblLiborSchedule(
       [LIBORScheduleID]
      ,[EventId]
      ,[Date]
      ,[Value]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
	  ,[ShardName])
EXEC sp_execute_remote @data_source_name  = @Env, @stmt = @liborschedulequery

--AmortSchedule
INSERT INTO ##tblAmortSchedule(
       [AmortScheduleID]
      ,[EventId]
      ,[Date]
      ,[Value]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
      ,[ShardName])
EXEC sp_execute_remote @data_source_name  = @Env, @stmt = @amortschedulequery

--FeeCouponStripReceivable
INSERT INTO ##tblFeeCouponStripReceivable(
	   [FeeCouponStripReceivableID]
      ,[EventId]
      ,[Date]
      ,[Value]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
      ,[SourceNoteId]
      ,[StrippedAmount]
      ,[RuleTypeID]
      ,[FeeName]
      ,[AnalysisID]
	  ,[ShardName])
EXEC sp_execute_remote @data_source_name  = @Env, @stmt = @feecouponstripreceivablequery

--Exceptions
INSERT INTO ##tblExceptions(
       [ExceptionID]
      ,[ObjectID]
      ,[ObjectTypeID]
      ,[FieldName]
      ,[Summary]
      ,[ActionLevelID]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
      ,[ShardName])
EXEC sp_execute_remote @data_source_name  = @Env, @stmt = @exceptionsquery

--FundingRules
INSERT INTO ##tblFundingRepaymentSequence(
       [FundingRepaymentSequenceID]
      ,[NoteID]
      ,[SequenceNo]
      ,[SequenceType]
      ,[Value]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
	  ,[ShardName])
EXEC sp_execute_remote @data_source_name  = @Env, @stmt = @fundingrulesquery


--PayruleDistributions
INSERT INTO ##tblPayruleDistributions(
       [PayruleDistributionsID]
      ,[SourceNoteID]
      ,[ReceiverNoteID]
      ,[TransactionDate]
      ,[Amount]
      ,[RuleID]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
      ,[FeeName]
      ,[AnalysisID]
	  ,[ShardName])

EXEC sp_execute_remote @data_source_name  = @Env, @stmt = @payruleditributionsquery

 --ServicerDropDateSetup
INSERT INTO ##tblServicerDropDateSetup(
       [ServicerDropDateSetupID]
      ,[NoteID]
      ,[ModeledPMTDropDate]
      ,[PMTDropDateOverride]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
      ,[ShardName])

EXEC sp_execute_remote @data_source_name  = @Env, @stmt = @servicerdropdatesetupquery

INSERT INTO ##tblFundingRepaymentSequenceWriteOff(
			DealID,
			NoteID,
			PriorityOverride,
			CreatedBy,
			CreatedDate,
			UpdatedBy,
			UpdatedDate,
			[ShardName])
EXEC sp_execute_remote @data_source_name  = @Env, @stmt = @FundingRepaymentSequenceWriteOffquery

INSERT INTO ##tblWLDealPotentialImpairmentDetail(
	        WLDealPotentialImpairmentMasterID,
			NoteID,
			Value,
			CreatedBy,
			CreatedDate,
			UpdatedBy,
			UpdatedDate,
			RowNo
			,[ShardName])
EXEC sp_execute_remote @data_source_name  = @Env, @stmt = @WLDealPotentialImpairmentDetailquery


 --NoteTransactionDetail
INSERT INTO ##tblNoteTransactionDetail(
[NoteTransactionDetailID]              
,[NoteID]   
,[TransactionDate]                      
,[TransactionType]                      
,[Amount]   
,[RelatedtoModeledPMTDate]              
,[ModeledPayment]                       
,[AmountOutstandingafterCurrentPayment] 
,[CreatedBy]
,[CreatedDate]                          
,[UpdatedBy]
,[UpdatedDate]                          
,[ServicingAmount]                      
,[CalculatedAmount]                     
,[Delta]    
,[M61Value] 
,[ServicerValue]                        
,[Ignore]   
,[OverrideValue]                        
,[comments] 
,[PostedDate]                           
,[ServicerMasterID]                     
,[Deleted]  
,[TransactionTypeText]                  
,[TranscationReconciliationID]          
,[RemittanceDate]                       
,[Exception]
,[Adjustment]                           
,[ActualDelta]  
,[OverrideReason]                       
,[BerAddlint]                           
,[TransactionEntryAmount]               
,[Orig_ServicerMasterID]                
,[InterestAdj]                          
,[AddlInterest]                         
,[TotalInterest]                        
,[WriteOffAmount]						
,[ShardName])
EXEC sp_execute_remote @data_source_name  = @Env, @stmt = @NoteTransactionDetailquery




 --NoteAdjustedCommitmentMaster
INSERT INTO ##tblNoteAdjustedCommitmentMaster(
DealID
,[Date]
,[Type]
,Comments	
,DealAdjustmentHistory	
,AdjustedCommitment	
,TotalCommitment	
,AggregatedCommitment	
,CreatedBy	
,CreatedDate	
,UpdatedBy	
,UpdatedDate
,TotalRequiredEquity
,TotalAdditionalEquity
,Rowno	
,TotalEquityatClosing					
,[ShardName])
EXEC sp_execute_remote @data_source_name  = @Env, @stmt = @NoteAdjustedCommitmentMasterquery


 --NoteAdjustedCommitmentDetail
INSERT INTO ##tblNoteAdjustedCommitmentDetail(
NoteID,
[Value],
CreatedBy,
CreatedDate,
UpdatedBy,
UpdatedDate,
[Type],
DealID,
NoteTotalCommitment,
NoteAdjustedTotalCommitment,
NoteAggregatedTotalCommitment,
Rowno				
,[ShardName])
EXEC sp_execute_remote @data_source_name  = @Env, @stmt = @NoteAdjustedCommitmentDetailquery



END
GO

