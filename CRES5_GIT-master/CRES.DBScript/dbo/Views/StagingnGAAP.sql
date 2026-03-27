Create view [dbo].StagingnGAAP
As
Select 
Nc.[NoteID]
, [PeriodEndDate] 
, EndingGAAPBookValue
, CleanCost
--,[CurrentPeriodPIKInterestAccrualPeriodEnddate]
,[AccumalatedCapitalizedCostBI]
,[CurrentPeriodInterestAccrualPeriodEnddate]
,[AccumaltedDiscountPremiumBI]
, [TotalAmortAccrualForPeriod]
--, Case when ActualPayoffDate is null then FullyExtendedMaturityDate else ActualPayoffDate end
from [DW].[NotePeriodicCalcBI] Nc with (NoLock)
Inner join Note n on n.Notekey = nc.NoteID
Where eomonth (periodenddate,0) = Periodenddate  
  