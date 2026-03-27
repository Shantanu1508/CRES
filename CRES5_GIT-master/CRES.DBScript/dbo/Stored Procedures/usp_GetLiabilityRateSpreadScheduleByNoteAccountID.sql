-- Procedure
CREATE PROCEDURE [dbo].[usp_GetLiabilityRateSpreadScheduleByNoteAccountID] 
	@NoteAccountID UNIQUEIDENTIFIER,
	@AdditionalAccountID UNIQUEIDENTIFIER = NULL
AS
BEGIN

Select 
 e.EffectiveStartDate as EffectiveDate
 ,e.AccountID
 ,e.AdditionalAccountID
,fs.[Date] 
,fs.[ValueTypeID]
,LValueTypeID.Name as ValueTypeText

,isnull(fs.[Value],0) as Value

,isnull(fs.[IntCalcMethodID],0) as IntCalcMethodID 
,LIntCalcMethodID.Name as IntCalcMethodText

,fs.[CreatedBy]
,fs.[CreatedDate]
,fs.[UpdatedBy]
,fs.[UpdatedDate]

,fs.[RateOrSpreadToBeStripped]

,fs.IndexNameID  
,lindex.name as IndexNameText  

,fs.DeterminationDateHolidayList
,LDeterminationDateHolidayList.CalendarName as DeterminationDateHolidayListText
from core.RateSpreadScheduleLiability fs
Inner Join core.Event e on e.EventID = fs.EventID
LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = fs.ValueTypeID
LEFT JOIN [CORE].[Lookup] LIntCalcMethodID ON LIntCalcMethodID.LookupID = fs.IntCalcMethodID
LEFT JOIN app.HoliDaysMaster LDeterminationDateHolidayList ON LDeterminationDateHolidayList.HolidayMasterID = fs.DeterminationDateHolidayList
LEFT JOIN [CORE].[Lookup] lindex ON lindex.LookupID = fs.IndexNameID  

Where e.StatusID=1 and AccountID = @NoteAccountID AND e.EffectiveStartDate=(select Max(EffectiveStartDate) from [Core].[Event] e Where AccountID=@NoteAccountID and (@AdditionalAccountID IS NULL OR e.AdditionalAccountID = @AdditionalAccountID) and eventtypeid = 909 and StatusID = 1)
and (@AdditionalAccountID IS NULL OR e.AdditionalAccountID = @AdditionalAccountID)

END


 