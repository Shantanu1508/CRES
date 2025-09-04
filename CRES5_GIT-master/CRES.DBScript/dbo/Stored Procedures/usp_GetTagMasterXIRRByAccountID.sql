CREATE PROCEDURE [dbo].[usp_GetTagMasterXIRRByAccountID]
(
	@AccountID UNIQUEIDENTIFIER
)
AS
BEGIN

select tm.TagMasterXIRRID,tm.TagMasterXIRRGUID,tm.Name from cre.TagMasterXIRR tm join cre.TagAccountMappingXIRR ta on tm.TagMasterXIRRID=ta.TagMasterXIRRID
where ta.AccountID=@AccountID
END