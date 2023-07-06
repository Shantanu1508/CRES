


CREATE PROCEDURE [dbo].[usp_GetFinancingSchedulePeriodicDataByNoteId] --'62D692B2-3073-4A21-A723-B1ED48011E05', '80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B',1,1,null
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
n.NoteID
,acc.AccountID
,eve.[Date] as Event_Date
,eve.EffectiveStartDate
,eve.EffectiveEndDate
,eve.EventTypeID
,LEventTypeID.Name as EventTypeText

,fs.FinancingScheduleID
,fs.[EventID]
,fs.[Date]
,fs.Value

,fs.ValueTypeID
,LValueTypeID.Name as ValueTypeText
,fs.IndexTypeID
,LIndexTypeID.Name as IndexTypeText
,fs.IntCalcMethodID
,LIntCalcMethodID.Name as IntCalcMethodText
,fs.CurrencyCode

,fs.[CreatedBy]
,fs.[CreatedDate]
,fs.[UpdatedBy]
,fs.[UpdatedDate]
from [CORE].[FinancingSchedule] fs
INNER JOIN [CORE].[Event] eve ON eve.EventID = fs.EventId
INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
INNER JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID

LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = fs.ValueTypeID
LEFT JOIN [CORE].[Lookup] LIndexTypeID ON LValueTypeID.LookupID = fs.IndexTypeID
LEFT JOIN [CORE].[Lookup] LIntCalcMethodID ON LValueTypeID.LookupID = fs.IntCalcMethodID

where n.NoteID = @NoteId and acc.IsDeleted = 0 
and eve.StatusID = (Select LookupID from Core.Lookup where name = 'Active' and parentid = 1)

ORDER BY eve.EffectiveStartDate,fs.[Date]
	--OFFSET @PgeIndex - 1 ROWS
	--FETCH NEXT @PageSize ROWS ONLY


SET @TotalCount = (SELECT @@Rowcount);

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED

END

