CREATE View Gaapcomptest
As

Select 
Dealname
,CreNoteid
,Nc.[NoteID]
, [PeriodEndDate] 
, EndingGAAPBookValue
--,DiscountPremiumAccrual
, CleanCost
,[CurrentPeriodPIKInterestAccrualPeriodEnddate]
,[AccumalatedCapitalizedCostBI]
,[CurrentPeriodInterestAccrualPeriodEnddate]
,[AccumaltedDiscountPremiumBI]
, AccumulatedAmort
,TotalAmortAccrualForPeriod
,[DiscountPremiumAccrual]
,[CapitalizedCostAccrual]
,InterestSuspenseAccountActivityforthePeriod     
,InterestSuspenseAccountBalance
, CalcGAAP= (Cleancost 
-InterestSuspenseAccountBalance
+[AccumaltedDiscountPremiumBI]
+ [CurrentPeriodPIKInterestAccrualPeriodEnddate]
+[CurrentPeriodInterestAccrualPeriodEnddate]
+  AccumulatedAmort
+[AccumalatedCapitalizedCostBI])

--, MaturityDateBI= Case when ActualPayoffDate is null then FullyExtendedMaturityDate else ActualPayoffDate end
from [DW].[NotePeriodicCalcBI] Nc with (NoLock)
Inner join Note n on n.Notekey = nc.NoteID
	
Where nc.Month is not null
and Analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
and Periodenddate =  eomonth (Periodenddate,0)
and Periodenddate <> ISNULL(eomonth(n.ActualPayoffdate,0),eomonth(n.FullyextendedMaturitydate,0))

--and crenoteid = '8789'
--and crenoteid = '7734'