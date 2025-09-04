CREATE PROCEDURE [dbo].[usp_getDealDatabyCREDealID]
	@CREDealID nvarchar(256) 
AS
BEGIN

Select d.AccountID as DealAccountID, d.DealID, n.CRENoteID, n.Account_AccountID as NoteAccountID, Max(n.FullyExtendedMaturityDate) as MaturityDate
from cre.note n
Inner join cre.Deal d on d.DealID = n.DealID
where d.CREDealID = @CREDealID

GROUP BY d.AccountID, d.DealID, n.CRENoteID, n.Account_AccountID

END