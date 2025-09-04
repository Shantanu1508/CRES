-- View
CREATE view [dbo].[TotalNegativeBalance]
As
Select * from
(
Select [creDealID]
, [Deal_WithFF_SmallNegativeBal] 
as DealName,[HasScheduledPrincipal]
, SmallVsHighBal= 'Small Negative Balance' 
, UserRuleYvsUseRuleN = 'Use Rule N'
,  FF_Vs_FullyFundied = 'Future Funding' from [dbo].[Deal_WithFF_SmallNegativeBal_useRuleN]
Union
Select *
,SmallVsHighBal= 'High Negative Balance' 
, UserRuleYvsUseRuleN = 'Use Rule N'
,  FF_Vs_FullyFundied = 'Future Funding'

from [dbo].[Deal_WithFF_HighNegativeBal_useRuleN]
Union
Select *
,SmallVsHighBal= 'High Negative Balance' 
, UserRuleYvsUseRuleN = 'Use Rule Y'
,  FF_Vs_FullyFundied = 'Future Funding'
from [dbo].[Deal_WithFF_HighNegativeBal]
Union
Select *
,SmallVsHighBal= 'Small Negative Balance' 
, UserRuleYvsUseRuleN = 'Use Rule Y'
,  FF_Vs_FullyFundied = 'Future Funding'

from [dbo].[Deal_WithFF_SmallNegativeBal]

union
Select * 
,SmallVsHighBal= 'High Negative Balance' 
, UserRuleYvsUseRuleN = 'Use Rule Y'
,  FF_Vs_FullyFundied = 'Fully Funded'
from [dbo].[Deal_NoFF_HighNegativeBal]
union
Select * 
,SmallVsHighBal= 'High Negative Balance' 
, UserRuleYvsUseRuleN = 'Use Rule N'
,  FF_Vs_FullyFundied = 'Fully Funded'
from.[dbo].[Deal_NoFF_HighNegativeBal_useRuleN]

union
Select * 
,SmallVsHighBal= 'Small Negative Balance' 
, UserRuleYvsUseRuleN = 'Use Rule Y'
,  FF_Vs_FullyFundied = 'Fully Funded'
from [dbo].[Deal_NoFF_SmallNegativeBal]
union
Select * 
,SmallVsHighBal= 'High Negative Balance' 
, UserRuleYvsUseRuleN = 'Use Rule Y'
,  FF_Vs_FullyFundied = 'Fully Funded'
from [dbo].[Deal_WithFF_HighNegativeBal]

)x
--where dealname = 'KSL - Westin Indianapolis'