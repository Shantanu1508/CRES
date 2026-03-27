-- View
create View hasFunding_NoFunding
as

Select N.Noteid
, X.Amount
,InitialFundingamount
, HasFunding= Case when (InitialFundingamount + ISNULL(x.Amount,0))  > 0.01 
then 'HasFunding' else 'has No Funding'  end
from Note N
outer apply (select crenoteid , SUM(Amount)Amount from Notefundingschedule NS
			where NS.CRENoteID = n.noteid and amount> 0
			group by NS.crenoteid)x