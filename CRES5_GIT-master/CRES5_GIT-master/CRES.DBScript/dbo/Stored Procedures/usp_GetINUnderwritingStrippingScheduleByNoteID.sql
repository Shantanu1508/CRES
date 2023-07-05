



CREATE PROCEDURE [dbo].[usp_GetINUnderwritingStrippingScheduleByNoteID] 
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

,ss.[IN_UnderwritingStrippingScheduleID]
,ss.[IN_UnderwritingEventID]
,ss.[StartDate]
,ss.[ValueTypeID]
,LValueTypeID.Name as ValueTypeIDText
,ss.[Value]
,ss.[CreatedBy]
,ss.[CreatedDate]
,ss.[UpdatedBy]
,ss.[UpdatedDate]

	
FROM [IO].[IN_UnderwritingStrippingSchedule] ss
INNER JOIN [IO].[IN_UnderwritingEvent] eve ON eve.IN_UnderwritingEventID = ss.IN_UnderwritingEventID
INNER JOIN [IO].[IN_UnderwritingAccount] acc ON acc.IN_UnderwritingAccountID = eve.IN_UnderwritingAccountID
INNER JOIN [IO].[IN_UnderwritingNote] note ON note.IN_UnderwritingAccountID = acc.IN_UnderwritingAccountID

INNER JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = ss.ValueTypeID

WHERE note.IN_UnderwritingNoteID = @NoteID
	
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
