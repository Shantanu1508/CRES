CREATE PROCEDURE [dbo].[usp_GetDebtByDebtName]  
	@DebtName nvarchar(256) 
AS
BEGIN


Select DebtID,DebtGUID,dt.AccountID as DebtAccountID,acc.name as DebtName,PortfolioAccountID as CashAccountID
from cre.debt dt
Inner join core.account acc on acc.accountid = dt.AccountID
where acc.Name = @DebtName



END