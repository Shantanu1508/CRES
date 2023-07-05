

CREATE View [dbo].[DealFundingWF]
As

Select D.*, r.statusnamebi As StatusName 
, CurrentDate = GetDate()
from [DW].[DealFundingSchduleBI] D
Left join RecentWF R on R.DealFundingID = D.[DealFundingID]
