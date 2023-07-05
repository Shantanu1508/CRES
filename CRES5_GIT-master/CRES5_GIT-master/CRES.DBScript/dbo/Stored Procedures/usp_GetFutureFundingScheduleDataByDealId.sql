--[dbo].[usp_GetFutureFundingScheduleDataByDealId] '51229850-8bed-4687-9dd2-784908033535'

CREATE PROCEDURE [dbo].[usp_GetFutureFundingScheduleDataByDealId] 
(
    @Dealid UNIQUEIDENTIFIER
)
	
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
   
 
 
 
 IF OBJECT_ID('tempdb..#tblEffDateList ') IS NOT NULL             
	DROP TABLE #tblEffDateList

CREATE TABLE #tblEffDateList
(
	NOteID UNIQUEIDENTIFIER,
	EventID UNIQUEIDENTIFIER,
	EffectiveDate date	
)
INSERT INTO #tblEffDateList(NOteID,EventID,EffectiveDate)
Select noteid,eventid,EffectiveStartDate
From(
	Select Distinct n.noteid,eve.eventid,eve.EffectiveStartDate
	from [CORE].[FundingSchedule] fs  
	INNER JOIN [CORE].[Event] eve ON eve.EventID = fs.EventId  
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID  
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
	INNER JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID  
	left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID  
	where n.DealID = @Dealid  and acc.IsDeleted = 0  
	and eve.StatusID = 1
)a
Order by a.EffectiveStartDate


IF OBJECT_ID('tempdb..#tblDistFundingDate ') IS NOT NULL             
	DROP TABLE #tblDistFundingDate

CREATE TABLE #tblDistFundingDate
(
	NOteID UNIQUEIDENTIFIER,
	[Date] date	
)

INSERT INTO #tblDistFundingDate(NOteID,[Date])
Select Distinct n.NOteID ,fs.[Date]
from [CORE].[FundingSchedule] fs  
INNER JOIN [CORE].[Event] eve ON eve.EventID = fs.EventId  
INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID  
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
INNER JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID  
left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID  
where n.DealID = @Dealid  and acc.IsDeleted = 0  
and eve.StatusID = 1
Order by fs.[Date]



IF OBJECT_ID('tempdb..#tblFinal ') IS NOT NULL             
	DROP TABLE #tblFinal

CREATE TABLE #tblFinal
(
	NoteID UNIQUEIDENTIFIER,
	AccountID UNIQUEIDENTIFIER,
	Date Date,
	Value decimal(28,15) null,
	EffectiveDate date,
	EffectiveStartDate date,
	EffectiveEndDate date,
	EventTypeID int null,
	EventTypeText nvarchar(256),
	EventID UNIQUEIDENTIFIER null,
	PurposeID int null,
	PurposeText nvarchar(256),
	Applied bit null,
	CreatedBy nvarchar(256),
	CreatedDate datetime,
	UpdatedBy nvarchar(256),
	UpdatedDate datetime
)
--====================================

Declare @NoteID UNIQUEIDENTIFIER 
Declare @EventID UNIQUEIDENTIFIER 
Declare @EffectiveDate Date 

IF CURSOR_STATUS('global','CursorEffDate')>=-1
BEGIN
	DEALLOCATE CursorEffDate
END

DECLARE CursorEffDate CURSOR 
for
(
	Select NoteID,EventID,EffectiveDate from #tblEffDateList   
)
OPEN CursorEffDate 

FETCH NEXT FROM CursorEffDate
INTO @NoteID,@EventID,@EffectiveDate

WHILE @@FETCH_STATUS = 0
BEGIN
--------------------------
--Print (COnvert(nvarchar(256),@EffectiveDate,101))
INSERT INTO #tblFinal(NoteID,AccountID,Date,Value,EffectiveDate,EffectiveStartDate,EffectiveEndDate,EventTypeID,EventTypeText,EventID,PurposeID,PurposeText,Applied,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate)
Select   
n.NoteID
,acc.AccountID
,fs.[Date]
,fs.Value
,eve.EffectiveStartDate AS EffectiveDate
,eve.EffectiveStartDate
,eve.EffectiveEndDate
,eve.EventTypeID
,LEventTypeID.Name as EventTypeText
,fs.[EventID]
,fs.PurposeID
,LPurposeID.Name PurposeText
,Applied
,fs.[CreatedBy]
,fs.[CreatedDate]
,fs.[UpdatedBy]
,fs.[UpdatedDate]
from [CORE].[FundingSchedule] fs  
INNER JOIN [CORE].[Event] eve ON eve.EventID = fs.EventId  
INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID  
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
INNER JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID  
left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID  
where n.NoteID = @Noteid  and acc.IsDeleted = 0  
and eve.StatusID = 1
and eve.eventid = @EventID
Order by eve.EffectiveStartDate,fs.[Date]  
-----------------------------------

INSERT INTO #tblFinal(NoteID,AccountID,Date,Value,EffectiveDate,EffectiveStartDate,EffectiveEndDate,EventTypeID,EventTypeText,EventID,PurposeID,PurposeText,Applied,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate)
Select NoteID,AccountID,Date,Value,EffectiveDate,EffectiveStartDate,EffectiveEndDate,EventTypeID,EventTypeText,EventID,PurposeID,PurposeText,Applied,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate
From(
Select   
n.NoteID  
,acc.AccountID  
,fs.[Date]  
,0 as [Value]
,@EffectiveDate AS EffectiveDate  
,@EffectiveDate EffectiveStartDate  
,eve.EffectiveEndDate  
,eve.EventTypeID  
,LEventTypeID.Name as EventTypeText  
,@EventID [EventID]  
,fs.PurposeID  
,LPurposeID.Name PurposeText  
,Applied  
,fs.[CreatedBy]  
,fs.[CreatedDate]  
,fs.[UpdatedBy]  
,fs.[UpdatedDate]
,ROW_NUmber() over(partition by fs.Date order by fs.date,eve.EffectiveStartDate desc) as rno
from [CORE].[FundingSchedule] fs  
INNER JOIN [CORE].[Event] eve ON eve.EventID = fs.EventId  
INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID  
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
INNER JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID  
left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID  
where n.NoteID = @Noteid  and acc.IsDeleted = 0  
and eve.StatusID = 1

and fs.date in (
	Select [Date] 
	from #tblDistFundingDate where date not in (
		Select  fs.[Date] 
		from [CORE].[FundingSchedule] fs  
		INNER JOIN [CORE].[Event] eve ON eve.EventID = fs.EventId  
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID  
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
		INNER JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID  
		left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID  
		where n.NoteID = @Noteid  and acc.IsDeleted = 0  
		and eve.StatusID = 1
		and eve.eventid = @EventID
	)

)
and eve.EffectiveStartDate < @EffectiveDate

)a
where a.rno = 1
--------------------------

FETCH NEXT FROM CursorEffDate
INTO @NOteID,@EventID,@EffectiveDate
END
CLOSE CursorEffDate   
DEALLOCATE CursorEffDate



Select NoteID,AccountID,Date,Value,EffectiveDate,EffectiveStartDate,EffectiveEndDate,EventTypeID,EventTypeText,EventID,PurposeID,PurposeText,Applied,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate 
from #tblFinal 
ORDER BY NoteID DESC



	SET TRANSACTION ISOLATION LEVEL READ COMMITTED

END

