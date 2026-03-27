Update cre.note set InitialFundingAmount = null where noteid in (
	Select n.noteid from cre.note n
	inner join core.Account acc on acc.AccountID = n.Account_AccountID
	Inner join cre.deal d on d.dealid = n.DealID
	where acc.IsDeleted <> 1
	and n.InitialFundingAmount = 0.01

	and d.dealname not in ('RXR Suburban Office Portfolio')
)