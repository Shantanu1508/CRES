-- View
-- View
CREATE view [dbo].[Note_NoFF_HighNegativeBal]
as

Select Distinct creDealID, d.DealName, d.Crenoteid  
,HasScheduledPrincipal= case when x.Noteid is null then 'No' 
						else 'Yes' end

, SmallVsHighBal= 'High Negative Balance' 
, UserRuleYvsUseRuleN = 'Use Rule Y'
,  FF_Vs_FullyFundied = 'Fully Funded'
from [DealLevelBalancePastDeals] d
left join (select Distinct DealName, Noteid from Transactionentry
			Where Scenario = 'Default' and Type = 'ScheduledPrincipalPaid' and AccountTypeID = 1)x
			on d.Crenoteid = x.Noteid
where HighorSmallNegativebalance = 'High Negative Balance'

union

Select Distinct creDealID, d.DealName ,d.crenoteid 
,HaScheduledPrincipal= case when x.Noteid is null then 'No' 
						else 'Yes' end
, SmallVsHighBal= 'High Negative Balance' 
, UserRuleYvsUseRuleN = 'Use Rule N'
,  FF_Vs_FullyFundied = 'Fully Funded'
from [dbo].[DealLevelBalancePastDeals_useruleN] d
left join (select Distinct DealName, NoteID from Transactionentry
			Where Scenario = 'Default' and Type = 'ScheduledPrincipalPaid' and AccountTypeID = 1)x
			on d.crenoteid = x.Noteid
where HighorSmallNegativebalance = 'High Negative Balance'

Union

Select Distinct creDealID, d. DealName, Crenoteid 
,HasScheduledPrincipal= case when x.Noteid is null then 'No' 
						else 'Yes' end
, SmallVsHighBal= 'Small Negative Balance' 
, UserRuleYvsUseRuleN = 'Use Rule Y'
,  FF_Vs_FullyFundied = 'Fully Funded'
from [DealLevelBalancePastDeals] d
left join (select Distinct DealName, Noteid from Transactionentry
			Where Scenario = 'Default' and Type = 'ScheduledPrincipalPaid' and AccountTypeID = 1)x
			on d.Crenoteid = x.Noteid
where HighorSmallNegativebalance = 'Small Negative Balance'

union

Select Distinct creDealID
, d.DealName , Crenoteid 
,HasScheduledPrincipal= case when x.Noteid is null then 'No' 
						else 'Yes' end
, SmallVsHighBal= 'Small Negative Balance' 
, UserRuleYvsUseRuleN = 'Use Rule N'
,  FF_Vs_FullyFundied = 'Fully Funded'
from [dbo].[DealLevelBalancePastDeals_useruleN] d

left join (select Distinct DealName, Noteid from Transactionentry
			Where Scenario = 'Default' and Type = 'ScheduledPrincipalPaid' and AccountTypeID = 1)x
			on d.crenoteid = x.Noteid
where HighorSmallNegativebalance = 'Small Negative Balance'
 union


 Select Distinct creDealID, d.DealName,  Crenoteid 
,HasScheduledPrincipal= case when x.Noteid is null then 'No' 
						else 'Yes' end
, SmallVsHighBal= 'High Negative Balance' 
, UserRuleYvsUseRuleN = 'Use Rule Y'
,  FF_Vs_FullyFundied = 'Future Funding'
from [DealLevelBalanceFFDeals] d
left join (select Distinct DealName Noteid from Transactionentry
			Where Scenario = 'Default' and Type = 'ScheduledPrincipalPaid' and AccountTypeID = 1)x
			on d.Crenoteid = x.Noteid
where HighorSmallNegativebalance = 'High Negative Balance'

union

Select Distinct creDealID
, d.DealName ,Crenoteid 
,HasScheduledPrincipal= case when x.Noteid is null then 'No' 
						else 'Yes' end
, SmallVsHighBal= 'High Negative Balance' 
, UserRuleYvsUseRuleN = 'Use Rule N'
,  FF_Vs_FullyFundied = 'Future Funding'

from [dbo].[DealLevelBalanceFFDeals_useruleN] D
left join (select Distinct DealName, Noteid from Transactionentry
			Where Scenario = 'Default' and Type = 'ScheduledPrincipalPaid' and AccountTypeID = 1)x
			on d.Crenoteid = x.Noteid
where HighorSmallNegativebalance = 'High Negative Balance'
Union

Select Distinct creDealID, d.DealName ,Crenoteid 
,HasScheduledPrincipal= case when x.NoteID is null then 'No' 
						else 'Yes' end

, SmallVsHighBal= 'Small Negative Balance' 
, UserRuleYvsUseRuleN = 'Use Rule Y'
,  FF_Vs_FullyFundied = 'Future Funding'
from [DealLevelBalanceFFDeals] D
left join (select Distinct DealName, Noteid from Transactionentry
			Where Scenario = 'Default' and Type = 'ScheduledPrincipalPaid' and AccountTypeID = 1)x
			on d.Crenoteid = x.Noteid
where HighorSmallNegativebalance = 'Small Negative Balance'
union

Select Distinct creDealID, d.DealName ,Crenoteid 
,HasScheduledPrincipal= case when x.Noteid is null then 'No' 
						else 'Yes' end
, SmallVsHighBal= 'Small Negative Balance' 
, UserRuleYvsUseRuleN = 'Use Rule N'
,  FF_Vs_FullyFundied = 'Future Funding'
from [dbo].[DealLevelBalanceFFDeals_useruleN] d
left join (select Distinct DealName, Noteid from Transactionentry
			Where Scenario = 'Default' and Type = 'ScheduledPrincipalPaid' and AccountTypeID = 1)x
			on d.Crenoteid = x.Noteid
where HighorSmallNegativebalance = 'Small Negative Balance'