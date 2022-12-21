CREATE PROCEDURE [dbo].[usp_GetRateSpreadSchedulePeriodicDataByNoteId]  --'ddbec9e8-a065-4fb7-905b-95f0c61eb16b', '80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B',1,1,null
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
   
SELECT @totalCount =  
COUNT(NoteID)
from [CORE].RateSpreadSchedule rs
INNER JOIN [CORE].[Event] eve ON eve.EventID = rs.EventId
INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID
LEFT JOIN [CORE].[Lookup] LIntCalcMethodID ON LIntCalcMethodID.LookupID = rs.IntCalcMethodID
LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
where n.NoteID = @NoteId  and acc.IsDeleted = 0
and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)
   	

--------------------------
Select 
n.NoteID
,acc.AccountID
,eve.[Date] as [Event_Date]
,eve.EffectiveStartDate
,eve.EffectiveEndDate
,eve.EventTypeID
,LEventTypeID.Name as EventTypeText

,rs.[RateSpreadScheduleID]
,rs.[EventID]
,rs.[Date]
,rs.[ValueTypeID]
,LValueTypeID.Name as ValueTypeText

,isnull(rs.[Value],0) as Value
,isnull(rs.[IntCalcMethodID],0) as IntCalcMethodID
--,rs.[Value]
--,rs.[IntCalcMethodID]
,LIntCalcMethodID.Name as IntCalcMethodText
,rs.[CreatedBy]
,rs.[CreatedDate]
,rs.[UpdatedBy]
,rs.[UpdatedDate]
,rs.[RateOrSpreadToBeStripped]
,rs.IndexNameID  
,lindex.name as IndexNameText  

from [CORE].RateSpreadSchedule rs
INNER JOIN [CORE].[Event] eve ON eve.EventID = rs.EventId
INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID
LEFT JOIN [CORE].[Lookup] LIntCalcMethodID ON LIntCalcMethodID.LookupID = rs.IntCalcMethodID
LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
LEFT JOIN [CORE].[Lookup] lindex ON lindex.LookupID = rs.IndexNameID  

where n.NoteID = @NoteId and acc.IsDeleted = 0
and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)
ORDER BY eve.EffectiveStartDate,rs.[Date]
	--OFFSET @PgeIndex - 1 ROWS
	--FETCH NEXT @PageSize ROWS ONLY


	SET TRANSACTION ISOLATION LEVEL READ COMMITTED

END

