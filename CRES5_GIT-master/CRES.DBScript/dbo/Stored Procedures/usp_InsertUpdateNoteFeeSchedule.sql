-- Procedure
-- Procedure
CREATE PROCEDURE [dbo].[usp_InsertUpdateNoteFeeSchedule] 
(
	@tbltype_NoteFeeSchedule [dbo].[TableTypeNoteFeeSchedule] READONLY,
	@UserID	nvarchar(256)
)
AS
BEGIN


Declare @AccountID uniqueidentifier = (SELECT Distinct top 1 AccountID FROM @tbltype_NoteFeeSchedule where AccountID is not null)

DELETE FROM [CORE].[PrepayAndAdditionalFeeSchedule]
WHERE PrepayAndAdditionalFeeScheduleID IN (SELECT t.ScheduleID FROM @tbltype_NoteFeeSchedule t WHERE ISNULL(t.IsDeleted,0) = 1)

UPDATE [CORE].[PrepayAndAdditionalFeeSchedule]
SET
PrepayAndAdditionalFeeSchedule.StartDate =  z.StartDate, 
PrepayAndAdditionalFeeSchedule.ValueTypeID= z.ValueTypeID, 
PrepayAndAdditionalFeeSchedule.Value= z.Value, 
PrepayAndAdditionalFeeSchedule.IncludedLevelYield= ISNULL(z.IncludedLevelYield,0), 
PrepayAndAdditionalFeeSchedule.IncludedBasis= ISNULL(z.IncludedBasis,0), 
PrepayAndAdditionalFeeSchedule.UpdatedBy = @UserID, 
PrepayAndAdditionalFeeSchedule.UpdatedDate = GETDATE(),
PrepayAndAdditionalFeeSchedule.FeeName = z.FeeName, 
PrepayAndAdditionalFeeSchedule.EndDate = z.EndDate, 
PrepayAndAdditionalFeeSchedule.FeeAmountOverride = z.FeeAmountOverride, 
PrepayAndAdditionalFeeSchedule.BaseAmountOverride = z.BaseAmountOverride, 
PrepayAndAdditionalFeeSchedule.ApplyTrueUpFeature = z.ApplyTrueUpFeature, 
PrepayAndAdditionalFeeSchedule.FeetobeStripped = z.FeetobeStripped 
FROM(

	Select  rs.PrepayAndAdditionalFeeScheduleID
	,t.StartDate
    ,t.ValueTypeID 
    ,t.Value
    ,t.IncludedLevelYield
    ,t.IncludedBasis   
    ,t.FeeName
    ,t.ScheduleEndDate as EndDate
    ,t.FeeAmountOverride
    ,t.BaseAmountOverride
    ,t.ApplyTrueUpFeatureID as ApplyTrueUpFeature 
    ,t.PercentageOfFeeToBeStripped as FeetobeStripped 
	from [CORE].[PrepayAndAdditionalFeeSchedule] rs  
	INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId 
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	Inner JOin(
		SELECT  ScheduleID, AccountID, EffectiveDate, StartDate, ScheduleEndDate, FeeName, ValueTypeID, Value ,FeeAmountOverride,BaseAmountOverride,ApplyTrueUpFeatureID,PercentageOfFeeToBeStripped,IncludedLevelYield,IncludedBasis
		FROM 	@tbltype_NoteFeeSchedule
		where ISNULL(IsDeleted,0) <> 1 and ScheduleID <> '00000000-0000-0000-0000-000000000000'
	)t on t.AccountID = n.Account_AccountID and t.ScheduleID = rs.PrepayAndAdditionalFeeScheduleID
	where e.StatusID = 1
	and n.Account_AccountID = @AccountID  and acc.IsDeleted = 0

)z
WHERE [CORE].PrepayAndAdditionalFeeSchedule.PrepayAndAdditionalFeeScheduleID = z.PrepayAndAdditionalFeeScheduleID


    Insert INTO [Core].[PrepayAndAdditionalFeeSchedule] (EventID, FeeName,StartDate,EndDate,ValueTypeID,Value,FeeAmountOverride,BaseAmountOverride,ApplyTrueUpFeature,IncludedLevelYield,FeetobeStripped,[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate])
	SELECT e.EventID, FeeName, StartDate, ScheduleEndDate, ValueTypeID, Value, FeeAmountOverride, BaseAmountOverride, ApplyTrueUpFeatureID, IncludedLevelYield, PercentageOfFeeToBeStripped, @UserID, GETDATE(), @UserID, GETDATE()
	FROM @tbltype_NoteFeeSchedule t 
	Inner Join(	
	Select AccountID,EffectiveStartDate,EventID 
	from core.Event where StatusID = 1 and EventTypeID = 13
	)e on e.AccountID = t.AccountID and e.EffectiveStartDate = t.EffectiveDate
	where ISNULL(t.IsDeleted,0)<>1 and t.ScheduleID = '00000000-0000-0000-0000-000000000000'


	--Delete effective dates thats do not have Fee
	Delete from core.Event where EventTypeID = 13 and AccountID= @AccountID
	and EventID in (
		Select eventid from(
			SELECT e.EventID, e.EffectiveStartDate, COUNT(t.PrepayAndAdditionalFeeScheduleID) cnt
			FROM core.Event e
			LEFT JOIN [Core].[PrepayAndAdditionalFeeSchedule] t ON e.EventID = t.EventID
			WHERE e.EventTypeID = 13 and e.AccountID=@AccountID
			group by e.EventID, e.EffectiveStartDate
		) a
		where cnt = 0
	)


END