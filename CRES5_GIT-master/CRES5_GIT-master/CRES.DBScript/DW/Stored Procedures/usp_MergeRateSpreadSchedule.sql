

CREATE PROCEDURE [DW].[usp_MergeRateSpreadSchedule]
@BatchLogId int
AS
BEGIN

SET NOCOUNT ON


SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 


UPDATE [DW].BatchDetail
	SET
	BITableName = 'RateSpreadScheduleBI',
	BIStartTime = GETDATE()
	WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_RateSpreadScheduleBI'


IF EXISTS(Select top 1 [RateSpreadScheduleAutoID] from [DW].[L_RateSpreadScheduleBI])
BEGIN

---Delete from [DW].[RateSpreadScheduleBI] where CRENoteID in (Select Distinct CRENoteID from [DW].[L_RateSpreadScheduleBI])
Truncate table [DW].[RateSpreadScheduleBI]
	
	
INSERT INTO [DW].[RateSpreadScheduleBI]
(RateSpreadScheduleID,
EventId,
Date,
ValueTypeID,
Value,
IntCalcMethodID,
CreatedBy,
CreatedDate,
UpdatedBy,
UpdatedDate,
RateOrSpreadToBeStripped,
ValueTypeBI,
IntCalcMethodBI,
CreDealId,
DealName,
CreNoteID,
NoteName,
RateSpreadScheduleAutoID,
ScheduleText,
IndexNameID,
IndexNameBI,
EffectiveStartDate)

Select
te.RateSpreadScheduleID,
te.EventId,
te.Date,
te.ValueTypeID,
te.Value,
te.IntCalcMethodID,
te.CreatedBy,
te.CreatedDate,
te.UpdatedBy,
te.UpdatedDate,
te.RateOrSpreadToBeStripped,
te.ValueTypeBI,
te.IntCalcMethodBI,
te.CreDealId,
te.DealName,
te.CreNoteID,
te.NoteName,
te.RateSpreadScheduleAutoID,
te.ScheduleText,
te.IndexNameID,
te.IndexNameBI,
te.EffectiveStartDate
From DW.L_RateSpreadScheduleBI te



END


DECLARE @RowCount int
SET @RowCount = @@ROWCOUNT



UPDATE [DW].BatchDetail
SET
BIEndTime = GETDATE(),
BIRecordCount = @RowCount
WHERE BatchLogId = @BatchLogId and LandingTableName = 'L_RateSpreadScheduleBI'

Print(char(9) +'usp_MergeRateSpreadSchedule - ROWCOUNT = '+cast(@RowCount  as varchar(100)));



SET TRANSACTION ISOLATION LEVEL READ COMMITTED 

END

