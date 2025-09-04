
---[dbo].[usp_GetCalcJsonByFundNameForFeesAndInterest]   'ACORE Credit Partners II','c10f3372-0fc2-4861-a9f5-148f1f80804f'
---[dbo].[usp_GetCalcJsonByFundNameForFeesAndInterest]   'ACORE Opportunistic Credit II','c10f3372-0fc2-4861-a9f5-148f1f80804f'

CREATE PROCEDURE [dbo].[usp_GetCalcJsonByFundNameForFeesAndInterest]  
(  	
	@FundIdOrName NVARCHAR(256),  
	@AnalysisID UNIQUEIDENTIFIER 	
)   
  
AS  
BEGIN  
 SET NOCOUNT ON;


 declare @fundAccountID uniqueidentifier,@AccountName nvarchar(256),@batch bit;
 
IF((SELECT 1 WHERE @FundIdOrName LIKE REPLACE('00000000-0000-0000-0000-000000000000', '0', '[0-9a-fA-F]')) = 1)  
BEGIN   
	SET @fundAccountID = @FundIdOrName  
END  
ELSE  
BEGIN  
	SET @fundAccountID = (Select acc.accountid from cre.Equity eq Inner Join core.Account acc on acc.AccountID = eq.AccountID where acc.name = @FundIdOrName)  
END 

select @AccountName=[Name] from core.Account where AccountID=@fundAccountID

select @batch = batch from [CRE].[RootV1Calc]


Declare @UseServicingActual nvarchar(10);  
  
Select @UseServicingActual = ISNULL(lUseActuals.name,'')
from core.analysis a  
inner join core.analysisparameter am on am.analysisid = a.analysisid  
left join core.lookup lUseActuals on lUseActuals.lookupid = am.UseActuals  
where a.analysisid=@AnalysisID  


----------------------------------------------
IF OBJECT_ID('tempdb..#tblliabilityNoteAccountID') IS NOT NULL         
	DROP TABLE #tblliabilityNoteAccountID


CREATE table #tblliabilityNoteAccountID(
	liabilityNoteAccountID UNIQUEIDENTIFIER,
	LiabilityNoteID nvarchar(256),
	liabilityTypeID UNIQUEIDENTIFIER,
	LibFlag nvarchar(256),
	LiabilityTypeName nvarchar(256)
)

INSERT INTO #tblliabilityNoteAccountID(liabilityNoteAccountID,LiabilityNoteID,liabilityTypeID,LibFlag,LiabilityTypeName)

SELECT Distinct ln.AccountID,ln.LiabilityNoteID,ln.LiabilityTypeID,tblLibtype.LibFlag,tblLibtype.[LiabilityTypeName]
FROM cre.liabilitynote ln
INNER JOIN cre.liabilitynoteassetmapping la ON ln.AccountID = la.LiabilityNoteAccountId
INNER JOIN (
    SELECT am.AssetAccountId AS assetnotesid
    FROM cre.liabilitynote l
    INNER JOIN cre.liabilitynoteassetmapping am ON l.AccountID = am.LiabilityNoteAccountId
    WHERE l.LiabilityTypeID = @fundAccountID
) sub ON la.AssetAccountId = sub.assetnotesid
LEFT JOIN core.Account a on ln.LiabilityTypeID = a.AccountID

Left Join(  
	Select acc.AccountID as AccountID,acc.name as [LiabilityTypeName] ,'Debt' as LibFlag
	from cre.Debt d 
	Inner Join core.Account acc on acc.AccountID =  d.AccountID 
	Left Join core.accountCategory ac on ac.accountCategoryID = acc.accountTypeId
	where IsDeleted<> 1
	
	UNION ALL

	Select acc.AccountID as AccountID,acc.name as [LiabilityTypeName] ,'Equity' as LibFlag
	from cre.Equity d 
	Inner Join core.Account acc on acc.AccountID =  d.AccountID 
	Left Join core.accountCategory ac on ac.accountCategoryID = acc.accountTypeId
	where IsDeleted<> 1
	and d.accountid = @fundAccountID

	UNION ALL

	Select acc.AccountID as AccountID,acc.name as [LiabilityTypeName] ,'Cash' as LibFlag
	from cre.CASH ch 
	Inner Join core.Account acc on acc.AccountID =  ch.AccountID 
	Left Join core.accountCategory ac on ac.accountCategoryID = acc.accountTypeId
	where IsDeleted<> 1
	

)tblLibtype on tblLibtype.AccountID = ln.LiabilityTypeID  
where a.IsDeleted <> 1
and tblLibtype.LibFlag = 'Debt'
----------------------------------------------

IF OBJECT_ID('tempdb..#tblRSS') IS NOT NULL         
	DROP TABLE #tblRSS


CREATE Table #tblRSS(
AccountID  UNIQUEIDENTIFIER,
EffectiveDate date,
[Date] date,
ValueTypeID int,
ValueTypeText nvarchar(256),
[Value] decimal(28,15),
IntCalcMethodID int,
IntCalcMethodText nvarchar(256),
IndexNameID int,
IndexNameText nvarchar(256),
DeterminationDateHolidayList int,
DeterminationDateHolidayListText nvarchar(256)
)

INSERT INTO #tblRSS(AccountID,EffectiveDate,Date,ValueTypeID,ValueTypeText,Value,IntCalcMethodID,IntCalcMethodText,IndexNameID,IndexNameText,DeterminationDateHolidayList,DeterminationDateHolidayListText)
Select e.AccountID
,e.EffectiveStartDate as EffectiveDate
,fs.[Date] 
,fs.[ValueTypeID]
,LValueTypeID.Name as ValueTypeText
,isnull(fs.[Value],0) as Value
,isnull(fs.[IntCalcMethodID],0) as IntCalcMethodID 
,LIntCalcMethodID.Name as IntCalcMethodText
,fs.IndexNameID  
,LOWER(lindex.name) as IndexNameText  
,fs.DeterminationDateHolidayList
,LDeterminationDateHolidayList.CalendarName as DeterminationDateHolidayListText
from core.RateSpreadScheduleLiability fs
Inner Join core.Event e on e.EventID = fs.EventID
Inner join core.account acc on acc.accountid = e.AccountID
LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = fs.ValueTypeID
LEFT JOIN [CORE].[Lookup] LIntCalcMethodID ON LIntCalcMethodID.LookupID = fs.IntCalcMethodID
LEFT JOIN app.HoliDaysMaster LDeterminationDateHolidayList ON LDeterminationDateHolidayList.HolidayMasterID = fs.DeterminationDateHolidayList
LEFT JOIN [CORE].[Lookup] lindex ON lindex.LookupID = fs.IndexNameID  

Where e.StatusID=1 ---
and e.AccountID in (
	Select liabilityNoteAccountID from #tblliabilityNoteAccountID	
	UNION
	Select @fundAccountID
)

INSERT INTO #tblRSS(AccountID,EffectiveDate,Date,ValueTypeID,ValueTypeText,Value,IntCalcMethodID,IntCalcMethodText,IndexNameID,IndexNameText,DeterminationDateHolidayList,DeterminationDateHolidayListText)
Select e.AccountID
,e.EffectiveStartDate as EffectiveDate
,fs.[Date] 
,fs.[ValueTypeID]
,LValueTypeID.Name as ValueTypeText
,isnull(fs.[Value],0) as Value
,isnull(fs.[IntCalcMethodID],0) as IntCalcMethodID 
,LIntCalcMethodID.Name as IntCalcMethodText
,fs.IndexNameID  
,LOWER(lindex.name) as IndexNameText  
,fs.DeterminationDateHolidayList
,LDeterminationDateHolidayList.CalendarName as DeterminationDateHolidayListText
from core.RateSpreadScheduleLiability fs
Inner Join core.Event e on e.EventID = fs.EventID
Inner join core.account acc on acc.accountid = e.AccountID
LEFT JOIN [CORE].[Lookup] LValueTypeID ON LValueTypeID.LookupID = fs.ValueTypeID
LEFT JOIN [CORE].[Lookup] LIntCalcMethodID ON LIntCalcMethodID.LookupID = fs.IntCalcMethodID
LEFT JOIN app.HoliDaysMaster LDeterminationDateHolidayList ON LDeterminationDateHolidayList.HolidayMasterID = fs.DeterminationDateHolidayList
LEFT JOIN [CORE].[Lookup] lindex ON lindex.LookupID = fs.IndexNameID  

Where e.StatusID=1 and e.additionalaccountid = @fundAccountID
and e.AccountID in (
	Select liabilityTypeID from #tblliabilityNoteAccountID	
)
----==============================





IF OBJECT_ID('tempdb..#tblLibNote_RSSAccountID') IS NOT NULL         
	DROP TABLE #tblLibNote_RSSAccountID

CREATE TABLE #tblLibNote_RSSAccountID (
LiabilityNoteAccountID  UNIQUEIDENTIFIER,
RSSAccountID  UNIQUEIDENTIFIER
)

INSERT INTO #tblLibNote_RSSAccountID(LiabilityNoteAccountID,RSSAccountID)
Select liabilityNoteAccountID ,
ISNULL(rsslibnote.AccountID,ISNULL(rsslibType.AccountID,@fundAccountID)) as RSSAccountID
from #tblliabilityNoteAccountID ln
Left Join #tblRSS rsslibnote on rsslibnote.accountid = ln.liabilityNoteAccountID
Left Join #tblRSS rsslibType on rsslibType.accountid = ln.liabilityTypeID


---===============================

IF OBJECT_ID('tempdb..#tblFEE') IS NOT NULL         
	DROP TABLE #tblFEE


CREATE Table #tblFEE(
AccountID  UNIQUEIDENTIFIER,
EffectiveDate date,
FeeName nvarchar(256),
[StartDate] date,
[EndDate] date,
ValueTypeID int,
FeeTypeText nvarchar(256),
[Value] decimal(28,15),
FeeAmountOverride decimal(28,15),
BaseAmountOverride decimal(28,15),
ApplyTrueUpFeatureID int,
ApplyTrueUpFeatureText nvarchar(256),
IncludedLevelYield int,
FeetobeStripped decimal(28,15),
IncludedBasis decimal(28,15),
feescheduleid UNIQUEIDENTIFIER
)

INSERT INTO #tblFEE(AccountID,EffectiveDate,FeeName,[StartDate],[EndDate],ValueTypeID,FeeTypeText,[Value],FeeAmountOverride,BaseAmountOverride,ApplyTrueUpFeatureID,ApplyTrueUpFeatureText,IncludedLevelYield,FeetobeStripped,IncludedBasis)
Select
e.AccountID,
e.EffectiveStartDate,
fs.FeeName,
fs.StartDate,
fs.EndDate,
fs.ValueTypeID,
LValueTypeID.FeeTypeNameText as FeeTypeText,
isnull(fs.Value,0) as [value],
fs.FeeAmountOverride,
fs.BaseAmountOverride,
fs.ApplyTrueUpFeature as ApplyTrueUpFeatureID
,LApplyTrueUpFeature.[Name] as ApplyTrueUpFeatureText,
isnull(fs.IncludedLevelYield,0) as IncludedLevelYield,
fs.FeetobeStripped,
fs.IncludedBasis
from
core.PrepayAndAdditionalFeeScheduleLiability fs
Inner Join core.Event e on e.EventID = fs.EventID
LEFT JOIN cre.FeeSchedulesConfig LValueTypeID ON LValueTypeID.FeeTypeNameID = fs.ValueTypeID
LEFT JOIN [CORE].[Lookup] LApplyTrueUpFeature ON LApplyTrueUpFeature.LookupID = fs.ApplyTrueUpFeature
Where e.StatusID=1 and e.AccountID in (
	Select liabilityNoteAccountID from #tblliabilityNoteAccountID	
	UNION
	Select @fundAccountID
)

INSERT INTO #tblFEE(AccountID,EffectiveDate,FeeName,[StartDate],[EndDate],ValueTypeID,FeeTypeText,[Value],FeeAmountOverride,BaseAmountOverride,ApplyTrueUpFeatureID,ApplyTrueUpFeatureText,IncludedLevelYield,FeetobeStripped,IncludedBasis)
Select
e.AccountID,
e.EffectiveStartDate,
fs.FeeName,
fs.StartDate,
fs.EndDate,
fs.ValueTypeID,
LValueTypeID.FeeTypeNameText as FeeTypeText,
isnull(fs.Value,0) as [value],
fs.FeeAmountOverride,
fs.BaseAmountOverride,
fs.ApplyTrueUpFeature as ApplyTrueUpFeatureID
,LApplyTrueUpFeature.[Name] as ApplyTrueUpFeatureText,
isnull(fs.IncludedLevelYield,0) as IncludedLevelYield,
fs.FeetobeStripped,
fs.IncludedBasis
from
core.PrepayAndAdditionalFeeScheduleLiability fs
Inner Join core.Event e on e.EventID = fs.EventID
LEFT JOIN cre.FeeSchedulesConfig LValueTypeID ON LValueTypeID.FeeTypeNameID = fs.ValueTypeID
LEFT JOIN [CORE].[Lookup] LApplyTrueUpFeature ON LApplyTrueUpFeature.LookupID = fs.ApplyTrueUpFeature
Where e.StatusID=1 and e.AdditionalAccountID = @fundAccountID
and e.AccountID in (
	Select liabilityTypeID from #tblliabilityNoteAccountID
)



IF OBJECT_ID('tempdb..#tblLibNote_FeeAccountID') IS NOT NULL         
	DROP TABLE #tblLibNote_FeeAccountID

CREATE TABLE #tblLibNote_FeeAccountID (
LiabilityNoteAccountID  UNIQUEIDENTIFIER,
FeeAccountID  UNIQUEIDENTIFIER
)

INSERT INTO #tblLibNote_FeeAccountID(LiabilityNoteAccountID,FeeAccountID)
Select liabilityNoteAccountID ,
ISNULL(feelibnote.AccountID,ISNULL(feelibType.AccountID,@fundAccountID)) as FeeAccountID
from #tblliabilityNoteAccountID ln
Left Join #tblFee feelibnote on feelibnote.accountid = ln.liabilityNoteAccountID
Left Join #tblFee feelibType on feelibType.accountid = ln.liabilityTypeID


---=================================================
IF OBJECT_ID('tempdb..#tblInterestExpence') IS NOT NULL         
	DROP TABLE #tblInterestExpence


CREATE Table #tblInterestExpence(
	InterestExpenseScheduleID int,
	AccountID UNIQUEIDENTIFIER,
	AdditionalAccountID UNIQUEIDENTIFIER,
	EventID UNIQUEIDENTIFIER,
	EffectiveStartDate date,
	InitialInterestAccrualEndDate date,
	PaymentDayOfMonth int,
	PaymentDateBusinessDayLag int,
	DeterminationDateLeadDays int,
	DeterminationDateReferenceDayOftheMonth int,
	InitialIndexValueOverride decimal(28,15),
	FirstRateIndexResetDate date
)

INSERT INTO #tblInterestExpence(InterestExpenseScheduleID,AccountID,AdditionalAccountID,EventID,EffectiveStartDate,InitialInterestAccrualEndDate,PaymentDayOfMonth,PaymentDateBusinessDayLag,DeterminationDateLeadDays,DeterminationDateReferenceDayOftheMonth,InitialIndexValueOverride,FirstRateIndexResetDate)
Select
Es.InterestExpenseScheduleID,
E.AccountID,
E.AdditionalAccountID,
E.EventID,
E.EffectiveStartDate as EffectiveDate,
Es.InitialInterestAccrualEndDate,
Es.PaymentDayOfMonth,
Es.PaymentDateBusinessDayLag,
Es.DeterminationDateLeadDays,
Es.DeterminationDateReferenceDayOftheMonth,
Es.InitialIndexValueOverride,
Es.FirstRateIndexResetDate
FROM [CORE].[InterestExpenseSchedule] Es
Inner Join core.Event e on e.EventID = Es.EventID
Inner join core.account acc on acc.accountid = e.accountid
Where e.StatusID=1 
and e.AccountID in (
	Select liabilityNoteAccountID from #tblliabilityNoteAccountID	
	UNION
	Select @fundAccountID
)

INSERT INTO #tblInterestExpence(InterestExpenseScheduleID,AccountID,AdditionalAccountID,EventID,EffectiveStartDate,InitialInterestAccrualEndDate,PaymentDayOfMonth,PaymentDateBusinessDayLag,DeterminationDateLeadDays,DeterminationDateReferenceDayOftheMonth,InitialIndexValueOverride,FirstRateIndexResetDate)
Select
Es.InterestExpenseScheduleID,
E.AccountID,
E.AdditionalAccountID,
E.EventID,
E.EffectiveStartDate as EffectiveDate,
Es.InitialInterestAccrualEndDate,
Es.PaymentDayOfMonth,
Es.PaymentDateBusinessDayLag,
Es.DeterminationDateLeadDays,
Es.DeterminationDateReferenceDayOftheMonth,
Es.InitialIndexValueOverride,
Es.FirstRateIndexResetDate
FROM [CORE].[InterestExpenseSchedule] Es
Inner Join core.Event e on e.EventID = Es.EventID
Inner join core.account acc on acc.accountid = e.accountid
Where e.StatusID=1 and e.additionalaccountid = @fundAccountID
and e.AccountID in (
	Select liabilityTypeID from #tblliabilityNoteAccountID	
)


IF OBJECT_ID('tempdb..#tblLibNote_IntExpAccountID') IS NOT NULL         
	DROP TABLE #tblLibNote_IntExpAccountID

CREATE TABLE #tblLibNote_IntExpAccountID (
LiabilityNoteAccountID  UNIQUEIDENTIFIER,
IntExpAccountID  UNIQUEIDENTIFIER
)

INSERT INTO #tblLibNote_IntExpAccountID(LiabilityNoteAccountID,IntExpAccountID)
Select liabilityNoteAccountID ,
ISNULL(IntExplibnote.AccountID,ISNULL(IntExplibType.AccountID,@fundAccountID)) as IntExpAccountID
from #tblliabilityNoteAccountID ln
Left Join #tblInterestExpence IntExplibnote on IntExplibnote.accountid = ln.liabilityNoteAccountID
Left Join #tblInterestExpence IntExplibType on IntExplibType.accountid = ln.liabilityTypeID




-----===================================================
DECLARE @tTableAlias as table  
(  
	ID int identity(1,1),  
	[Name] NVARCHAR(100),
	[GroupName] NVARCHAR(100) 
) 



Select 'cre' as engine
Insert into @tTableAlias([Name]) values('root')
---========================================

Declare @period_start_date date;
Declare @period_end_date date;

Select @period_start_date = MIN(dt.originationdate), @period_end_date = MAX(gsetupdt.InitialMaturityDate)
from cre.debt dt 
left Join (
	Select acc.AccountID,e.EffectiveStartDate,Commitment,InitialMaturityDate,ExitFee,ExtensionFees
	from [CORE].GeneralSetupDetailsDebt gslia
	INNER JOIN [CORE].[Event] e on e.EventID = gslia.EventId
	INNER JOIN 
	(						
		Select eve.AccountID,MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
		from [CORE].[Event] eve	
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'GeneralSetupDetailsDebt')
		and acc.IsDeleted <> 1
		and eve.StatusID = 1
		GROUP BY eve.AccountID,EventTypeID,eve.StatusID

	) sEvent
	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	where e.StatusID = 1 and acc.IsDeleted <> 1
)gsetupdt on gsetupdt.AccountID = dt.AccountID
Where dt.accountid in (Select Distinct liabilityTypeID from #tblliabilityNoteAccountID)


select ISNULL(CONVERT(VARCHAR, @period_start_date,101),'')  as period_start_date
,ISNULL(CONVERT(VARCHAR, @period_end_date,101),'')  as period_end_date
,'' as root_note_id
,1 as calc_basis
,0 as debug
,@UseServicingActual as use_servicingactual
,0 as accountingclose
,@AnalysisID as AnalysisID
 ,@AccountName AS client_reference_id
 ,@batch as [batch]
 ,0 as isCalcStarted
 ,0 as isCalcCancel
Insert into @tTableAlias([Name]) values('root.data') 
---========================================

IF OBJECT_ID('tempdb..#tNoteEffectiveDates') IS NOT NULL         
	DROP TABLE #tNoteEffectiveDates

create table #tNoteEffectiveDates  
(  
	LiabilityNoteID NVARCHAR(256),  
	LiabilityNoteAccountID UNIQUEIDENTIFIER,  
	EffectiveDate date  
)  
INSERT INTO #tNoteEffectiveDates(LiabilityNoteID,LiabilityNoteAccountID,EffectiveDate)

Select Distinct LiabilityNoteID,LiabilityNoteAccountID,EffectiveDate
From(
	Select Distinct ln.LiabilityNoteID,lrss.LiabilityNoteAccountID,rss.EffectiveDate 
	from #tblLibNote_RSSAccountID lrss
	Inner join #tblRSS rss on rss.AccountID = lrss.RSSAccountID
	Inner join #tblliabilityNoteAccountID ln on ln.liabilityNoteAccountID = lrss.LiabilityNoteAccountID
	Where rss.EffectiveDate  is not null

	UNION 

	Select Distinct ln.LiabilityNoteID,lfee.LiabilityNoteAccountID,fee.EffectiveDate 
	from #tblLibNote_feeAccountID lfee
	Inner join #tblfee fee on fee.AccountID = lfee.feeAccountID
	Inner join #tblliabilityNoteAccountID ln on ln.liabilityNoteAccountID = lfee.LiabilityNoteAccountID
	Where fee.EffectiveDate  is not null

	UNION

	Select Distinct ln.LiabilityNoteID,lfee.LiabilityNoteAccountID,fee.EffectiveStartDate as EffectiveDate 
	from #tblLibNote_IntExpAccountID   lfee
	Inner join #tblInterestExpence fee on fee.AccountID = lfee.IntExpAccountID
	Inner join #tblliabilityNoteAccountID ln on ln.liabilityNoteAccountID = lfee.LiabilityNoteAccountID
	where fee.EffectiveStartDate  is not null
)a



Select  CONVERT(VARCHAR, EffectiveDate,101) as effective_dates  
From(  
	Select Distinct EffectiveDate from #tNoteEffectiveDates   
)a  
order by a.EffectiveDate  
insert into @tTableAlias([Name]) values('root.data.effective_dates')  

---========================================

select CalendarName as HolidayTypeText,CONVERT(VARCHAR, HoliDayDate,101) HoliDayDate   
from App.HoliDays hd   
left join app.HoliDaysMaster hdm on hdm.HolidayMasterID = hd.HoliDayTypeID
where isnull(hd.isSoftHoliday,0)<>3
Order by CalendarName,CAST(HoliDayDate as date)  
insert into @tTableAlias([Name]) values('root.data.calendar')  
  
---========================================  
-----------------INdex Data----------
Declare @IndexName nvarchar(256) = null;  

SET @IndexName = (  
Select im.indexesname as IndexName  
from core.analysisParameter ap  
left join core.indexesmaster im on im.IndexesMasterID = ap.IndexScenarioOverride  
where analysisid = @AnalysisID
)  

if(@IndexName is null)  
BEGIN  
SET @IndexName = 'Default Index';  
END  


IF OBJECT_ID('tempdb..#tblNote_indexName') IS NOT NULL         
	DROP TABLE #tblNote_indexName

CREATE TABLE #tblNote_indexName 
(  
	IndexName nvarchar(100)  
)  
  
Delete from #tblNote_indexName  
INSERT INTO #tblNote_indexName (IndexName)  
Select Distinct IndexNameText from #tblRSS
--Values('1M LIBOR'),
--('1M Term SOFR'),
--('3M Term SOFR')



IF OBJECT_ID('tempdb..#tblindex') IS NOT NULL         
	DROP TABLE #tblindex


CREATE TABLE #tblindex 
(   
[Date] date,  
[value] decimal(28,7),  
IndexName nvarchar(100)  
)   
  
Delete from #tblindex  
INSERT INTO #tblindex ([Date],[value],IndexName)  
  
Select   
CONVERT(VARCHAR, i.[date],101) as date,  
Cast(ISNULL(i.[value],0) as decimal(28,7)) as [value],  
ISNULL(LOWER(l.name),'')  as IndexName  
from core.Indexes i  
Inner Join core.indexesmaster im on im.IndexesMasterID = i.IndexesMasterID  
left JOin core.lookup l on l.lookupid = i.IndexType  
where im.IndexesName = @IndexName  
and i.[date] is not null  
and l.name in (Select IndexName from #tblNote_indexName)  
---and i.[date] >= DATEADD(day,-5,@min_closingDate)  
order by CAST(i.[Date] as Date)  
  
  
Select indexname,
CONVERT(VARCHAR, [date],101) as date,  
Cast(ISNULL([value],0) as decimal(28,7)) as [value]   
from #tblindex  
order by IndexName,cAST([Date] as Date)  

insert into @tTableAlias([Name]) values('root.data.index')  
---========================================
  
SELECT @fundAccountID as LiabilityAccountID,ln.LiabilityTypeID as LiabilityTypeID,ln.AccountID as LiabilityNoteAccountID,ln.LiabilityNoteID,ln.LiabilityNoteID as id,acc.Name as [name] 
,tblLibtype.[LiabilityTypeName] as [type], CONVERT(VARCHAR, gsetupLia.PledgeDate,101) as PledgeDate,'liabilitynote' as grptype
,lDebtEquityTypeID.name as libnotetype
FROM cre.liabilitynote ln
LEFT JOIN core.Account acc on ln.AccountID = acc.AccountID
left join core.AccountCategory lDebtEquityTypeID on lDebtEquityTypeID.AccountCategoryid = ln.DebtEquityTypeID
LEFT JOIN (
Select acc.AccountID,MIN(PledgeDate) as PledgeDate
	from [CORE].GeneralSetupDetailsLiabilityNote gslia
	INNER JOIN [CORE].[Event] e on e.EventID = gslia.EventId
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	where e.StatusID = 1 and acc.IsDeleted <> 1
	Group by acc.AccountID
)gsetupLia on gsetupLia.AccountID = ln.AccountID
Left Join(  
	Select acc.AccountID as AccountID,acc.name as [LiabilityTypeName] 
	from cre.Debt d 
	Inner Join core.Account acc on acc.AccountID =  d.AccountID 
	Left Join core.accountCategory ac on ac.accountCategoryID = acc.accountTypeId
	where IsDeleted<> 1
	and d.accountid in (Select liabilityTypeID from #tblliabilityNoteAccountID)

	UNION ALL

	Select acc.AccountID as AccountID,acc.name as [LiabilityTypeName] 
	from cre.Equity d 
	Inner Join core.Account acc on acc.AccountID =  d.AccountID 
	Left Join core.accountCategory ac on ac.accountCategoryID = acc.accountTypeId
	where IsDeleted<> 1
	and d.accountid = @fundAccountID

	UNION ALL

	Select acc.AccountID as AccountID,acc.name as [LiabilityTypeName] 
	from cre.CASH ch 
	Inner Join core.Account acc on acc.AccountID =  ch.AccountID 
	Left Join core.accountCategory ac on ac.accountCategoryID = acc.accountTypeId
	where IsDeleted<> 1
	and ch.accountid in (Select liabilityTypeID from #tblliabilityNoteAccountID)

)tblLibtype on tblLibtype.AccountID = ln.LiabilityTypeID  
where acc.IsDeleted <> 1
and ln.AccountID in (Select liabilityNoteAccountID from #tblliabilityNoteAccountID)

insert into @tTableAlias([Name]) values('root.data.notes')  
---========================================


Select LiabilityNoteID,CONVERT(VARCHAR, EffectiveDate,101) as EffectiveDate from #tNoteEffectiveDates
insert into @tTableAlias([Name]) values('root.data.notes.LiabilityNote.effectivedate')  
---========================================

Select ln.LiabilityNoteID,CONVERT(VARCHAR, tr.Date,101) as Date,tr.Amount as TransactionAmount,tr.TransactionType,tr.EndingBalance
from cre.TransactionEntryLiability tr
Inner join cre.liabilitynote ln on ln.accountid = tr.LiabilityNoteAccountID
Where tr.TransactionType <> 'InterestPaid'
and ln.AccountID in (Select liabilityNoteAccountID from #tblliabilityNoteAccountID)

insert into @tTableAlias([Name]) values('root.data.notes.LiabilityNote.notebalance')  


---========================================


Select 
ln.liabilityNoteID
,ln.liabilityNoteID as CRENoteID
,ln.accountid as NoteID
,ISNULL(CONVERT(VARCHAR, tblDtMinEffDate.min_EffectiveStartDate,101),'') as min_effective_dates

,(CASE WHEN ln.UseNoteLevelOverride = 1 THEN ISNULL(ln.PaymentFrequency,0) ELSE ISNULL(tblDtExt.PaymentFrequency,0) END) as payfreq
--,(CASE WHEN ln.UseNoteLevelOverride = 1 THEN ISNULL(CONVERT(VARCHAR, ln.InitialInterestAccrualEndDate,101),'') ELSE ISNULL(CONVERT(VARCHAR, tblDtExt.InitialInterestAccrualEndDate,101),'') END) as initaccenddt
,(CASE WHEN ln.UseNoteLevelOverride = 1 THEN ISNULL(ln.AccrualEndDateBusinessDayLag,0) ELSE ISNULL(tblDtExt.AccrualEndDateBusinessDayLag,0) END) as accenddatebusidaylag 
,(CASE WHEN ln.UseNoteLevelOverride = 1 THEN ISNULL(ln.AccrualFrequency,0) ELSE ISNULL(tblDtExt.AccrualFrequency,0) END) as accfreq
--,(CASE WHEN ln.UseNoteLevelOverride = 1 THEN ISNULL(ln.PaymentDateBusinessDayLag,0) ELSE ISNULL(tblDtExt.PaymentDateBusinessDayLag,0) END) as paydatebusiessdaylag
--,(CASE WHEN ln.UseNoteLevelOverride = 1 THEN ISNULL(ln.DeterminationDateLeadDays,0) ELSE isnull(tblDtExt.DeterminationDateLeadDays ,0) END) as leaddays
--,(CASE WHEN ln.UseNoteLevelOverride = 1 THEN ISNULL(ln.DeterminationDateReferenceDayOftheMonth,0) ELSE isnull(tblDtExt.DeterminationDateReferenceDayOftheMonth ,0) END) as determidayrefdayofmnth 
,(CASE WHEN ln.UseNoteLevelOverride = 1 THEN UPPER(ISNULL(lroundedMethod.name,'')) ELSE UPPER(isnull(tblDtExt.roundmethodtext,'')) END) as roundmethod
,(CASE WHEN ln.UseNoteLevelOverride = 1 THEN ISNULL(ln.IndexRoundingRule, 1000) ELSE ISNULL(tblDtExt.IndexRoundingRule, 1000) END) as [precision]
,(CASE WHEN ln.UseNoteLevelOverride = 1 THEN ISNULL(ln.FinanacingSpreadRate, 0) ELSE ISNULL(tblDtExt.FinanacingSpreadRate, 0) END) as FinanacingSpreadRate
,(CASE WHEN ln.UseNoteLevelOverride = 1 THEN ISNULL(lIntActMethod.Name,'') ELSE isnull(tblDtExt.intactmethodtext,'') END) as intactmethod
,(CASE WHEN ln.UseNoteLevelOverride = 1 THEN ISNULL(lDefaultIndexName.Name,'') ELSE isnull(tblDtExt.defaultindexnm,'') END) as defaultindexnm
,(CASE WHEN ln.UseNoteLevelOverride = 1 THEN ISNULL(ln.TargetAdvanceRate, 0) ELSE ISNULL(tblDtExt.TargetAdvanceRate, 0) END) as targetadvrate
--,(CASE WHEN ln.UseNoteLevelOverride = 1 THEN ISNULL(ln.PaymentDayOfMonth, 0) ELSE ISNULL(tblDtExt.PaymentDayOfMonth, 0) END) as accperpaydaywhennoteomnth
--,(CASE WHEN ln.UseNoteLevelOverride = 1 THEN ISNULL(ln.InitialIndexValueOverride, 0) ELSE ISNULL(tblDtExt.InitialIndexValueOverride, 0) END) as initindex
--,(CASE WHEN ln.UseNoteLevelOverride = 1 THEN ISNULL(CONVERT(VARCHAR, ln.FirstRateIndexResetDate,101),'') ELSE ISNULL(CONVERT(VARCHAR, tblDtExt.FirstRateIndexResetDate,101),'') END) as initresetdt

,(CASE WHEN ln.UseNoteLevelOverride = 1 THEN ISNULL(lpmtdtaccper.Name, 'Current') ELSE ISNULL(tblDtExt.pmtdtaccpertext, 'Current') END) as pmtdtaccper
,(CASE WHEN ln.UseNoteLevelOverride = 1 THEN ISNULL(lResetIndexDaily.name , 'N') ELSE ISNULL(tblDtExt.ResetIndexDailytext , 'N') END) as ResetIndexDaily

,ISNULL(CONVERT(VARCHAR, dt.OriginationDate,101),'') as initpmtdt
,ISNULL(CONVERT(VARCHAR, dt.OriginationDate,101),'') as clsdt
,isnull(null,0) as perenddtbuslag
,isnull(null,'') as expectedmaturitydate

,ISNULL(CONVERT(VARCHAR,gsetupdt.InitialMaturityDate,101),'') as initmatdt
,ISNULL(CONVERT(VARCHAR,gsetupdt.InitialMaturityDate,101),'') as contractmat

,ISNULL(tblDtExt.pydt_detdt_hlday_ls , 'US')  as pydt_detdt_hlday_ls

FROM cre.liabilitynote ln
Inner Join core.account acc on acc.accountid = ln.accountid
Left Join cre.debt dt on dt.accountid = ln.liabilityTypeID
Left Join core.lookup lroundedMethod on lroundedMethod.lookupid = ln.Roundingmethod
Left Join core.lookup lIntActMethod on lIntActMethod.lookupid = ln.IntActMethod
Left Join core.lookup lDefaultIndexName on lDefaultIndexName.lookupid = ln.DefaultIndexName
Left Join core.lookup lpmtdtaccper on lpmtdtaccper.lookupid = ln.pmtdtaccper
Left Join core.lookup lResetIndexDaily on lResetIndexDaily.lookupid = ln.ResetIndexDaily
left Join (
	Select acc.AccountID,e.EffectiveStartDate,Commitment,InitialMaturityDate,ExitFee,ExtensionFees
	from [CORE].GeneralSetupDetailsDebt gslia
	INNER JOIN [CORE].[Event] e on e.EventID = gslia.EventId
	INNER JOIN 
	(						
		Select eve.AccountID,MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
		from [CORE].[Event] eve	
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'GeneralSetupDetailsDebt')
		and acc.IsDeleted <> 1
		and eve.StatusID = 1
		GROUP BY eve.AccountID,EventTypeID,eve.StatusID

	) sEvent
	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	where e.StatusID = 1 and acc.IsDeleted <> 1
)gsetupdt on gsetupdt.AccountID = dt.AccountID

Left join(
	Select acc.AccountID,MIN(e.EffectiveStartDate) as min_EffectiveStartDate
	from [CORE].GeneralSetupDetailsDebt gslia
	INNER JOIN [CORE].[Event] e on e.EventID = gslia.EventId
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	where e.StatusID = 1 and acc.IsDeleted <> 1
	group by  acc.AccountID
)tblDtMinEffDate on tblDtMinEffDate.AccountID = dt.AccountID

Left join(
	Select d.AccountID
	,dex.PaymentFrequency
	--,dex.InitialInterestAccrualEndDate
	,dex.AccrualEndDateBusinessDayLag
	,dex.AccrualFrequency
	--,dex.PaymentDayOfMonth
	--,dex.PaymentDateBusinessDayLag
	--,dex.DeterminationDateLeadDays
	--,dex.DeterminationDateReferenceDayOftheMonth
	,dex.Roundingmethod
	,isnull(lroundedMethod.name,'') as roundmethodtext
	,dex.IndexRoundingRule
	,dex.FinanacingSpreadRate
	,dex.IntActMethod
	,isnull(lIntActMethod.name,'') as intactmethodtext
	,dex.DefaultIndexName
	,isnull(lDefaultIndexName.name,'') as defaultindexnm
	,dex.TargetAdvanceRate
	--,dex.InitialIndexValueOverride
	--,dex.FirstRateIndexResetDate
	,dex.pmtdtaccper
	,isnull(lpmtdtaccper.name,'Current') as pmtdtaccpertext
	,dex.ResetIndexDaily 
	,isnull(lResetIndexDaily.name,'N') as ResetIndexDailytext
	,dex.DeterminationDateHolidayList
	,isnull(LDeterminationDateHolidayList.CalendarName,'US') as pydt_detdt_hlday_ls
	
	from cre.Debt d
	left join cre.debtext dex on d.accountid = dex.DebtAccountID
	Left Join core.lookup lroundedMethod on lroundedMethod.lookupid = dex.Roundingmethod
	Left Join core.lookup lIntActMethod on lIntActMethod.lookupid = dex.IntActMethod
	Left Join core.lookup lDefaultIndexName on lDefaultIndexName.lookupid = dex.DefaultIndexName	
	Left Join core.lookup lpmtdtaccper on lpmtdtaccper.lookupid = dex.pmtdtaccper
	Left Join core.lookup lResetIndexDaily on lResetIndexDaily.lookupid = dex.ResetIndexDaily
	LEFT JOIN app.HoliDaysMaster LDeterminationDateHolidayList ON LDeterminationDateHolidayList.HolidayMasterID = dex.DeterminationDateHolidayList
	Where dex.AdditionalAccountID = @fundAccountID

)tblDtExt on tblDtExt.AccountID = ln.liabilityTypeID

where acc.isdeleted <> 1
and ln.accountid in (Select liabilityNoteAccountID from #tblliabilityNoteAccountID)

insert into @tTableAlias([Name]) values('root.data.notes.LiabilityNote.effectivedate.LiabilityNoteDetail')




---========================================


Select ln.LiabilityNoteID
,ln.liabilityNoteAccountID
--ln.liabilityNoteID
--,ln.liabilityNoteID as CRENoteID
--,ln.liabilityNoteAccountID as NoteID
,ISNULL(CONVERT(VARCHAR, fee.EffectiveStartDate,101),'') as EffectiveDate
,ISNULL(CONVERT(VARCHAR, fee.InitialInterestAccrualEndDate,101),'')  as initaccenddt
,ISNULL(fee.PaymentDateBusinessDayLag,0) as paydatebusiessdaylag
,isnull(fee.DeterminationDateLeadDays ,0)  as leaddays
,isnull(fee.DeterminationDateReferenceDayOftheMonth ,0)  as determidayrefdayofmnth 
,ISNULL(fee.PaymentDayOfMonth, 0)  as accperpaydaywhennoteomnth
,CASE WHEN fee.InitialIndexValueOverride = 0 THEN NULL ELSE fee.InitialIndexValueOverride END  as initindex	--doing forcefull NULL when Zero
,ISNULL(CONVERT(VARCHAR, fee.FirstRateIndexResetDate,101),'')  as initresetdt 
from #tblLibNote_IntExpAccountID   lfee
Inner join #tblInterestExpence fee on fee.AccountID = lfee.IntExpAccountID
Inner join #tblliabilityNoteAccountID ln on ln.liabilityNoteAccountID = lfee.LiabilityNoteAccountID
where fee.EffectiveStartDate  is not null
insert into @tTableAlias([Name]) values('root.data.notes.LiabilityNote.effectivedate.LiabilityNoteDetailByEffectiveDate')


---=============================
IF OBJECT_ID('tempdb..#tRateSpreadSchedule') IS NOT NULL         
	DROP TABLE #tRateSpreadSchedule

CREATE TABLE #tRateSpreadSchedule 
(  
	ID int identity(1,1),  
	ValueTypeID int,  
	Name NVARCHAR(100)  
)  

Insert into #tRateSpreadSchedule  
Select distinct rss.ValuetypeID,replace(lower(rss.ValueTypeText),' ','_') 
from #tblLibNote_RSSAccountID lrss
Inner join #tblRSS rss on rss.AccountID = lrss.RSSAccountID
Inner join #tblliabilityNoteAccountID ln on ln.liabilityNoteAccountID = lrss.LiabilityNoteAccountID
Where rss.EffectiveDate  is not null
and rss.ValueTypeText  is not null


declare @cnt int=1,
@ValueTypeID nvarchar(50),
@Name nvarchar(100),
@totalCntRateSpread int, 
@RateSpreadSchedule nvarchar(max)  


select @totalCntRateSpread = count(1) from #tRateSpreadSchedule  

while (@cnt<=@totalCntRateSpread)  
BEGIN  
  select @ValueTypeID=ValueTypeID,@Name=Name from #tRateSpreadSchedule where ID=@cnt  
   
 if(@Name = 'rate')  
 BEGIN  

   set @RateSpreadSchedule='Select Distinct LiabilityNoteID, liabilityNoteAccountID,  
   CONVERT(VARCHAR, EffectiveDate,101) as EffectiveDate,  
   CONVERT(VARCHAR, startdt,101) as startdt,  
   valtype,  
   val,  
   intcalcdays,  
   detdt_hlday_ls,  
   LOWER(indexnametext) as indexnametext  
   from  
   (  
		Select ln.liabilityNoteID as LiabilityNoteID 
		,ln.liabilityNoteAccountID as liabilityNoteAccountID
		,rss.EffectiveDate
		,rss.Date as startdt
		,'''+@Name+''' as valtype
		,isnull(rss.Value,0) as val ,  
		ISNULL(rss.IntCalcMethodID,0) as intcalcdays  
		,(CASE WHEN ISNULL(DeterminationDateHolidayListText,'''') = ''US & UK'' Then ''US_and_UK'' ELSE ISNULL(DeterminationDateHolidayListText,'''') END)  as detdt_hlday_ls  
		,ISNULL(IndexNameText,'''') as indexnametext 
		from #tblLibNote_RSSAccountID lrss
		Inner join #tblRSS rss on rss.AccountID = lrss.RSSAccountID
		Inner join #tblliabilityNoteAccountID ln on ln.liabilityNoteAccountID = lrss.LiabilityNoteAccountID
		Where rss.EffectiveDate  is not null
		and ValueTypeID='''+@ValueTypeID+''' 
  
		union all  
  
		Select ln.liabilityNoteID as LiabilityNoteID 
		,ln.liabilityNoteAccountID as liabilityNoteAccountID
		,rss.EffectiveDate
		,rss.Date as startdt
		,'''+@Name+''' as valtype
		,isnull(rss.Value,0) as val ,  
		ISNULL(rss.IntCalcMethodID,0) as intcalcdays  
		,(CASE WHEN ISNULL(DeterminationDateHolidayListText,'''') = ''US & UK'' Then ''US_and_UK'' ELSE ISNULL(DeterminationDateHolidayListText,'''') END)  as detdt_hlday_ls  
		,ISNULL(IndexNameText,'''') as indexnametext 
		from #tblLibNote_RSSAccountID lrss
		Inner join #tblRSS rss on rss.AccountID = lrss.RSSAccountID
		Inner join #tblliabilityNoteAccountID ln on ln.liabilityNoteAccountID = lrss.LiabilityNoteAccountID
		Where rss.EffectiveDate  is not null
		and ValueTypeID=151 
  ) as [root.data.notes.LiabilityNote.effectivedate.'''+@Name+''']'  

 END  
 ELSE if(@Name = 'spread')  
 BEGIN  
   set @RateSpreadSchedule='Select Distinct LiabilityNoteID, liabilityNoteAccountID,  
   CONVERT(VARCHAR, EffectiveDate,101) as EffectiveDate,  
   CONVERT(VARCHAR, startdt,101) as startdt,  
   valtype,  
   val,  
   intcalcdays,  
   detdt_hlday_ls,  
   LOWER(indexnametext) as indexnametext  
   from  
   (  
		Select ln.liabilityNoteID as LiabilityNoteID 
		,ln.liabilityNoteAccountID as liabilityNoteAccountID
		,rss.EffectiveDate
		,rss.Date as startdt
		,'''+@Name+''' as valtype
		,isnull(rss.Value,0) as val ,  
		ISNULL(rss.IntCalcMethodID,0) as intcalcdays  
		,(CASE WHEN ISNULL(DeterminationDateHolidayListText,'''') = ''US & UK'' Then ''US_and_UK'' ELSE ISNULL(DeterminationDateHolidayListText,'''') END)  as detdt_hlday_ls  
		,ISNULL(IndexNameText,'''') as indexnametext 
		from #tblLibNote_RSSAccountID lrss
		Inner join #tblRSS rss on rss.AccountID = lrss.RSSAccountID
		Inner join #tblliabilityNoteAccountID ln on ln.liabilityNoteAccountID = lrss.LiabilityNoteAccountID
		Where rss.EffectiveDate  is not null
		and ValueTypeID='''+@ValueTypeID+''' 
  
		union all  
  
		Select ln.liabilityNoteID as LiabilityNoteID 
		,ln.liabilityNoteAccountID as liabilityNoteAccountID
		,rss.EffectiveDate
		,rss.Date as startdt
		,'''+@Name+''' as valtype
		,isnull(rss.Value,0) as val ,  
		ISNULL(rss.IntCalcMethodID,0) as intcalcdays  
		,(CASE WHEN ISNULL(DeterminationDateHolidayListText,'''') = ''US & UK'' Then ''US_and_UK'' ELSE ISNULL(DeterminationDateHolidayListText,'''') END)  as detdt_hlday_ls  
		,ISNULL(IndexNameText,'''') as indexnametext 
		from #tblLibNote_RSSAccountID lrss
		Inner join #tblRSS rss on rss.AccountID = lrss.RSSAccountID
		Inner join #tblliabilityNoteAccountID ln on ln.liabilityNoteAccountID = lrss.LiabilityNoteAccountID
		Where rss.EffectiveDate  is not null
		and ValueTypeID=150
  ) as [root.data.notes.LiabilityNote.effectivedate.'''+@Name+''']'  
 END  
 ELSE  
 BEGIN  
  set @RateSpreadSchedule='Select Distinct LiabilityNoteID, liabilityNoteAccountID,  
  CONVERT(VARCHAR, EffectiveDate,101) as EffectiveDate,  
  CONVERT(VARCHAR, startdt,101) as startdt,  
  valtype,  
  val,  
  intcalcdays,  
  detdt_hlday_ls,  
  LOWER(indexnametext) as indexnametext  
  from  
  (  
		Select ln.liabilityNoteID as LiabilityNoteID 
		,ln.liabilityNoteAccountID as liabilityNoteAccountID
		,rss.EffectiveDate
		,rss.Date as startdt
		,'''+@Name+''' as valtype
		,isnull(rss.Value,0) as val ,  
		ISNULL(rss.IntCalcMethodID,0) as intcalcdays  
		,(CASE WHEN ISNULL(DeterminationDateHolidayListText,'''') = ''US & UK'' Then ''US_and_UK'' ELSE ISNULL(DeterminationDateHolidayListText,'''') END)  as detdt_hlday_ls  
		,ISNULL(IndexNameText,'''') as indexnametext 
		from #tblLibNote_RSSAccountID lrss
		Inner join #tblRSS rss on rss.AccountID = lrss.RSSAccountID
		Inner join #tblliabilityNoteAccountID ln on ln.liabilityNoteAccountID = lrss.LiabilityNoteAccountID
		Where rss.EffectiveDate  is not null
		and ValueTypeID='''+@ValueTypeID+''' 
 ) as [root.data.notes.LiabilityNote.effectivedate.'''+@Name+''']'  
 END  
  
 insert into @tTableAlias ([Name],GroupName) values('root.data.notes.LiabilityNote.effectivedate.'+@Name,'rate')  
 EXEC (@RateSpreadSchedule)  
 set @cnt+=1  
END  

---========================================


	select LiabilityNoteID, liabilityNoteAccountID,  
	CONVERT(VARCHAR, EffectiveDate,101) as EffectiveDate,  
	feename,  
	CONVERT(VARCHAR, startdt,101) as startdt,  
	CONVERT(VARCHAR, enddt,101) as enddt,  
	valtype,[type],  
	val ,ovrfeeamt,ovrbaseamt,trueupflag, levyldincl,basisincl, stripval,  
	CONVERT(VARCHAR, actual_startdt,101) as actual_startdt  ,
	feescheduleid
	from  
	(  
		Select ln.LiabilityNoteID as LiabilityNoteID,ln.liabilityNoteAccountID,fee.EffectiveDate,  
		ISNULL(fee.FeeName,'') as feename,   
		(CASE 
		WHEN (fe.FeeTypeNameID = fee.ValueTypeID) and fee.StartDate < fee.EffectiveDate  THEN fee.EffectiveDate  
		ELSE fee.StartDate END
		) as startdt,   
		--(CASE WHEN fee.EndDate is null  and (fe.FeeTypeNameID = fee.ValueTypeID) THEN @l_MaturityDate_ScenarioBased ELSE rs.EndDate END) as enddt,   
		fee.EndDate as enddt,
		fee.ValueTypeID as valtype,  
		fee.FeeTypeText as [type]  ,  
		ISNULL(fee.Value,0) as val ,  
		ISNULL(fee.FeeAmountOverride,0) as ovrfeeamt,  
		ISNULL(fee.BaseAmountOverride,0) as ovrbaseamt,  
  
		fee.ApplyTrueUpFeatureID as trueupflag,  

		ISNULL(fee.IncludedLevelYield,0) as levyldincl,  
		ISNULL(fee.IncludedBasis,0) as basisincl,  
		ISNULL(fee.FeetobeStripped,0) as stripval,  
		fee.StartDate as actual_startdt  ,
		fee.feescheduleid
		from #tblLibNote_feeAccountID lfee
		Inner join #tblfee fee on fee.AccountID = lfee.feeAccountID
		Inner join #tblliabilityNoteAccountID ln on ln.liabilityNoteAccountID = lfee.LiabilityNoteAccountID
		LEFT JOIN(
			Select	FeeTypeNameID,
			FS.FeeTypeNameText as feename	
			from [CRE].[FeeSchedulesConfig] FS
			LEFT JOIN [CORE].[Lookup] LFeePaymentFrequencyID ON LFeePaymentFrequencyID.LookupID = FS.FeePaymentFrequencyID AND LFeePaymentFrequencyID.ParentID=89 
			LEFT JOIN [CORE].[Lookup] LFeeCoveragePeriodID ON LFeeCoveragePeriodID.LookupID = FS.FeeCoveragePeriodID AND LFeeCoveragePeriodID.ParentID=90	
			where ISNULL(IsActive,1)  = 1
			and LFeePaymentFrequencyID.Name = 'Transaction Based'
			and LFeeCoveragePeriodID.Name = 'Open Period'
		)fe on fe.FeeTypeNameID =  fee.ValueTypeID  

		where fee.EffectiveDate  is not null
	) as [data.notes.setup.tables.fees]  
	order by liabilityNoteAccountID,EffectiveDate  
	
insert into @tTableAlias([Name]) values('root.data.notes.LiabilityNote.effectivedate.fees')  

----===================================


IF OBJECT_ID('tempdb..#tblliabilityunallocatedbls') IS NOT NULL         
	DROP TABLE #tblliabilityunallocatedbls


CREATE table #tblliabilityunallocatedbls(
	
	LiabilityTypeName nvarchar(256),
	id nvarchar(256),
	LiabilityAccountID UNIQUEIDENTIFIER,
	liabilityTypeID UNIQUEIDENTIFIER,
	[Date] date,
	Amount decimal(28,15),
	grptype nvarchar(256)
)

INSERT INTO #tblliabilityunallocatedbls(LiabilityTypeName,ID,LiabilityAccountID,LiabilityTypeID,[Date],Amount,grptype)
Select 	'unallocatedbls_' + acc.name as LiabilityTypeName
,'unallocatedbls_' + acc.name as ID
,@fundAccountID as LiabilityAccountID
,dt.Accountid as LiabilityTypeID	
,ISNULL(CONVERT(VARCHAR, tr.Date,101),'') as [Date]
,ISNULL(tr.Amount,0) as Amount
,'unallocatedbls' as grptype
from CRE.Transactionentry tr
Inner join cre.debt dt on dt.PortfolioAccountID = tr.accountid
Inner join core.account acc on acc.accountid = dt.accountid
Where tr.AnalysisID = @AnalysisID and 
dt.accountid in (Select liabilityTypeID from #tblliabilityNoteAccountID)



Select LiabilityTypeName,ID,LiabilityAccountID,LiabilityTypeID,'' as LiabilityNoteID,ISNULL(CONVERT(VARCHAR, Date,101),'') as [Date],Amount,grptype from #tblliabilityunallocatedbls
insert into @tTableAlias([Name]) values('root.data.notes.unallocatedbls')  




Select Distinct liabilityTypeID,'unallocatedbls_'+LiabilityTypeName as LiabilityTypeName,'' as LiabilityNoteID,CONVERT(VARCHAR, EffectiveDate,101) as EffectiveDate,a.EffectiveDate as OrderedDate
From(
	Select Distinct ln.liabilityTypeID,ln.LiabilityTypeName,rss.EffectiveDate 
	from  #tblRSS rss 
	Inner join #tblliabilityNoteAccountID ln on ln.liabilityTypeID = rss.AccountID
	Where rss.EffectiveDate  is not null

	UNION 

	Select Distinct ln.liabilityTypeID,ln.LiabilityTypeName,fee.EffectiveDate 
	from #tblfee fee 
	Inner join #tblliabilityNoteAccountID ln on ln.liabilityTypeID = fee.AccountID
	Where fee.EffectiveDate  is not null

	UNION

	Select Distinct fee.AccountID as liabilityTypeID,accdt.name as LiabilityTypeName,fee.EffectiveStartDate as EffectiveDate 
	from #tblInterestExpence fee 
	INNER JOIN [CORE].[Account] accdt ON accdt.AccountID = fee.AccountID
	where fee.EffectiveStartDate  is not null
)a
where liabilityTypeID in (Select Distinct LiabilityTypeID from #tblliabilityunallocatedbls)
Order by a.EffectiveDate
insert into @tTableAlias([Name]) values('root.data.notes.unallocatedbls.effectivedate')  






Select 
dt.AccountID as LiabilityTypeID,'' as LiabilityNoteID
,'unallocatedbls_'+ accdt.Name as LiabilityTypeName
,ISNULL(CONVERT(VARCHAR, tblDtMinEffDate.min_EffectiveStartDate,101),'') as min_effective_dates
,ISNULL(tblDtExt.PaymentFrequency,0)  as payfreq
--,ISNULL(CONVERT(VARCHAR, tblDtExt.InitialInterestAccrualEndDate,101),'')  as initaccenddt
,ISNULL(tblDtExt.AccrualEndDateBusinessDayLag,0)  as accenddatebusidaylag 
,ISNULL(tblDtExt.AccrualFrequency,0)  as accfreq
--,ISNULL(tblDtExt.PaymentDateBusinessDayLag,0)  as paydatebusiessdaylag
--,isnull(tblDtExt.DeterminationDateLeadDays ,0)  as leaddays
--,isnull(tblDtExt.DeterminationDateReferenceDayOftheMonth ,0)  as determidayrefdayofmnth 
,Upper(isnull(tblDtExt.roundmethodtext,''))  as roundmethod
,ISNULL(tblDtExt.IndexRoundingRule, 1000)  as [precision]
,ISNULL(tblDtExt.FinanacingSpreadRate, 0)  as FinanacingSpreadRate
,isnull(tblDtExt.intactmethodtext,'')  as intactmethod
,isnull(tblDtExt.defaultindexnm,'')  as defaultindexnm
,ISNULL(tblDtExt.TargetAdvanceRate, 0)  as targetadvrate
--,ISNULL(tblDtExt.PaymentDayOfMonth, 0)  as accperpaydaywhennoteomnth
--,CASE WHEN tblDtExt.InitialIndexValueOverride = 0 THEN NULL ELSE tblDtExt.InitialIndexValueOverride END as initindex	--doing forcefull NULL when Zero
--,ISNULL(CONVERT(VARCHAR, tblDtExt.FirstRateIndexResetDate,101),'') as initresetdt

,ISNULL(CONVERT(VARCHAR, dt.OriginationDate,101),'') as initpmtdt
,ISNULL(CONVERT(VARCHAR, dt.OriginationDate,101),'') as clsdt

,isnull(null,0) as perenddtbuslag
,isnull(null,'') as expectedmaturitydate

,ISNULL(CONVERT(VARCHAR,gsetupdt.InitialMaturityDate,101),'') as initmatdt
,ISNULL(CONVERT(VARCHAR,gsetupdt.InitialMaturityDate,101),'') as contractmat

,ISNULL(tblDtExt.pmtdtaccpertext, 'Current')  as pmtdtaccper
,ISNULL(tblDtExt.ResetIndexDailytext , 'N')  as ResetIndexDaily
,ISNULL(tblDtExt.pydt_detdt_hlday_ls , 'US')  as pydt_detdt_hlday_ls

FROM cre.debt dt 
INNER JOIN [CORE].[Account] accdt ON accdt.AccountID = dt.AccountID
left Join (
	Select acc.AccountID,e.EffectiveStartDate,Commitment,InitialMaturityDate,ExitFee,ExtensionFees
	from [CORE].GeneralSetupDetailsDebt gslia
	INNER JOIN [CORE].[Event] e on e.EventID = gslia.EventId
	INNER JOIN 
	(						
		Select eve.AccountID,MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
		from [CORE].[Event] eve	
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'GeneralSetupDetailsDebt')
		and acc.IsDeleted <> 1
		and eve.StatusID = 1
		GROUP BY eve.AccountID,EventTypeID,eve.StatusID

	) sEvent
	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	where e.StatusID = 1 and acc.IsDeleted <> 1
)gsetupdt on gsetupdt.AccountID = dt.AccountID

Left join(
	Select acc.AccountID,MIN(e.EffectiveStartDate) as min_EffectiveStartDate
	from [CORE].GeneralSetupDetailsDebt gslia
	INNER JOIN [CORE].[Event] e on e.EventID = gslia.EventId
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	where e.StatusID = 1 and acc.IsDeleted <> 1
	group by  acc.AccountID
)tblDtMinEffDate on tblDtMinEffDate.AccountID = dt.AccountID

Left join(
	Select d.AccountID
	,dex.PaymentFrequency
	--,dex.InitialInterestAccrualEndDate
	,dex.AccrualEndDateBusinessDayLag
	,dex.AccrualFrequency
	--,dex.PaymentDayOfMonth
	--,dex.PaymentDateBusinessDayLag
	--,dex.DeterminationDateLeadDays
	--,dex.DeterminationDateReferenceDayOftheMonth
	,dex.Roundingmethod
	,isnull(lroundedMethod.name,'') as roundmethodtext
	,dex.IndexRoundingRule
	,dex.FinanacingSpreadRate
	,dex.IntActMethod
	,isnull(lIntActMethod.name,'') as intactmethodtext
	,dex.DefaultIndexName
	,isnull(lDefaultIndexName.name,'') as defaultindexnm
	,dex.TargetAdvanceRate
	--,dex.InitialIndexValueOverride
	--,dex.FirstRateIndexResetDate
	,dex.pmtdtaccper
	,isnull(lpmtdtaccper.name,'Current') as pmtdtaccpertext
	,dex.ResetIndexDaily 
	,isnull(lResetIndexDaily.name,'N') as ResetIndexDailytext 
	,dex.DeterminationDateHolidayList
	,isnull(LDeterminationDateHolidayList.CalendarName,'US') as pydt_detdt_hlday_ls
	from cre.Debt d
	left join cre.debtext dex on d.accountid = dex.DebtAccountID
	Left Join core.lookup lroundedMethod on lroundedMethod.lookupid = dex.Roundingmethod
	Left Join core.lookup lIntActMethod on lIntActMethod.lookupid = dex.IntActMethod
	Left Join core.lookup lDefaultIndexName on lDefaultIndexName.lookupid = dex.DefaultIndexName	
	Left Join core.lookup lpmtdtaccper on lpmtdtaccper.lookupid = dex.pmtdtaccper
	Left Join core.lookup lResetIndexDaily on lResetIndexDaily.lookupid = dex.ResetIndexDaily
	LEFT JOIN app.HoliDaysMaster LDeterminationDateHolidayList ON LDeterminationDateHolidayList.HolidayMasterID = dex.DeterminationDateHolidayList
	Where dex.AdditionalAccountID = @fundAccountID

)tblDtExt on tblDtExt.AccountID = dt.AccountID
where accdt.isdeleted <> 1
and dt.accountid in (Select liabilityTypeID from #tblliabilityNoteAccountID)

and dt.AccountID in (Select Distinct LiabilityTypeID from #tblliabilityunallocatedbls)

insert into @tTableAlias([Name]) values('root.data.notes.unallocatedbls.effectivedate.unallocatedblsDetail')




Select fee.AccountID as LiabilityTypeID,'' as LiabilityNoteID
,'unallocatedbls_'+ accdt.Name as LiabilityTypeName
,ISNULL(CONVERT(VARCHAR, fee.EffectiveStartDate,101),'') as EffectiveDate
,ISNULL(CONVERT(VARCHAR, fee.InitialInterestAccrualEndDate,101),'')  as initaccenddt
,ISNULL(fee.PaymentDateBusinessDayLag,0) as paydatebusiessdaylag
,isnull(fee.DeterminationDateLeadDays ,0)  as leaddays
,isnull(fee.DeterminationDateReferenceDayOftheMonth ,0)  as determidayrefdayofmnth 
,ISNULL(fee.PaymentDayOfMonth, 0)  as accperpaydaywhennoteomnth
,CASE WHEN fee.InitialIndexValueOverride = 0 THEN NULL ELSE fee.InitialIndexValueOverride END  as initindex	--doing forcefull NULL when Zero
,ISNULL(CONVERT(VARCHAR, fee.FirstRateIndexResetDate,101),'')  as initresetdt 
from #tblInterestExpence fee 
INNER JOIN [CORE].[Account] accdt ON accdt.AccountID = fee.AccountID
where fee.EffectiveStartDate  is not null
and fee.AccountID in (Select Distinct LiabilityTypeID from #tblliabilityunallocatedbls)
insert into @tTableAlias([Name]) values('root.data.notes.unallocatedbls.effectivedate.unallocatedblsDetailByEffectiveDate')



IF OBJECT_ID('tempdb..#tRateSpreadSchedule_dt') IS NOT NULL         
	DROP TABLE #tRateSpreadSchedule_dt

CREATE TABLE #tRateSpreadSchedule_dt
(  
	ID int identity(1,1),  
	ValueTypeID int,  
	Name NVARCHAR(100)  
)  

Insert into #tRateSpreadSchedule_dt  
Select distinct rss.ValuetypeID,replace(lower(rss.ValueTypeText),' ','_') 
from #tblRSS rss 
Inner join #tblliabilityNoteAccountID ln on ln.liabilityTypeID = rss.AccountID
Where rss.EffectiveDate  is not null
and rss.ValueTypeText  is not null
and ln.liabilityTypeID in (Select Distinct LiabilityTypeID from #tblliabilityunallocatedbls)


declare @cnt_dt int=1,
@ValueTypeID_dt nvarchar(50),
@Name_dt nvarchar(100),
@totalCntRateSpread_dt int, 
@RateSpreadSchedule_dt nvarchar(max)  


select @totalCntRateSpread_dt = count(1) from #tRateSpreadSchedule_dt  

while (@cnt_dt<=@totalCntRateSpread_dt)  
BEGIN  
  select @ValueTypeID_dt=ValueTypeID,@Name_dt=Name from #tRateSpreadSchedule_dt where ID=@cnt_dt
   
 if(@Name_dt = 'rate')  
 BEGIN  

   set @RateSpreadSchedule_dt='Select Distinct liabilityTypeID, ''unallocatedbls_'' + liabilityTypeName as LiabilityTypeName,
   CONVERT(VARCHAR, EffectiveDate,101) as EffectiveDate,  
   CONVERT(VARCHAR, startdt,101) as startdt,  
   valtype,  
   val,  
   intcalcdays,  
   detdt_hlday_ls,  
   LOWER(indexnametext) as indexnametext  
   from  
   (  
		Select ln.liabilityTypeID
		,ln.liabilityTypeName
		,rss.EffectiveDate
		,rss.Date as startdt
		,'''+@Name_dt+''' as valtype
		,isnull(rss.Value,0) as val ,  
		ISNULL(rss.IntCalcMethodID,0) as intcalcdays  
		,(CASE WHEN ISNULL(DeterminationDateHolidayListText,'''') = ''US & UK'' Then ''US_and_UK'' ELSE ISNULL(DeterminationDateHolidayListText,'''') END)  as detdt_hlday_ls  
		,ISNULL(IndexNameText,'''') as indexnametext 
		from #tblRSS rss 
		Inner join #tblliabilityNoteAccountID ln on ln.liabilityTypeID = rss.AccountID
		Where rss.EffectiveDate  is not null
		and ValueTypeID='''+@ValueTypeID_dt+''' 
		and ln.liabilityTypeID in (Select Distinct LiabilityTypeID from #tblliabilityunallocatedbls)
  
		union all  
  
		Select ln.liabilityTypeID
		,ln.liabilityTypeName
		,rss.EffectiveDate
		,rss.Date as startdt
		,'''+@Name_dt+''' as valtype
		,isnull(rss.Value,0) as val ,  
		ISNULL(rss.IntCalcMethodID,0) as intcalcdays  
		,(CASE WHEN ISNULL(DeterminationDateHolidayListText,'''') = ''US & UK'' Then ''US_and_UK'' ELSE ISNULL(DeterminationDateHolidayListText,'''') END)  as detdt_hlday_ls  
		,ISNULL(IndexNameText,'''') as indexnametext 
		from #tblRSS rss 
		Inner join #tblliabilityNoteAccountID ln on ln.liabilityTypeID = rss.AccountID
		Where rss.EffectiveDate  is not null
		and ValueTypeID=151 
		and ln.liabilityTypeID in (Select Distinct LiabilityTypeID from #tblliabilityunallocatedbls)

  ) as [root.data.notes.LiabilityNote.effectivedate.'''+@Name_dt+''']'  
  


 END  
 ELSE if(@Name_dt = 'spread')  
 BEGIN  
   set @RateSpreadSchedule_dt='Select Distinct liabilityTypeID, ''unallocatedbls_''+liabilityTypeName as LiabilityTypeName, 
   CONVERT(VARCHAR, EffectiveDate,101) as EffectiveDate,  
   CONVERT(VARCHAR, startdt,101) as startdt,  
   valtype,  
   val,  
   intcalcdays,  
   detdt_hlday_ls,  
   LOWER(indexnametext) as indexnametext  
   from  
   (  
		Select ln.liabilityTypeID
		,ln.liabilityTypeName
		,rss.EffectiveDate
		,rss.Date as startdt
		,'''+@Name_dt+''' as valtype
		,isnull(rss.Value,0) as val ,  
		ISNULL(rss.IntCalcMethodID,0) as intcalcdays  
		,(CASE WHEN ISNULL(DeterminationDateHolidayListText,'''') = ''US & UK'' Then ''US_and_UK'' ELSE ISNULL(DeterminationDateHolidayListText,'''') END)  as detdt_hlday_ls  
		,ISNULL(IndexNameText,'''') as indexnametext 
		from #tblRSS rss 
		Inner join #tblliabilityNoteAccountID ln on ln.liabilityTypeID = rss.AccountID
		Where rss.EffectiveDate  is not null
		and ValueTypeID='''+@ValueTypeID_dt+''' 
		and ln.liabilityTypeID in (Select Distinct LiabilityTypeID from #tblliabilityunallocatedbls)
  
		union all  
  
		Select ln.liabilityTypeID
		,ln.liabilityTypeName
		,rss.EffectiveDate
		,rss.Date as startdt
		,'''+@Name_dt+''' as valtype
		,isnull(rss.Value,0) as val ,  
		ISNULL(rss.IntCalcMethodID,0) as intcalcdays  
		,(CASE WHEN ISNULL(DeterminationDateHolidayListText,'''') = ''US & UK'' Then ''US_and_UK'' ELSE ISNULL(DeterminationDateHolidayListText,'''') END)  as detdt_hlday_ls  
		,ISNULL(IndexNameText,'''') as indexnametext 
		from #tblRSS rss 
		Inner join #tblliabilityNoteAccountID ln on ln.liabilityTypeID = rss.AccountID
		Where rss.EffectiveDate  is not null
		and ValueTypeID=150
		and ln.liabilityTypeID in (Select Distinct LiabilityTypeID from #tblliabilityunallocatedbls)
  ) as [root.data.notes.LiabilityNote.effectivedate.'''+@Name_dt+''']'  
 END  
 ELSE  
 BEGIN  
  set @RateSpreadSchedule_dt='Select Distinct liabilityTypeID, ''unallocatedbls_'' + liabilityTypeName as LiabilityTypeName,  
  CONVERT(VARCHAR, EffectiveDate,101) as EffectiveDate,  
  CONVERT(VARCHAR, startdt,101) as startdt,  
  valtype,  
  val,  
  intcalcdays,  
  detdt_hlday_ls,  
  LOWER(indexnametext) as indexnametext  
  from  
  (  
		Select ln.liabilityTypeID
		,ln.liabilityTypeName
		,rss.EffectiveDate
		,rss.Date as startdt
		,'''+@Name_dt+''' as valtype
		,isnull(rss.Value,0) as val ,  
		ISNULL(rss.IntCalcMethodID,0) as intcalcdays  
		,(CASE WHEN ISNULL(DeterminationDateHolidayListText,'''') = ''US & UK'' Then ''US_and_UK'' ELSE ISNULL(DeterminationDateHolidayListText,'''') END)  as detdt_hlday_ls  
		,ISNULL(IndexNameText,'''') as indexnametext 
		from #tblRSS rss 
		Inner join #tblliabilityNoteAccountID ln on ln.liabilityTypeID = rss.AccountID
		Where rss.EffectiveDate  is not null
		and ValueTypeID='''+@ValueTypeID_dt+''' 
		and ln.liabilityTypeID in (Select Distinct LiabilityTypeID from #tblliabilityunallocatedbls)
 ) as [root.data.notes.LiabilityNote.effectivedate.'''+@Name_dt+''']'  
 END  
  
 insert into @tTableAlias ([Name],GroupName) values('root.data.notes.unallocatedbls.effectivedate.'+@Name_dt,'rate')  
 EXEC (@RateSpreadSchedule_dt)  
 set @cnt_dt += 1  
END  



select liabilityTypeID,'unallocatedbls_' + LiabilityTypeName as LiabilityTypeName,
	CONVERT(VARCHAR, EffectiveDate,101) as EffectiveDate,  
	feename,  
	CONVERT(VARCHAR, startdt,101) as startdt,  
	CONVERT(VARCHAR, enddt,101) as enddt,  
	ISNULL(valtype,0) as valtype,
	[type],  
	val ,ovrfeeamt,ovrbaseamt,ISNULL(trueupflag,0) as trueupflag, 
	ISNULL(levyldincl,0) as levyldincl,
	basisincl, stripval,  
	CONVERT(VARCHAR, actual_startdt,101) as actual_startdt  ,
	feescheduleid
	from  
	(  
		Select ln.liabilityTypeID,ln.LiabilityTypeName
		,fee.EffectiveDate,  
		ISNULL(fee.FeeName,'') as feename,   
		(CASE 
		WHEN (fe.FeeTypeNameID = fee.ValueTypeID) and fee.StartDate < fee.EffectiveDate  THEN fee.EffectiveDate  
		ELSE fee.StartDate END
		) as startdt,   
		--(CASE WHEN fee.EndDate is null  and (fe.FeeTypeNameID = fee.ValueTypeID) THEN @l_MaturityDate_ScenarioBased ELSE rs.EndDate END) as enddt,   
		fee.EndDate as enddt,
		fee.ValueTypeID as valtype,  
		fee.FeeTypeText as [type]  ,  
		ISNULL(fee.Value,0) as val ,  
		ISNULL(fee.FeeAmountOverride,0) as ovrfeeamt,  
		ISNULL(fee.BaseAmountOverride,0) as ovrbaseamt,  
  
		fee.ApplyTrueUpFeatureID as trueupflag,  

		ISNULL(fee.IncludedLevelYield,0) as levyldincl,  
		ISNULL(fee.IncludedBasis,0) as basisincl,  
		ISNULL(fee.FeetobeStripped,0) as stripval,  
		fee.StartDate as actual_startdt  ,
		fee.feescheduleid
		from #tblfee fee 
		Inner join #tblliabilityNoteAccountID ln on ln.liabilityTypeID = fee.AccountID
		LEFT JOIN(
			Select	FeeTypeNameID,
			FS.FeeTypeNameText as feename	
			from [CRE].[FeeSchedulesConfig] FS
			LEFT JOIN [CORE].[Lookup] LFeePaymentFrequencyID ON LFeePaymentFrequencyID.LookupID = FS.FeePaymentFrequencyID AND LFeePaymentFrequencyID.ParentID=89 
			LEFT JOIN [CORE].[Lookup] LFeeCoveragePeriodID ON LFeeCoveragePeriodID.LookupID = FS.FeeCoveragePeriodID AND LFeeCoveragePeriodID.ParentID=90	
			where ISNULL(IsActive,1)  = 1
			and LFeePaymentFrequencyID.Name = 'Transaction Based'
			and LFeeCoveragePeriodID.Name = 'Open Period'
		)fe on fe.FeeTypeNameID =  fee.ValueTypeID  

		where fee.EffectiveDate  is not null
	) as [data.notes.setup.tables.fees]  
	where liabilityTypeID in (Select Distinct LiabilityTypeID from #tblliabilityunallocatedbls)

	order by liabilityTypeID,EffectiveDate  
	
insert into @tTableAlias([Name]) values('root.data.notes.unallocatedbls.effectivedate.fees')  



---====================================
Declare @AnalysisID_Default UNIQUEIDENTIFIER = (Select AnalysisID from [CORE].[Analysis] where [Name] = 'Default')
  

Declare @JsonTemplate as table (
Id	int,
[Key]	nvarchar(256),
[Value]	nvarchar(256),
[Type]	nvarchar(256),
[FileName]	nvarchar(256),
DBFileName nvarchar(256)
)

INSERT INTO @JsonTemplate (Id,[Key],DBFileName)  
Select c.RuleTypeMasterID as [Id],Replace(LOWER(c.RuleTypeName),'liability_','') as [Key],b.[DBFileName]  
from [CRE].[AnalysisRuleTypeSetup] a    
inner join [CRE].[RuleTypeDetail] b on a.RuleTypeDetailID=b.RuleTypeDetailID    
inner join [CRE].[RuleTypeMaster] c on a.RuleTypeMasterID=c.RuleTypeMasterID    
where c.GroupName = 'Liability Calculator'
and a.AnalysisID in (CASE WHEN (Select COUNT(AnalysisID) from [CRE].[AnalysisRuleTypeSetup] where AnalysisID = @AnalysisID)= 0 THEN @AnalysisID_Default ELSE @AnalysisID END ) 


--select 1,'accounts','Liability_Accounts_LiabilityAccount05_21_2025_10_50_51.json'
--union
--select 2,'config','Liability_Config_LiabilityConfig05_16_2025_05_30_36.json'
--union
--select 3,'rules','Liability_Rules_LiabilityRules05_21_2025_10_46_14.json'




insert into @tTableAlias([Name]) values('JsonTemplate')  

select Id,[Key],DBFileName from @JsonTemplate

Select * from @tTableAlias

 
END
