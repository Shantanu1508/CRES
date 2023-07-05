


CREATE PROCEDURE [dbo].[usp_GetServicingFeeScheduleDataByNoteId] --'62D692B2-3073-4A21-A723-B1ED48011E05', '80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B',1,1,null
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
,sfs.[Date]
,sfs.Value
,eve.EffectiveStartDate AS EffectiveDate
,eve.EffectiveStartDate
,eve.EffectiveEndDate
,eve.EventTypeID
,LEventTypeID.Name as EventTypeText
,sfs.[EventID]
,sfs.[CreatedBy]
,sfs.[CreatedDate]
,sfs.[UpdatedBy]
,sfs.[UpdatedDate]
from [CORE].[ServicingFeeSchedule] sfs
INNER JOIN [CORE].[Event] eve ON eve.EventID = sfs.EventId
INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
INNER JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID

where n.NoteID = @NoteId  and acc.IsDeleted = 0

ORDER BY sfs.UpdatedDate DESC
	--OFFSET @PageIndex - 1 ROWS
	--FETCH NEXT @PageSize ROWS ONLY


SET @TotalCount = (SELECT @@Rowcount);


	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END

