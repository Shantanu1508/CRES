CREATE view [dbo].[TransactionEntry_DealLevel]
as
select
T.Dealid
,T.Amount 
,ISNULL(X.amount,0) ExitFeeGreaterThenToday
,AnalysisID
,Scenario
,T.DealName
,T. Dealkey
,M61Commitment
, ISNULL(y.ExtFeeCommitmentBI,0)ExtFeeCommitmentBI
,ISNULL(M61AdjustedCommitment,0)M61AdjustedCommitment
,ISNULL(Scheduleprincipallessthantoday,0)Scheduleprincipallessthantoday
from [TransactionEntry_DealLevelinterim] T
outer apply (Select 
					 T1.Dealid
					,Sum(t1.Amount)Amount 
					
					from Transactionentry T1
					Where T.Dealid = T1.Dealid and T.Scenario = T1.Scenario and  t1.Type like'%Exit%' 
					
					and T1.Scenario = 'Default' and t1.Date>getdate()  
					and T1.AccountTypeID = 1
					Group by T1.Dealid
					)x
Outer apply (Select * from ExitFeeCommitment_Deallevel E
				where T.Dealid = E.Dealid)y
					--where  T.DealID = '19-1259'