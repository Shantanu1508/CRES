CREATE Procedure [dbo].[usp_GetNotePeriodicByCRENoteID]   --'2307'--'629A3892-863B-4313-8CCC-70205B36B9F6'
(
 @CRENoteId nvarchar(256)
)
as 
BEGIN


	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


Declare @NoteID Uniqueidentifier
Declare @AccountID Uniqueidentifier

select @NoteID = n.NoteID ,@AccountID = n.Account_AccountID
from CRE.Note n 
inner join Core.Account ac on n.Account_AccountID=ac.AccountID 
where n.CRENoteID=  @CRENoteId and ac.isdeleted=0



SELECT
 
  [PeriodEndDate]
,ISNULL([Month] ,0) as [Month]
,ISNULL([ActualCashFlows] ,0) as [ActualCashFlows]
,ISNULL([GAAPCashFlows] ,0) as [GAAPCashFlows]
,ISNULL([EndingGAAPBookValue] ,0) as [EndingGAAPBookValue]
,ISNULL([ReversalofPriorInterestAccrual] ,0) as [ReversalofPriorInterestAccrual]
,ISNULL([InterestReceivedinCurrentPeriod] ,0) as [InterestReceivedinCurrentPeriod]
,ISNULL([CurrentPeriodInterestAccrual] ,0) as [CurrentPeriodInterestAccrual]
,ISNULL([TotalGAAPInterestFortheCurrentPeriod] ,0) as [TotalGAAPInterestFortheCurrentPeriod]
,ISNULL([AllInCouponRate] ,0) as [AllInCouponRate]
--,ISNULL([PIKInterestAccrualforthePeriod] ,0) as [PIKInterestAccrualforthePeriod]
,ISNULL([OrigFeeAccrual] ,0) as [OrigFeeAccrual]
,ISNULL(DiscountPremiumAccrual ,0) as DiscountPremiumAccrual
,ISNULL(ExitFeeAccrual ,0) as ExitFeeAccrual
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


--,ISNULL([ExitFeeIncludedInLevelYield] ,0) as [ExitFeeIncludedInLevelYield]
--,ISNULL([ExitFeeExcludedFromLevelYield] ,0) as [ExitFeeExcludedFromLevelYield]
--,ISNULL([AdditionalFeesIncludedInLevelYield] ,0) as [AdditionalFeesIncludedInLevelYield]
--,ISNULL([AdditionalFeesExcludedFromLevelYield] ,0) as [AdditionalFeesExcludedFromLevelYield]
--,ISNULL([OriginationFeeStripping] ,0) as [OriginationFeeStripping]
--,ISNULL([ExitFeeStrippingIncldinLevelYield] ,0) as [ExitFeeStrippingIncldinLevelYield]
--,ISNULL([ExitFeeStrippingExcldfromLevelYield] ,0) as [ExitFeeStrippingExcldfromLevelYield]
--,ISNULL([AddlFeesStrippingIncldinLevelYield] ,0) as [AddlFeesStrippingIncldinLevelYield]
--,ISNULL([AddlFeesStrippingExcldfromLevelYield] ,0) as [AddlFeesStrippingExcldfromLevelYield]


,ISNULL([EndOfPeriodWAL] ,0) as [EndOfPeriodWAL]
,ISNULL([PIKInterestFromPIKSourceNote] ,0) as [PIKInterestFromPIKSourceNote]
,ISNULL([PIKInterestTransferredToRelatedNote] ,0) as [PIKInterestTransferredToRelatedNote]
,ISNULL([PIKInterestForThePeriod] ,0) as [PIKInterestForThePeriod]
,ISNULL([BeginningPIKBalanceNotInsideLoanBalance] ,0) as [BeginningPIKBalanceNotInsideLoanBalance]
,ISNULL([PIKInterestForPeriodNotInsideLoanBalance] ,0) as [PIKInterestForPeriodNotInsideLoanBalance]
,ISNULL([PIKBalanceBalloonPayment] ,0) as [PIKBalanceBalloonPayment]
,ISNULL([EndingPIKBalanceNotInsideLoanBalance] ,0) as [EndingPIKBalanceNotInsideLoanBalance]
,ISNULL([CleanCost] ,0) as CleanCost
,ISNULL([GrossDeferredFees] ,0) as GrossDeferredFees
,ISNULL([DeferredFeesReceivable] ,0) as DeferredFeesReceivable
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
,ISNULL([CleanCostPrice] ,0) as CleanCostPrice
,ISNULL([AmortizedCostPrice] ,0) as AmortizedCostPrice
,ISNULL([AdditionalFeeAccrual] ,0) as AdditionalFeeAccrual
,ISNULL([CapitalizedCostAccrual] ,0) as CapitalizedCostAccrual
,ISNULL(InvestmentBasis ,0) as InvestmentBasis 
,ISNULL(AllInBasisValuation ,0) as AllInBasisValuation
,ISNULL(CurrentPeriodPIKInterestAccrual ,0) as CurrentPeriodPIKInterestAccrual

FROM [CRE].[NotePeriodicCalc] npc 
Inner join core.account acc on acc.accountid = npc.AccountID
Inner join cre.note n on n.account_accountid = acc.accountid and acc.AccounttypeID = 1
where n.NoteID = @NoteID 
and acc.AccounttypeID = 1
and [PeriodEndDate] in (SELECT DISTINCT EOMONTH([PeriodEndDate]) FROM [CRE].[NotePeriodicCalc] where AccountID = @AccountID)

ORDER BY [PeriodEndDate]


	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
