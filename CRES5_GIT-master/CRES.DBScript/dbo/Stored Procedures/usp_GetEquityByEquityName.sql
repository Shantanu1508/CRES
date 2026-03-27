CREATE PROCEDURE [dbo].[usp_GetEquityByEquityName]
	@EquityName nvarchar(256) 
AS
BEGIN


Select EquityID,EquityGUID,dt.AccountID as EquityAccountID,acc.name as EquityName,LinkedShortTermBorrowingFacility,LName.[Name] as LinkedShortTermBorrowingFacilityText,PortfolioAccountID as CashAccountID
from cre.Equity dt
Inner join core.account acc on acc.accountid = dt.AccountID
Left join core.account LName on dt.LinkedShortTermBorrowingFacility = LName.AccountID
where acc.Name = @EquityName



END