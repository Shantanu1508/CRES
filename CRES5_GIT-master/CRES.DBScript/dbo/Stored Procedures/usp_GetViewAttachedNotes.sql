CREATE PROCEDURE [dbo].[usp_GetViewAttachedNotes]
(
	@TagMasterXIRRID int
)
AS
BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

    SELECT DISTINCT d.CREDealID as DealID, d.DealName, n.CRENoteID as NoteID, a.Name as NoteName, f.FinancingSourceName as FinancingSourceType 
    FROM [CRE].[TagAccountMappingXIRR] ta
	INNER join [CORE].[Account] a ON a.AccountID = ta.AccountID
	INNER join [CRE].[Note] n ON n.Account_AccountID = ta.AccountID
	INNER join [CRE].[Deal] d ON d.DealID = n.DealID
	LEFT Join [CRE].[FinancingSourceMaster] f on f.FinancingSourceMasterID = n.FinancingSourceID
    WHERE TagMasterXIRRID = @TagMasterXIRRID
	and a.isDeleted <> 1
	
	order by d.DealName

    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
END
