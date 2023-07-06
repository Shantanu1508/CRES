CREATE View  [dbo].[Hasrepayment]
as



Select Distinct 
n.Crenoteid
from [CORE].FundingSchedule fs
INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
INNER JOIN [CRE].Deal d on d.dealid = n.dealid
Inner join(

	Select credealid,dealname,crenoteid,EffectiveStartDate,rno from(
		Select credealid,dealname,crenoteid,EffectiveStartDate,
		Row_Number() over (Partition by credealid,dealname,crenoteid order by credealid,dealname,crenoteid,EffectiveStartDate desc) as rno
		from(
			Select Distinct d.credealid,d.dealname,n.crenoteid,e.EffectiveStartDate
			from [CORE].FundingSchedule fs
			INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
			INNER JOIN [CRE].Deal d on d.dealid = n.dealid
			where e.StatusID = 1  and acc.IsDeleted = 0
		)a
	)b
	where rno = 1

)tblLatestSchedule on tblLatestSchedule.crenoteid = n.crenoteid


where e.StatusID = 1  and acc.IsDeleted = 0




and e.EffectiveStartDate <> tblLatestSchedule.EffectiveStartDate
and fs.value < 0
--and n.crenoteid = 'RXR_A'
and fs.PurposeID <> 351

Union

select Crenoteid from [NoteFundingSchedule]
Where AMount < 0 and Date < Getdate()
