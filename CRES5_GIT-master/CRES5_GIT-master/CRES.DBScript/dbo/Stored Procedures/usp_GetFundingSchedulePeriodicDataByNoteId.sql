


CREATE PROCEDURE [dbo].[usp_GetFundingSchedulePeriodicDataByNoteId] --'62D692B2-3073-4A21-A723-B1ED48011E05', '80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B',1,1,null
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
from [CORE].[FundingSchedule] fs
INNER JOIN [CORE].[Event] eve ON eve.EventID = fs.EventId
INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
where n.NoteID = @NoteId  and acc.IsDeleted = 0

---------------------    	
Select 
n.NoteID
,acc.AccountID
,eve.[Date]
,eve.EffectiveStartDate
,eve.EffectiveEndDate
,eve.EventTypeID
,LEventTypeID.Name as EventTypeText

,fs.FundingScheduleID
,fs.[EventID]
,fs.[Date]
,fs.Value

,fs.[CreatedBy]
,fs.[CreatedDate]
,fs.[UpdatedBy]
,fs.[UpdatedDate]
from [CORE].[FundingSchedule] fs
INNER JOIN [CORE].[Event] eve ON eve.EventID = fs.EventId
INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
where n.NoteID = @NoteId  and acc.IsDeleted = 0

ORDER BY fs.UpdatedDate DESC
	--OFFSET @PgeIndex - 1 ROWS
	--FETCH NEXT @PageSize ROWS ONLY


 

 	SET TRANSACTION ISOLATION LEVEL READ COMMITTED

END

