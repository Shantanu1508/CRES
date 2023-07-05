

CREATE PROCEDURE [IO].[usp_GetINUnderwritingFundingScheduleByNoteID] 
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
,FF.[IN_UnderwritingFundingScheduleID]
,FF.[IN_UnderwritingEventID]
,FF.[Date]
,FF.[Value]
,FF.[CreatedBy]
,FF.[CreatedDate]
,FF.[UpdatedBy]
,FF.[UpdatedDate]
  FROM [IO].[IN_UnderwritingFundingSchedule] FF

 
INNER JOIN [IO].[IN_UnderwritingEvent] eve ON eve.IN_UnderwritingEventID = FF.IN_UnderwritingEventID
INNER JOIN [IO].[IN_UnderwritingAccount] acc ON acc.IN_UnderwritingAccountID = eve.IN_UnderwritingAccountID
INNER JOIN [IO].[IN_UnderwritingNote] note ON note.IN_UnderwritingAccountID = acc.IN_UnderwritingAccountID
WHERE note.IN_UnderwritingNoteID = @NoteID 
	

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
