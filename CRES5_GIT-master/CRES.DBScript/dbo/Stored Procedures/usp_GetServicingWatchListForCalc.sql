--[dbo].[usp_GetServicingLogByNoteID] '1e5f84e6-3ee8-4907-b9d6-7fbd0f81a7ab'  ,'C10F3372-0FC2-4861-A9F5-148F1F80804F'


CREATE PROCEDURE [dbo].[usp_GetServicingWatchListForCalc] --'69f7abd1-c9c4-414d-8846-bc7247c9522b'
	@NoteID nvarchar(256)
	
AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	select n.noteid,n.crenoteid,pm.date,pd.value as amount
	from [CRE].[WLDealPotentialImpairmentMaster] pm
	left Join [CRE].[WLDealPotentialImpairmentDetail] pd on pm.WLDealPotentialImpairmentMasterID = pd.WLDealPotentialImpairmentMasterID
	Inner JOin cre.note n on n.noteid = pd.noteid
	Inner JOin core.account acc on acc.accountid = n.Account_accountid
	Where acc.Isdeleted <> 1
	and ISNULL(pm.Applied,0) <> 1
	and pd.NoteID= @NoteID
	ORDER by n.CRENoteID,pm.RowNo


	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
GO

