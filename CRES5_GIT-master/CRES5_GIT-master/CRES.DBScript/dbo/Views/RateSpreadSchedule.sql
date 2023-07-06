
CREATE view [dbo].[RateSpreadSchedule]
as 

Select
RateSpreadScheduleID as RateSpreadScheduleKey,
EventId,
Date,
ValueTypeBI as ValueType,
Value,
IntCalcMethodBI as IntCalcMethod,
CreatedBy,
CreatedDate,
UpdatedBy,
UpdatedDate,
RateOrSpreadToBeStripped as FeeToBeStripped,

CreDealId as DealId	,
DealName	,
CreNoteID	as NoteID,
NoteName  ,
RateSpreadScheduleAutoID,
ScheduleText,
IndexNameBI as IndexName,
EffectiveStartDate as EffectiveDate
From DW.RateSpreadScheduleBI 
