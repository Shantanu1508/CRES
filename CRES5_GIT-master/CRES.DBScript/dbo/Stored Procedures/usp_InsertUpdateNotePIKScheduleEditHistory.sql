CREATE PROCEDURE [dbo].[usp_InsertUpdateNotePIKScheduleEditHistory] 
(
	@tbltype_NoteEditPIKSchedule [dbo].[TableTypeNoteEditPIKSchedule] READONLY,
	@UserID	nvarchar(256)
)
AS
BEGIN


Declare @AccountID uniqueidentifier = (SELECT Distinct top 1 AccountID FROM @tbltype_NoteEditPIKSchedule where AccountID is not null)

DELETE FROM [CORE].PIKSchedule
WHERE PIKScheduleID IN (SELECT t.ScheduleID FROM @tbltype_NoteEditPIKSchedule t WHERE ISNULL(t.IsDeleted,0) = 1)

UPDATE [CORE].PIKSchedule
SET
PIKSchedule.SourceAccountID = z.SourceAccountID,
PIKSchedule.TargetAccountID = z.TargetAccountID,
PIKSchedule.AdditionalIntRate = z.AdditionalIntRate,
PIKSchedule.AdditionalSpread = z.AdditionalSpread,
PIKSchedule.IndexFloor = z.IndexFloor,
PIKSchedule.IntCompoundingRate = z.IntCompoundingRate,
PIKSchedule.IntCompoundingSpread = z.IntCompoundingSpread,
PIKSchedule.StartDate = z.StartDate,
PIKSchedule.EndDate = z.EndDate,
PIKSchedule.IntCapAmt = z.IntCapAmt,
PIKSchedule.PurBal = z.PurBal,
PIKSchedule.AccCapBal = z.AccCapBal,
PIKSchedule.UpdatedBy = @UserID, 
PIKSchedule.UpdatedDate = GETDATE(),
PIKSchedule.PIKReasonCodeID = z.PIKReasonCodeID,
PIKSchedule.PIKComments = z.PIKComments,
PIKSchedule.PIKIntCalcMethodID = z.PIKIntCalcMethodID,
PIKSchedule.PeriodicRateCapAmount = z.PeriodicRateCapAmount,
PIKSchedule.PeriodicRateCapPercent = z.PeriodicRateCapPercent,
PIKSchedule.PIKSetup = z.PIKSetup,
PIKSchedule.PIKPercentage = z.PIKPercentage,
PIKSchedule.PIKCurrentPayRate = z.PIKCurrentPayRate,
PIKSchedule.PIKSeparateCompounding = z.PIKSeparateCompounding

FROM(

	Select  pk.PIKScheduleID
	,t.SourceAccountID
    ,t.TargetAccountID 
    ,t.AdditionalIntRate
    ,t.AdditionalSpread
    ,t.IndexFloor   
    ,t.IntCompoundingRate
    ,t.IntCompoundingSpread
    ,t.StartDate
    ,t.EndDate
    ,t.IntCapAmt 
    ,t.PurBal
	,t.AccCapBal
	,t.PIKReasonCodeID
	,t.PIKComments
	,t.PIKIntCalcMethodID
	,t.PeriodicRateCapAmount
	,t.PeriodicRateCapPercent
	,t.PIKSetUp
	,t.PIKPercentage
	,t.PIKCurrentPayRate
	,t.PIKSeparateCompounding
	from [CORE].PIKSchedule pk  
	INNER JOIN [CORE].[Event] e on e.EventID = pk.EventId 
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	Inner JOin(
		SELECT  ScheduleID, AccountID, EffectiveDate, SourceAccountID,TargetAccountID,AdditionalIntRate,AdditionalSpread,IndexFloor,IntCompoundingRate,IntCompoundingSpread,StartDate,EndDate,IntCapAmt,PurBal,AccCapBal,PIKReasonCodeID,PIKComments,PIKIntCalcMethodID,PeriodicRateCapAmount ,PeriodicRateCapPercent, PIKSetUp, PIKPercentage, PIKCurrentPayRate, PIKSeparateCompounding
		FROM 	@tbltype_NoteEditPIKSchedule
		where ISNULL(IsDeleted,0) <> 1 and ScheduleID <> '00000000-0000-0000-0000-000000000000'
	)t on t.AccountID = n.Account_AccountID and t.ScheduleID = pk.PIKScheduleID
	where ISNULL(e.StatusID, 1) = 1
	and n.Account_AccountID = @AccountID  and acc.IsDeleted = 0

)z
WHERE [CORE].PIKSchedule.PIKScheduleID = z.PIKScheduleID


    Insert INTO [CORE].PIKSchedule (EventID,SourceAccountID,TargetAccountID,AdditionalIntRate,AdditionalSpread,IndexFloor,IntCompoundingRate,IntCompoundingSpread,StartDate,EndDate,IntCapAmt,PurBal,AccCapBal,PIKReasonCodeID,PIKComments,PIKIntCalcMethodID,PeriodicRateCapAmount ,PeriodicRateCapPercent, PIKSetUp, PIKPercentage, PIKCurrentPayRate, PIKSeparateCompounding, CreatedBy, CreatedDate,UpdatedBy,UpdatedDate)
	SELECT e.EventID, SourceAccountID,TargetAccountID,AdditionalIntRate,AdditionalSpread,IndexFloor,IntCompoundingRate,IntCompoundingSpread,StartDate,EndDate,IntCapAmt,PurBal,AccCapBal,PIKReasonCodeID,PIKComments,PIKIntCalcMethodID,PeriodicRateCapAmount ,PeriodicRateCapPercent, PIKSetUp, PIKPercentage, PIKCurrentPayRate, PIKSeparateCompounding,  @UserID, GETDATE(), @UserID, GETDATE()
	FROM @tbltype_NoteEditPIKSchedule t 
	Inner Join(	
	Select AccountID,EffectiveStartDate,EventID 
	from core.Event where ISNULL(StatusID, 1) = 1 and EventTypeID = 12
	)e on e.AccountID = t.AccountID and e.EffectiveStartDate = t.EffectiveDate
	where ISNULL(t.IsDeleted,0)<>1 and t.ScheduleID = '00000000-0000-0000-0000-000000000000'


	--Delete effective dates thats do not have Fee
	Delete from core.Event where EventTypeID = 12 and AccountID= @AccountID
	and EventID in (
		Select eventid from(
			SELECT e.EventID, e.EffectiveStartDate, COUNT(t.PIKScheduleID) cnt
			FROM core.Event e
			LEFT JOIN [CORE].PIKSchedule t ON e.EventID = t.EventID
			WHERE e.EventTypeID = 12 and e.AccountID=@AccountID
			group by e.EventID, e.EffectiveStartDate
		) a
		where cnt = 0
	)


END