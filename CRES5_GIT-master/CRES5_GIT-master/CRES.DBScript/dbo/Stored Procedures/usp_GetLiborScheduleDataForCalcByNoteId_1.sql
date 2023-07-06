

--[dbo].[usp_GetLiborScheduleDataForCalcByNoteId]   '9ccee7dc-a959-4b61-998e-e6c56eb23e10',NULL, '80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B',1,1,null

CREATE PROCEDURE [dbo].[usp_GetLiborScheduleDataForCalcByNoteId_1] 
(
    @NoteId UNIQUEIDENTIFIER,
	@IndexNameID int,
	@UserID UNIQUEIDENTIFIER,	
	@PageIndex INT,
    @PageSize INT,
	@TotalCount INT OUTPUT 
)
	
AS
BEGIN
     SET NOCOUNT ON;
	 	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
   PRINT GETDATE();
   IF @IndexNameID is NULL or @IndexNameID=0
   Begin
	set @IndexNameID=(SELECT LookupID FROM CORE.LOOKUP WHERE Name='1M LIBOR')
   End

PRINT GETDATE(); 	


DECLARE @AnalysisID VARCHAR(50);
DECLARE @LScheduleLookupID INT;
DECLARE @AccountID UNIQUEIDENTIFIER;

Select @LScheduleLookupID = LookupID from CORE.[Lookup] where Name = 'LiborSchedule';
set @AnalysisID =(SELECT AnalysisID  FROM core.Analysis WHERE StatusID = (select LookupID from  Core.Lookup where ParentID=2 and Name='Y'))
SELECT @AccountID = Account_AccountID FROM [CRE].[Note] WHERE NoteID = @NoteId;


CREATE TABLE #tmpIndex
(
  Dates DATE,
  NoteID UNIQUEIDENTIFIER
)

CREATE TABLE #tmpLIBORSchedule
(
  LiborScheduleID UNIQUEIDENTIFIER,
  Value DECIMAL(28,15),
  Date DATETIME, 
  [EventID] UNIQUEIDENTIFIER,
  [CreatedBy] NVARCHAR(256),
  [CreatedDate] DATETIME,
  [UpdatedBy] NVARCHAR(256),
  [UpdatedDate] DATETIME
)


INSERT INTO #tmpIndex(Dates, NoteID)
Select 
	 ls.[Date] Dates
	 ,n.NoteID NoteID
	from [CORE].[LIBORSchedule] ls
	INNER JOIN [CORE].[Event] eve ON eve.EventID = ls.EventId
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	where n.NoteID = @NoteId
	UNION
	select [Date] Dates
	,@NoteId
	from Core.[Indexes] ind
	WHERE ind.[IndexType]=@IndexNameID
--	,n.NoteID NoteID
--		   from Core.[Indexes] ind 
--	INNER JOIN [CRE].[Note] n ON ind.[IndexType]=@IndexNameID
--where n.NoteID = @NoteId;
PRINT GETDATE(); 

INSERT INTO #tmpLIBORSchedule
(
  LiborScheduleID , Value, Date ,[EventID] ,[CreatedBy] ,[CreatedDate] ,[UpdatedBy] ,[UpdatedDate] 
)
SELECT  
  LiborScheduleID , Value, Date ,[EventID] ,[CreatedBy] ,[CreatedDate] ,[UpdatedBy] ,[UpdatedDate] 
 FROM [CORE].[LIBORSchedule] ls
WHERE ls.EventId IN 
    (SELECT EventId FROM [CORE].[Event] eve 
      WHERE eve.EventTypeID = @LScheduleLookupID and eve.AccountID =@AccountID 
	) 
   and ls.[Date] IN (SELECT Dates FROM #tmpIndex)


--INNER JOIN [CRE].[Note] n ON n.NoteID =dates.NoteID
--INNER JOIN [CORE].[Account] acc ON n.Account_AccountID = acc.AccountID 
--LEFT JOIN [CORE].[Event] eve  ON eve.EventTypeID = @LScheduleLookupID and eve.AccountID =acc.AccountID  
--LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
--left JOIN [CORE].[LIBORSchedule] ls ON eve.EventID = ls.EventId and ls.[Date]=dates.[Dates]


PRINT GETDATE(); 

Select 
distinct dates.dates
,n.NoteID
,acc.AccountID
,ls.LiborScheduleID as ScheduleID
,ls.Value 
,ind.Value IndexValue
,eve.[Date] as Event_Date
,ISNULL(eve.EffectiveStartDate,isnull(n.ClosingDate,getdate())) AS EffectiveDate
,eve.EffectiveEndDate
,isnull(eve.[EventTypeID],@LScheduleLookupID)   EventTypeID
,LEventTypeID.Name as EventTypeText
,ls.[EventID]
,ls.[CreatedBy]
,ls.[CreatedDate]
,ls.[UpdatedBy]
,ls.[UpdatedDate]
from 
(
   SELECT Dates, NoteID  FROM #tmpIndex
	--Select 
	-- ls.[Date] Dates
	-- ,n.NoteID NoteID
	--from [CORE].[LIBORSchedule] ls
	--INNER JOIN [CORE].[Event] eve ON eve.EventID = ls.EventId
	--INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
	--INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	--where n.NoteID = @NoteId
	--union
	--select [Date] Dates
	--,n.NoteID NoteID
	--	   from Core.[Indexes] ind 
	--INNER JOIN [CRE].[Note] n ON ind.[IndexType]=@IndexNameID
	--where n.NoteID = @NoteId
) dates
INNER JOIN [CRE].[Note] n ON n.NoteID =dates.NoteID
INNER JOIN [CORE].[Account] acc ON n.Account_AccountID = acc.AccountID 
LEFT JOIN [CORE].[Event] eve  ON eve.EventTypeID = @LScheduleLookupID and eve.AccountID =acc.AccountID  
LEFT JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID
left JOIN #tmpLIBORSchedule ls ON eve.EventID = ls.EventId and ls.[Date]=dates.[Dates]
left join Core.[Indexes] ind on ind.IndexType =@IndexNameID and ind.[Date] =dates.[Dates] and  AnalysisID= @AnalysisID  
where n.NoteID = @NoteId  
--and dates.dates <= getdate()


--order by dates.dates
	--OFFSET @PageIndex - 1 ROWS
	--FETCH NEXT @PageSize ROWS ONLY
PRINT GETDATE(); 
SET @TotalCount = (SELECT @@Rowcount);

Drop Table #tmpIndex
Drop Table #tmpLIBORSchedule

PRINT GETDATE(); 
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

END


