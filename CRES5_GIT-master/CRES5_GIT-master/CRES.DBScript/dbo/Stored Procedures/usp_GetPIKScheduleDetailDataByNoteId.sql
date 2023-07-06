  


CREATE PROCEDURE [dbo].[usp_GetPIKScheduleDetailDataByNoteId] --'62D692B2-3073-4A21-A723-B1ED48011E05', '80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B',1,1,null
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
n.NoteID
,acc.AccountID
,psd.[Date]
,psd.Value
,eve.EffectiveStartDate AS EffectiveDate
,eve.EffectiveStartDate
,eve.EffectiveEndDate
,eve.EventTypeID
,LEventTypeID.Name as EventTypeText
,psd.[EventID]
,psd.[CreatedBy]
,psd.[CreatedDate]
,psd.[UpdatedBy]
,psd.[UpdatedDate]
from [CORE].[PIKScheduleDetail] psd
INNER JOIN [CORE].[Event] eve ON eve.EventID = psd.EventId
INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID

where n.NoteID = @NoteId  and acc.IsDeleted = 0

ORDER BY psd.UpdatedDate DESC
	--OFFSET @PageIndex - 1 ROWS
	--FETCH NEXT @PageSize ROWS ONLY


SET @TotalCount = (SELECT @@Rowcount);

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED

END

