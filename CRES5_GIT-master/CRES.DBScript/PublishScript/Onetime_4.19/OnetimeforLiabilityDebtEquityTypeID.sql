Update cre.LiabilityNote
Set cre.LiabilityNote.DebtEquityTypeID = a.AccountCategoryID
From(
select  AccountCategoryID, ac.Name as TypeName, acc.Name as LName, acc.AccountID 
from core.AccountCategory ac
Left Join core.Account acc on ac.AccountCategoryID =  acc.AccountTypeID
Inner Join cre.Debt d on acc.AccountID = d.AccountID

UNION

select  AccountCategoryID, ac.Name as TypeName, acc.Name as LName, acc.AccountID
from core.AccountCategory ac
Left Join core.Account acc on ac.AccountCategoryID =  acc.AccountTypeID
Inner Join cre.Equity e on acc.AccountID = e.AccountID

UNION

select  AccountCategoryID, ac.Name as TypeName, acc.Name as LName, acc.AccountID
from core.AccountCategory ac
Left Join core.Account acc on ac.AccountCategoryID =  acc.AccountTypeID
Inner Join cre.Cash c on acc.AccountID = c.AccountID
)a
where cre.LiabilityNote.LiabilityTypeID = a.AccountID