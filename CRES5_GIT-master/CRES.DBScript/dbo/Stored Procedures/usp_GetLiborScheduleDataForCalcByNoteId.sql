

--[dbo].[usp_GetLiborScheduleDataForCalcByNoteId]   '9dfc35be-c080-4736-a422-108307dc5807',0,'3BBEAC70-F8A0-49EE-906D-1E4D40CD16E7', 'C10F3372-0FC2-4861-A9F5-148F1F80804F',1,1,null

CREATE PROCEDURE [dbo].[usp_GetLiborScheduleDataForCalcByNoteId] 
(
    @NoteId UNIQUEIDENTIFIER,
	@IndexNameID int,
	@UserID UNIQUEIDENTIFIER,	
	@AnalysisID UNIQUEIDENTIFIER,
	@PageIndex INT,
    @PageSize INT,
	@TotalCount INT OUTPUT 
)
	
AS
BEGIN
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


Declare @tbl_IndexNameID as Table (IndexNameID int)

Delete from @tbl_IndexNameID

INSERT INTO @tbl_IndexNameID(IndexNameID)
Select Distinct rs.IndexNameID
from [CORE].RateSpreadSchedule rs  
INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId  
INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
where e.StatusID = 1 
and rs.IndexNameID is not null
and n.noteid = @NoteId



IF NOT EXISTS(Select IndexNameID from @tbl_IndexNameID)
BEGIN
	INSERT INTO @tbl_IndexNameID(IndexNameID) 
	SELECT LookupID FROM CORE.LOOKUP WHERE Name='1M LIBOR'
END

--IF @IndexNameID is NULL or @IndexNameID=0
--Begin
--	set @IndexNameID=(SELECT LookupID FROM CORE.LOOKUP WHERE Name='1M LIBOR')
--End


DECLARE @LScheduleLookupID INT;
DECLARE @AccountID UNIQUEIDENTIFIER;
DECLARE @IndexesMasterID int;
DECLARE @ClosingDate date;


Select @LScheduleLookupID = LookupID from CORE.[Lookup] where Name = 'LiborSchedule';
SELECT @AccountID = Account_AccountID FROM [CRE].[Note] WHERE NoteID = @NoteId;
SELECT @ClosingDate = ClosingDate FROM [CRE].[Note] WHERE NoteID = @NoteId;
Select @IndexesMasterID = ap.IndexScenarioOverride from core.Analysis an left join core.AnalysisParameter ap on an.AnalysisID = ap.AnalysisID where an.AnalysisID = @AnalysisID
--==============================================

Select 
distinct [Date] as dates
,@NoteId as NoteID
,@AccountID as AccountID
,cast(cast(0 as binary) as uniqueidentifier) as ScheduleID
,ind.Value as [Value]
--,ind.Value IndexValue
,isnull(@ClosingDate,getdate()) as Event_Date
,isnull(@ClosingDate,getdate()) AS EffectiveDate
,isnull(@ClosingDate,getdate()) EffectiveEndDate
,@LScheduleLookupID   EventTypeID
,'LiborSchedule' as EventTypeText
,cast(cast(0 as binary) as uniqueidentifier) as [EventID]
,ind.[CreatedBy]
,ind.[CreatedDate]
,ind.[UpdatedBy]
,ind.[UpdatedDate]
,l.name as [IndexType]
from Core.[Indexes] ind
left join core.lookup l on l.lookupid = ind.IndexType
WHERE ind.IndexesMasterID = @IndexesMasterID
and ind.[IndexType] in (Select IndexNameID from @tbl_IndexNameID)

order by  l.name,[Date]  asc


SET @TotalCount = (SELECT @@Rowcount);




SET TRANSACTION ISOLATION LEVEL READ COMMITTED

END




