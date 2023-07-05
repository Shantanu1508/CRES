
CREATE PROCEDURE [dbo].[usp_Import_Staging_Note_ByMultipleNoteID]
 @MultipleNoteids nvarchar(max)
AS
BEGIN
    SET NOCOUNT ON;
	
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

CREATE TABLE #tblListNotes(CRENoteID VARCHAR(256))

INSERT INTO #tblListNotes(CRENoteID)
Select Value from fn_Split(@MultipleNoteids);
--=================================================

Delete from [DW].[Staging_Note] where crenoteid in (Select Crenoteid from #tblListNotes)

INSERT INTO [DW].[Staging_Note]
([NoteID]
,[AccountID]
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
,[ServicerID]
,[TotalCommitment]
,[DeterminationDateHolidayListBI]
,[RateTypeBI]
,[ReAmortizeMonthlyBI]
,[ReAmortizeatPMTResetBI]
,[StubPaidInArrearsBI]
,[RelativePaymentMonthBI]
,[SettleWithAccrualFlagBI]
,[InterestDueAtMaturityBI]
,[LoanPurchaseBI]
,[StubPaidinAdvanceYNBI]
,[ProspectiveAccountingModeBI]
,[IsCapitalizedBI]
,[ClassificationBI]
,[SubClassificationBI]
,[GAAPDesignationBI]
,[GeographicLocationBI]
,[PropertyTypeBI]
,[RatingAgencyBI]
,[RiskRatingBI]
,[ModelFinancingDrawsForFutureFundingsBI]
,[NumberOfBusinessDaysLagForFinancingDrawBI]
,[FinancingFacilityBI]
,[FinancingPayFrequencyBI]
,[IncludeServicingPaymentOverrideinLevelYieldBI]
,[RoundingMethodBI]
,[StubInterestPaidonFutureAdvancesBI]
,[ExitFeeAmortCheckBI]
,[FixedAmortScheduleCheckBI]
,[IndexNameBI]
,[StatusID]
,[StatusBI]
,[Name]
,[BaseCurrencyID]
,[BaseCurrencyBI]
,[PayFrequency]
,[ClientName]
,[Portfolio]
,[Tag1]
,[Tag2]
,[Tag3]
,[Tag4]
,[CreatedBy]
,[CreatedDate]
,[UpdatedBy]
,[UpdatedDate]
,lienposition
,lienpositionBI
,priority
--,ExtendedMaturityScenario1	
--,ExtendedMaturityScenario2	
--,ExtendedMaturityScenario3	
,ActualPayoffDate	
,FullyExtendedMaturityDate	
,TotalCommitmentExtensionFeeisBasedOn
,LienPriority
,UnusedFeeThresholdBalance
,UnusedFeePaymentFrequency
,Servicer
,FullInterestAtPPayoff
,ServicerBI

,ClientID
,FinancingSourceID
,DebtTypeID
,BillingNotesID
,CapStack
,ClientBI
,FinancingSourceBI
,DebtTypeBI
,BillingNotesBI
,CapStackBI
,FundID
,FundBI
,PoolID
,PoolBI
,ServicerNameID
,ServicerNameBI
,BusinessdaylafrelativetoPMTDate
,DayoftheMonth
,InterestCalculationRuleForPaydowns
,InterestCalculationRuleForPaydownsBI
,PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate
,PIKInterestAddedToBalanceBasedOnBusinessAdjustedDateBI

,Pik_NonPIK
,HasFundingRepayment
,FullAccrualHasRepayment
,HasAmortTerm_Or_FixedAmort
,HasAmortTerm
,HasOnlyRepayment
,HasFixedAmort
,HasScheduledPrincipal
,HasPIkPrincipalpaid
,HasPIkInterestpaid


,InitialFundingEquCommit
,HasDSMonthlyOverride
,FixedPIK
,FloatingPIK
)




Select
n.[NoteID],
ac.[AccountID],
n.[DealID],
n.[CRENoteID],
n.[ClientNoteID],
n.[Comments],
n.[InitialInterestAccrualEndDate],
n.[AccrualFrequency],
n.[DeterminationDateLeadDays],
n.[DeterminationDateReferenceDayoftheMonth],
n.[DeterminationDateInterestAccrualPeriod],
n.[DeterminationDateHolidayList],
n.[FirstPaymentDate],
n.[InitialMonthEndPMTDateBiWeekly],
n.[PaymentDateBusinessDayLag],
n.[IOTerm],
n.[AmortTerm],
n.[PIKSeparateCompounding],
n.[MonthlyDSOverridewhenAmortizing],
n.[AccrualPeriodPaymentDayWhenNotEOMonth],
n.[FirstPeriodInterestPaymentOverride],
n.[FirstPeriodPrincipalPaymentOverride],
n.[FinalInterestAccrualEndDateOverride],
n.[AmortType],
n.[RateType],
n.[ReAmortizeMonthly],
n.[ReAmortizeatPMTReset],
n.[StubPaidInArrears],
n.[RelativePaymentMonth],
n.[SettleWithAccrualFlag],
n.[InterestDueAtMaturity],
n.[RateIndexResetFreq],
n.[FirstRateIndexResetDate],
n.[LoanPurchase],
n.[AmortIntCalcDayCount],
n.[StubPaidinAdvanceYN],
n.[FullPeriodInterestDueatMaturity],
n.[ProspectiveAccountingMode],
n.[IsCapitalized],
n.[SelectedMaturityDateScenario],
n.[SelectedMaturityDate],

(

	Select  TOP 1  mat.[MaturityDate] as SelectedMaturityDate
	from [CORE].Maturity mat  
	INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
	INNER JOIN   
	(          
		Select   
		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
		INNER JOIN [CORE].[Account] a ON a.AccountID = n.Account_AccountID  
		where EventTypeID = 11  and eve.StatusID = 1
		and a.IsDeleted = 0  	
		and a.AccountID = ac.AccountID		
		GROUP BY n.Account_AccountID,EventTypeID    
	) sEvent    
	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  and e.StatusID = 1
	INNER JOIN [CORE].[Account] acc1 ON acc1.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc1.AccountID 	
	where mat.maturityType = 708 
	and	mat.Approved = 3
	and acc1.AccountID = ac.AccountID

	--Select TOP 1 mat.[SelectedMaturityDate]
	--from CORE.Maturity mat
	--INNER JOIN CORE.Event e on e.EventID = mat.EventId
	--INNER JOIN 
	--			(
						
	--				Select 
	--					(Select AccountID from CORE.Account ac where ac.AccountID = n.Account_AccountID) AccountID ,
	--					MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
	--					INNER JOIN CRE.Note n ON n.Account_AccountID = eve.AccountID
	--					INNER JOIN CORE.Account acc ON acc.AccountID = n.Account_AccountID
	--					where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'Maturity')
	--					and acc.AccountID = ac.AccountID
	--					GROUP BY n.Account_AccountID,EventTypeID

	--			) sEvent
	--ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID

)InitialMaturityDate,

--n.[InitialMaturityDate],

n.[ExpectedMaturityDate],
n.[OpenPrepaymentDate],
n.[CashflowEngineID],
n.[LoanType],
n.[Classification],
n.[SubClassification],
n.[GAAPDesignation],
n.[PortfolioID],
n.[GeographicLocation],
n.[PropertyType],
n.[RatingAgency],
n.[RiskRating],
n.[PurchasePrice],
n.[FutureFeesUsedforLevelYeild],
n.[TotalToBeAmortized],
n.[StubPeriodInterest],
n.[WDPAssetMultiple],
n.[WDPEquityMultiple],
n.[PurchaseBalance],
n.[DaysofAccrued],
n.[InterestRate],
n.[PurchasedInterestCalc],
n.[ModelFinancingDrawsForFutureFundings],
n.[NumberOfBusinessDaysLagForFinancingDraw],
n.[FinancingFacilityID],
n.[FinancingInitialMaturityDate],
n.[FinancingExtendedMaturityDate],
n.[FinancingPayFrequency],
n.[FinancingInterestPaymentDay],
n.[ClosingDate],
n.[InitialFundingAmount],
n.[Discount],
n.[OriginationFee],
n.[CapitalizedClosingCosts],
n.[PurchaseDate],
n.[PurchaseAccruedFromDate],
n.[PurchasedInterestOverride],
n.[DiscountRate],
n.[ValuationDate],
n.[FairValue],
n.[DiscountRatePlus],
n.[FairValuePlus],
n.[DiscountRateMinus],
n.[FairValueMinus],
n.[InitialIndexValueOverride],
n.[IncludeServicingPaymentOverrideinLevelYield],
n.[OngoingAnnualizedServicingFee],
n.[IndexRoundingRule],
n.[RoundingMethod],
n.[StubInterestPaidonFutureAdvances],
n.[TaxAmortCheck],
n.[PIKWoCompCheck],
n.[GAAPAmortCheck],
n.[StubIntOverride],
n.[PurchasedIntOverride],
n.[ExitFeeFreePrepayAmt],
n.[ExitFeeBaseAmountOverride],
n.[ExitFeeAmortCheck],
n.[FixedAmortScheduleCheck],
n.[GeneratedBy],
n.[UseRuletoDetermineNoteFunding],
n.[NoteFundingRule],
n.[FundingPriority],
n.[NoteBalanceCap],
n.[RepaymentPriority],
n.[NoofdaysrelPaymentDaterollnextpaymentcycle],
n.[UseIndexOverrides],
n.[IndexNameID],
n.[ServicerID],
n.[TotalCommitment],
LDeterminationDateHolidayListBI.Name as  [DeterminationDateHolidayListBI],
LRateTypeBI.Name as  [RateTypeBI],
LReAmortizeMonthlyBI.Name as  [ReAmortizeMonthlyBI],
LReAmortizeatPMTResetBI.Name as  [ReAmortizeatPMTResetBI],
LStubPaidInArrearsBI.Name as  [StubPaidInArrearsBI],
LRelativePaymentMonthBI.Name as  [RelativePaymentMonthBI],
LSettleWithAccrualFlagBI.Name as  [SettleWithAccrualFlagBI],
LInterestDueAtMaturityBI.Name as  [InterestDueAtMaturityBI],
LLoanPurchaseBI.Name as  [LoanPurchaseBI],
LStubPaidinAdvanceYNBI.Name as  [StubPaidinAdvanceYNBI],
LProspectiveAccountingModeBI.Name as  [ProspectiveAccountingModeBI],
LIsCapitalizedBI.Name as  [IsCapitalizedBI],
LClassificationBI.Name as  [ClassificationBI],
LSubClassificationBI.Name as  [SubClassificationBI],
LGAAPDesignationBI.Name as  [GAAPDesignationBI],
LGeographicLocationBI.Name as  [GeographicLocationBI],
LPropertyTypeBI.Name as  [PropertyTypeBI],
LRatingAgencyBI.Name as  [RatingAgencyBI],
LRiskRatingBI.Name as  [RiskRatingBI],
LModelFinancingDrawsForFutureFundingsBI.Name as  [ModelFinancingDrawsForFutureFundingsBI],
LNumberOfBusinessDaysLagForFinancingDrawBI.Name as  [NumberOfBusinessDaysLagForFinancingDrawBI],
acFw.Name as  [FinancingFacilityBI],
LFinancingPayFrequencyBI.Name as  [FinancingPayFrequencyBI],
LIncludeServicingPaymentOverrideinLevelYieldBI.Name as  [IncludeServicingPaymentOverrideinLevelYieldBI],
LRoundingMethodBI.Name as  [RoundingMethodBI],
LStubInterestPaidonFutureAdvancesBI.Name as  [StubInterestPaidonFutureAdvancesBI],
LExitFeeAmortCheckBI.Name as  [ExitFeeAmortCheckBI],
LFixedAmortScheduleCheckBI.Name as  [FixedAmortScheduleCheckBI],
LIndexNameBI.Name as  [IndexNameBI],
ac.[StatusID],
LStatusBI .Name as  [StatusBI],
ac.[Name],
ac.[BaseCurrencyID],
LBaseCurrencyBI.Name as [BaseCurrencyBI],
ac.[PayFrequency],
n.[ClientName],
n.[Portfolio],
n.[Tag1],
n.[Tag2],
n.[Tag3],
n.[Tag4],
(CASE When EXISTS (SELECT 1 WHERE n.[CreatedBy] LIKE REPLACE('00000000-0000-0000-0000-000000000000', '0', '[0-9a-fA-F]'))
  THEN (select  top 1 u.[Login]  from App.[User] u where u.UserID =  n.[CreatedBy]) 
  ELSE n.[CreatedBy] END) as [CreatedBy],

n.[CreatedDate],

(CASE When EXISTS (SELECT 1 WHERE n.UpdatedBy LIKE REPLACE('00000000-0000-0000-0000-000000000000', '0', '[0-9a-fA-F]'))
  THEN (select  top 1 u.[Login]  from App.[User] u where u.UserID =  n.UpdatedBy) 
  ELSE n.UpdatedBy END) as UpdatedBy,
n.[UpdatedDate],
n.lienposition,
LlienpositionBI.Name as  [lienpositionBI],
n.priority,
--n.ExtendedMaturityScenario1,
--n.ExtendedMaturityScenario2,
--n.ExtendedMaturityScenario3,
n.ActualPayoffDate,
n.FullyExtendedMaturityDate,
n.TotalCommitmentExtensionFeeisBasedOn,
n.LienPriority,
n.UnusedFeeThresholdBalance,
n.UnusedFeePaymentFrequency,
n.Servicer,
n.FullInterestAtPPayoff,
LServicerBI.Name as ServicerBI,
n.ClientID,
n.FinancingSourceID,
n.DebtTypeID,
n.BillingNotesID,
n.CapStack,
clt.ClientName as ClientBI,

--LFinancingSourceID.Value as FinancingSourceBI,
LFinancingSourceID.FinancingSourceName as FinancingSourceBI,

LDebtTypeID.Name as DebtTypeBI,
LBillingNotesID.Name as BillingNotesBI,
LCapStack.Name as CapStackBI,
n.FundID,
f.FundName,
n.PoolID,
LPool.Name as PoolBI,
n.ServicerNameID ,
lsvr.ServicerName as ServicerNameBI,
n.BusinessdaylafrelativetoPMTDate,
n.DayoftheMonth,
n.InterestCalculationRuleForPaydowns,
lInterestCalculationRuleForPaydowns.name as InterestCalculationRuleForPaydownsBI,
n.PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate,
lPIKInterestAddedToBalanceBasedOnBusinessAdjustedDate.name as PIKInterestAddedToBalanceBasedOnBusinessAdjustedDateBI,



Pik_NonPIK = Case when CreNoteid in (Select CreNoteid from(Select n.crenoteid,(Select count(piks.StartDate)   
       from Core.[PIKSchedule] piks  
       inner join core.Event e on e.EventID = piks.EventId  
       inner join core.Account acc on acc.AccountID = e.AccountID  
       where e.EventTypeID = 12   
       and acc.AccountID = n.account_accountid) PIKScheduleCnt  
       from cre.Note n  
       )a  where PIKScheduleCnt > 0  
       ) THEN 'Pik Loan'  
          else 'Non PIK'  
          End  ,
HasFundingRepayment = Case 
						when CRENoteID in (Select Distinct CRENoteID from Dw.NoteFundingScheduleBI
											where PurposeBI <> 'Amortization' and Amount <> 0) 
						Then 'Yes' else 'No' end,

FullAccrualHasRepayment = Case when lInterestCalculationRuleForPaydowns.name = 'Full Period Accrual' 
								and 
								CRENoteID in (Select Distinct CRENoteID from Dw.NotefundingscheduleBi
											where PurposeBI <> 'Amortization' and Amount < 0)
								THEN 'Yes' else 'No' end
								,

HasAmortTerm_Or_FixedAmort = Case when crenoteid in (Select  distinct  CRENoteID
														from [Core].[AmortSchedule] A
														Inner join Core.Event E on E.EventID =  A.EventId
														Inner join Core.Lookup  L on L.LookupID = E.EventTypeID
														inner join cre.note n on n.Account_AccountID = e.AccountID
														inner join cre.Deal D on D.DealID = N.DealID
														where LookupID = 19 or Crenoteid in (Select Distinct CRENoteID from Cre.Note
														where ISNULL(AmortTerm,0) <> 0 )) Then 'Yes' else 'No' End,

HasAmortTerm = Case when crenoteid in  (Select Distinct CRENoteID from Cre.Note	where ISNULL(AmortTerm,0) <> 0 ) Then 'Yes' else 'No' End,
HasOnlyRepayment = Case when CRENoteID in (Select Distinct CRENoteID from DW.NoteFundingScheduleBI Where PurposeBI <> 'AMortization' and Amount < 0) Then 'Yes' else 'No' end,
HasFixedAmort = Case when crenoteid in (Select  distinct  CRENoteID
														from [Core].[AmortSchedule] A
														Inner join Core.Event E on E.EventID =  A.EventId
														Inner join Core.Lookup  L on L.LookupID = E.EventTypeID
														inner join cre.note n on n.Account_AccountID = e.AccountID
														inner join cre.Deal D on D.DealID = N.DealID
														where LookupID = 19) Then 'Yes' else 'No' End,

null as HasScheduledPrincipal,
null as HasPIkPrincipalpaid,
null as HasPIkInterestpaid,

InitialFundingEquCommit= Case when n.InitialFundingAmount>0.01 and n.InitialFundingAmount= n.TotalCommitment then 'Yes' else 'No'End,
HasDSMonthlyOverride = Case when ISNULL(MonthlyDSOverridewhenAmortizing ,0)<>0 then 'Yes' else 'No' end,
FixedPIK=Case when tblPIK.AdditionalIntRate <>0 then 'Fixed PIK' end,
FloatingPIK = case when tblPIK.AdditionalSpread <>0  then 'Floating PIK' end


From [dbo].[Ex_Staging_Note] n
Inner Join CORE.Account ac ON ac.AccountID = n.Account_AccountID
left join Core.Lookup  LDeterminationDateHolidayListBI ON n.[DeterminationDateHolidayList] = LDeterminationDateHolidayListBI .LookupID
left join Core.Lookup  LRateTypeBI ON n.[RateType] = LRateTypeBI .LookupID
left join Core.Lookup  LReAmortizeMonthlyBI ON n.[ReAmortizeMonthly] = LReAmortizeMonthlyBI .LookupID
left join Core.Lookup  LReAmortizeatPMTResetBI ON n.[ReAmortizeatPMTReset] = LReAmortizeatPMTResetBI .LookupID
left join Core.Lookup  LStubPaidInArrearsBI ON n.[StubPaidInArrears] = LStubPaidInArrearsBI .LookupID
left join Core.Lookup  LRelativePaymentMonthBI ON n.[RelativePaymentMonth] = LRelativePaymentMonthBI .LookupID
left join Core.Lookup  LSettleWithAccrualFlagBI ON n.[SettleWithAccrualFlag] = LSettleWithAccrualFlagBI .LookupID
left join Core.Lookup  LInterestDueAtMaturityBI ON n.[InterestDueAtMaturity] = LInterestDueAtMaturityBI .LookupID
left join Core.Lookup  LLoanPurchaseBI ON n.[LoanPurchase] = LLoanPurchaseBI .LookupID
left join Core.Lookup  LStubPaidinAdvanceYNBI ON n.[StubPaidinAdvanceYN] = LStubPaidinAdvanceYNBI .LookupID
left join Core.Lookup  LProspectiveAccountingModeBI ON n.[ProspectiveAccountingMode] = LProspectiveAccountingModeBI .LookupID
left join Core.Lookup  LIsCapitalizedBI ON n.[IsCapitalized] = LIsCapitalizedBI .LookupID
left join Core.Lookup  LClassificationBI ON n.[Classification] = LClassificationBI .LookupID
left join Core.Lookup  LSubClassificationBI ON n.[SubClassification] = LSubClassificationBI .LookupID
left join Core.Lookup  LGAAPDesignationBI ON n.[GAAPDesignation] = LGAAPDesignationBI .LookupID
left join Core.Lookup  LGeographicLocationBI ON n.[GeographicLocation] = LGeographicLocationBI .LookupID
left join Core.Lookup  LPropertyTypeBI ON n.[PropertyType] = LPropertyTypeBI .LookupID
left join Core.Lookup  LRatingAgencyBI ON n.[RatingAgency] = LRatingAgencyBI .LookupID
left join Core.Lookup  LRiskRatingBI ON n.[RiskRating] = LRiskRatingBI .LookupID
left join Core.Lookup  LModelFinancingDrawsForFutureFundingsBI ON n.[ModelFinancingDrawsForFutureFundings] = LModelFinancingDrawsForFutureFundingsBI .LookupID
left join Core.Lookup  LNumberOfBusinessDaysLagForFinancingDrawBI ON n.[NumberOfBusinessDaysLagForFinancingDraw] = LNumberOfBusinessDaysLagForFinancingDrawBI .LookupID
left join Core.Lookup  LFinancingPayFrequencyBI ON n.[FinancingPayFrequency] = LFinancingPayFrequencyBI .LookupID
left join Core.Lookup  LIncludeServicingPaymentOverrideinLevelYieldBI ON n.[IncludeServicingPaymentOverrideinLevelYield] = LIncludeServicingPaymentOverrideinLevelYieldBI .LookupID
left join Core.Lookup  LRoundingMethodBI ON n.[RoundingMethod] = LRoundingMethodBI .LookupID
left join Core.Lookup  LStubInterestPaidonFutureAdvancesBI ON n.[StubInterestPaidonFutureAdvances] = LStubInterestPaidonFutureAdvancesBI .LookupID
left join Core.Lookup  LExitFeeAmortCheckBI ON n.[ExitFeeAmortCheck] = LExitFeeAmortCheckBI .LookupID
left join Core.Lookup  LFixedAmortScheduleCheckBI ON n.[FixedAmortScheduleCheck] = LFixedAmortScheduleCheckBI .LookupID
left join Core.Lookup  LIndexNameBI ON n.[IndexNameID] = LIndexNameBI .LookupID
left join Core.Lookup  LStatusBI ON ac.[StatusID] = LStatusBI .LookupID
left join Core.Lookup  LBaseCurrencyBI ON ac.[BaseCurrencyID] = LBaseCurrencyBI .LookupID
left join Core.Lookup  LlienpositionBI ON n.lienposition = LlienpositionBI .LookupID
left join CRE.FinancingWarehouse fw ON n.[FinancingFacilityID] = fw.FinancingWarehouseID
left join CORE.Account acFw ON acFw.AccountID = fw.Account_AccountID
left join Core.Lookup  LServicerBI ON n.Servicer = LServicerBI.LookupID
left join CRE.Client clt on clt.ClientID = n.ClientID

left join [CRE].[FinancingSourceMaster] LFinancingSourceID on LFinancingSourceID.FinancingSourceMasterID = n.FinancingSourceID
--left join Core.Lookup  LFinancingSourceID ON n.FinancingSourceID = LFinancingSourceID.LookupID and LFinancingSourceID.Parentid = 71

left join Core.Lookup  LDebtTypeID ON n.DebtTypeID = LDebtTypeID.LookupID and LDebtTypeID.Parentid = 72
left join Core.Lookup  LBillingNotesID ON n.BillingNotesID = LBillingNotesID.LookupID and LBillingNotesID.Parentid = 2
left join Core.Lookup  LCapStack ON n.CapStack = LCapStack.LookupID and LCapStack.Parentid = 73
left join CRE.Fund f on f.Fundid = n.Fundid
left join Core.Lookup  LPool ON n.PoolID = LPool.LookupID and LPool.Parentid = 74
left join cre.Servicer lsvr ON n.ServicerNameID = lsvr.ServicerID
left join Core.Lookup lInterestCalculationRuleForPaydowns ON n.InterestCalculationRuleForPaydowns=lInterestCalculationRuleForPaydowns.LookupID
left join Core.Lookup lPIKInterestAddedToBalanceBasedOnBusinessAdjustedDate ON n.PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate=lPIKInterestAddedToBalanceBasedOnBusinessAdjustedDate.LookupID
Left JOin(
	Select  n.noteid,pik.[AdditionalIntRate]  ,pik.[AdditionalSpread] 
	from [CORE].PikSchedule pik  
	left JOIN [CORE].[Account] accsource ON accsource.AccountID = pik.SourceAccountID  
	left JOIN [CORE].[Account] accDest ON accDest.AccountID = pik.TargetAccountID  
	INNER JOIN [CORE].[Event] e on e.EventID = pik.EventId  
	LEFT JOIN [CORE].[Lookup] LPIKReasonCode ON LPIKReasonCode.LookupID = pik.PIKReasonCodeID  
	LEFT JOIN [CORE].[Lookup] LPIKIntCalcMethodID ON LPIKIntCalcMethodID.LookupID = pik.PIKIntCalcMethodID  
	INNER JOIN   
	(  
        
		Select   
		 (Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
		 MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
		 INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
		 INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
		 where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'PikSchedule')      
		 and acc.IsDeleted = 0  
		 GROUP BY n.Account_AccountID,EventTypeID   
	) sEvent  
	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
)tblPIK on tblPIK.noteid = n.noteid

where n.crenoteid in (Select Crenoteid from #tblListNotes)
and ac.isdeleted <> 1

SET TRANSACTION ISOLATION LEVEL READ COMMITTED



END
