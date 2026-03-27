CREATE View NegativeNoteBalanceMaster
As
Select creDealID
,DealName
,Crenoteid
,SmallVsHighBal
,UserRuleYvsUseRuleN
,FF_Vs_FullyFunded
,HasScheduledPrincp= Case when Crenoteid in (Select NoteID from TransactionEntry T
							Where Scenario = 'Default' and Type ='ScheduledPrincipalPaid' and T.AccountTypeID =1)
							then 'Scheduled Principal' else 'No Scheduled Principal' end
, HasPIK = Case when Crenoteid in (Select NoteID from TransactionEntry T
							Where Scenario = 'Default' and Type ='PIKInterest' and T.AccountTypeID =1)
							then 'PIK' else 'No PIK' end 
from [Note_NegativeBal]