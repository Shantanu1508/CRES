-- View
CREATE view [dbo].[AvgnNegativeBalance]
As


Select [CREDealID],[DealName],[creNoteId], Avg(Avg_Balance)Avg_Negative_Balance from (

select [CREDealID],[DealName],[creNoteId], ([EndingBalance])AVG_Balance
from [dbo].[DealLevelBalanceFFDeals]
where EndingBalance<0
union




Select [CREDealID],[DealName],[creNoteId], ([EndingBalance])AVG_Balance from 
[dbo].[DealLevelBalanceFFDeals_useruleN]

where EndingBalance<0
union

 Select [CREDealID],[DealName],[creNoteId], ([EndingBalance] )AVG_Balance
 from [dbo].[DealLevelBalancePastDeals]
 where EndingBalance<0
  union

Select [CREDealID],[DealName],[creNoteId], ([EndingBalance])AVG_Balance from
[dbo].[DealLevelBalancePastDeals_useruleN]
where EndingBalance<0
)x

group by [CREDealID],[DealName],[creNoteId]