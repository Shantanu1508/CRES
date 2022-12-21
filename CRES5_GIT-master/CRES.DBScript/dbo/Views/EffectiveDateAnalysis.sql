Create View dbo.EffectiveDateAnalysis
as
Select  d.dealname,d.credealid,n.crenoteid,acc.name as Notename,
n.actualpayoffdate, n.FullyExtendedmaturitydate,ISNULL(actualpayoffdate,FullyExtendedmaturitydate) as MaturityDateBI,
fs.FinancingSourceName,
(CASE WHEN tblNoteTr.noteid is null then 0 else 1 end) as IsNoteTransfer,
ISNULL(tblFF.EffCnt ,0) as FF_EffDateCount,
ISNULL(tblMat.EffCnt,0) as Maturity_EffDateCount,
ISNULL(tblRss.EffCnt,0) as RSS_EffDateCount,
ISNULL(tblFee.EffCnt,0) as Fee_EffDateCount,
ISNULL(tblPIK.EffCnt,0) as PIK_EffDateCount

from cre.note n
inner join core.account acc on acc.accountid = n.account_accountid
inner join cre.deal d on d.dealid =n.dealid
left join [CRE].[FinancingSourceMaster] fs on fs.FinancingSourceMasterID = n.FinancingSourceID
Left Join(
	Select Distinct n.noteid
	from [CORE].FundingSchedule fs
	INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	where e.StatusID = 1  and acc.IsDeleted = 0
	and fs.Purposeid = 629
)tblNoteTr on tblNoteTr.noteid = n.noteid

Left Join(
	Select noteid,crenoteid,COUNT(effectivestartdate) EffCnt
	From(
		Select Distinct n.noteid,n.crenoteid, e.effectivestartdate
		from [CORE].FundingSchedule fs
		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		where e.StatusID = 1  and acc.IsDeleted = 0	
	)a group by noteid,crenoteid
)tblFF on tblFF.noteid = n.noteid

LEft Join(
	Select noteid,crenoteid,COUNT(effectivestartdate) EffCnt
	From(
		Select Distinct n.noteid,n.crenoteid, e.effectivestartdate
		from [CORE].Maturity fs
		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		where  acc.IsDeleted = 0	and e.StatusID = 1
	)a group by noteid,crenoteid
)tblMat on tblMat.noteid = n.noteid

Left Join(
	Select noteid,crenoteid,COUNT(effectivestartdate) EffCnt
	From(
		Select Distinct n.noteid,n.crenoteid, e.effectivestartdate
		from [CORE].RateSpreadSchedule fs
		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		where e.StatusID = 1  and acc.IsDeleted = 0	
	)a group by noteid,crenoteid
)tblRss on tblRss.noteid = n.noteid

Left JOin(
	Select noteid,crenoteid,COUNT(effectivestartdate) EffCnt
	From(
		Select Distinct n.noteid,n.crenoteid, e.effectivestartdate
		from [CORE].PrepayAndAdditionalFeeSchedule fs
		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		where e.StatusID = 1  and acc.IsDeleted = 0	
	)a group by noteid,crenoteid
)tblFee on tblFee.noteid = n.noteid

Left Join(
	Select noteid,crenoteid,COUNT(effectivestartdate) EffCnt
	From(
		Select Distinct n.noteid,n.crenoteid, e.effectivestartdate
		from [CORE].PikSchedule fs
		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		where acc.IsDeleted = 0	
	)a group by noteid,crenoteid
)tblPIK on tblPIK.noteid = n.noteid

where acc.isdeleted <> 1 and d.isdeleted <> 1

--Order by d.dealname,n.crenoteid
GO

