CREATE VIEW dbo.vw_DealWatchListData
AS
select DealName, StartDate, [Type] as Status, ReasonCode, Comment, ls.CreatedBy,wlMax.Max_StartDate
from cre.WLDealLegalStatus ls 
join cre.deal d on d.dealid=ls.dealid
Left Join(
	Select dealid,Max(Cast(StartDate as Date))  as Max_StartDate
	from cre.WLDealLegalStatus
	Group By dealid
)wlMax on wlMax.dealid = d.dealid

Where --Cast(StartDate as Date)=(Select Max(Cast(StartDate as Date)) from cre.WLDealLegalStatus ls where ls.DealID=d.DealID) and
d.IsDeleted<>1 --and ls.[Type] like '%REO%'
--order by DealName, StartDate 