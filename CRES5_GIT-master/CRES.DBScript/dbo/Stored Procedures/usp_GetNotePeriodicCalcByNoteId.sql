 
-- Procedure  
CREATE Procedure [dbo].[usp_GetNotePeriodicCalcByNoteId] --'C7A300A5-33FF-42C9-9806-7D94D58F8010','c10f3372-0fc2-4861-a9f5-148f1f80804f'  
(  
 @NoteId uniqueidentifier,  
 @ScenarioId uniqueidentifier  
)  
as   
BEGIN  
 SET NOCOUNT ON;  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

 declare @AccountID uniqueidentifier = (Select Account_AccountID from cre.note where noteid = @NoteId)

SELECT  
  [NotePeriodicCalcID]  
  ,n.[NoteID]  
  ,[PeriodEndDate]  
  ,ISNULL([Month] ,0) as [Month]  
  ,ISNULL([ActualCashFlows] ,0) as [ActualCashFlows]  
  ,ISNULL([GAAPCashFlows] ,0) as [GAAPCashFlows]  
  ,ISNULL([EndingGAAPBookValue] ,0) as [EndingGAAPBookValue]  
  ,ISNULL([ReversalofPriorInterestAccrual] ,0) as [ReversalofPriorInterestAccrual]  
  ,ISNULL([InterestReceivedinCurrentPeriod] ,0) as [InterestReceivedinCurrentPeriod]  
  ,ISNULL([CurrentPeriodInterestAccrual] ,0) as [CurrentPeriodInterestAccrual]  
  ,ISNULL([TotalGAAPInterestFortheCurrentPeriod] ,0) as [TotalGAAPInterestFortheCurrentPeriod]   
  --,ISNULL([PIKInterestAccrualforthePeriod] ,0) as [PIKInterestAccrualforthePeriod]  
  ,ISNULL([TotalAmortAccrualForPeriod] ,0) as [TotalAmortAccrualForPeriod]  
  ,ISNULL([AccumulatedAmort] ,0) as [AccumulatedAmort]  
  ,ISNULL([BeginningBalance] ,0) as [BeginningBalance]  
  ,ISNULL([TotalFutureAdvancesForThePeriod] ,0) as [TotalFutureAdvancesForThePeriod]  
  ,ISNULL([TotalDiscretionaryCurtailmentsforthePeriod] ,0) as [TotalDiscretionaryCurtailmentsforthePeriod]  
  ,ISNULL([InterestPaidOnPaymentDate] ,0) as [InterestPaidOnPaymentDate]  
  ,ISNULL([TotalCouponStrippedforthePeriod] ,0) as [TotalCouponStrippedforthePeriod]  
  ,ISNULL([CouponStrippedonPaymentDate] ,0) as [CouponStrippedonPaymentDate]  
  ,ISNULL([ScheduledPrincipal] ,0) as [ScheduledPrincipal]  
  ,ISNULL([PrincipalPaid] ,0) as [PrincipalPaid]  
  ,ISNULL([BalloonPayment] ,0) as [BalloonPayment]  
  ,ISNULL([EndingBalance] ,0) as [EndingBalance]   
  ,ISNULL([EndOfPeriodWAL] ,0) as [EndOfPeriodWAL]  
  ,ISNULL([PIKInterestFromPIKSourceNote] ,0) as [PIKInterestFromPIKSourceNote]  
  ,ISNULL([PIKInterestTransferredToRelatedNote] ,0) as [PIKInterestTransferredToRelatedNote]  
  ,ISNULL([PIKInterestForThePeriod] ,0) as [PIKInterestForThePeriod]  
  ,ISNULL([BeginningPIKBalanceNotInsideLoanBalance] ,0) as [BeginningPIKBalanceNotInsideLoanBalance]  
  ,ISNULL([PIKInterestForPeriodNotInsideLoanBalance] ,0) as [PIKInterestForPeriodNotInsideLoanBalance]  
  ,ISNULL([PIKBalanceBalloonPayment] ,0) as [PIKBalanceBalloonPayment]  
  ,ISNULL([EndingPIKBalanceNotInsideLoanBalance] ,0) as [EndingPIKBalanceNotInsideLoanBalance]   
  ,ISNULL([AmortAccrualLevelYield] ,0) as [AmortAccrualLevelYield]  
  ,ISNULL([ScheduledPrincipalShortfall] ,0) as [ScheduledPrincipalShortfall]  
  ,ISNULL([PrincipalShortfall] ,0) as [PrincipalShortfall]  
  ,ISNULL([PrincipalLoss] ,0) as [PrincipalLoss]  
  ,ISNULL([InterestForPeriodShortfall] ,0) as [InterestForPeriodShortfall]  
  ,ISNULL([InterestPaidOnPMTDateShortfall] ,0) as [InterestPaidOnPMTDateShortfall]  
  ,ISNULL([CumulativeInterestPaidOnPMTDateShortfall] ,0) as [CumulativeInterestPaidOnPMTDateShortfall]  
  ,ISNULL([InterestShortfallLoss] ,0) as [InterestShortfallLoss]  
  ,ISNULL([InterestShortfallRecovery] ,0) as [InterestShortfallRecovery]  
  ,ISNULL([BeginningFinancingBalance] ,0) as [BeginningFinancingBalance]  
  ,ISNULL([TotalFinancingDrawsCurtailmentsForPeriod] ,0) as [TotalFinancingDrawsCurtailmentsForPeriod]  
  ,ISNULL([FinancingBalloon] ,0) as [FinancingBalloon]  
  ,ISNULL([EndingFinancingBalance] ,0) as [EndingFinancingBalance]  
  ,ISNULL([FinancingInterestPaid] ,0) as [FinancingInterestPaid]  
  ,ISNULL([FinancingFeesPaid] ,0) as [FinancingFeesPaid]  
  ,ISNULL([PeriodLeveredYield] ,0) as [PeriodLeveredYield]  
  ,ISNULL(OrigFeeAccrual ,0) as OrigFeeAccrual  
  ,ISNULL(DiscountPremiumAccrual ,0) as DiscountPremiumAccrual  
  ,ISNULL(ExitFeeAccrual ,0) as ExitFeeAccrual  
  ,ISNULL(AllInCouponRate ,0) as AllInCouponRate  
  ,ISNULL(npc.[CreatedBy] ,0) as [CreatedBy]  
  ,ISNULL(npc.[CreatedDate] ,0) as [CreatedDate]  
  ,ISNULL(npc.[UpdatedBy] ,0) as [UpdatedBy]  
  ,ISNULL(npc.[UpdatedDate] ,0) as [UpdatedDate]  
  ,ISNULL([CleanCost] ,0) as CleanCost  
  ,ISNULL([GrossDeferredFees] ,0) as GrossDeferredFees  
  ,ISNULL([DeferredFeesReceivable] ,0) as DeferredFeesReceivable  
  ,ISNULL([CleanCostPrice] ,0) as CleanCostPrice  
  ,ISNULL([AmortizedCostPrice] ,0) as AmortizedCostPrice  
  ,ISNULL([AdditionalFeeAccrual] ,0) as AdditionalFeeAccrual  
  ,ISNULL([CapitalizedCostAccrual] ,0) as CapitalizedCostAccrual    
  ,ISNULL(InvestmentBasis ,0) as InvestmentBasis   
  ,ISNULL([AmortizedCost] ,0) as [AmortizedCost]  
  ,ISNULL(CurrentPeriodInterestAccrualPeriodEnddate ,0) as CurrentPeriodInterestAccrualPeriodEnddate  
  ,npc.AnalysisID  
  ,ISNULL(FeeStrippedforthePeriod ,0) as FeeStrippedforthePeriod   
  ,ISNULL(PIKInterestPercentage ,0) as PIKInterestPercentage   
  ,ISNULL(InterestSuspenseAccountActivityforthePeriod ,0) as InterestSuspenseAccountActivityforthePeriod   
  ,ISNULL(InterestSuspenseAccountBalance ,0) as InterestSuspenseAccountBalance   
  --,ISNULL(CRL.Name,'') as CalculationStatus  
  ,ISNULL((CASE WHEN CRL.Name = 'SaveDBPending' THEN 'Running' ELSE CRL.Name END),'') as CalculationStatus  
  ,ISNULL(npc.AllInBasisValuation,0) as AllInBasisValuation  
  ,ISNULL(npc.AllInPIKRate,0) as AllInPIKRate  
  ,ISNULL(npc.CurrentPeriodPIKInterestAccrualPeriodEnddate,0) as CurrentPeriodPIKInterestAccrualPeriodEnddate  
  ,ISNULL(npc.PIKInterestPaidForThePeriod,0) as PIKInterestPaidForThePeriod   
  ,ISNULL(npc.PIKInterestAppliedForThePeriod,0) as PIKInterestAppliedForThePeriod  
  ,ISNULL(npc.EndingPreCapPVBasis,0) as EndingPreCapPVBasis  
  ,ISNULL(npc.LevelYieldIncomeForThePeriod,0) as LevelYieldIncomeForThePeriod  
  ,ISNULL(npc.PVAmortTotalIncomeMethod,0) as PVAmortTotalIncomeMethod  
  ,ISNULL(npc.EndingCleanCostLY,0) as EndingCleanCostLY  
  ,ISNULL(npc.EndingAccumAmort,0) as EndingAccumAmort  
  ,ISNULL(npc.PVAmortForThePeriod,0) as PVAmortForThePeriod  
  ,ISNULL(npc.EndingSLBasis,0) as EndingSLBasis  
  ,ISNULL(npc.SLAmortForThePeriod,0) as SLAmortForThePeriod  
  ,ISNULL(npc.SLAmortOfTotalFeesInclInLY,0) as SLAmortOfTotalFeesInclInLY  
  ,ISNULL(npc.SLAmortOfDiscountPremium,0) as SLAmortOfDiscountPremium  
  ,ISNULL(npc.SLAmortOfCapCost,0) as SLAmortOfCapCost  
  ,ISNULL(npc.EndingAccumSLAmort,0) as EndingAccumSLAmort  
  ,ISNULL(npc.EndingPreCapGAAPBasis,0) as EndingPreCapGAAPBasis   
  ,ISNULL(npc.PIKPrincipalPaidForThePeriod,0) as PIKPrincipalPaidForThePeriod   
  ,ISNULL(npc.RemainingUnfundedCommitment,0) as RemainingUnfundedCommitment    
  ,npc.accountingclosedate  
  ,ISNULL(CurrentPeriodPIKInterestAccrual ,0) as CurrentPeriodPIKInterestAccrual 
  ,ISNULL(DropDateInterestDeltaBalance ,0) as DropDateInterestDeltaBalance  
  ,ISNULL(AverageDailyBalance ,0) as AverageDailyBalance  
  ,ISNULL(InterestPastDue ,0) as InterestPastDue 
  , ISNULL(CapitalizedCostAccumulatedAmort ,0) as CapitalizedCostAccumulatedAmort 
  , ISNULL(DiscountPremiumAccumulatedAmort ,0) as DiscountPremiumAccumulatedAmort 
  , ISNULL(PrincipalWriteoff ,0) as PrincipalWriteoff 
  , ISNULL(NetPIKAmountForThePeriod ,0) as NetPIKAmountForThePeriod 
    , ISNULL(CashInterest ,0) as CashInterest 
	  , ISNULL(CapitalizedInterest ,0) as CapitalizedInterest 

FROM [CRE].[NotePeriodicCalc] npc  
inner join core.Account acc on acc.AccountID = npc.AccountID  
left join cre.Note n on n.Account_AccountID = acc.AccountID
left join [Core].[CalculationRequests] CR on CR.AccountId = n.Account_AccountID and CR.AnalysisID = @ScenarioId and CR.CalcType = 775  
left join [core].[Lookup] CRL On CRL.LookUpID = CR.StatusID  
where n.NoteID = @NoteId and acc.IsDeleted = 0  
and [PeriodEndDate] in (SELECT DISTINCT EOMONTH([PeriodEndDate]) FROM [CRE].[NotePeriodicCalc] where AccountID = @AccountID)  
  
and npc.AnalysisID = @ScenarioId  
  
ORDER BY [PeriodEndDate]  
  
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END
GO

