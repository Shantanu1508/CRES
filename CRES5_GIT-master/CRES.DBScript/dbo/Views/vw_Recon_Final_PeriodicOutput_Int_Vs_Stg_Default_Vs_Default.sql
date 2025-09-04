-- View
CREATE VIEW [dbo].[vw_Recon_Final_PeriodicOutput_Int_Vs_Stg_Default_Vs_Default]  
 AS  
 
Select ISNULL(a.dealname,b.dealname) as DealName,  ISNULL(a.crenoteid,b.crenoteid) as NoteID, 
acc.Name as NoteName , ISNULL(a.Type,b.Type) as TransactionType, CAST (ISNULL(a.PeriodEndDate,b.PeriodEndDate) as DATE) as PeriodEndDate,
SUM(a.Value) as DevAmount ,SUM(b.Value) as StgAmount, (ISNULL(SUM(a.Value),0)- ISNULL(SUM(b.Value),0)) as Delta,  
ABS((ISNULL(SUM(a.Value),0)- ISNULL(SUM(b.Value),0))) as ABS_Delta, 
CAST(n.closingDate as DATE) as ClosingDate, 
CAST (n.ActualPayoffDate as DATE) as ActualPayoffDate, DevCalcEngineType as DevCalcEngine, ISNULL(c.Status,0) as CalcStatus, LastCalculatedDate_UTC,
--ISNULL(a.Scenario,NULL) as [DevScenario], ISNULL(b.Scenario,NULL) as [StgScenario], 
ISNULL(a.credealid,b.credealid) as DealID, l.Name as DealStatus
from (
	Select * from [dbo].[vw_NotePeriodicCalc_Unpivot_Default]
	
) a
full outer join (
	Select * from [dbo].[vw_NotePeriodicCalc_Unpivot_Staging_Default]
	Where Scenario='Default'
	
) b on a.CreNoteID=b.CreNoteID and a.Type=b.type and a.PeriodEndDate=b.PeriodEndDate and a.Scenario=b.Scenario

left join cre.Note n on n.CRENoteID=ISNULL(a.CreNoteID ,b.Crenoteid)
left join core.account acc on acc.accountID=n.account_accountID
left join cre.Deal d on d.DealID=n.DealID
left join core.lookup l on l.lookupID=d.status
left join (
	Select CreNoteID, ISNULL(l.Name,'') as Status, aa.Name as Analysis , l2.name as DevCalcEngineType, EndTime as LastCalculatedDate_UTC
	from core.CalculationRequests cr
	left join cre.Note n on n.Account_accountid=cr.accountid
	left join core.Lookup l on l.LookupID=cr.StatusID
	left join core.Lookup l2 on l2.LookupID=cr.CalcEngineType
	left join core.Analysis aa on aa.AnalysisID=cr.AnalysisID
	Where aa.Name='Default'
	) c on c.CRENoteID=n.CRENoteID

Where
 ABS(ISNULL(a.Value,0)-ISNULL(b.Value,0)) > 0.01
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
 --and a.CREDealID in ('20-1525')
Group by ISNULL(a.crenoteid,b.crenoteid), ISNULL(a.Scenario,NULL), ISNULL(b.Scenario,NULL), ISNULL(a.dealname,b.dealname),ISNULL(a.credealid,b.credealid),  ISNULL(a.crenoteid,b.crenoteid), acc.Name, ISNULL(a.Type,b.type),  n.closingDate, n.ActualPayoffDate, ISNULL(a.PeriodEndDate,b.PeriodEndDate),
   n.EnableM61Calculations, c.Status, DevCalcEngineType, LastCalculatedDate_UTC, l.Name
 --Order By DealName, NoteID, PeriodEndDate, Type