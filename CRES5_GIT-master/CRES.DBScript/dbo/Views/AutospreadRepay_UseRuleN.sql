-- View
CREATE View [dbo].[AutospreadRepay_UseRuleN]
as
Select * from 
(Select * from [DealLevelBalancePastDeals_useruleN]
	where isnull (Payoffdate, '1/1/1999') >= Date
union

Select* from [DealLevelBalanceFFDeals_useruleN]
where isnull (Payoffdate, '1/1/1999') >= Date


)x