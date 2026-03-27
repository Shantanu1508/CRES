


CREATE PROCEDURE [dbo].[usp_GetMaturityHistoricalDataByDealID] 
(
	@DealID UNIQUEIDENTIFIER,
	@MultipleNoteids nvarchar(max),
	@UserID UNIQUEIDENTIFIER
	
)
	
AS
BEGIN

	SET NOCOUNT ON;

	CREATE TABLE #tblListNotes(
	  CRENoteID VARCHAR(256)
	)

	INSERT INTO #tblListNotes(CRENoteID)
	select Value from fn_Split(@MultipleNoteids);
	--==============================================


	Select n.crenoteid as [Note Id],ISNULL(Convert (nvarchar(MAX), e.EffectiveStartDate, 101),'')  as [Effective Date],
	lMaturityType.name as [Maturity Type],
	ISNULL(Convert (nvarchar(MAX), mat.MaturityDate, 101),'') as [Maturity Date],
	lApproved.name as Approved,
	lExtensionType.name as ExtensionType
	from [CORE].Maturity mat  
	INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
	Left JOin Core.lookup lMaturityType on lMaturityType.lookupid = mat.MaturityType
	Left JOin Core.lookup lApproved on lApproved.lookupid = mat.Approved
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 
	Left JOin Core.lookup lExtensionType on lExtensionType.lookupid = mat.ExtensionType
	where e.StatusID = 1 
	and n.dealid = @DealID
	--and n.MaturityMethodID = @MaturityMethodID 
	and n.crenoteid in (Select crenoteid from #tblListNotes)
	
	--ORDER BY EffectiveStartDate,lMaturityType.SortOrder,mat.MaturityDate
	Order by ISNULL(n.lienposition,99999), n.Priority,n.InitialFundingAmount desc, acc.Name,
	EffectiveStartDate,lMaturityType.SortOrder,mat.MaturityDate

END
