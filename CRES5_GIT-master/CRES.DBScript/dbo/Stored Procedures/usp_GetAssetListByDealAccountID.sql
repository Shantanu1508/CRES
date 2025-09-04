CREATE PROCEDURE [dbo].[usp_GetAssetListByDealAccountID]
    @DealAccountID uniqueidentifier
AS
BEGIN
    SELECT
        d.DealName as AssetName,
        acc.AccountID as AssetAccountID,
		acc.AccountTypeId,
        d.CREdealID+'_'+acc.Name as AssetIdName
    FROM
        CRE.Deal AS d
    INNER JOIN
        Core.Account AS acc ON acc.AccountID = d.AccountID
    WHERE
        acc.IsDeleted <> 1
		and acc.AccountID = @DealAccountID

    UNION ALL

    SELECT
        n.CRENoteID as AssetName,
        acc.AccountID as AssetAccountID,
		acc.AccountTypeId,
        n.CRENoteID+' - '+acc.Name+' / '+ f.FinancingSourceName as AssetIdName
    FROM
        CRE.Note AS n

    INNER JOIN Core.Account AS acc ON acc.AccountID = n.Account_AccountID
	LEFT JOIN cre.FinancingSourceMaster f on n.FinancingSourceID = f.FinancingSourceMasterID

    WHERE
        acc.IsDeleted <> 1
		and n.DealID = (Select dealid from cre.deal where AccountID= @DealAccountID)
END;
