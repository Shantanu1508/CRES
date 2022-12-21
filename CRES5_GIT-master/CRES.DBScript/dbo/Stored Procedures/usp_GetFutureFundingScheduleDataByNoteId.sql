--[dbo].[usp_GetFutureFundingScheduleDataByNoteId] '55c58817-6fcd-4e29-a5f4-2efb4abfea5c', '80E27BC4-B933-4724-9DB2-EF3CDB8ADB6B',1,1,null

creatE PROCEDURE [dbo].[usp_GetFutureFundingScheduleDataByNoteId] 
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
   
 
 IF OBJECT_ID('tempdb..#tblEffDateList ') IS NOT NULL             
	DROP TABLE #tblEffDateList

CREATE TABLE #tblEffDateList
(
	EventID UNIQUEIDENTIFIER,
	EffectiveDate date	
)
INSERT INTO #tblEffDateList(EventID,EffectiveDate)
Select eventid,EffectiveStartDate
From(
	Select Distinct eve.eventid,eve.EffectiveStartDate
	from [CORE].[FundingSchedule] fs  
	INNER JOIN [CORE].[Event] eve ON eve.EventID = fs.EventId  
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID  
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
	INNER JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID  
	left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID  
	where n.NoteID = @Noteid  and acc.IsDeleted = 0  
	and eve.StatusID = 1
)a
Order by a.EffectiveStartDate


IF OBJECT_ID('tempdb..#tblDistFundingDate ') IS NOT NULL             
	DROP TABLE #tblDistFundingDate

CREATE TABLE #tblDistFundingDate
(
	[Date] date	
)

INSERT INTO #tblDistFundingDate([Date])
Select Distinct fs.[Date]
from [CORE].[FundingSchedule] fs  
INNER JOIN [CORE].[Event] eve ON eve.EventID = fs.EventId  
INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID  
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
INNER JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = eve.EventTypeID  
left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID  
where n.NoteID = @Noteid  and acc.IsDeleted = 0  
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
Declare @EventID UNIQUEIDENTIFIER 
Declare @EffectiveDate Date 

IF CURSOR_STATUS('global','CursorEffDate')>=-1
BEGIN
	DEALLOCATE CursorEffDate
END

DECLARE CursorEffDate CURSOR 
for
(
	Select EventID,EffectiveDate from #tblEffDateList   
)
OPEN CursorEffDate 

FETCH NEXT FROM CursorEffDate
INTO @EventID,@EffectiveDate

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
INTO @EventID,@EffectiveDate
END
CLOSE CursorEffDate   
DEALLOCATE CursorEffDate



Select NoteID,AccountID,Date,Value,EffectiveDate,EffectiveStartDate,EffectiveEndDate,EventTypeID,EventTypeText,EventID,PurposeID,PurposeText,Applied,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate 
from #tblFinal 
ORDER BY UpdatedDate DESC



----------Add PIK Tran in Last paydown in FF---------
--Declare @AnalysisID UNIQUEIDENTIFIER = 'c10f3372-0fc2-4861-a9f5-148f1f80804f' 
--Declare @DealID UNIQUEIDENTIFIER;

--SET @DealID = (Select dealid from cre.note n 
--inner join core.account acc on acc.accountid = n.account_accountid
--where acc.isdeleted <> 1 and n.noteid = @Noteid)


--Declare @tblFundingdataWithPIK as table
--(
--dealid UNIQUEIDENTIFIER,
--noteid UNIQUEIDENTIFIER,
--credealid nvarchar(256),
--crenoteid nvarchar(256),
--lastPayDown_Date date,
--lastPayDown_Amount decimal(28,15),
--Purposeid int,
--PurposeTypeText nvarchar(256),
--Lastest_EffectiveDate	 date,
--PIKFunding_afterLastPyDn decimal(28,15)
--)

--INSERT INTO @tblFundingdataWithPIK (dealid,noteid,credealid,crenoteid,lastPayDown_Date,lastPayDown_Amount,Purposeid,PurposeTypeText,Lastest_EffectiveDate,PIKFunding_afterLastPyDn)
--exec [dbo].[usp_GetLastPaydownandPIKTranForNote] @DealID, @AnalysisID


---------------------------------------------------------------------------
--Select fs.NoteID,AccountID,Date,
--([Value] + ISNULL(pik.PIKFunding_afterLastPyDn,0)) as [Value],
--EffectiveDate,EffectiveStartDate,EffectiveEndDate,EventTypeID,EventTypeText,EventID,fs.PurposeID,PurposeText,Applied,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate 
--from #tblFinal fs
--Left Join 
--(
--	Select dealid,noteid,credealid,crenoteid,lastPayDown_Date,lastPayDown_Amount,Purposeid,PurposeTypeText,Lastest_EffectiveDate,PIKFunding_afterLastPyDn 
--	from @tblFundingdataWithPIK 
--	where noteid =  @Noteid
--)pik on pik.noteid = fs.noteid and pik.Lastest_EffectiveDate = fs.effectivestartdate and pik.lastPayDown_Date = fs.date and pik.Purposeid = fs.PurposeID

--order by EffectiveDate,date





SET @TotalCount = (SELECT @@Rowcount);

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED

END

