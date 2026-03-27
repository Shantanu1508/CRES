	----Update State deal level
Update cre.deal set cre.deal.statefromproperty = [State]
From(
	SELECT b.dealid,b.[State]
	From(
		Select Distinct d.dealid,d.credealid,p.city,p.PState as [State],Allocation,(city + ', ' +PState) as [M61_location],
		ROW_NUMBER() Over(Partition by credealid order by credealid,PropertyRollUpSW desc,Allocation desc) as rno,
		BSPropertyID,PropertyRollUpSW
		from cre.Property p
		inner join cre.deal d on d.dealid = p.deal_dealid
		where p.isdeleted <> 1 and d.isdeleted <> 1 AND p.PState IS NOT NULL
	)b where rno = 1
)z
where cre.deal.dealid = z.dealid


go


	Update cre.deal set cre.deal.RealizedUnRealized = a.LoanStatus
	From(
		Select Distinct d.dealid,(CASE WHEN tblActivedeal.dealid IS NOT NULL THEN 'Unrealized' ELSE 'Realized' END) as LoanStatus
		from cre.note n
		Inner Join core.account acc on acc.accountid = n.account_accountid
		Inner join cre.deal d on d.dealid = n.dealid
		Left Join(
			Select Distinct d.dealid,n.actualPayoffdate
			from cre.note n
			Inner Join core.account acc on acc.accountid = n.account_accountid
			Inner join cre.deal d on d.dealid = n.dealid
			Where acc.isdeleted <> 1 and n.actualPayoffdate is null
		)tblActivedeal on tblActivedeal.DealID = d.DealID
		Where acc.isdeleted <> 1
	)a
	Where cre.deal.DealID = a.DealID