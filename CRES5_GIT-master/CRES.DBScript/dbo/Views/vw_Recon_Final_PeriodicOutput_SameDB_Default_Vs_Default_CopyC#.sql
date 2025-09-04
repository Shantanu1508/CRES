

CREATE VIEW [dbo].[vw_Recon_Final_PeriodicOutput_SameDB_Default_Vs_Default_CopyC#]  
 AS  

Select ISNULL(a.dealname,b.dealname) as DealName, ISNULL(a.credealid,b.credealid) as DealID, ISNULL(a.crenoteid,b.crenoteid) as NoteID, 
acc.Name as NoteName , ISNULL(a.Type,b.Type) as TransactionType, ISNULL(a.PeriodEndDate,b.PeriodEndDate) as PeriodEndDate,
SUM(a.Value) as DevAmount ,SUM(b.Value) as StgAmount, SUM(ISNULL(a.Value,0)-ISNULL(b.Value,0)) as Delta,  n.closingDate as ClosingDate, 
n.ActualPayoffDate as ActualPayoffDate, DevCalcEngineType, ISNULL(c.Status,'') as CalculationStatus, ISNULL(a.Scenario,'') as [DevScenario], 
ISNULL(b.Scenario,'') as [StgScenario]
from (
	Select * from [dbo].[vw_NotePeriodicCalc_Unpivot_Default]
	
) a
full outer join (
	Select * from dbo.vw_NotePeriodicCalc_Unpivot_DefaultC#
	--Where credealid='20-1525'
) b on a.CreNoteID=b.CreNoteID and a.Type=b.type and a.PeriodEndDate=b.PeriodEndDate

left join cre.Note n on n.CRENoteID=ISNULL(a.CreNoteID ,b.Crenoteid)
left join core.account acc on acc.accountID=n.account_accountID
left join cre.Deal d on d.DealID=n.DealID
left join (
	Select CreNoteID, ISNULL(l.Name,'') as Status, aa.Name as Analysis , l2.name as DevCalcEngineType
	from core.CalculationRequests cr
	left join cre.Note n on n.Account_accountid=cr.accountid
	left join core.Lookup l on l.LookupID=cr.StatusID
	left join core.Lookup l2 on l2.LookupID=cr.CalcEngineType
	left join core.Analysis aa on aa.AnalysisID=cr.AnalysisID
	Where aa.Name='Default'
	) c on c.CRENoteID=n.CRENoteID

Where
  (ABS(a.Value-b.Value) > 0.01 or  (a.Value-b.Value) is NULL)
 and n.EnableM61Calculations=3
 and d.IsDeleted<>1
 and acc.IsDeleted <>1
and ISNULL(a.Type,b.type) in ('BeginningBalance','TotalFutureAdvancesForThePeriod','PIKInterestAppliedForThePeriod','ScheduledPrincipal','TotalDiscretionaryCurtailmentsforthePeriod','BalloonPayment','EndingBalance','GrossDeferredFees','CleanCost','TotalAmortAccrualForPeriod','AccumulatedAmort','DiscountPremiumAccrual','DiscountPremiumAccumulatedAmort','CapitalizedCostAccrual','CapitalizedCostAccumulatedAmort','AmortizedCost', 'CurrentPeriodPIKInterestAccrual','CurrentPeriodInterestAccrual','InterestSuspenseAccountBalance','EndingGAAPBookValue','InvestmentBasis','PVAmortForThePeriod', 'CleanCostPrice','AmortizedCostPrice','ReversalofPriorInterestAccrual','InterestReceivedinCurrentPeriod','CurrentPeriodPIKInterestAccrual','CurrentPeriodInterestAccrual','InterestSuspenseAccountBalance','TotalGAAPInterestFortheCurrentPeriod','EndingGAAPBookValue')
  --DiscountPremiumAcrual
  --and d.CalcEngineType=798
  --and n.ClosingDate>= '2022-06-01 00:00:00.000'
  --and c.Status='Completed'
  --and n.CRENoteID not in ('10639')
  --and a.type like '%AccumulatedAmort%'
  --and ISNULL(a.CREDealID,b.CREDealID) in ('20-1525')
Group by ISNULL(a.crenoteid,b.crenoteid), ISNULL(a.Scenario,''), ISNULL(b.Scenario,''), ISNULL(a.dealname,b.dealname),ISNULL(a.credealid,b.credealid),  ISNULL(a.crenoteid,b.crenoteid), acc.Name, ISNULL(a.Type,b.type),  n.closingDate, n.ActualPayoffDate, a.PeriodEndDate, b.PeriodEndDate,
   n.EnableM61Calculations, c.Status, DevCalcEngineType
  -- Order By DealName, NoteID, PeriodEndDate, Type