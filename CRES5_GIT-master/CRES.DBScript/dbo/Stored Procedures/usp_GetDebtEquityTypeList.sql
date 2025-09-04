CREATE PROCEDURE [dbo].[usp_GetDebtEquityTypeList]
AS    
BEGIN

select distinct AccountCategoryID, ac.Name 
from core.AccountCategory ac
Left Join core.Account acc on ac.AccountCategoryID =  acc.AccountTypeID
Inner Join cre.Debt d on acc.AccountID = d.AccountID

UNION

select distinct AccountCategoryID, ac.Name 
from core.AccountCategory ac
Left Join core.Account acc on ac.AccountCategoryID =  acc.AccountTypeID
Inner Join cre.Equity e on acc.AccountID = e.AccountID

UNION

select distinct AccountCategoryID, ac.Name 
from core.AccountCategory ac
Left Join core.Account acc on ac.AccountCategoryID =  acc.AccountTypeID
Inner Join cre.Cash c on acc.AccountID = c.AccountID
    
END
GO