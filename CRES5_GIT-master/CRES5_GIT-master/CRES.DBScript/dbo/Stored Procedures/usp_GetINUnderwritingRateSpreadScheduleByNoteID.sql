



CREATE PROCEDURE [dbo].[usp_GetINUnderwritingRateSpreadScheduleByNoteID] 
(
	@NoteID uniqueidentifier,
	@UserID UNIQUEIDENTIFIER
)
	
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--SELECT  
--note.IN_UnderwritingNoteID
--,acc.IN_UnderwritingAccountID
--,rs.[IN_UnderwritingRateSpreadScheduleID]
--,rs.[IN_UnderwritingEventID]
--,rs.[Date]
--,rs.[ValueTypeID]
--,LValueTypeID.Name as ValueTypeIDText
--,rs.[Value]
--,rs.[IntCalcMethodID]
--,LIntCalcMethodID.Name as IntCalcMethodIDText
--,rs.[CreatedBy]
--,rs.[CreatedDate]
--,rs.[UpdatedBy]
--,rs.[UpdatedDate]
	
--FROM [IO].[IN_UnderwritingRateSpreadSchedule] rs
--INNER JOIN [IO].[IN_UnderwritingEvent] eve ON eve.IN_UnderwritingEventID = rs.IN_UnderwritingEventID
--INNER JOIN [IO].[IN_UnderwritingAccount] acc ON acc.IN_UnderwritingAccountID = eve.IN_UnderwritingAccountID
--INNER JOIN [IO].[IN_UnderwritingNote] note ON note.IN_UnderwritingAccountID = acc.IN_UnderwritingAccountID

--INNER JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID
--INNER JOIN [CORE].[Lookup] LIntCalcMethodID ON LIntCalcMethodID.LookupID = rs.IntCalcMethodID

--WHERE note.IN_UnderwritingNoteID = @NoteID



Select 
note.IN_UnderwritingNoteID
,acc.IN_UnderwritingAccountID
,rs.[IN_UnderwritingRateSpreadScheduleID]
,rs.[IN_UnderwritingEventID]
,rs.[Date]
,rs.[ValueTypeID]
,LValueTypeID.Name as ValueTypeIDText
,rs.[Value]
,rs.[IntCalcMethodID]
,LIntCalcMethodID.Name as IntCalcMethodIDText
,rs.[CreatedBy]
,rs.[CreatedDate]
,rs.[UpdatedBy]
,rs.[UpdatedDate]
			from [IO].IN_UnderwritingRateSpreadSchedule rs
			INNER JOIN [IO].[IN_UnderwritingEvent] eve ON eve.IN_UnderwritingEventID = rs.IN_UnderwritingEventID
			INNER JOIN [IO].[IN_UnderwritingAccount] acc ON acc.IN_UnderwritingAccountID = eve.IN_UnderwritingAccountID
			INNER JOIN [IO].[IN_UnderwritingNote] note ON note.IN_UnderwritingAccountID = acc.IN_UnderwritingAccountID

			INNER JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = rs.ValueTypeID
			INNER JOIN [CORE].[Lookup] LIntCalcMethodID ON LIntCalcMethodID.LookupID = rs.IntCalcMethodID
			where eve.IN_UnderwritingEventID in 
			(

				Select e.IN_UnderwritingEventID from [IO].[IN_UnderwritingEvent] e
				INNER JOIN 
						(
							Select eve.IN_UnderwritingAccountID,MAX(EffectiveStartDate) EffectiveStartDate from [IO].[IN_UnderwritingEvent] eve
							INNER JOIN [IO].[IN_UnderwritingNote] n ON n.IN_UnderwritingAccountID = eve.IN_UnderwritingAccountID
							INNER JOIN [IO].[IN_UnderwritingAccount] acc ON acc.IN_UnderwritingAccountID = n.IN_UnderwritingAccountID
							where EventTypeID = (Select LookupID from CORE.Lookup where Name = 'RateSpreadSchedule')
							and n.IN_UnderwritingNoteID = @NoteID
							GROUP BY eve.IN_UnderwritingAccountID
						) sEvent

				ON sEvent.IN_UnderwritingAccountID = e.IN_UnderwritingAccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate and EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'RateSpreadSchedule')
			)
	
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
