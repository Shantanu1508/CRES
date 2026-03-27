CREATE PROCEDURE [dbo].[usp_GetLiabilityNoteAssetMapping] 
    @DealAccountID uniqueidentifier
AS
BEGIN
    SELECT
	    n.LiabilityNoteID,
        la.DealAccountId,
        la.LiabilityNoteAccountId,
		la.AssetAccountId 
    FROM
        [CRE].[LiabilityNoteAssetMapping] AS la
		INNER JOIN
        [CRE].[LiabilityNote] AS n ON n.AccountID = la.LiabilityNoteAccountId
    
    WHERE
		la.DealAccountId = @DealAccountID
END;