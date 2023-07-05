

CREATE procedure [dbo].[usp_GetFundingDetailByDealID] --'E36B0A6F-394D-4BF7-9215-B5B03F33599A','E36B0A6F-394D-4BF7-9215-B5B03F33599A'
@UserID UNIQUEIDENTIFIER,
@DealID nvarchar(255)
AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT 
	n.NoteID,
	n.CRENoteID,
	acc.[Name],
	fs.DealFundingRowno,
	fs.[Value],
	fs.[Date],
	d.DealID,
	df.DealFundingID
	FROM [CORE].FundingSchedule fs
	INNER JOIN [CORE].[Event] e ON e.EventID = fs.EventId
	INNER JOIN 
	(
	SELECT 
	(SELECT AccountID FROM [CORE].[Account] ac WHERE ac.AccountID = ns.Account_AccountID) AccountID ,
	MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
	FROM [CORE].[Event] eve
	INNER JOIN [CRE].[Note] ns ON ns.Account_AccountID = eve.AccountID
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = ns.Account_AccountID
	WHERE EventTypeID = (SELECT LookupID FROM CORE.[Lookup] WHERE [Name] = 'FundingSchedule')
	--and ns.NoteID = @NoteId 
	AND acc.IsDeleted = 0
	AND eve.StatusID = (SELECT LookupID FROM Core.Lookup WHERE [Name] = 'Active' AND ParentID = 1)
	GROUP BY ns.Account_AccountID,EventTypeID,eve.StatusID
	) sEvent

	ON sEvent.AccountID = e.AccountID AND e.EffectiveStartDate = sEvent.EffectiveStartDate AND e.EventTypeID = sEvent.EventTypeID

	LEFT JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID 
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	INNER JOIN [CRE].Deal d ON n.DealID = d.DealID
	INNER JOIN [CRE].DealFunding df ON df.DealID = d.DealID AND df.DealFundingRowno = fs.DealFundingRowno
	WHERE sEvent.StatusID = e.StatusID AND acc.IsDeleted = 0 AND d.DealID=@DealID
	and df.DealFundingID in (select distinct(taskid) from cre.WFTaskDetail)
	Order by n.CRENoteID, fs.[Date]

	
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
