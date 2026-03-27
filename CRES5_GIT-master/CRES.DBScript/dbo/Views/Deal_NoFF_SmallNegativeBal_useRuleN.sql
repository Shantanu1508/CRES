-- View
-- View
CREATE view [dbo].[Deal_NoFF_SmallNegativeBal_useRuleN]
as

Select Distinct creDealID
, d.DealName Deal_NoFF_SmallNegativeBal 
,HasScheduledPrincipal= case when x.dealname is null then 'No' 
						else 'Yes' end
from [dbo].[DealLevelBalancePastDeals_useruleN] d

left join (select Distinct DealName from Transactionentry
			Where Scenario = 'Default' and Type = 'ScheduledPrincipalPaid'
			and AccountTypeID = 1)x
			on d.DealName = x.DealName
where HighorSmallNegativebalance = 'Small Negative Balance'