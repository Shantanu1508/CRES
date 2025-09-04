
Declare @tbltemp as table(
	AccountidToBeDelete UNIQUEIDENTIFIER
)
 
INSERT INTO @tbltemp(AccountidToBeDelete)
Select acc.accountid --,acc.name,orig.PortfolioAccountID 
from core.account acc
left join(
	Select portfolioaccountid from (
		Select portfolioaccountid from cre.equity
		UNION ALL
		Select portfolioaccountid from cre.debt
	)a
)orig on orig.PortfolioAccountID = acc.AccountID
 
where accountid in (select accountid from cre.cash)
and orig.PortfolioAccountID  is null
 
 
Delete from cre.cash where accountid in (Select AccountidToBeDelete from @tbltemp)
 
Delete from core.account where AccountTypeID = 8 and accountid in (Select AccountidToBeDelete from @tbltemp)