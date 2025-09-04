

---Update aggregate transaction type
Update cre.LiabilityFundingScheduleAggregate set cre.LiabilityFundingScheduleAggregate.TransactionTypes = z.TransactionTypes_New
From(


	Select agg.LiabilityFundingScheduleAggregateID,agg.AccountID,agg.LibName,agg.TransactionDate,agg.TransactionTypes,det.TransactionTypes as TransactionTypes_New,detCnt.AccountIDCnt
	From(
		Select Distinct acc.name as LibName,LiabilityFundingScheduleAggregateID,lfa.AccountID,lfa.TransactionDate,lfa.TransactionTypes
		from cre.LiabilityFundingScheduleAggregate lfa
		Inner join core.Account acc on acc.accountid = lfa.AccountID
		where Applied =1
		--and lfa.Accountid = '05A96B38-8B22-47B2-AA06-6C84F63C9C67'
	)agg
	Left JOin(
		Select Distinct acc.name as LibName,lf.AccountID,lf.TransactionDate,lf.TransactionTypes
		from cre.LiabilityFundingSchedule lf
		Inner join core.Account acc on acc.accountid = lf.AccountID
		where Applied =1
		--and lf.Accountid = '05A96B38-8B22-47B2-AA06-6C84F63C9C67'
	)det on agg.AccountID = det.AccountID and agg.TransactionDate = det.TransactionDate

	Left JOin(
		Select Distinct acc.name as LibName,lf.AccountID as AccountIDCnt,lf.TransactionDate,lf.TransactionTypes
		from cre.LiabilityFundingSchedule lf
		Inner join core.Account acc on acc.accountid = lf.AccountID
		where Applied =1
		--and lf.Accountid = '05A96B38-8B22-47B2-AA06-6C84F63C9C67'
	
	)detCnt on agg.AccountID = detCnt.AccountIDCnt and agg.TransactionDate = detCnt.TransactionDate and agg.TransactionTypes = detCnt.TransactionTypes


	where agg.TransactionTypes <> det.TransactionTypes
	and agg.LibName not like '% cash%'
	and detCnt.AccountIDCnt is null
	--and agg.TransactionDate = '6/17/2022'
	--order by agg.LibName,agg.TransactionDate

)z
where cre.LiabilityFundingScheduleAggregate.LiabilityFundingScheduleAggregateID = z.LiabilityFundingScheduleAggregateID




