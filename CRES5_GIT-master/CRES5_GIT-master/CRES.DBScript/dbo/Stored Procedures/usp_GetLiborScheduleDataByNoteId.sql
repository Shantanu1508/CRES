


CREATE PROCEDURE [dbo].[usp_GetLiborScheduleDataByNoteId] --'62D692B2-3073-4A21-A723-B1ED48011E05', '80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B',1,1,null
(
    @NoteId UNIQUEIDENTIFIER,
	@UserID UNIQUEIDENTIFIER,
	
	@PageIndex INT,
    @PageSize INT,
	@TotalCount INT OUTPUT 
)
	
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
 Select 
distinct dates.dates
,n.NoteID
,acc.AccountID
,ls.LiborScheduleID as ScheduleID
,ls.Value 
,ind.Value IndexValue
,eve.[Date] as Event_Date
,eve.EffectiveStartDate AS EffectiveDate
,eve.EffectiveEndDate
,eve.EventTypeID
,LEventTypeID.Name as EventTypeText
,ls.[EventID]
,ls.[CreatedBy]
,ls.[CreatedDate]
,ls.[UpdatedBy]
,ls.[UpdatedDate]
from 
(
	Select 
	 ls.[Date] Dates
	 ,n.NoteID NoteID
	from [CORE].[LIBORSchedule] ls
	INNER JOIN [CORE].[Event] eve ON eve.EventID = ls.EventId
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	where n.NoteID = @NoteId and acc.IsDeleted = 0

	union

	select [Date] Dates
	,n.NoteID NoteID  from Core.[Indexes] ind 
	INNER JOIN [CRE].[Note] n ON ind.[IndexType]=n.IndexNameID
	inner join core.Account acc on acc.AccountID = n.Account_AccountID
	where n.NoteID = @NoteId and acc.IsDeleted = 0

) dates
INNER JOIN [CRE].[Note] n ON n.NoteID =dates.NoteID
INNER JOIN [CORE].[Account] acc ON n.Account_AccountID = acc.AccountID 
INNER JOIN [CORE].[Event] eve  ON eve.EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'LiborSchedule') and eve.AccountID =acc.AccountID  
INNER JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
left JOIN [CORE].[LIBORSchedule] ls ON eve.EventID = ls.EventId and ls.[Date]=dates.[Dates]
left join Core.[Indexes] ind on ind.IndexType =n.IndexNameID and ind.[Date] =dates.[Dates]
where n.NoteID = @NoteId  and acc.IsDeleted = 0

ORDER BY ls.UpdatedDate DESC
	--OFFSET @PageIndex - 1 ROWS
	--FETCH NEXT @PageSize ROWS ONLY


SET @TotalCount = (SELECT @@Rowcount);


	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END

