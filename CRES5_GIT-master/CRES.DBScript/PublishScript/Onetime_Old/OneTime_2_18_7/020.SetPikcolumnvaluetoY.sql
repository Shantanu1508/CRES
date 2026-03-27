
Update cre.note set PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate = 3 where noteid in (
	Select noteid 
	from cre.note n
	inner join core.Account acc on acc.accountid = n.account_accountid
	where acc.isdeleted <> 1
	and PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate is null
	and noteid in (

		Select Distinct n.noteid 
		from [CORE].PikSchedule pik  
		left JOIN [CORE].[Account] accsource ON accsource.AccountID = pik.SourceAccountID  
		left JOIN [CORE].[Account] accDest ON accDest.AccountID = pik.TargetAccountID  
		INNER JOIN [CORE].[Event] e on e.EventID = pik.EventId  
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		Where acc.isdeleted <> 1
	)  
)