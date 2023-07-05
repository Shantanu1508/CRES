


CREATE PROCEDURE [dbo].[usp_GetStrippingSchedulePeriodicDataByNoteId] --'62D692B2-3073-4A21-A723-B1ED48011E05', '80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B',1,1,null
(
    @NoteId UNIQUEIDENTIFIER,
	@UserID UNIQUEIDENTIFIER,
	
	@PgeIndex INT,
    @PageSize INT,
	@TotalCount INT OUTPUT 
)
	
AS
BEGIN
    SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
   


Select 
@totalCount =  COUNT(n.NoteID)  from [CORE].[StrippingSchedule] ss
INNER JOIN [CORE].[Event] eve ON eve.EventID = ss.EventId
INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = ss.ValueTypeID
where n.NoteID = @NoteId and acc.IsDeleted = 0
and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)

--------------------     	

Select 
n.NoteID
,acc.AccountID
,eve.[Date]
,eve.EffectiveStartDate
,eve.EffectiveEndDate
,eve.EventTypeID
,LEventTypeID.Name as EventTypeText

,ss.StrippingScheduleID
,ss.[EventID]
,ss.[StartDate]

,ss.Value
,ss.ValueTypeID
,LValueTypeID.Name as ValueTypeText

,ss.IncludedLevelYield
,ss.IncludedBasis

,ss.[CreatedBy]
,ss.[CreatedDate]
,ss.[UpdatedBy]
,ss.[UpdatedDate]
from [CORE].[StrippingSchedule] ss
INNER JOIN [CORE].[Event] eve ON eve.EventID = ss.EventId
INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = ss.ValueTypeID
where n.NoteID = @NoteId  and acc.IsDeleted = 0
and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)

ORDER BY  eve.EffectiveStartDate,ss.[StartDate]
	--OFFSET @PgeIndex - 1 ROWS
	--FETCH NEXT @PageSize ROWS ONLY
 
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END

