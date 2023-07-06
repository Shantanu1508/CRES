


CREATE PROCEDURE [dbo].[usp_GetFixedAmortScheduleDataByNoteId] --'df9a0887-2878-4af7-a4f0-91f2f9b3a77c', '80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B',1,1,null
(
    @NoteId UNIQUEIDENTIFIER,
	@UserID UNIQUEIDENTIFIER,
	
	@PageIndex INT,
    @PageSize INT,
	@TotalCount INT OUTPUT 
)
	
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
   
     	
Select 
n.NoteID
,acc.AccountID
,ams.[Date]
,ams.Value
,eve.EffectiveStartDate AS EffectiveDate
,eve.EffectiveStartDate
,eve.EffectiveEndDate
,eve.EventTypeID
,LEventTypeID.Name as EventTypeText
,ams.[EventID]
,ams.[CreatedBy]
,ams.[CreatedDate]
,ams.[UpdatedBy]
,ams.[UpdatedDate]
from [CORE].[AmortSchedule] ams
INNER JOIN [CORE].[Event] eve ON eve.EventID = ams.EventId
INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
INNER JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID

where n.NoteID = @NoteId  and acc.IsDeleted = 0 and eve.statusId = 1

ORDER BY ams.UpdatedDate DESC
	--OFFSET @PageIndex - 1 ROWS
	--FETCH NEXT @PageSize ROWS ONLY


SET @TotalCount = (SELECT @@Rowcount);

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED

END

