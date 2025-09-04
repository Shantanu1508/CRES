CREATE VIEW [dbo].[vw_NotePariodicCalc_Unpivot_Staging_Default_CopyC#]
AS
Select Scenario,dealname,credealid,crenoteid,accountid,[Type],PeriodEndDate,[Value]
From(
	Select a.Name as Scenario,d.dealname,d.credealid,n.crenoteid, nc.accountid
	, nc.PeriodEndDate	
	,ISNULL(AllInCouponRate,0) as AllInCouponRate
	,ISNULL(AllInPIKRate,0) as AllInPIKRate
	,ISNULL(RemainingUnfundedCommitment,0) as RemainingUnfundedCommitment

	--Balance Components
	,ISNULL(BeginningBalance,0) as BeginningBalance
	,ISNULL(TotalFutureAdvancesForThePeriod,0) as TotalFutureAdvancesForThePeriod
	,ISNULL(TotalDiscretionaryCurtailmentsforthePeriod,0) as TotalDiscretionaryCurtailmentsforthePeriod
	,ISNULL(ScheduledPrincipal,0) as ScheduledPrincipal
	,ISNULL(PrincipalPaid,0) as PrincipalPaid
	,ISNULL(PIKInterestForThePeriod,0) as PIKInterestForThePeriod
	,ISNULL(PIKInterestPaidForThePeriod,0) as PIKInterestPaidForThePeriod
	,ISNULL(PIKInterestAppliedForThePeriod,0) as PIKInterestAppliedForThePeriod
	,ISNULL(PIKPrincipalPaidForThePeriod,0) as PIKPrincipalPaidForThePeriod
	,ISNULL(BalloonPayment,0) as BalloonPayment
	,ISNULL(EndingBalance,0) as EndingBalance

	--Total GAAP Interest Income Components
	,ISNULL(ReversalofPriorInterestAccrual,0) as ReversalofPriorInterestAccrual
	,ISNULL(InterestReceivedinCurrentPeriod,0) as InterestReceivedinCurrentPeriod
	,ISNULL(CurrentPeriodInterestAccrual,0) as CurrentPeriodInterestAccrual
	,ISNULL(CurrentPeriodPIKInterestAccrual,0) as CurrentPeriodPIKInterestAccrual
	,ISNULL(TotalGAAPInterestFortheCurrentPeriod,0) as TotalGAAPInterestFortheCurrentPeriod
	,ISNULL(CurrentPeriodInterestAccrualPeriodEnddate,0) as CurrentPeriodInterestAccrualPeriodEnddate
	,ISNULL(CurrentPeriodPIKInterestAccrualPeriodEnddate,0) as CurrentPeriodPIKInterestAccrualPeriodEnddate

	--GAAP Book Value Components
	,ISNULL(CleanCost,0) as CleanCost
	,ISNULL(GrossDeferredFees,0) as GrossDeferredFees
	,ISNULL(DeferredFeesReceivable,0) as DeferredFeesReceivable
	,ISNULL(AmortizedCost,0) as AmortizedCost
	,ISNULL(TotalAmortAccrualForPeriod,0) as TotalAmortAccrualForPeriod
	,ISNULL(AccumulatedAmort,0) as AccumulatedAmort
	,ISNULL(DiscountPremiumAccrual,0) as DiscountPremiumAccrual
	,ISNULL(DiscountPremiumAccumulatedAmort,0) as DiscountPremiumAccumulatedAmort
	,ISNULL(CapitalizedCostAccrual,0) as CapitalizedCostAccrual
	,ISNULL(CapitalizedCostAccumulatedAmort,0) as CapitalizedCostAccumulatedAmort
	,ISNULL(DropDateInterestDeltaBalance,0) as DropDateInterestDeltaBalance
	,ISNULL(InterestSuspenseAccountActivityforthePeriod,0) as InterestSuspenseAccountActivityforthePeriod
	,ISNULL(InterestSuspenseAccountBalance,0) as InterestSuspenseAccountBalance
	,ISNULL(EndingGAAPBookValue,0) as EndingGAAPBookValue

	from CRE.NotePeriodicCalc nc
	inner join core.account acc on acc.accountid = nc.accountid 
	inner join cre.note n on n.Account_AccountID = acc.accountid 
	inner join cre.deal d on d.dealid = n.dealid
	left join core.analysis a on a.analysisid = nc.analysisid
	where nc.analysisID = '00B25F98-7037-4C2C-ABB1-A23F0854E0D1' and nc.[month] is not null
	---and n.crenoteid = '2230'
)a
UNPIVOT 
(
	[Value] FOR [Type] IN (
	 AllInCouponRate
	,AllInPIKRate
	,RemainingUnfundedCommitment
	,BeginningBalance
	,TotalFutureAdvancesForThePeriod
	,TotalDiscretionaryCurtailmentsforthePeriod
	,ScheduledPrincipal
	,PrincipalPaid
	,PIKInterestForThePeriod
	,PIKInterestPaidForThePeriod
	,PIKInterestAppliedForThePeriod
	,PIKPrincipalPaidForThePeriod
	,BalloonPayment
	,EndingBalance
	,ReversalofPriorInterestAccrual
	,InterestReceivedinCurrentPeriod
	,CurrentPeriodInterestAccrual
	,CurrentPeriodPIKInterestAccrual
	,TotalGAAPInterestFortheCurrentPeriod
	,CurrentPeriodInterestAccrualPeriodEnddate
	,CurrentPeriodPIKInterestAccrualPeriodEnddate
	,CleanCost
	,GrossDeferredFees
	,DeferredFeesReceivable
	,AmortizedCost
	,TotalAmortAccrualForPeriod
	,AccumulatedAmort
	,DiscountPremiumAccrual
	,DiscountPremiumAccumulatedAmort
	,CapitalizedCostAccrual
	,CapitalizedCostAccumulatedAmort
	,DropDateInterestDeltaBalance
	,InterestSuspenseAccountActivityforthePeriod
	,InterestSuspenseAccountBalance
	,EndingGAAPBookValue

	)
) as sq_up

--order by Scenario,dealname,crenoteid,[Type],PeriodEndDate