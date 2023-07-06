

CREATE PROCEDURE [IO].[usp_GetINUnderwritingPIKScheduleByNoteID] 
(
	@NoteID uniqueidentifier,
	@UserID UNIQUEIDENTIFIER
)
	
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT  
note.IN_UnderwritingNoteID
,acc.IN_UnderwritingAccountID

,pik.[IN_UnderwritingPIKScheduleID]
,pik.[IN_UnderwritingEventID]
,pik.[AdditionalIntRate]
,pik.[StartDate]
,pik.[EndDate]
,pik.[CreatedBy]
,pik.[CreatedDate]
,pik.[UpdatedBy]
,pik.[UpdatedDate]

	
FROM [IO].[IN_UnderwritingPIKSchedule] pik
INNER JOIN [IO].[IN_UnderwritingEvent] eve ON eve.IN_UnderwritingEventID = pik.IN_UnderwritingEventID
INNER JOIN [IO].[IN_UnderwritingAccount] acc ON acc.IN_UnderwritingAccountID = eve.IN_UnderwritingAccountID
INNER JOIN [IO].[IN_UnderwritingNote] note ON note.IN_UnderwritingAccountID = acc.IN_UnderwritingAccountID
WHERE note.IN_UnderwritingNoteID = @NoteID
	
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED

END
