
CREATE View [dbo].[BalanceRoll_NPC] 
AS

Select Scenario,DealName,DealID,NoteID,NoteName,FinancingSourceName,PeriodEndDate,EndingBalance
from(
	Select ana.name as Scenario	
	,d.DealName	
	,d.credealid as DealID	
	,n.crenoteid as NoteID	
	,acc.name as NoteName	
	,fs.FinancingSourceName	
	,nc.PeriodEndDate 
	,ISNULL(nc.EndingBalance,0) as EndingBalance
	,ROW_NUMBER() Over (Partition by nc.analysisid,n.noteid order by nc.analysisid,n.noteid,nc.periodenddate desc) rno
	from cre.NotePeriodicCalc nc
	inner join cre.note n on n.Account_AccountID =nc.AccountID 
	inner join core.account acc on acc.accountid = n.Account_AccountID
	Inner join cre.deal d on d.dealid = n.dealid
	Inner join core.Analysis ana on ana.AnalysisID = nc.AnalysisID
	left join cre.FinancingSourceMaster fs on fs.FinancingSourceMasterID = n.FinancingSourceID
	where acc.IsDeleted <> 1	
	and [month] is not null	
	and acc.AccountTypeID = 1
	and nc.AnalysisID in ('C10F3372-0FC2-4861-A9F5-148F1F80804F','D8F8AF6D-B9C7-4015-A610-41D34941EEB5')
	and d.[Status] = 323
	AND d.DealName NOT LIKE '%copy%'
	
	and (nc.PeriodEndDate >= DATEADD(q, DATEDIFF(q, 0, GETDATE()), 0) and nc.PeriodEndDate <= DATEADD(d, -1, DATEADD(q, DATEDIFF(q, 0, GETDATE()) + 1, 0)) )
	--and n.crenoteid = '2230'

)z 
--where rno = 1
---Order By Scenario,DealName,DealID,NoteID,NoteName,FinancingSourceName,PeriodEndDate
