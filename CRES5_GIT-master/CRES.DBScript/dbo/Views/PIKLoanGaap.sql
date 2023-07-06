Create View [dbo].PIKLoanGaap
As

Select 
N1.Noteid
,PeriodEndDate
, EndingGAAPBookValue - (AccumulatedAmort + CurrentPeriodPIKInterestAccrualPeriodEnddate
+ CleanCost + CurrentPeriodInterestAccrualPeriodEnddate) Delta
,AccumulatedAmort
,CurrentPeriodInterestAccrual
, CleanCost
, Discount
from Cre.NoteperiodicCalc N
inner join Note N1 on N1.Notekey = N.Noteid
where Analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'  and periodenddate = eomonth (periodenddate,0) 
and OriginationFee <>0
and EndingGAAPBookValue - (AccumulatedAmort + CurrentPeriodInterestAccrual + CleanCost) <> 0
and Actualpayoffdate is null and N1.Noteid in (Select distinct NoteID from TransactionEntry
									where scenario = 'default'  
									and type = 'PIKInterest'
									)
--and ABS( EndingGAAPBookValue - (AccumulatedAmort + CurrentPeriodPIKInterestAccrualPeriodEnddate + CleanCost + CurrentPeriodInterestAccrualPeriodEnddate) )> 1
--and eomonth (FullyextendedMaturitydate,0) <> eomonth(Periodenddate,0)
