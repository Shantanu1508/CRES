
--[dbo].[usp_GetLastUpdatedDateAndUpdatedByForSchedule] 'fc977090-a4d7-4360-be52-faefab844745' ,'Note'

CREATE PROCEDURE [dbo].[usp_GetLastUpdatedDateAndUpdatedByForSchedule]
(
    @ObjectID UNIQUEIDENTIFIER,
	@ModuleName nvarchar(256)
)
	
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

IF(@ModuleName = 'Note')
BEGIN
	Select 'FundingSchedule' as ScheduleType, Max(fs.UpdatedDate) as LastUpdatedDate, Cast(format(Max(fs.UpdatedDate),'MM/dd/yyyy hh:mm:ss tt') as nvarchar(256)) as LastUpdatedDate_String,
	(CASE When EXISTS (SELECT 1 WHERE fs.UpdatedBy  LIKE REPLACE('00000000-0000-0000-0000-000000000000', '0', '[0-9a-fA-F]'))
	THEN (select  top 1 u.[Login]  from CRE.DealFunding  sdf left join App.[User]  u  on u.UserID =  fs.UpdatedBy ) 
	ELSE fs.UpdatedBy  END) as LastUpdatedBy
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
					and n.NoteID = @ObjectID  and acc.IsDeleted = 0
					and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and ParentID = 1)
					GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID

			) sEvent

	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID

	left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID
	left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID 
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0
	group by fs.UpdatedBy
END






	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END

