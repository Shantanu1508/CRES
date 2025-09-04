-- View
CREATE View [dbo].PIKLoanGaap
As

Select 
N.Noteid
,PeriodEndDate
, EndingGAAPBookValue - (AccumulatedAmort + CurrentPeriodPIKInterestAccrualPeriodEnddate
+ CleanCost + CurrentPeriodInterestAccrualPeriodEnddate) Delta
,AccumulatedAmort
,CurrentPeriodInterestAccrual
, CleanCost
, Discount
from Cre.NoteperiodicCalc NPC
Inner join core.account acc on acc.accountid = NPC.AccountID
Inner join cre.note n on n.account_accountid = acc.accountid
--inner join cre.Note N1 on N1.Account_AccountID = Npc.AccountID
where Analysisid = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'  and periodenddate = eomonth (periodenddate,0)  and acc.AccounttypeID = 1
and OriginationFee <>0
and EndingGAAPBookValue - (AccumulatedAmort + CurrentPeriodInterestAccrual + CleanCost) <> 0
and Actualpayoffdate is null and N.Noteid in (Select distinct NoteID from TransactionEntry where scenario = 'default'  and type = 'PIKInterest')


--and ABS( EndingGAAPBookValue - (AccumulatedAmort + CurrentPeriodPIKInterestAccrualPeriodEnddate + CleanCost + CurrentPeriodInterestAccrualPeriodEnddate) )> 1
--and eomonth (FullyextendedMaturitydate,0) <> eomonth(Periodenddate,0)