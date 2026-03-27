---[dbo].[usp_GetCalcJsonByFundNameForFeesOnly]   'ACORE Credit Partners II','c10f3372-0fc2-4861-a9f5-148f1f80804f'

CREATE PROCEDURE [dbo].[usp_GetCalcJsonByFundNameForFeesOnly]  
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
 
INSERT INTO #tblFEE(AccountID,EffectiveDate,FeeName,[StartDate],[EndDate],ValueTypeID,FeeTypeText,[Value],FeeAmountOverride,BaseAmountOverride,ApplyTrueUpFeatureID,ApplyTrueUpFeatureText,IncludedLevelYield,FeetobeStripped,IncludedBasis,feescheduleid)
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
fs.IncludedBasis,
fs.PrepayAndAdditionalFeeScheduleLiabilityID
from
core.PrepayAndAdditionalFeeScheduleLiability fs
Inner Join core.Event e on e.EventID = fs.EventID
LEFT JOIN cre.FeeSchedulesConfigLiability LValueTypeID ON LValueTypeID.FeeTypeNameID = fs.ValueTypeID
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
Where e.StatusID=1 and e.additionalaccountid = @fundAccountID
and e.AccountID in (
	Select liabilityTypeID from #tblliabilityNoteAccountID	
)

---=================================================

IF OBJECT_ID('tempdb..#tblGenSetupDebt') IS NOT NULL         
	DROP TABLE #tblGenSetupDebt

CREATE Table #tblGenSetupDebt(
	GeneralSetupDetailsDebtAutoID int,
	AccountID UNIQUEIDENTIFIER,
	EventID UNIQUEIDENTIFIER,
	EffectiveDate date,
	Commitment decimal(28,15)
)

INSERT INTO #tblGenSetupDebt(GeneralSetupDetailsDebtAutoID,AccountID,EventID,EffectiveDate,Commitment)
Select
gsd.GeneralSetupDetailsDebtAutoID,
E.AccountID,
E.EventID,
E.EffectiveStartDate as EffectiveDate,
gsd.Commitment
FROM [CORE].[GeneralSetupDetailsDebt] gsd
Inner Join core.Event e on e.EventID = gsd.EventID
Inner join core.account acc on acc.accountid = e.accountid
Where e.StatusID=1
and e.EffectiveStartDate is not null
and e.AccountID in (
	Select liabilityTypeID from #tblliabilityNoteAccountID	
)

---=================================================

IF OBJECT_ID('tempdb..#tblLibNote_IntExpAccountID') IS NOT NULL         
	DROP TABLE #tblLibNote_IntExpAccountID

CREATE TABLE #tblLibNote_IntExpAccountID (
LiabilityNoteAccountID  UNIQUEIDENTIFIER,
IntExpAccountID  UNIQUEIDENTIFIER
)

INSERT INTO #tblLibNote_IntExpAccountID(LiabilityNoteAccountID,IntExpAccountID)
Select liabilityNoteAccountID,
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
,0 as isCalcStarted
,0 as isCalcCancel
,@AccountName AS client_reference_id
,@batch as [batch]
Insert into @tTableAlias([Name]) values('root.data') 
---========================================

select CalendarName as HolidayTypeText,CONVERT(VARCHAR, HoliDayDate,101) HoliDayDate   
from App.HoliDays hd   
left join app.HoliDaysMaster hdm on hdm.HolidayMasterID = hd.HoliDayTypeID
where isnull(hd.isSoftHoliday,0)<>3
Order by CalendarName,CAST(HoliDayDate as date)  
insert into @tTableAlias([Name]) values('root.data.calendar')  
  
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
	Select Distinct ln.LiabilityNoteID,lfee.LiabilityNoteAccountID,fee.EffectiveDate 
	from #tblLibNote_feeAccountID lfee
	Inner join #tblfee fee on fee.AccountID = lfee.feeAccountID
	Inner join #tblliabilityNoteAccountID ln on ln.liabilityNoteAccountID = lfee.LiabilityNoteAccountID
	Where fee.EffectiveDate  is not null

	UNION

	Select Distinct ln.LiabilityNoteID,lfee.LiabilityNoteAccountID,fee.EffectiveStartDate as EffectiveDate 
	from #tblLibNote_IntExpAccountID lfee
	Inner join #tblInterestExpence fee on fee.AccountID = lfee.IntExpAccountID
	Inner join #tblliabilityNoteAccountID ln on ln.liabilityNoteAccountID = lfee.LiabilityNoteAccountID
	where fee.EffectiveStartDate  is not null

	UNION

	Select Distinct ln.LiabilityNoteID,ln.LiabilityNoteAccountID,lfee.EffectiveDate 
	from #tblGenSetupDebt lfee
	Inner join #tblliabilityNoteAccountID ln on ln.liabilityTypeID = lfee.AccountID
	where lfee.EffectiveDate  is not null
)a

Select  CONVERT(VARCHAR, EffectiveDate,101) as effective_dates  
From(  
	Select Distinct EffectiveDate from #tNoteEffectiveDates   
)a  
order by a.EffectiveDate  
insert into @tTableAlias([Name]) values('root.data.effective_dates')  

---========================================

Select Distinct t.liabilityTypeID, t.LiabilityTypeName as [name], @fundAccountID as FundAccountID, t.LiabilityTypeName as id
from #tblliabilityNoteAccountID t
insert into @tTableAlias([Name]) values('root.data.notes')  
---========================================

Select Distinct ln.liabilityTypeID,ln.LiabilityTypeName as [name],CONVERT(VARCHAR, EffectiveDate,101) as EffectiveDate
from #tNoteEffectiveDates teff
Left join #tblliabilityNoteAccountID ln on ln.liabilityNoteAccountID = teff.LiabilityNoteAccountID
insert into @tTableAlias([Name]) values('root.data.notes.Facility.effectivedate')  
---========================================

Select Distinct ln.liabilityTypeID,ln.LiabilityTypeName as [name],CONVERT(VARCHAR, gsd.EffectiveDate,101) as EffectiveDate, gsd.Commitment as commitmentamt
from #tblGenSetupDebt gsd
Inner join #tblliabilityNoteAccountID ln on ln.liabilityTypeID = gsd.AccountID
insert into @tTableAlias([Name]) values('root.data.notes.Facility.CommitmentAmtbyEffectivedate')  
---========================================
	
Select d.AccountID as liabilityTypeID
,acc.Name as [name]
,ISNULL(dex.PaymentFrequency,0) as payfreq
,ISNULL(dex.AccrualEndDateBusinessDayLag,0) as accenddatebusidaylag
,ISNULL(dex.AccrualFrequency,0) as accfreq
,isnull(lroundedMethod.name,'') as roundmethod
,ISNULL(dex.IndexRoundingRule, 1000) as [precision]
,ISNULL(dex.FinanacingSpreadRate, 0) as FinancingSpreadRate
,isnull(lIntActMethod.name,'') as intactmethod
,isnull(lDefaultIndexName.name,'') as defaultindexnm
,ISNULL(dex.TargetAdvanceRate, 0) as targetadvrate
,isnull(lpmtdtaccper.name,'Current') as pmtdtaccper
,isnull(lResetIndexDaily.name,'N') as ResetIndexDaily
,isnull(LDeterminationDateHolidayList.CalendarName,'US') as pydt_detdt_hlday_ls
,ISNULL(CONVERT(VARCHAR, gsetupdt.InitialMaturityDate,101),'') as initmatdt
,ISNULL(CONVERT(VARCHAR, d.OriginationDate,101),'') as clsdt

from cre.Debt d
Inner join cre.debtext dex on d.accountid = dex.DebtAccountID
Inner Join core.Account acc on acc.AccountID = d.AccountID
Left Join core.lookup lroundedMethod on lroundedMethod.lookupid = dex.Roundingmethod
Left Join core.lookup lIntActMethod on lIntActMethod.lookupid = dex.IntActMethod
Left Join core.lookup lDefaultIndexName on lDefaultIndexName.lookupid = dex.DefaultIndexName	
Left Join core.lookup lpmtdtaccper on lpmtdtaccper.lookupid = dex.pmtdtaccper
Left Join core.lookup lResetIndexDaily on lResetIndexDaily.lookupid = dex.ResetIndexDaily
LEFT JOIN app.HoliDaysMaster LDeterminationDateHolidayList ON LDeterminationDateHolidayList.HolidayMasterID = dex.DeterminationDateHolidayList
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
)gsetupdt on gsetupdt.AccountID = d.AccountID

Where dex.AdditionalAccountID = @fundAccountID
and d.AccountID in (Select liabilityTypeID from #tblliabilityNoteAccountID)

insert into @tTableAlias([Name]) values('root.data.notes.Facility.effectivedate.FacilityDetails')  
---========================================

Select Distinct ln.liabilityTypeID
,ln.LiabilityTypeName as [name]
,ISNULL(CONVERT(VARCHAR, fee.EffectiveStartDate,101),'') as EffectiveDate
,ISNULL(CONVERT(VARCHAR, fee.InitialInterestAccrualEndDate,101),'')  as initaccenddt
,ISNULL(fee.PaymentDateBusinessDayLag,0) as paydatebusiessdaylag
,isnull(fee.DeterminationDateLeadDays ,0)  as leaddays
,isnull(fee.DeterminationDateReferenceDayOftheMonth ,0)  as determidayrefdayofmnth 
,ISNULL(fee.PaymentDayOfMonth, 0)  as accperpaydaywhennoteomnth
,CASE WHEN fee.InitialIndexValueOverride = 0 THEN NULL ELSE fee.InitialIndexValueOverride END  as initindex	--doing forcefull NULL when Zero
,ISNULL(CONVERT(VARCHAR, fee.FirstRateIndexResetDate,101),'')  as initresetdt 
from #tblLibNote_IntExpAccountID lfee
Inner join #tblInterestExpence fee on fee.AccountID = lfee.IntExpAccountID
Inner join #tblliabilityNoteAccountID ln on ln.liabilityNoteAccountID = lfee.LiabilityNoteAccountID
where fee.EffectiveStartDate  is not null
insert into @tTableAlias([Name]) values('root.data.notes.Facility.effectivedate.FacilityDetailsByEffectiveDate')
---========================================

select distinct liabilityTypeID
	,[name]
	,CONVERT(VARCHAR, EffectiveDate,101) as EffectiveDate,  
	feename,  
	CONVERT(VARCHAR, startdt,101) as startdt,  
	CONVERT(VARCHAR, enddt,101) as enddt,  
	valtype,[type],  
	val ,ovrfeeamt,ovrbaseamt,trueupflag, levyldincl,basisincl, stripval,  
	CONVERT(VARCHAR, actual_startdt,101) as actual_startdt  ,
	feescheduleid
	from  
	(  
		Select ln.liabilityTypeID
		,ln.LiabilityTypeName as [name]
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
		from #tblLibNote_feeAccountID lfee
		Inner join #tblfee fee on fee.AccountID = lfee.feeAccountID
		Inner join #tblliabilityNoteAccountID ln on ln.liabilityNoteAccountID = lfee.LiabilityNoteAccountID
		LEFT JOIN(
			Select	FeeTypeNameID,
			FS.FeeTypeNameText as feename	
			from [CRE].[FeeSchedulesConfigLiability] FS
			LEFT JOIN [CORE].[Lookup] LFeePaymentFrequencyID ON LFeePaymentFrequencyID.LookupID = FS.FeePaymentFrequencyID AND LFeePaymentFrequencyID.ParentID=89 
			LEFT JOIN [CORE].[Lookup] LFeeCoveragePeriodID ON LFeeCoveragePeriodID.LookupID = FS.FeeCoveragePeriodID AND LFeeCoveragePeriodID.ParentID=90	
			where ISNULL(IsActive,1)  = 1
			and LFeePaymentFrequencyID.Name = 'Transaction Based'
			and LFeeCoveragePeriodID.Name = 'Open Period'
		)fe on fe.FeeTypeNameID =  fee.ValueTypeID  

		where fee.EffectiveDate  is not null
	) as [data.notes.setup.tables.fees]  
	order by liabilityTypeID,EffectiveDate  
	
insert into @tTableAlias([Name]) values('root.data.notes.Facility.effectivedate.fees')  

----===================================

Select d.AccountID,CONVERT(VARCHAR, tr.Date,101) as Date,tr.Amount as TransactionAmount,tr.TransactionType,tr.EndingBalance
from cre.TransactionEntryLiability tr
Inner join cre.Debt d on d.accountid = tr.LiabilityAccountID
Where tr.TransactionType <> 'InterestPaid'
and d.AccountID in (Select liabilityTypeID from #tblliabilityNoteAccountID)

insert into @tTableAlias([Name]) values('root.data.notes.Facility.notebalance')  

----===================================

Select
FF.FunctionNameID,
FF.FunctionGuID,
ISNULL(FF.FunctionNameText,'') as FunctionNameText,
ISNULL(LFunctionTypeID.Name,'') as FunctionTypeText,
ISNULL(LFunctionTypeID.LookupID,0) as FunctionTypeID,
ISNULL(LPaymentFrequencyID.Name,'') as PaymentFrequencyText,
ISNULL(LPaymentFrequencyID.LookupID,0) as PaymentFrequencyID,
ISNULL(LAccrualBasisID.Name,'') as AccrualBasisText, 
ISNULL(LAccrualBasisID.LookupID,0) as AccrualBasisID,
ISNULL(LAccrualStartDateID.Name,'') as AccrualStartDateText, 
ISNULL(LAccrualStartDateID.LookupID,0) as AccrualStartDateID,
ISNULL(LAccrualPeriodID.Name,'') as AccrualPeriodText,
ISNULL(LAccrualPeriodID.LookupID,0) as AccrualPeriodID,
ISNULL(FF.FunctionNameID,0) as LookupID,
ISNULL(FF.FunctionNameText,'') as [Name],
IsUsedInFeeSchedule = Case when exists(select 1 from [CRE].[FeeSchedulesConfig] where FeeFunctionID=FF.FunctionNameID) then 1 else 0 end	
from [CRE].[FeeFunctionsConfigLiability] FF
LEFT JOIN [CORE].[Lookup] LFunctionTypeID ON LFunctionTypeID.LookupID = FF.FunctionTypeID AND LFunctionTypeID.ParentID=84 
LEFT JOIN [CORE].[Lookup] LPaymentFrequencyID ON LPaymentFrequencyID.LookupID = FF.PaymentFrequencyID AND LPaymentFrequencyID.ParentID=85
LEFT JOIN [CORE].[Lookup] LAccrualBasisID ON LAccrualBasisID.LookupID = FF.AccrualBasisID AND LAccrualBasisID.ParentID=86
LEFT JOIN [CORE].[Lookup] LAccrualStartDateID ON LAccrualStartDateID.LookupID = FF.AccrualStartDateID AND LAccrualStartDateID.ParentID=87
LEFT JOIN [CORE].[Lookup] LAccrualPeriodID ON LAccrualPeriodID.LookupID = FF.AccrualPeriodID AND LAccrualPeriodID.ParentID=88
insert into @tTableAlias([Name]) values('root.data.listfeefunctions')

Select feename,type,frequency,Coverage,Account,[Value],[function]
From(
	Select	
	FS.FeeTypeNameText as feename,
	LFeeNameTransID.Name as [type],
	LFeePaymentFrequencyID.Name as frequency,
	LFeeCoveragePeriodID.Name as Coverage,
	LTotalCommitmentID.Name as totalcmt,
	LUnscheduledPaydownsID.Name as paydown,
	LBalloonPaymentID.Name as balloon,
	LLoanFundingsID.Name as funding,
	LScheduledPrincipalAmortizationPaymentID.Name as schprinpaid,
	LCurrentLoanBalanceID.Name as endbal,
	LInterestPaymentID.Name as periodint,
	LInitialFundingID.name as initfunding,
	LM61AdjustedCommitmentID.name as noteadjustedtotalcommitment,
	LPIKFundingID.name as periodpikfunding,
	LPIKPrincipalPaymentID.name as act_pikprinpaid,
	LUnfundedCommitmentID.name as rem_unfunded_commitment,
	LCurtailmentID.name as curtailment,
	LUpsizeAmountID.name as upsizeamount,
	FF.FunctionNameText as [function]
	from [CRE].[FeeSchedulesConfigLiability] FS
	LEFT JOIN [CORE].[Lookup] LFeePaymentFrequencyID ON LFeePaymentFrequencyID.LookupID = FS.FeePaymentFrequencyID AND LFeePaymentFrequencyID.ParentID=89 
	LEFT JOIN [CORE].[Lookup] LFeeCoveragePeriodID ON LFeeCoveragePeriodID.LookupID = FS.FeeCoveragePeriodID AND LFeeCoveragePeriodID.ParentID=90
	LEFT JOIN [CRE].[FeeFunctionsConfigLiability] FF ON FF.FunctionNameID = FS.FeeFunctionID
	LEFT JOIN [CORE].[Lookup] LTotalCommitmentID ON LTotalCommitmentID.LookupID = FS.TotalCommitmentID AND LTotalCommitmentID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LUnscheduledPaydownsID ON LUnscheduledPaydownsID.LookupID = FS.UnscheduledPaydownsID AND LUnscheduledPaydownsID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LBalloonPaymentID ON LBalloonPaymentID.LookupID = FS.BalloonPaymentID AND LBalloonPaymentID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LLoanFundingsID ON LLoanFundingsID.LookupID = FS.LoanFundingsID AND LLoanFundingsID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LScheduledPrincipalAmortizationPaymentID ON LScheduledPrincipalAmortizationPaymentID.LookupID = FS.ScheduledPrincipalAmortizationPaymentID AND LScheduledPrincipalAmortizationPaymentID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LCurrentLoanBalanceID ON LCurrentLoanBalanceID.LookupID = FS.CurrentLoanBalanceID AND LCurrentLoanBalanceID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LInterestPaymentID ON LInterestPaymentID.LookupID = FS.InterestPaymentID AND LInterestPaymentID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LFeeNameTransID ON LFeeNameTransID.LookupID = FS.FeeNameTransID AND LFeeNameTransID.ParentID=94
	LEFT JOIN [CORE].[Lookup] LInitialFundingID ON LInitialFundingID.LookupID = FS.InitialFundingID AND LInitialFundingID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LM61AdjustedCommitmentID ON LM61AdjustedCommitmentID.LookupID = FS.M61AdjustedCommitmentID AND LM61AdjustedCommitmentID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LPIKFundingID ON LPIKFundingID.LookupID = FS.PIKFundingID AND LPIKFundingID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LPIKPrincipalPaymentID ON LPIKPrincipalPaymentID.LookupID = FS.PIKPrincipalPaymentID AND LPIKPrincipalPaymentID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LCurtailmentID ON LCurtailmentID.LookupID = FS.CurtailmentID AND LCurtailmentID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LUpsizeAmountID ON LUpsizeAmountID.LookupID = FS.UpsizeAmountID AND LUpsizeAmountID.ParentID=91
	LEFT JOIN [CORE].[Lookup] LUnfundedCommitmentID ON LUnfundedCommitmentID.LookupID = FS.UnfundedCommitmentID AND LUnfundedCommitmentID.ParentID=91
	
	where ISNULL(IsActive,1)  = 1
)as a
UNPIVOT 
(
	[Value] FOR Account IN (totalcmt,paydown,balloon,funding,schprinpaid,endbal,periodint,initfunding,noteadjustedtotalcommitment,periodpikfunding,act_pikprinpaid,rem_unfunded_commitment,curtailment,upsizeamount)
) as sq_up

where sq_up.[Value] = 'TRUE'
order by sq_up.feename

insert into @tTableAlias([Name]) values('root.data.config.fee.config')


----===================================

select PrepayAndAdditionalFeeScheduleLiabilityID As feescheduleid,
		[From],
		[To],
		[Value]
		from [Core].[PrepayAndAdditionalFeeScheduleLiabilityDetail] 
		where PrepayAndAdditionalFeeScheduleLiabilityID IN (Select FeeScheduleID from #tblFEE);
	
insert into @tTableAlias([Name]) values('root.data.notes.Facility.effectivedate.fees.feeperconfig')


----===================================
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
where c.GroupName = 'Liability Calculator Fee'
and a.AnalysisID in (CASE WHEN (Select COUNT(AnalysisID) from [CRE].[AnalysisRuleTypeSetup] where AnalysisID = @AnalysisID)= 0 THEN @AnalysisID_Default ELSE @AnalysisID END ) 

insert into @tTableAlias([Name]) values('JsonTemplate')  

select Id,[Key],DBFileName from @JsonTemplate

Select * from @tTableAlias

END