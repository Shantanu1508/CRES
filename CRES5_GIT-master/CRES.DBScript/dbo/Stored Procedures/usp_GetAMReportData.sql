--select top 1 * from dw.[WFTaskDetailBI]
create PROCEDURE [dbo].[usp_GetAMReportData] --2600
as
begin

select d.DealName as 'Deal Name',
tb.[Under Review User],
tb.[1st Approval User],
tb.[2nd Approval User],
tb.[Final Approval User],
df.Amount as 'Funding Amount',
tb.[Under Review Date],
tb.[1st Approval Date],
tb.[2nd Approval Date],
tb.[Final Approval Date],
cast(df.Date as date) 'Funding Date',
tbday.Businessday_cnt as 'Draw Time (Days)',
l.Name as 'Purpose Type'
from 
(
select t1.TaskID, t1.FundingDate,
isnull(t1.[Under Review],'') as [Under Review User],
isnull(t1.[1st Approval],'') as [1st Approval User],
isnull(t1.[2nd Approval],'') as [2nd Approval User],
isnull(t1.[Final Approval],'') as [Final Approval User],
cast(t2.[Under Review]as date) as [Under Review Date],
isnull(cast(cast(t2.[1st Approval] as date) as varchar(50)),'') as [1st Approval Date],
isnull(cast(cast(t2.[2nd Approval] as date) as varchar(50)),'') as [2nd Approval Date],
isnull(cast(cast(t2.[Final Approval] as date) as varchar(50)),'') as [Final Approval Date]

 from
(
	select  * from 
	(
	select taskid,FundingDate,UserName,StatusDisplayName,SubmitType from WFTaskDetail where SubmitType=498
	--select d.DealName, wt.taskid,wt.FundingDate,wt.UserName,DealFundingDisplayName,wt.SubmitType from WFTaskDetail wt  join WorkFlow w on cast(wt.TaskID as varchar(50))=cast(w.TaskID as varchar(50)) join Deal d on cast(d.DealID as varchar(50))=cast(w.dealid as varchar(50))
	) t
	 PIVOT
	(Max(UserName) FOR StatusDisplayName IN ([Under Review],[1st Approval],[2nd Approval],[Final Approval])) as pvt
	--where TaskID='001BC636-C829-4E3E-A446-03A735706438' and SubmitType=498
) t1
join 
(
	select * from 
	(
	select taskid,FundingDate,StatusDisplayName,SubmitType,createdDate from WFTaskDetail where SubmitType=498
	) t
	 PIVOT
	(max(createdDate) FOR StatusDisplayName IN ([Under Review],[1st Approval],[2nd Approval],[Final Approval])) as pvt
	--where TaskID='001BC636-C829-4E3E-A446-03A735706438' and SubmitType=498
) t2 
on t1.TaskID=t2.TaskID
) tb
join cre.DealFunding df on tb.TaskID=df.DealFundingID join cre.Deal d on d.DealID=df.DealID
join core.Lookup l on l.LookupID=df.PurposeID


join
(
    select TaskID,Businessday_cnt,TotalDayCount from WFTaskDetail where WFStatusMasterID=2 and SubmitType=498
) tbday
on tbday.TaskID=tb.TaskID
order by d.DealName

end
