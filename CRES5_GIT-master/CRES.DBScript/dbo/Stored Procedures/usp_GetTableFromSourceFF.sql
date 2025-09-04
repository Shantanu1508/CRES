
--[dbo].[usp_GetTableFromSourceFF]  '19-16351UseRuleN','RemoteReference_ImportFFOtherSrc'

CREATE   PROCEDURE [dbo].[usp_GetTableFromSourceFF]  
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
FROM [CRE].[Deal] d
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
      --,n.[SelectedMaturityDate]
      --,n.[InitialMaturityDate]
      ,n.[ExpectedMaturityDate]
      --,n.[FullyExtendedMaturityDate]
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
	  --,n.[ExtendedMaturityScenario1]
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
  FROM [Core].[FundingSchedule] funds
  inner join core.Event e  on e.eventid =  funds.EventId
  inner join core.Account acc on acc.AccountID =  e.AccountID
  inner join [CRE].[Note] n ON n.[Account_AccountID] = acc.AccountID
  inner join [CRE].[Deal] d on d.DealID = n.DealID
  WHERE d.CREDealID = '''+@CREDealID+''' AND e.EventTypeID=10
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
	ShardName nvarchar(max)  NULL 
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
	--[SelectedMaturityDate] [date] NULL,
	--[InitialMaturityDate] [date] NULL,
	[ExpectedMaturityDate] [date] NULL,
	--[FullyExtendedMaturityDate] [date] NULL,
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
	FirstIndexDeterminationDateOverride Date null,
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
 EnableAutoSpread,
 ShardName
 )
 EXEC sp_execute_remote @data_source_name  = @Env, @stmt = @queryDeal


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
--,[SelectedMaturityDate]
--,[InitialMaturityDate]
,[ExpectedMaturityDate]
--,[FullyExtendedMaturityDate]
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
      ,[ShardName])
EXEC sp_execute_remote @data_source_name  = @Env, @stmt = @fundingschedulequery


 END
