CREATE PROCEDURE [dbo].[usp_GetXIRRViewNotesByObjectID]
(
	@XIRRConfigID int,
	@ObjectID nvarchar(256)
	
)
AS
BEGIN


Select Distinct d.CREDealID as DealID, d.DealName, n.CRENoteID,acc.name as NoteName ,l.FinancingSourceName
from [CRE].[XIRRCalculationInput] xi
Inner Join cre.note n on n.account_accountid = xi.NoteAccountID
Inner Join core.Account acc on acc.accountid =n.account_accountid
Inner join [CRE].[Deal] d ON d.DealID = n.DealID
left join [CRE].[FinancingSourceMaster] l on l.FinancingSourceMasterID = n.FinancingSourceID
where XIRRConfigID = @XIRRConfigID and xi.DealAccountID = @ObjectID
and acc.isDeleted <> 1
order by n.CRENoteID


END