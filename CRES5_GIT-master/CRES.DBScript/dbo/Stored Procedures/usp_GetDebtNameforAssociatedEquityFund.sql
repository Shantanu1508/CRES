
CREATE PROCEDURE [dbo].[usp_GetDebtNameforAssociatedEquityFund] 

@AccountID UNIQUEIDENTIFIER,
@LiabilityType nvarchar(256)

AS  
BEGIN  
  
SET NOCOUNT ON;  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

IF(@LiabilityType = 'Debt') --For showing associated Debt on Equity Page
BEGIN
SELECT distinct(ln.LiabilityTypeID) as DebtAccountID, a.Name as DebtName, d.DebtGUID, ac.Name as CategoryName, ac.SortOrder
FROM cre.liabilitynote ln
INNER JOIN cre.liabilitynoteassetmapping la ON ln.AccountID = la.LiabilityNoteAccountId
INNER JOIN (
    SELECT am.AssetAccountId AS assetnotesid
    FROM cre.liabilitynote l
    INNER JOIN cre.liabilitynoteassetmapping am ON l.AccountID = am.LiabilityNoteAccountId
    WHERE l.LiabilityTypeID = @AccountID
) sub ON la.AssetAccountId = sub.assetnotesid
LEFT JOIN core.Account a on ln.LiabilityTypeID = a.AccountID
LEFT JOIN core.AccountCategory ac on a.AccountTypeID = ac.AccountCategoryID
LEFT JOIN cre.Debt d on ln.LiabilityTypeID = d.AccountID
where  ln.LiabilityTypeID in (Select AccountID from cre.Debt) and a.IsDeleted = 0
order by ac.SortOrder
END

IF(@LiabilityType = 'Equity') --For showing associated Equity on Debt Page
BEGIN
SELECT distinct(ln.LiabilityTypeID) as EquityAccountID, a.Name as EquityName, e.EquityGUID, ac.Name as CategoryName, ac.SortOrder
FROM cre.liabilitynote ln
INNER JOIN cre.liabilitynoteassetmapping la ON ln.AccountID = la.LiabilityNoteAccountId
INNER JOIN (
    SELECT am.AssetAccountId AS assetnotesid
    FROM cre.liabilitynote l
    INNER JOIN cre.liabilitynoteassetmapping am ON l.AccountID = am.LiabilityNoteAccountId
    WHERE l.LiabilityTypeID = @AccountID
) sub ON la.AssetAccountId = sub.assetnotesid
LEFT JOIN core.Account a on ln.LiabilityTypeID = a.AccountID
LEFT JOIN core.AccountCategory ac on a.AccountTypeID = ac.AccountCategoryID
LEFT JOIN cre.Equity e on ln.LiabilityTypeID = e.AccountID
where  ln.LiabilityTypeID in (Select AccountID from cre.Equity) and a.IsDeleted = 0
order by ac.SortOrder
END

 SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END  