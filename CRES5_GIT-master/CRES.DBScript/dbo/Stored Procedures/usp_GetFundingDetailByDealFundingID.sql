

CREATE procedure [dbo].[usp_GetFundingDetailByDealFundingID] --'465CBC77-0D0E-4B37-9C5A-2BF8A90F9D26', '00000000-0000-0000-0000-000000000000'
@UserID UNIQUEIDENTIFIER,
@DealFundingID nvarchar(500)
AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT Distinct
	n.NoteID,
	n.CRENoteID,
	acc.[Name],
	fs.DealFundingRowno,
	fs.[Value],
	fs.[Date],
	d.DealID,
	d.CreDealID,
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
	left join cre.WFTaskDetail td  on  td.TaskID = df.DealFundingID
	left join cre.WFStatusPurposeMapping mapp on mapp.WFStatusPurposeMappingID = td.WFStatusPurposeMappingID  
	left join cre.WFStatusMaster sm on sm.WFStatusMasterID = mapp.WFStatusMasterID  

	WHERE sEvent.StatusID = e.StatusID AND acc.IsDeleted = 0 AND 
	df.DealFundingID = 
	(CASE WHEN @DealFundingID = '00000000-0000-0000-0000-000000000000' THEN df.DealFundingID ELSE @DealFundingID END)
	 and  df.Applied <> 1
	 and sm.StatusName <> 'Completed'
	 and (df.Date > (getdate() - 1) and df.Date < (getdate() + 60))
	 and td.IsDeleted=0
	 and ISNULL(d.LinkedDealID,'')=''
	
	 Order by fs.[Date]

	
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
