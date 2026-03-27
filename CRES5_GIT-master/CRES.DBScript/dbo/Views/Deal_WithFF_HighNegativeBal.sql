-- View
CREATE view [dbo].[Deal_WithFF_HighNegativeBal]
as
Select Distinct creDealID, d.DealName Deal_WithFF_HighNegativeBal 
,HasScheduledPrincipal= case when x.dealname is null then 'No' 
						else 'Yes' end

from [DealLevelBalanceFFDeals] d
left join (select Distinct DealName from Transactionentry
			Where Scenario = 'Default' and Type = 'ScheduledPrincipalPaid'
			and AccountTypeID = 1)x
			on d.DealName = x.DealName
where HighorSmallNegativebalance = 'High Negative Balance'