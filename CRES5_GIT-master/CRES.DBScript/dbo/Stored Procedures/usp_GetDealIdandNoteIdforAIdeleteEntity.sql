--  [dbo].[usp_GetDealIdandNoteIdforAIdeleteEntity]'B0E6697B-3534-4C09-BE0A-04473401AB93','Deal','4A314C01-DF7E-410F-96B3-D21E77EC463D'
--  [dbo].[usp_GetDealIdandNoteIdforAIdeleteEntity]'B0E6697B-3534-4C09-BE0A-04473401AB93','Deal','0EDC7743-DEE7-4687-B070-7BEF02970EA9'
--  [dbo].[usp_GetDealIdandNoteIdforAIdeleteEntity]'B0E6697B-3534-4C09-BE0A-04473401AB93','note','41D1E6A6-F43C-4FFC-8BF7-4F43D7A98892'

CREATE PROCEDURE [dbo].[usp_GetDealIdandNoteIdforAIdeleteEntity] --'1479'
(
	@UserId Uniqueidentifier,
	@ModuleName nvarchar(256),
	@ModuleID Uniqueidentifier
)
AS
BEGIN
	IF(@ModuleName = 'Note')
	BEGIN
		SELECT CRENoteID from CRE.Note n
		left join core.account acc on acc.AccountID = n.Account_AccountID
		where NoteID = @ModuleID and acc.IsDeleted = 1
	END

	IF(@ModuleName = 'Deal')
	BEGIN
		SELECT d.CREDealID, d.DealName, n.CRENoteID from CRE.Deal d
		left join cre.note n on n.dealid = d.dealid
		where d.DealID = @ModuleID and d.IsDeleted = 1
		
	END

END







