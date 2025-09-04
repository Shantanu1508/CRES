CREATE PROCEDURE [dbo].[usp_GetLinkedShortTermBorrowingFacility]   
  @SearchKey VARCHAR(500)
AS  
BEGIN

SELECT acc.AccountID as AccountID, acc.name as [Text], 'Debt' as [Type]
FROM cre.Debt d
INNER JOIN core.Account acc ON acc.AccountID = d.AccountID
WHERE IsDeleted <> 1
  AND acc.name LIKE '%' + @SearchKey + '%'
  AND acc.AccountTypeID = 3

END