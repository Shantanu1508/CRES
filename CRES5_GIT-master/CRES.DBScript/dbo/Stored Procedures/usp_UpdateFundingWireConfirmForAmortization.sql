

CREATE PROCEDURE [dbo].[usp_UpdateFundingWireConfirmForAmortization] --'6504AE99-9AB5-49E5-B4C8-2B9A90994267', '80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B',1,1,null
(
    @dealid UNIQUEIDENTIFIER,
	@dealfundingid UNIQUEIDENTIFIER,
	@UserID nvarchar(256)
)
	
AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Update [CORE].FundingSchedule set Applied = 1,updatedby = @UserID,updateddate =getdate() Where Purposeid = 351 and dealfundingid = @dealfundingid and FundingScheduleID in (
Select fs.FundingScheduleID
from [CORE].FundingSchedule fs
INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
INNER JOIN 
(						
	Select 
	(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
	MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
	from [CORE].[Event] eve
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
	where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'FundingSchedule')
	and n.DealID = @dealid  
	and acc.IsDeleted = 0
	and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
	GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID
) sEvent

ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID

left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID
left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID 
INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID

where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0
and n.dealid = @dealid
and fs.Purposeid = 351
and fs.dealfundingid = @dealfundingid
)



SET TRANSACTION ISOLATION LEVEL READ COMMITTED


END