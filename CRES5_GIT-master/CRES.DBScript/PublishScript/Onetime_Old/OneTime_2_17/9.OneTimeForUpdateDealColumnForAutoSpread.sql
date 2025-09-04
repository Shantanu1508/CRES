go
Print('Update deal column for auto spread')
go


Update cre.deal set 
cre.deal.RepaymentAutoSpreadMethodID = a.RepaymentAutoSpreadMethodID,
cre.deal.PossibleRepaymentdayofthemonth = a.PossibleRepaymentdayofthemonth,
cre.deal.Repaymentallocationfrequency = a.Repaymentallocationfrequency,
cre.deal.Blockoutperiod = 2
From(
	Select Distinct d.dealid,  
	701 as RepaymentAutoSpreadMethodID, 
	tblDe.DeterminationDateReferenceDayoftheMonth as PossibleRepaymentdayofthemonth,  
	1 as Repaymentallocationfrequency
	From cre.deal d 
	left join(  
		Select Distinct d.dealid,n.DeterminationDateReferenceDayoftheMonth from cre.note n  
		inner join core.account acc on acc.accountid = n.account_accountid  
		inner join cre.deal d on d.dealid = n.dealid  
		where acc.isdeleted <> 1  
		and n.DeterminationDateReferenceDayoftheMonth is not null
	)tblDe on tblDe.dealid = d.dealid    
	where d.isdeleted <> 1  
)a
Where cre.deal.dealid = a.DealID