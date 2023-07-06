


CREATE PROCEDURE [dbo].[usp_GetPIKSchedulePeriodicDataByNoteId]-- 'd472b1cd-b8ca-4cfb-8ec4-aab2014e1a07', '80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B',1,1,null
(
    @NoteId UNIQUEIDENTIFIER,
	@UserID UNIQUEIDENTIFIER,
	
	@PgeIndex INT,
    @PageSize INT,
	@TotalCount INT OUTPUT 
)
	
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
   

Select 
@totalCount =  COUNT(n.NoteID)
from [CORE].[PIKSchedule] pik
INNER JOIN [CORE].[Event] eve ON eve.EventID = pik.EventId
INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
where n.NoteID = @NoteId  and acc.IsDeleted = 0
-------------------------------------
    	
Select 
n.NoteID
,TargateNote.NoteID as TargateNoteID
,acc.AccountID
,eve.[Date]
,eve.EffectiveStartDate
,eve.EffectiveEndDate
,eve.EventTypeID
,LEventTypeID.Name as EventTypeText

,pik.PIKScheduleID
,pik.[EventID]
,pik.SourceAccountID
,pik.TargetAccountID
,pik.AdditionalIntRate
,pik.AdditionalSpread
,pik.IndexFloor
,pik.IntCompoundingRate
,pik.IntCompoundingSpread
,pik.StartDate
,pik.EndDate
,pik.IntCapAmt
,pik.PurBal
,pik.AccCapBal

,pik.[CreatedBy]
,pik.[CreatedDate]
,pik.[UpdatedBy]
,pik.[UpdatedDate]

,pik.PIKReasonCodeID
,LPIKReasonCode.name as PIKReasonCodeText
,pik.PIKComments
,pik.PIKIntCalcMethodID
,LPIKIntCalcMethodID.name as PIKIntCalcMethodIDText

from [CORE].[PIKSchedule] pik
INNER JOIN [CORE].[Event] eve ON eve.EventID = pik.EventId
INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID

left JOIN [CRE].[Note] TargateNote ON TargateNote.Account_AccountID = pik.TargetAccountID

LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
LEFT JOIN [CORE].[Lookup] LPIKReasonCode ON LPIKReasonCode.LookupID = pik.PIKReasonCodeID
LEFT JOIN [CORE].[Lookup] LPIKIntCalcMethodID ON LPIKIntCalcMethodID.LookupID = pik.PIKIntCalcMethodID 
where n.NoteID = @NoteId  and acc.IsDeleted = 0

ORDER BY pik.UpdatedDate DESC
	--OFFSET @PgeIndex - 1 ROWS
	--FETCH NEXT @PageSize ROWS ONLY


 

 	SET TRANSACTION ISOLATION LEVEL READ COMMITTED

END

