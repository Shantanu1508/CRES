-- Procedure
-- Procedure
CREATE PROCEDURE [dbo].[usp_InsertUpdateNoteRateSpreadSchedule] 
(
	@tbltype_NoteRateSpreadSchedule [dbo].[TableTypeNoteRateSpread] READONLY,
	@UserID	nvarchar(256)
)
AS
BEGIN


Declare @AccountID uniqueidentifier = (SELECT Distinct top 1 AccountID FROM @tbltype_NoteRateSpreadSchedule where AccountID is not null)

DELETE FROM [Core].[RateSpreadSchedule]
WHERE RateSpreadScheduleID IN (SELECT t.ScheduleID FROM @tbltype_NoteRateSpreadSchedule t WHERE ISNULL(t.IsDeleted,0) = 1)

UPDATE [Core].[RateSpreadSchedule] 
SET
RateSpreadSchedule.Date = z.Date, 
RateSpreadSchedule.ValueTypeID= z.ValueTypeID, 
RateSpreadSchedule.Value= z.Value, 
RateSpreadSchedule.IntCalcMethodID= z.IntCalcMethodID, 
RateSpreadSchedule.UpdatedBy = @UserID, 
RateSpreadSchedule.UpdatedDate = GETDATE(),
RateSpreadSchedule.RateOrSpreadToBeStripped = z.RateOrSpreadToBeStripped,
RateSpreadSchedule.IndexNameID = z.IndexNameID,
RateSpreadSchedule.DeterminationDateHolidayList = z.DeterminationDateHolidayList
FROM(

	Select RateSpreadScheduleID
	,t.Date
	,t.ValueTypeID
	,t.Value
	,t.IntCalcMethodID
	,t.RateOrSpreadToBeStripped
	,t.IndexNameID
	,t.DeterminationDateHolidayList
	from [CORE].RateSpreadSchedule rs  
	INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId 
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	Inner JOin(
		SELECT  ScheduleID, AccountID, EffectiveDate, Date, ValueTypeID, Value, IntCalcMethodID, RateOrSpreadToBeStripped, IndexNameID, DeterminationDateHolidayList
		FROM 	@tbltype_NoteRateSpreadSchedule
		where ISNULL(IsDeleted,0) <> 1 and ScheduleID <> '00000000-0000-0000-0000-000000000000'
	)t on t.AccountID = n.Account_AccountID and t.ScheduleID = rs.RateSpreadScheduleID
	where e.StatusID = 1
	and n.Account_AccountID = @AccountID  and acc.IsDeleted = 0

)z
WHERE [CORE].[RateSpreadSchedule].RateSpreadScheduleID = z.RateSpreadScheduleID


    INSERT INTO [CORE].[RateSpreadSchedule] (EventID, Date, ValueTypeID, Value, IntCalcMethodID,RateOrSpreadToBeStripped,IndexNameID,DeterminationDateHolidayList, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
	SELECT e.EventID, Date, ValueTypeID, Value, IntCalcMethodID,RateOrSpreadToBeStripped,IndexNameID,DeterminationDateHolidayList, @UserID, GETDATE(), @UserID, GETDATE()
	FROM @tbltype_NoteRateSpreadSchedule t 
	Inner Join(	
	Select AccountID,EffectiveStartDate,EventID 
	from core.Event where StatusID = 1 and EventTypeID = 14
	)e on e.AccountID = t.AccountID and e.EffectiveStartDate = t.EffectiveDate
	where ISNULL(t.IsDeleted,0)<>1 and t.ScheduleID = '00000000-0000-0000-0000-000000000000'

	--Delete effective dates thats do not have RSS
	Delete from core.Event where EventTypeID = 14 and AccountID= @AccountID
	and EventID in (
		Select eventid from(
			SELECT e.EventID, e.EffectiveStartDate, COUNT(t.RateSpreadScheduleID) cnt
			FROM core.Event e
			LEFT JOIN [Core].[RateSpreadSchedule] t ON e.EventID = t.EventID
			WHERE e.EventTypeID = 14 and e.AccountID=@AccountID
			group by e.EventID, e.EffectiveStartDate
		) a
		where cnt = 0
	)

END