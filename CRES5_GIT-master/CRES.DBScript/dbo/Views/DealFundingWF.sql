
CREATE View [dbo].[DealFundingWF]
As

Select D.*, r.statusnamebi As StatusName     
, CurrentDate = GetDate()    
,D.CREDealID +'_'+ CONVERT(varchar(10), Date) Credealid_Date
,StatusWithNoWFAllow = (case when  (r.statusnamebi is null and D.Applied=0) then 'Projected'
when (r.statusnamebi is null and D.Applied=1) then 'Completed' else r.statusnamebi end)
from [DW].[DealFundingSchduleBI] D    
Left join (
	select dealid,DealFundingID,statusnamebi
	From(
	select dealid,DealFundingID,statusnamebi,updateddate,ROW_NUMBER() over (partition by dealid,DealFundingID order by dealid,DealFundingID,updateddate desc) rno
	from RecentWF w
	)a where a.rno = 1
) R on R.DealFundingID = D.[DealFundingID] 






