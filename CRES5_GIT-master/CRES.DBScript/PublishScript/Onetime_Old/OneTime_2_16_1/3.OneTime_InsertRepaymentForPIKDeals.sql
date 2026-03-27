
Update cre.deal set ApplyNoteLevelPaydowns = 1 where dealid in (
	select distinct d.dealid
	from cre.deal d
	left join cre.note n on n.dealid=d.dealid
	where isdeleted<>1 and n.UseRuletoDetermineNoteFunding = 3 and status=323
	and n.actualpayoffdate is null
)


GO

INSERT INTO [CRE].[FundingRepaymentSequence]
           ([NoteID]
           ,[SequenceNo]
           ,[SequenceType]
           ,[Value]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])

Select
n.[NoteID]
,tblSequenceNo.NextSequenceNo + 1 [SequenceNo]
,259 as [SequenceType]
,ISNULL((CASE WHEN tr.SumPikAmount > 0 THEN tr.SumPikAmount ELSE (tr.SumPikAmount * -1) END),0)  as [Value]
,'B0E6697B-3534-4C09-BE0A-04473401AB93' as CreatedBy
,Getdate() as CreatedDate
,'B0E6697B-3534-4C09-BE0A-04473401AB93' as UpdatedBy
,Getdate() as UpdatedDate
from cre.Note n
inner join core.account acc on acc.accountid = n.account_accountid
inner join cre.deal d on d.dealid = n.dealid
Left Join(
	Select noteid,MAX(SequenceNo)  as NextSequenceNo
	from [CRE].[FundingRepaymentSequence] 
	where SequenceType = 259
	group by noteid
)tblSequenceNo on tblSequenceNo.noteid = n.noteid

left join(
	Select tr.noteid,SUM(tr.Amount) as SumPikAmount
	from cre.transactionEntry Tr
	inner join cre.note n on n.noteid=tr.noteid 
	where tr.analysisID =  'C10F3372-0FC2-4861-A9F5-148F1F80804F' and tr.[Type] in ('PikPrincipalPaid','PIKPrincipalFunding')
	--and tr.date <= CAST(getdate() as date)
	group by tr.noteid
)tr on tr.noteid = n.noteid

where acc.IsDeleted <> 1
and d.credealid in (
	--PIK Deals
	Select Distinct credealid from(
		Select Distinct d.CREDealID,dealname,
		(CASE WHEN tblPIKNotes.credealid is not null then 1 else 0 end) as IsPIKDeal
		from cre.Note n
		inner join cre.Deal d on n.DealID = d.DealID
		inner join core.Account acc on acc.accountid = n.account_accountid
		left join core.lookup l on l.lookupid = d.Status
		LEFT JOIN(
			Select Distinct dealid,credealid 
			from(
				Select n.crenoteid,d.dealid,d.credealid,
				(Select count(piks.StartDate) from Core.[PIKSchedule] piks
				inner join core.Event e on e.EventID = piks.EventId
				inner join core.Account acc on acc.AccountID = e.AccountID
				where e.EventTypeID = 12 
				and acc.AccountID = n.account_accountid) PIKScheduleCnt
				from cre.Note n
				inner join cre.Deal d on n.DealID = d.DealID
				inner join core.Account acc on acc.accountid = n.account_accountid
				where acc.isdeleted <> 1
			)a
			where PIKScheduleCnt > 0

		)tblPIKNotes on tblPIKNotes.dealid = d.dealid
		where d.isdeleted <> 1 and acc.IsDeleted <> 1 and n.ActualPayoffDate is null
		and l.name = 'Active'
	)z where z.IsPIKDeal = 1
)



