
-- [dbo].[usp_GetMaturityPeriodicDataByNoteId]  'E2F964AD-7A39-4B70-85F6-1BB93921A122','80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B',1,1,null

CREATE PROCEDURE [dbo].[usp_GetMaturityPeriodicDataByNoteId] --'62D692B2-3073-4A21-A723-B1ED48011E05', '80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B',1,1,null
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
@totalCount =  COUNT(n.NoteID)    	
from [CORE].[Maturity] mat
INNER JOIN [CORE].[Event] eve ON eve.EventID = mat.EventId
INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
where n.NoteID = @NoteId and acc.IsDeleted = 0 and eve.StatusID = 1

--------------------------------
Select 
 n.NoteID
--,acc.AccountID
--,mat.[MaturityID]
--,mat.[EventID]
,n.ExpectedMaturityDate    
,n.ActualPayoffDate  
,n.OpenPrepaymentDate    
,mat.MaturityDate  
,eve.EffectiveStartDate as EffectiveDate    
,LMaturityType.name as [Type]   
,LApproved.name as [Approved]
--,null as [CreatedBy]
--,null as [CreatedDate]
--,null as [UpdatedBy]
--,null as [UpdatedDate]
--,null as [ScheduleID]
--,null as [Date]
--,null as [ModuleId]

from [CORE].[Maturity] mat
INNER JOIN [CORE].[Event] eve ON eve.EventID = mat.EventId
INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
left JOIN [CORE].[Lookup] LApproved ON LApproved.LookupID = mat.Approved    
left JOIN [CORE].[Lookup] LMaturityType ON LMaturityType.LookupID = mat.MaturityType 
where n.NoteID = @NoteId and acc.IsDeleted = 0 
and eve.StatusID = 1
ORDER BY mat.UpdatedDate DESC

-------------------=========================----------------
--Select 
-- n.NoteID
--,acc.AccountID
--,mat.[MaturityID]
--,mat.[EventID]
--,eve.[Date]
--,eve.EffectiveStartDate
--,eve.EffectiveEndDate
--,eve.EventTypeID
--,LEventTypeID.Name as EventTypeText
--,mat.SelectedMaturityDate
--,mat.[CreatedBy]
--,mat.[CreatedDate]
--,mat.[UpdatedBy]
--,mat.[UpdatedDate]
--from [CORE].[Maturity] mat
--INNER JOIN [CORE].[Event] eve ON eve.EventID = mat.EventId
--INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
--INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
--LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
--where n.NoteID = @NoteId and acc.IsDeleted = 0 --'62D692B2-3073-4A21-A723-B1ED48011E05'

--ORDER BY mat.UpdatedDate DESC
	--OFFSET @PageIndex - 1 ROWS
	--FETCH NEXT @PageSize ROWS ONLY


 	SET TRANSACTION ISOLATION LEVEL READ COMMITTED


END

