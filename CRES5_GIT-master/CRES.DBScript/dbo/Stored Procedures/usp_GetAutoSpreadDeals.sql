
CREATE PROCEDURE [dbo].[usp_GetAutoSpreadDeals] ---'80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B',1,20,''
    @UserID UNIQUEIDENTIFIER,
    @PgeIndex INT,
    @PageSize INT,
	@TotalCount INT OUTPUT 
AS
BEGIN
      SET NOCOUNT ON;

Select Distinct dealname,credealid ,d.UpdatedDate
from cre.deal d
inner join cre.note n on n.dealid = d.dealid
inner join core.account acc on acc.accountid = n.account_accountid
Where d.isdeleted <> 1 and acc.isdeleted <> 1
and d.status = 323
and EnableAutoSpreadRepayments = 1

ORDER BY d.UpdatedDate DESC
OFFSET (@PgeIndex - 1)*@PageSize ROWS
FETCH NEXT @PageSize ROWS ONLY


END