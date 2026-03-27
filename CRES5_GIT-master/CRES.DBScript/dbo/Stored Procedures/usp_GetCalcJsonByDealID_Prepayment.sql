--[usp_GetCalcJsonByDealID_Prepayment] '','20-1357','72114A53-495C-464B-A020-62884A0F1462',776

CREATE PROCEDURE [dbo].[usp_GetCalcJsonByDealID_Prepayment]  
(
    @UserID NVARCHAR(256),
    @DealID_any NVARCHAR(256),
	@Analysis_ID UNIQUEIDENTIFIER,
	@CalcTypeID int

)	

AS
BEGIN
	SET NOCOUNT ON;


	Declare @DealID UNIQUEIDENTIFIER;

	
	IF((SELECT 1 WHERE @DealID_any LIKE REPLACE('00000000-0000-0000-0000-000000000000', '0', '[0-9a-fA-F]')) = 1)
	BEGIN
		---If @DealID_any is guid
		SET @DealID = @DealID_any
	END
	ELSE
	BEGIN
		SET @DealID = (Select dealid from cre.deal where credealid = @DealID_any)
	END



	Declare @prepaydate date;
	SET @prepaydate = (Select ISNULL(prepaydate,getdate()) from cre.deal where dealid = @DealID)

	Declare @CalculationMode int;
	SET @CalculationMode = (Select CalculationMode from core.analysisparameter where analysisid=@Analysis_ID)

	Declare @calc_basis_freq nvarchar(50);
	SET @calc_basis_freq = (Select l.name from core.analysisparameter am left join core.lookup l on l.lookupid = am.CalculationFrequency where analysisid=@Analysis_ID)


	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	DECLARE @AnalysisID UNIQUEIDENTIFIER = @Analysis_ID  ---'c10f3372-0fc2-4861-a9f5-148f1f80804f'
	DECLARE @CREDealID NVARCHAR(256)
	DECLARE @DealName NVARCHAR(256)
	DECLARE @AnalysisName NVARCHAR(256)

	DECLARE @RateSpreadSchedule nvarchar(max)
	declare @cnt int=1,@ValueTypeID nvarchar(50),@Name nvarchar(100),@totalCntRateSpread int,
	@deal_min_effDate date,@TotalSequ1 as DECIMAL (28, 15)
	declare @UseRuletoDetermineNoteFundingAsYES int=(Select LookupID from CORE.Lookup where Name = 'Y' and Parentid = 2)   

	SET @AnalysisName = (Select [name] from core.analysis where AnalysisID = @AnalysisID)
	
	DECLARE @CalcStatus int
	SET @CalcStatus = (Select Distinct top 1  statusid from core.CalculationRequests where AnalysisId = @AnalysisID and dealid = @DealID)

	Declare @ExcludedForcastedPrePaymentText nvarchar(10);
	Declare @UseServicingActual nvarchar(10);
	Declare @DisableBusinessDay nvarchar(10);
	Declare @MaturityScenarioOverride nvarchar(100);

	Select @ExcludedForcastedPrePaymentText = ISNULL(lExcludedForcastedPrePayment.name,''),
	@UseServicingActual = ISNULL(lUseActuals.name,''),
	@DisableBusinessDay = ISNULL(lUseBusinessDayAdjustment.name,'N') ,
	@MaturityScenarioOverride = ISNULL(lMaturityScenarioOverrideID.name,'')
	from core.analysis a
	inner join core.analysisparameter am on am.analysisid = a.analysisid
	left join core.lookup lExcludedForcastedPrePayment on lExcludedForcastedPrePayment.lookupid = am.ExcludedForcastedPrePayment
	left join core.lookup lUseActuals on lUseActuals.lookupid = am.UseActuals
	left join core.lookup lUseBusinessDayAdjustment on lUseBusinessDayAdjustment.lookupid = am.UseBusinessDayAdjustment
	left join core.lookup lMaturityScenarioOverrideID on lMaturityScenarioOverrideID.lookupid = am.MaturityScenarioOverrideID
	where a.analysisid=@AnalysisID


	Declare @calc_priority int;

	SET @calc_priority = (Select top 1 cr.[PriorityID] as calc_priority
	from core.calculationrequests cr
	where analysisid=@AnalysisID
	and cr.dealid = @DealID)



	--=================================
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

	Print(@IndexName)
	--=================================


	---===Root table variables========
	--Declare @calc_basis bit
	--Declare @calc_deffee_basis bit
	--Declare @calc_disc_basis bit
	--Declare @calc_capcosts_basis bit
	Declare @batch bit
	--Declare @init_logging bit
	Declare @engine nvarchar(50)
	Declare @debug bit

	Select 
	--@calc_basis = calc_basis,
	--@calc_deffee_basis = calc_deffee_basis,
	--@calc_disc_basis = calc_disc_basis,
	--@calc_capcosts_basis = calc_capcosts_basis,
	@batch = batch,
	--@init_logging = init_logging,
	@engine = (CASE WHEN @CalcTypeID = 776 THEN 'script' else  engine end)
	from [CRE].[RootV1Calc]

	SET @debug = (Select top 1 [value] from app.AppConfig where [Key] = 'AllowDebugInCalc')
	--=======================================

	Declare @mat_Type nvarchar(256)

	SET @mat_Type = (
		Select MaturityType from(
			Select a.AnalysisID,a.name,l.name as MaturityScenarioOverride,
			(CASE WHEN l.name ='Initial or Actual Payoff Date' then 'Initial'
			WHEN l.name ='Expected Maturity Date' then 'Expected Maturity Date'  
			WHEN l.name ='Extended Maturity Date' then 'Extension'
			WHEN l.name ='Open Prepayment Date' then 'Fully extended' --'OpenPrepaymentDate'
			WHEN l.name ='Fully Extended Maturity Date' then 'Fully extended'
			WHEN l.name ='Current Maturity Date' then 'Current Maturity Date'
			end)  MaturityType
			from core.Analysis a
			inner join core.analysisparameter am on am.AnalysisID = a.AnalysisID
			left join core.lookup l on l.lookupid = am.MaturityScenarioOverrideID
			where a.AnalysisID = @AnalysisID
		)a
	)
	--=======================================

	--DECLARE @tNoteEffectiveDates as table
	--(
	--CRENoteID NVARCHAR(256),
	--NoteID UNIQUEIDENTIFIER,
	--EffectiveDate date
	--)
	create table  #tNoteEffectiveDates
	(
	CRENoteID NVARCHAR(256),
	NoteID UNIQUEIDENTIFIER,
	EffectiveDate date
	)
	DECLARE @tRateSpreadSchedule as table
	(
	ID int identity(1,1),
	ValueTypeID int,
	Name NVARCHAR(100)
	)
	DECLARE @tTableAlias as table
	(
	ID int identity(1,1),
	[Name] NVARCHAR(100),
	[GroupName] NVARCHAR(100)
	)		
	 
	

	--#table
	insert into #tNoteEffectiveDates
	Select Distinct CRENoteID,NoteID,effectivestartdate as effective_dates
	From(
		select n.CRENoteID,n.NoteID,n.ClosingDate as effectivestartdate,'ClosingDate' as [Type]
		from cre.note n
		inner join core.account acc on acc.accountid = n.account_accountid 
		inner join cre.Deal d on d.DealID = n.DealID
		where acc.IsDeleted <> 1  and n.Dealid = @DealID	 

		UNION
	 

		Select Distinct n.CRENoteID,n.NoteID,e.effectivedate,'PrepayPremiumSchedule' as [Type]
		from [CORE].prepaySchedule ps
		INNER JOIN [CORE].[EventDeal] e on e.EventDealID = ps.EventDealID
		inner join cre.note n on n.dealid = e.dealid
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.account_accountid
		where e.StatusID = 1  and acc.IsDeleted <> 1
		and e.dealid = @DealID

		UNION

		select Distinct n.crenoteid,n.noteid,n.ActualPayoffdate as effectivedate,'ActualPayoffdate' as [Type]
		from cre.note n
		inner join core.account acc on acc.accountid = n.account_accountid 
		where acc.isdeleted <> 1
		and n.ActualPayoffdate is not null
		and n.dealid = @DealID

	)a where effectivestartdate is not null	 
	 
	select @deal_min_effDate = min(distinct EffectiveDate) from #tNoteEffectiveDates

	select @CREDealID = CREDealID,@DealName=DealName from cre.Deal where DealID=@DealID
	

	Select 	CONVERT(VARCHAR, EffectiveDate,101) as effective_dates
	From(
		Select Distinct EffectiveDate from #tNoteEffectiveDates 
	)a
	order by a.EffectiveDate

	insert into @tTableAlias([Name]) values('data.effective_dates')
	


	select CONVERT(VARCHAR, period_start_date ,101) AS period_start_date,
	 CONVERT(VARCHAR,period_end_date,101) AS period_end_date,
	 root_note_id,

	 --(CASE WHEN @CalculationMode = 503 THEN 0 ELSE 1 END) AS calc_basis,  ---Cash Flow Only = 503
	 --@calc_basis_freq as calc_basis_freq,

	 --@calc_deffee_basis AS calc_deffee_basis,
     --@calc_disc_basis AS calc_disc_basis,
    -- @calc_capcosts_basis AS calc_capcosts_basis ,
	 LOWER(@AnalysisName) + '_' + LOWER(@CREDealID) AS client_reference_id,
	 @batch as [batch],
	 --@init_logging AS init_logging,
	 @engine as engine,
	 @CalcStatus as CalcStatus,
	 -- @ExcludedForcastedPrePaymentText as ExcludedForcastedPrePaymentText,
	 --@UseServicingActual as UseServicingActual,
	 --@DisableBusinessDay as DisableBusinessDay,
	 --@MaturityScenarioOverride as MaturityScenarioOverride,
	 @debug as debug,
	 ISNULL(@calc_priority,273) as calc_priority,
	 (cASE WHEN @calc_priority =  272 tHEN 0 ELSE 1 END) as batchType,
	 0 as isCalcStarted,
	 0 as isCalcCancel
	 from
	(
	--root level info
	select
	--min of all notes closing date
	(
		select min(n.closingDate) as period_start_date
		from [CRE].[Note] n 
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
		inner join cre.deal d on d.DealID=n.DealID
		where  acc.IsDeleted <> 1
		and d.dealid=@DealID

	) as period_start_date,
	
	--max of all notes  maturity date based on scenario
	(
		Select MAX(DateAdd(month, DateDIff(month,n.InitialInterestAccrualEndDate,tblmatfull.FullyExtended) + (CASE WHEN DAY(tblmatfull.FullyExtended) <= DAY(n.InitialInterestAccrualEndDate) Then 0 ELSE ISNULL(n.AccrualFrequency,1) END),n.InitialInterestAccrualEndDate)  ) period_end_date
		
		from cre.note n
		left join(
				Select n.noteid, MAX(mat.MaturityDate) as FullyExtended
				from [CORE].Maturity mat  
				INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
				
				--INNER JOIN   
				--(          
				--	Select   
				--	(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
				--	MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
				--	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
				--	INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
				--	where EventTypeID = 11  and eve.StatusID = 1
				--	and acc.IsDeleted = 0  
				--	and n.DealID = @DealID
				--	GROUP BY n.Account_AccountID,EventTypeID    
				--) sEvent    
				--ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  and e.StatusID = 1
				
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 	
				where n.DealID = @DealID and mat.MaturityType = 710 and mat.Approved = 3
				group by n.noteid
		)tblmatfull on tblmatfull.noteid = n.noteid
		where n.dealid = @DealID
	) as period_end_date 


	,@CREDealID as root_note_id
	) as [data.rootinfo]
	
	insert into @tTableAlias([Name]) values('data.rootinfo')


--notes
Declare @tblNotes as table
(
Id nvarchar(256),
[name] nvarchar(256),
[type] nvarchar(256),
objectguid uniqueidEntIFIER,
prepaydate  date,
lienposition int, 
Priority int,
InitialFundingAmount decimal(28,15)
)

INSERT INTO @tblNotes(Id,[name],[type],objectguid,prepaydate,lienposition,Priority,InitialFundingAmount)

select Id,[name],[type],objectguid,prepaydate ,lienposition,Priority,InitialFundingAmount
from
(
	select @CREDealID as Id,@DealName as [name],'wholenote' as [type], @DealID as objectguid,CONVERT(VARCHAR, @prepaydate ,101) as prepaydate,null as lienposition,null as Priority,null as InitialFundingAmount
	union all
	
	select CRENoteID as Id,ac.[Name] as [name],'legal' as [type] ,n.noteid as objectguid,CONVERT(VARCHAR, @prepaydate ,101) as prepaydate,n.lienposition,n.Priority,n.InitialFundingAmount
	from cre.note n 
	join [CORE].[Account] ac on n.Account_AccountID=ac.AccountID
	
	where n.DealID=@DealID and ac.IsDeleted=0

) as [data.notes]


select Id,[name],[type],objectguid,prepaydate 
from @tblNotes n
order by ISNULL(n.lienposition,99999), n.Priority,n.InitialFundingAmount desc, n.Name
insert into @tTableAlias([Name]) values('data.notes')

--
--data.notes.setup
select n.CRENoteID,n.NoteID,CONVERT(VARCHAR, n.EffectiveDate,101) as effective_dates 
from #tNoteEffectiveDates n
inner join cre.note nn on nn.noteid = n.noteid
inner join core.account acc on acc.accountid = nn.account_accountid
order by ISNULL(nn.lienposition,99999), nn.Priority,nn.InitialFundingAmount desc, acc.Name ,EffectiveDate

insert into @tTableAlias([Name]) values('data.notes.setup')
--

--data.notes.setup.dictionary
select CRENoteID,NoteID,
CONVERT(VARCHAR, min_effective_dates,101) as min_effective_dates,
CONVERT(VARCHAR, initaccenddt,101) as initaccenddt,
CONVERT(VARCHAR, initmatdt,101) as initmatdt,
CONVERT(VARCHAR, initpmtdt,101) as initpmtdt,
ioterm,amterm,
CONVERT(VARCHAR, clsdt,101) as clsdt
,initbal
--,totalcmt 
,leaddays,
CONVERT(VARCHAR, initresetdt,101) as initresetdt ,
initindex,
UPPER(roundmethod) as roundmethod,
[precision],
ISNULL(discount,0) as discount

, stubintovrd
, loanpurchase
, purintovrd
, insvrpayoverinlvly
, intecalcrulepydn as intcalcrulepydn
, capclscost
, busidayrelapmtdt
, dayofmnth
, accfreq
, determidtinterestaccper
, determidayrefdayofmnth

, rateindexresetfreq
, accperpaydaywhennoteomnth
, payfreq
, paydatebusiessdaylag
, stubpaidadv
, CONVERT(VARCHAR, finalintaccenddtvrd,101) as finalintaccenddtvrd
, stubonff
, monamovrd
, fixedamortsche
, amortintcalcdaycnt
, pikinteraddedtoblsbusiadvdate
, piksepcomponding
, intcalcruleforpydwnamort as intcalcruleforamort

,CONVERT(VARCHAR, actualpayoffdate,101)  as actualpayoffdate
,[priority]
,lienpos

,pikcalcrulepydn
,pikcalcruleforamort
,intcalcrulepikprinpmt
,pikcalcrulepikprinpmt
,CONVERT(VARCHAR, expectedmaturitydate,101)  as  expectedmaturitydate
,CONVERT(VARCHAR, FstIndexDeterDtOverride,101) as FstIndexDeterDtOverride
,accrualperiodtype
,accrualperiodbusinessdayadj	
,detdt_hlday_ls
,CONVERT(VARCHAR, EOMONTH(DateADD(month,-1,getdate())),101)  as accountingclosedate
from
(
	select CRENoteID,NoteID,min_effective_dates,
	initaccenddt,
	
	--(Select  mat.maturityDate
	--	from [CORE].Maturity mat  
	--	INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
	--	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	--	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 		
	--	where mat.maturityType = 708 
	--	and	mat.Approved = 3
	--	and e.statusid = 1
	--	and n.noteid = tbldictionary.NoteID
	--	and cast(e.effectivestartdate as date) = cast(min_effective_dates as date)
	--) as initmatdt,
	
	initmatdt,
	
	initpmtdt,
	ioterm,
	amterm,
	clsdt,
	initbal,
	totalcmt,
	leaddays,
	initresetdt ,
	initindex,
	roundmethod,
	[precision],
	discount

	, stubintovrd
	, loanpurchase
	, purintovrd
	, insvrpayoverinlvly
	, intecalcrulepydn
	, capclscost
	, busidayrelapmtdt
	, dayofmnth
	, accfreq
	, determidtinterestaccper
	, determidayrefdayofmnth
	
	, rateindexresetfreq
	, accperpaydaywhennoteomnth
	, payfreq
	, paydatebusiessdaylag
	, stubpaidadv
	, finalintaccenddtvrd
	, stubonff
	, monamovrd
	, fixedamortsche
	, amortintcalcdaycnt
	, pikinteraddedtoblsbusiadvdate
	, piksepcomponding
	, intcalcruleforpydwnamort

	,actualpayoffdate
	,[priority]
	,lienpos
	,lienposition
	,NoteName
	,pikcalcrulepydn
	,pikcalcruleforamort
	,intcalcrulepikprinpmt
	,pikcalcrulepikprinpmt
	,expectedmaturitydate
	,FstIndexDeterDtOverride
	,accrualperiodtype
	,accrualperiodbusinessdayadj	
	,detdt_hlday_ls
	from 
	(
		select CRENoteID,nt.NoteID,
		(Select 
			min(EffectiveStartDate) as effective_dates
			from [CORE].[Event] eve
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
			inner join cre.deal d on d.DealID=n.DealID
			where  acc.IsDeleted=0
			and isnull(eve.StatusID,1) = 1
			and n.NoteID=nt.NoteID
			and d.dealid=@DealID 
		) min_effective_dates,
		nt.InitialInterestAccrualEndDate as initaccenddt,
		tblInitmat.InitialMat as initmatdt,
		nt.FirstPaymentDate as initpmtdt,
		isnull(nt.IOTerm,0) as ioterm,
		isnull(nt.AmortTerm,0) as amterm,
		nt.ClosingDate as clsdt,
		isnull(nt.InitialFundingAmount,0) as initbal,
		isnull(nt.TotalCommitment,0) as totalcmt,

		ISNULL(nt.DeterminationDateLeadDays,0) as leaddays,
		nt.FirstRateIndexResetDate as initresetdt,
		isnull(nt.InitialIndexValueOverride,0) as initindex,
		ISNULL(lRoundingMethod.name,'') as roundmethod,
		
		--ISNULL((LEN(nt.IndexRoundingRule) - 1) + 2, 5)  as [precision],
		ISNULL(nt.IndexRoundingRule,1000)  as [precision],
		
		ISNULL(nt.discount,0) as discount 

		,ISNULL(nt.StubIntOverride,0) as stubintovrd
		,ISNULL(lLoanPurchase.name,'') as loanpurchase
		,ISNULL(nt.PurchasedInterestOverride,0) as purintovrd
		,ISNULL(lIncludeServicingPaymentOverrideinLevelYield.name,'') as insvrpayoverinlvly
		,ISNULL(lInterestCalculationRuleForPaydowns.name,'') as intecalcrulepydn
		,ISNULL(nt.CapitalizedClosingCosts,0) as capclscost
		,ISNULL(nt.BusinessdaylafrelativetoPMTDate,0) as busidayrelapmtdt
		,ISNULL(nt.DayoftheMonth,0) as dayofmnth
		,ISNULL(nt.AccrualFrequency,0) as accfreq
		,ISNULL(nt.DeterminationDateInterestAccrualPeriod,0) as determidtinterestaccper
		,ISNULL(nt.DeterminationDateReferenceDayoftheMonth,0) as determidayrefdayofmnth
	
		,ISNULL(nt.RateIndexResetFreq,0) as rateindexresetfreq
		,ISNULL(nt.AccrualPeriodPaymentDayWhenNotEOMonth,0) as accperpaydaywhennoteomnth
		,ISNULL(ac.PayFrequency,0) as payfreq
		,ISNULL(nt.PaymentDateBusinessDayLag,0) as paydatebusiessdaylag
		,ISNULL(lStubPaidinAdvanceYN.name,'') as stubpaidadv
		,nt.FinalInterestAccrualEndDateOverride as finalintaccenddtvrd  --dt
		,ISNULL(lStubInterestPaidonFutureAdvances.name,'') as stubonff
		,ISNULL(nt.MonthlyDSOverridewhenAmortizing,0) as monamovrd
		,ISNULL(lFixedAmortScheduleCheck.name,'') as fixedamortsche
		,ISNULL(nt.AmortIntCalcDayCount,0) as amortintcalcdaycnt
		,ISNULL(lPIKInterestAddedToBalanceBasedOnBusinessAdjustedDate.name,'') as pikinteraddedtoblsbusiadvdate
		,ISNULL(lPIKSeparateCompounding.name,'') as piksepcomponding
		,ISNULL(lInterestCalculationRuleForPaydownsAmort.name,'') as intcalcruleforpydwnamort
		
		,nt.ActualPayOffDate as actualpayoffdate
		,ISNULL(nt.[priority],0) as [priority]
		,isnuLL(llienposition.name,'') as lienpos
		
		,nt.lienposition
		,ac.name as NoteName

		,ISNULL(lpikCalculationRuleForPaydowns.name,'') as pikcalcrulepydn
		,ISNULL(lpikCalculationRuleForPaydownsAmort.name,'') as pikcalcruleforamort
		
		,ISNULL(lInterestCalculationRuleForPaydowns.name,'') as intcalcrulepikprinpmt
		,ISNULL(lpikCalculationRuleForPaydowns.name,'') as pikcalcrulepikprinpmt
		,nt.expectedmaturitydate
		,nt.FirstIndexDeterminationDateOverride as FstIndexDeterDtOverride

		,ISNULL(lAccrualPeriodType.name,'') as accrualperiodtype
		,ISNULL(lAccrualPeriodBusinessDayAdj.name,'') as accrualperiodbusinessdayadj
		,(CASE WHEN ISNULL(LDeterminationDateHolidayList.CalendarName,'') = 'US & UK' Then 'US_and_UK' ELSE ISNULL(LDeterminationDateHolidayList.CalendarName,'') END)  as detdt_hlday_ls

		from cre.note nt 
		inner join [CORE].[Account] ac on nt.Account_AccountID=ac.AccountID 
		left join core.lookup lRoundingMethod on lRoundingMethod.lookupid = nt.RoundingMethod
		left JOin core.lookup lLoanPurchase on lLoanPurchase.lookupid = nt.LoanPurchase
		left JOin core.lookup lIncludeServicingPaymentOverrideinLevelYield on lIncludeServicingPaymentOverrideinLevelYield.lookupid = nt.IncludeServicingPaymentOverrideinLevelYield
		left JOin core.lookup lInterestCalculationRuleForPaydowns on lInterestCalculationRuleForPaydowns.lookupid = nt.InterestCalculationRuleForPaydowns
		left JOin core.lookup lStubPaidinAdvanceYN on lStubPaidinAdvanceYN.lookupid = nt.StubPaidinAdvanceYN
		left JOin core.lookup lStubInterestPaidonFutureAdvances on lStubInterestPaidonFutureAdvances.lookupid = nt.StubInterestPaidonFutureAdvances
		left JOin core.lookup lFixedAmortScheduleCheck on lFixedAmortScheduleCheck.lookupid = nt.FixedAmortScheduleCheck
		left JOin core.lookup lPIKInterestAddedToBalanceBasedOnBusinessAdjustedDate on lPIKInterestAddedToBalanceBasedOnBusinessAdjustedDate.lookupid = nt.PIKInterestAddedToBalanceBasedOnBusinessAdjustedDate
		left JOin core.lookup lPIKSeparateCompounding on lPIKSeparateCompounding.lookupid = nt.PIKSeparateCompounding
		left JOin core.lookup lInterestCalculationRuleForPaydownsAmort on lInterestCalculationRuleForPaydownsAmort.lookupid = nt.InterestCalculationRuleForPaydownsAmort
		left join Core.Lookup llienposition ON nt.lienposition=llienposition.LookupID 
		left JOin core.lookup lpikCalculationRuleForPaydowns on lpikCalculationRuleForPaydowns.lookupid = nt.pikCalculationRuleForPaydowns
		left JOin core.lookup lpikCalculationRuleForPaydownsAmort on lpikCalculationRuleForPaydownsAmort.lookupid = nt.pikCalculationRuleForPaydownsAmort

		left JOin core.lookup lAccrualPeriodType on lAccrualPeriodType.lookupid = ISNULL(nt.AccrualPeriodType,811)
		left JOin core.lookup lAccrualPeriodBusinessDayAdj on lAccrualPeriodBusinessDayAdj.lookupid = ISNULL(nt.AccrualPeriodBusinessDayAdj,813)
		LEFT JOIN app.HoliDaysMaster LDeterminationDateHolidayList ON LDeterminationDateHolidayList.HolidayMasterID = nt.DeterminationDateHolidayList	
		Left Join(
			
			Select  n.noteid,ISNULL(n.actualpayoffdate,tblmatfull.FullyExtended) InitialMat
			from cre.note n
			left join(
				Select n.noteid,mat.MaturityDate as FullyExtended
				from [CORE].Maturity mat  
				INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
				INNER JOIN   
				(          
					Select   
					(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
					MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
					INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
					INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
					where EventTypeID = 11  and eve.StatusID = 1
					and acc.IsDeleted = 0  
					and n.DealID = @DealID
					GROUP BY n.Account_AccountID,EventTypeID    
				) sEvent    
				ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  and e.StatusID = 1
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 	
				where mat.MaturityType = 710 and mat.Approved = 3
			)tblmatfull on tblmatfull.noteid = n.noteid
			where n.DealID = @DealID

			--Select n.noteid,mat.MaturityDate as InitialMat
			--from [CORE].Maturity mat  
			--INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
			--INNER JOIN   
			--(          
			--	Select   
			--	(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
			--	MIN(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
			--	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
			--	INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
			--	where EventTypeID = 11  and eve.StatusID = 1
			--	and acc.IsDeleted = 0  
			--	and n.DealID = @DealID
			--	GROUP BY n.Account_AccountID,EventTypeID    
			--) sEvent    
			--ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  and e.StatusID = 1
			--INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
			--INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 	
			--where mat.MaturityType = 708 and mat.Approved = 3
			--and n.DealID = @DealID

		)tblInitmat on tblInitmat.NoteID = nt.NoteID

		where ac.isdeleted <> 1 and nt.DealID=@DealID
	) tbldictionary
	

) as [data.notes.setup.dictionary]

order by ISNULL(lienposition,99999), [Priority],initbal desc, NoteName

insert into @tTableAlias([Name]) values('data.notes.setup.dictionary')
--
 --
 --setup->tables->all rate spread with one result set corresponding to each
insert into @tRateSpreadSchedule
Select distinct rs.ValuetypeID,replace(lower(tl.[Name]),' ','_')
from core.RateSpreadSchedule rs  
INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId  
INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
LEFT JOIN core.Lookup tl ON tl.LookupID=rs.ValueTypeID
INNER JOIN #tNoteEffectiveDates tn on tn.NoteID=n.NoteID and tn.EffectiveDate=e.effectivestartdate
where e.statusid = 1


select @totalCntRateSpread = count(1) from @tRateSpreadSchedule
while (@cnt<=@totalCntRateSpread)
BEGIN
	 select @ValueTypeID=ValueTypeID,@Name=Name from @tRateSpreadSchedule where ID=@cnt
	
	if(@Name = 'rate')
	BEGIN
		 set @RateSpreadSchedule='Select CRENoteID, NoteID,
		 CONVERT(VARCHAR, EffectiveDate,101) as EffectiveDate,
		 CONVERT(VARCHAR, startdt,101) as startdt,
		 valtype,
		 val,
		 intcalcdays,
		 detdt_hlday_ls,
		 LOWER(indexnametext) as indexnametext
		 from
		 (
			 Select n.CRENoteID ,tn.NoteID,tn.EffectiveDate,rs.Date as startdt,
			 '''+@Name+''' as valtype,isnull(rs.Value,0) as val ,
			 ISNULL(IntCalcMethodID,0) as intcalcdays
			 ,(CASE WHEN ISNULL(LDeterminationDateHolidayList.CalendarName,'''') = ''US & UK'' Then ''US_and_UK'' ELSE ISNULL(LDeterminationDateHolidayList.CalendarName,'''') END)  as detdt_hlday_ls
			 ,ISNULL(lindex.name,'''') as indexnametext
			from core.RateSpreadSchedule rs  
			INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId  
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
			LEFT JOIN core.Lookup tl ON tl.LookupID=rs.ValueTypeID
			LEFT JOIN app.HoliDaysMaster LDeterminationDateHolidayList ON LDeterminationDateHolidayList.HolidayMasterID = rs.DeterminationDateHolidayList
			LEFT JOIN [CORE].[Lookup] lindex ON lindex.LookupID = rs.IndexNameID 
			INNER JOIN #tNoteEffectiveDates tn on tn.NoteID=n.NoteID and tn.EffectiveDate=e.effectivestartdate
			where e.statusid = 1 and ValueTypeID='''+@ValueTypeID+'''

			union all

			Select n.CRENoteID ,tn.NoteID,tn.EffectiveDate,rs.Date as startdt,
			 '''+@Name+''' as valtype,0 as val ,
			 ISNULL(IntCalcMethodID,0) as intcalcdays
			 ,(CASE WHEN ISNULL(LDeterminationDateHolidayList.CalendarName,'''') = ''US & UK'' Then ''US_and_UK'' ELSE ISNULL(LDeterminationDateHolidayList.CalendarName,'''') END)  as detdt_hlday_ls
			 ,ISNULL(lindex.name,'''') as indexnametext
			from core.RateSpreadSchedule rs  
			INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId  
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
			LEFT JOIN core.Lookup tl ON tl.LookupID=rs.ValueTypeID
			LEFT JOIN app.HoliDaysMaster LDeterminationDateHolidayList ON LDeterminationDateHolidayList.HolidayMasterID = rs.DeterminationDateHolidayList
			LEFT JOIN [CORE].[Lookup] lindex ON lindex.LookupID = rs.IndexNameID 
			INNER JOIN #tNoteEffectiveDates tn on tn.NoteID=n.NoteID and tn.EffectiveDate=e.effectivestartdate
			where e.statusid = 1 and ValueTypeID=151
		) as [data.notes.'''+@Name+''']'
	END
	ELSE if(@Name = 'spread')
	BEGIN
		 set @RateSpreadSchedule='Select CRENoteID, NoteID,
		 CONVERT(VARCHAR, EffectiveDate,101) as EffectiveDate,
		 CONVERT(VARCHAR, startdt,101) as startdt,
		 valtype,
		 val,
		 intcalcdays,
		 detdt_hlday_ls,
		 LOWER(indexnametext) as indexnametext
		 from
		 (
			 Select n.CRENoteID ,tn.NoteID,tn.EffectiveDate,rs.Date as startdt,
			 '''+@Name+''' as valtype,isnull(rs.Value,0) as val ,
			 ISNULL(IntCalcMethodID,0) as intcalcdays
			 ,(CASE WHEN ISNULL(LDeterminationDateHolidayList.CalendarName,'''') = ''US & UK'' Then ''US_and_UK'' ELSE ISNULL(LDeterminationDateHolidayList.CalendarName,'''') END)  as detdt_hlday_ls
			 ,ISNULL(lindex.name,'''') as indexnametext
			from core.RateSpreadSchedule rs  
			INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId  
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
			LEFT JOIN core.Lookup tl ON tl.LookupID=rs.ValueTypeID
			LEFT JOIN app.HoliDaysMaster LDeterminationDateHolidayList ON LDeterminationDateHolidayList.HolidayMasterID = rs.DeterminationDateHolidayList
			LEFT JOIN [CORE].[Lookup] lindex ON lindex.LookupID = rs.IndexNameID 
			INNER JOIN #tNoteEffectiveDates tn on tn.NoteID=n.NoteID and tn.EffectiveDate=e.effectivestartdate
			where e.statusid = 1 and ValueTypeID='''+@ValueTypeID+'''

			union all

			Select n.CRENoteID ,tn.NoteID,tn.EffectiveDate,rs.Date as startdt,
			 '''+@Name+''' as valtype,0 as val ,
			 ISNULL(IntCalcMethodID,0) as intcalcdays
			 ,(CASE WHEN ISNULL(LDeterminationDateHolidayList.CalendarName,'''') = ''US & UK'' Then ''US_and_UK'' ELSE ISNULL(LDeterminationDateHolidayList.CalendarName,'''') END)  as detdt_hlday_ls
			 ,ISNULL(lindex.name,'''') as indexnametext
			from core.RateSpreadSchedule rs  
			INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId  
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
			LEFT JOIN core.Lookup tl ON tl.LookupID=rs.ValueTypeID
			LEFT JOIN app.HoliDaysMaster LDeterminationDateHolidayList ON LDeterminationDateHolidayList.HolidayMasterID = rs.DeterminationDateHolidayList
			LEFT JOIN [CORE].[Lookup] lindex ON lindex.LookupID = rs.IndexNameID 
			INNER JOIN #tNoteEffectiveDates tn on tn.NoteID=n.NoteID and tn.EffectiveDate=e.effectivestartdate
			where e.statusid = 1 and ValueTypeID=150
		) as [data.notes.'''+@Name+''']'
	END
	ELSE
	BEGIN
	 set @RateSpreadSchedule='Select CRENoteID, NoteID,
	 CONVERT(VARCHAR, EffectiveDate,101) as EffectiveDate,
	 CONVERT(VARCHAR, startdt,101) as startdt,
	 valtype,
	 val,
	 intcalcdays,
	 detdt_hlday_ls,
	 LOWER(indexnametext) as indexnametext
	 from
	 (
		 Select n.CRENoteID ,tn.NoteID,tn.EffectiveDate,rs.Date as startdt,
		 '''+@Name+''' as valtype,isnull(rs.Value,0) as val ,
		 ISNULL(IntCalcMethodID,0) as intcalcdays
		 ,(CASE WHEN ISNULL(LDeterminationDateHolidayList.CalendarName,'''') = ''US & UK'' Then ''US_and_UK'' ELSE ISNULL(LDeterminationDateHolidayList.CalendarName,'''') END)  as detdt_hlday_ls
		 ,ISNULL(lindex.name,'''') as indexnametext
		from core.RateSpreadSchedule rs  
		INNER JOIN [CORE].[Event] e on e.EventID = rs.EventId  
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		LEFT JOIN core.Lookup tl ON tl.LookupID=rs.ValueTypeID
		LEFT JOIN app.HoliDaysMaster LDeterminationDateHolidayList ON LDeterminationDateHolidayList.HolidayMasterID = rs.DeterminationDateHolidayList
		LEFT JOIN [CORE].[Lookup] lindex ON lindex.LookupID = rs.IndexNameID 
		INNER JOIN #tNoteEffectiveDates tn on tn.NoteID=n.NoteID and tn.EffectiveDate=e.effectivestartdate
		where e.statusid = 1 and ValueTypeID='''+@ValueTypeID+'''
	) as [data.notes.'''+@Name+''']'
	END

	insert into @tTableAlias ([Name],GroupName) values('data.notes.'+@Name,'rate')
	EXEC (@RateSpreadSchedule)
	set @cnt+=1
END

--

--

--data.deal.setup.min_effective_date
select CONVERT(VARCHAR, @deal_min_effDate,101) as min_effective_dates,
CONVERT(VARCHAR, clsdt,101) as clsdt,
initbal,
CONVERT(VARCHAR, initmatdt,101) as initmatdt
from
(
	select
	(select min(n.closingDate) as period_start_date
		from [CORE].[Event] eve
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
		inner join cre.deal d on d.DealID=n.DealID
		where  acc.IsDeleted=0
		and isnull(eve.StatusID,1) = 1
		and d.dealid=@DealID
	) as clsdt,
	(select sum(isnull(InitialFundingAmount,0)) from cre.note where dealid=@DealID) as initbal,
	(Select  MIN(mat.maturityDate) 
		from [CORE].Maturity mat  
		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 		
		where e.statusid = 1 and 
		mat.maturityType = 708 
		and	mat.Approved = 3
		and n.dealid = @DealID
		and e.effectiveStartDate=@deal_min_effDate
		group by n.dealid
	) as initmatdt

) as [data.deal.setup.min_effective_date]

insert into @tTableAlias([Name]) values('data.deal.setup.min_effective_date')
--
 
 
--data.rulesets.pay
Select @TotalSequ1 = sum(ISNULL(fs.Value,0))
from [CRE].[FundingRepaymentSequence] fs
INNER JOIN [CRE].[Note] n ON fs.NoteID=n.NoteID
LEFT JOIN [CORE].[Lookup] LSequenceTypeID ON LSequenceTypeID.LookupID = fs.SequenceType
where n.DealID =@DealID
and fs.SequenceNo=1 and fs.SequenceType=258

select CRENoteID as note, CAST(ROUND(Value,2) as decimal(28,2))  as cumulative_threshold,[weight]
from
(
	Select n.CRENoteID,isnull(fs.Value,0) as Value,
	[weight]=case when isnull(fs.Value,0)=0 then 0 else isnull(fs.Value,0)/@TotalSequ1 end,
	1 as sortorder
	from [CRE].[FundingRepaymentSequence] fs
	INNER JOIN [CRE].[Note] n ON fs.NoteID=n.NoteID
	inner join Core.Account a on a.AccountID=n.Account_AccountID
	LEFT JOIN [CORE].[Lookup] LSequenceTypeID ON LSequenceTypeID.LookupID = fs.SequenceType
	where n.DealID =@DealID
	and fs.SequenceNo=1 and fs.SequenceType=258
	and n.UseRuletoDetermineNoteFunding=@UseRuletoDetermineNoteFundingAsYES

	union

	select CRENoteID,Value, [weight],sortorder 
	from (
		Select top 1 n.CRENoteID,0 as Value,0 as [weight], 2 as sortorder
		from [CRE].[FundingRepaymentSequence] fs
		INNER JOIN [CRE].[Note] n ON fs.NoteID=n.NoteID
		inner join Core.Account a on a.AccountID=n.Account_AccountID
		LEFT JOIN [CORE].[Lookup] LSequenceTypeID ON LSequenceTypeID.LookupID = fs.SequenceType
		where n.DealID =@DealID
		and fs.SequenceNo=1 and fs.SequenceType=258
		and n.UseRuletoDetermineNoteFunding=@UseRuletoDetermineNoteFundingAsYES
		order by ISNULL(n.lienposition,99999), n.Priority,n.InitialFundingAmount desc, a.Name
	) tb1
) as [data.rulesets.pay]
order by sortorder

insert into @tTableAlias([Name]) values('data.rulesets.pay')
--


select CalendarName as HolidayTypeText,CONVERT(VARCHAR, HoliDayDate,101) HoliDayDate	
from App.HoliDays hd 
left join app.HoliDaysMaster hdm on hdm.HolidayMasterID = hd.HoliDayTypeID
Order by CalendarName,CAST(HoliDayDate as date)
insert into @tTableAlias([Name]) values('data.calendars')

----===============================================================================
	Declare @ServicerMasterID int;
	Declare @ServicerModifiedID int;
	Declare @ServicerManual int;

	SET @ServicerMasterID = (Select ServicerMasterID from cre.servicermaster where ServicerName = 'M61Addin')	
	SET @ServicerModifiedID = (Select ServicerMasterID from cre.servicermaster where ServicerName = 'Modified')	
	SET @ServicerManual = (Select ServicerMasterID from cre.servicermaster where ServicerName = 'ManualTransaction')

	select note.CRENoteID as CRENoteID,
	ty.accountname as account,
	CONVERT(VARCHAR, ntd.RelatedtoModeledPMTDate,101) as dt,
	note.crenoteid as note,

	(CASE WHEN (ty.Calculated = 3 and IncludeServicingReconciliation = 3) THEN (Case When ntd.OverrideValue > 0 then ntd.OverrideValue When (isnull(ntd.M61Value,0) = 0 and isnull(ntd.ServicerValue,0) = 0 ) then ntd.OverrideValue When (isnull(ntd.M61Value,0) <> 0 ) Then ntd.CalculatedAmount	When (isnull(ntd.ServicerValue,0) <>0 ) Then ntd.ServicingAmount	When (isnull(ntd.Ignore,0) <> 0 ) Then ntd.OverrideValue	ELSE ntd.CalculatedAmount END) 
	WHEN (ty.Calculated = 3 and AllowCalculationOverride = 3) THEN ntd.CalculatedAmount
	WHEN (ty.Calculated = 4 and ServicerMasterID <> @ServicerManual) 
		THEN (CASE WHEN TransactionTypeText = 'PrepaymentFeeExcludedFromLevelYield' THEN (Case When ntd.OverrideValue > 0 then ntd.OverrideValue When (isnull(ntd.M61Value,0) = 0 and isnull(ntd.ServicerValue,0) = 0 ) then ntd.OverrideValue When (isnull(ntd.M61Value,0) <> 0 ) Then ntd.CalculatedAmount	When (isnull(ntd.ServicerValue,0) <>0 ) Then ntd.ServicingAmount	When (isnull(ntd.Ignore,0) <> 0 ) Then ntd.OverrideValue	ELSE ntd.CalculatedAmount END) ELSE ntd.CalculatedAmount END)
	WHEN (ty.Calculated = 4 and ServicerMasterID = @ServicerManual) THEN (Case When ntd.OverrideValue > 0 then ntd.OverrideValue When (isnull(ntd.M61Value,0) = 0 and isnull(ntd.ServicerValue,0) = 0 ) then ntd.OverrideValue When (isnull(ntd.M61Value,0) <> 0 ) Then ntd.CalculatedAmount	When (isnull(ntd.ServicerValue,0) <>0 ) Then ntd.ServicingAmount	When (isnull(ntd.Ignore,0) <> 0 ) Then ntd.OverrideValue	ELSE ntd.CalculatedAmount END) 
	ELSE ntd.CalculatedAmount END) as [val],

	CAST((CASE WHEN Cash_NonCash = 'Cash' then 1 else 0 end) as bit) as cash,
	CAST((CASE WHEN ty.Calculated = 3 THEN 1 ELSE 0 END) as bit) as calculated,

	CONVERT(VARCHAR, ntd.TransactionDate ,101) as trans_dt,
	CONVERT(VARCHAR, ntd.RemittanceDate ,101)  as remit_dt,

	COnvert(VARCHAR,
	Cast(	
	(Case WHEN RemittanceDate <= dbo.Fn_GetnextWorkingDays(Cast(RelatedtoModeledPMTDate as datetime), (case when TransactionTypeText = 'ScheduledPrincipalPaid' then 10 else 5 end)  ,'PMT Date') THEN Cast(RelatedtoModeledPMTDate as datetime) 
	WHEN RemittanceDate > dbo.Fn_GetnextWorkingDays(Cast(RelatedtoModeledPMTDate as datetime),(case when TransactionTypeText = 'ScheduledPrincipalPaid' then 10 else 5 end),'PMT Date') THEN RemittanceDate 
	ELSE RelatedtoModeledPMTDate END) 	
	as datetime)  
	,101) as transdtbyrule_dt
	,ntd.Adjustment as adjustment
	,ntd.ActualDelta as actualdelta
	,CONVERT(VARCHAR, DATEADD(day,1,note.InitialInterestAccrualEndDate),101) as initialinterestaccrualenddate

	from cre.NoteTransactionDetail ntd
	inner join CRE.Note note on note.NoteID = ntd.NoteID 
	inner join Core.Account ac on note.Account_AccountID=ac.AccountID
	left join Core.Lookup l1 on l1.LookupID =ntd.TransactionType 
	left join cre.TransactionTypes ty on ty.TransactionName = ntd.TransactionTypeText
	where note.DealID  = @DealID
	and ac.IsDeleted=0
	and ntd.TransactionTypeText in ('PIKInterestPaid','InterestPaid','OriginationFeeExcludedFromLevelYield','UnusedFeeExcludedFromLevelYield')
	and ((Calculated = 3 and IncludeServicingReconciliation = 3) 
			or (Calculated = 3 and AllowCalculationOverride = 3 and ntd.ServicerMasterID = @ServicerModifiedID) 
			or (Calculated = 4))
	and ntd.RelatedtoModeledPMTDate <= @prepaydate

	order by note.crenoteid,ntd.RelatedtoModeledPMTDate asc,ntd.TransactionDate asc

 insert into @tTableAlias([Name]) values('data.notes.actuals')

----====================================================================================================== 


Update core.calculationrequests set jsonpicktime =getdate() where DealID = @DealID and AnalysisID = @AnalysisID




Select e.DealID
,CONVERT(VARCHAR, e.EffectiveDate,101)  as EffectiveDate_Prepay
--,CONVERT(VARCHAR, ps.[PrepayDate],101)  as [PrepayDate]
,CONVERT(VARCHAR, ps.[CalcThru],101)  as  CalcThru
,ISNULL(PrepaymentMethod,0) as [PrepaymentMethod]
,ISNULL(BaseAmountType,0) as BaseAmountType
,ISNULL(SpreadCalcMethod,0) as [SpreadCalcMethod]
,ISNULL(ps.[GreaterOfSMOrBaseAmtTimeSpread],0) as GreaterOfSMOrBaseAmtTimeSpread
,ISNULL(ps.HasNoteLevelSMSchedule,0) as HasNoteLevelSMSchedule 
,(CASE when ps.IncludeFeesInCredits = 1 then 'true' else 'false' end) as IncludeFeesInCredits
,CONVERT(VARCHAR, ps.OpenPaymentDate,101)  as OpenPaymentDate
,ISNULL(ps.[MinimumMultipleDue],0) as MinimumMultipleDue
	
from [CORE].prepaySchedule ps
INNER JOIN [CORE].[EventDeal] e on e.EventDealID = ps.EventDealID
Inner join cre.deal d on d.dealid = e.dealid
where d.IsDeleted<>1 and e.StatusID = 1  
and e.dealid = @DealID
ORDER BY e.DealID,e.EffectiveDate
insert into @tTableAlias([Name]) values('data.notes.PrepayScheduleDict')

 
--====================================================
Declare @tblSpreadMain as table(
DealID	UNIQUEIDENTIFIER,
EffectiveDate_Prepay	date,
HasNoteLevelSMSchedule	bit,
CRENoteID	nvarchar(256) null,
[date]	date,
SpreadPercentage	decimal(28,15),
CalcAfterPayoff bit
)


Declare @c_DealID UNIQUEIDENTIFIER
Declare @c_effectivedate date
Declare @c_PrepayScheduleID int
Declare @c_HasNoteLevelSMSchedule bit
 
IF CURSOR_STATUS('global','Cursor_Prepay')>=-1
BEGIN
	DEALLOCATE Cursor_Prepay
END

DECLARE Cursor_Prepay CURSOR 
for
(
	Select e.dealid,e.effectivedate,ps.PrepayScheduleID,ISNULL(ps.HasNoteLevelSMSchedule,0) as HasNoteLevelSMSchedule
	from core.PrepaySchedule ps 
	INNER JOIN [CORE].[EventDeal] e on e.EventDealID = ps.EventDealID
	Inner JOin cre.deal d on d.dealid = e.dealid
	where e.StatusID = 1  
	and e.dealid = @DealID
)
OPEN Cursor_Prepay 

FETCH NEXT FROM Cursor_Prepay
INTO @c_DealID,@c_effectivedate,@c_PrepayScheduleID,@c_HasNoteLevelSMSchedule

WHILE @@FETCH_STATUS = 0
BEGIN

	IF(@c_HasNoteLevelSMSchedule = 1)
	BEGIN
		
		INSERT INTO @tblSpreadMain (DealID,EffectiveDate_Prepay,HasNoteLevelSMSchedule,CRENoteID,date,SpreadPercentage,CalcAfterPayoff)
		Select e.DealID,
		CONVERT(VARCHAR, e.EffectiveDate,101) as EffectiveDate_Prepay
		,ps.HasNoteLevelSMSchedule
		,n.crenoteid as CRENoteID
		,CONVERT(VARCHAR, sm.date,101) [date]
		,sm.Spread as Spread
		,sm.CalcAfterPayoff
		from [CORE].SpreadMaintenanceSchedule sm
		inner join core.PrepaySchedule ps on sm.PrepayScheduleID = ps.PrepayScheduleID
		INNER JOIN [CORE].[EventDeal] e on e.EventDealID = ps.EventDealID
		Inner JOin cre.deal d on d.dealid = e.dealid
		left join cre.note n on n.noteid = sm.noteid
		where e.StatusID = 1  
		and e.dealid = @c_DealID
		and sm.date is not null
		order by e.EffectiveDate,sm.date

		Update [CRE].[JsonFormatCalcV1] set [IsActive] = 1 Where [Type] = 'tbl_SpreadMaintenanceSchedule' and [Key] = 'CRENoteID'
	END
	ELSE
	BEGIN
		INSERT INTO @tblSpreadMain (DealID,EffectiveDate_Prepay,HasNoteLevelSMSchedule,CRENoteID,date,SpreadPercentage,CalcAfterPayoff)
		Select Distinct e.DealID,
		CONVERT(VARCHAR, e.EffectiveDate,101) as EffectiveDate_Prepay
		,ps.[HasNoteLevelSMSchedule]
		,null as CRENoteID
		,CONVERT(VARCHAR, sm.date,101) [date]
		,sm.Spread as SpreadPercentage
		,sm.CalcAfterPayoff
		from [CORE].SpreadMaintenanceSchedule sm
		inner join core.PrepaySchedule ps on sm.PrepayScheduleID = ps.PrepayScheduleID
		INNER JOIN [CORE].[EventDeal] e on e.EventDealID = ps.EventDealID
		Inner JOin cre.deal d on d.dealid = e.dealid
		where e.StatusID = 1  
		and e.dealid = @c_DealID
		and sm.date is not null


		Update [CRE].[JsonFormatCalcV1] set [IsActive] = 0 Where [Type] = 'tbl_SpreadMaintenanceSchedule' and [Key] = 'CRENoteID'
		
	END
	
					 
FETCH NEXT FROM Cursor_Prepay
INTO @c_DealID,@c_effectivedate,@c_PrepayScheduleID,@c_HasNoteLevelSMSchedule
END
CLOSE Cursor_Prepay   
DEALLOCATE Cursor_Prepay

Select DealID,
CONVERT(VARCHAR, EffectiveDate_Prepay,101) as EffectiveDate_Prepay
,ISNULL(HasNoteLevelSMSchedule,0) HasNoteLevelSMSchedule
,ISNULL(CRENoteID,'') as CRENoteID
,CONVERT(VARCHAR, [date],101) [Date]
,SpreadPercentage as Spread
,CalcAfterPayoff from @tblSpreadMain 
insert into @tTableAlias([Name]) values('data.notes.SpreadMaintenanceSchedule')
--====================================================


Select e.DealID
,CONVERT(VARCHAR, e.EffectiveDate,101) as EffectiveDate_Prepay
,CONVERT(VARCHAR, sm.date,101) [Date]
,ISNULL(sm.PrepayAdjAmt,0) as PrepayAdjAmt 
,ISNULL(sm.Comment,'') Comment
from [CORE].PrepayAdjustment sm
inner join core.PrepaySchedule ps on sm.PrepayScheduleID = ps.PrepayScheduleID
INNER JOIN [CORE].[EventDeal] e on e.EventDealID = ps.EventDealID
inner join cre.deal d on d.dealid =e.dealid 
where d.isdeleted <> 1 and e.StatusID = 1  
and e.dealid = @DealID
order by e.DealID,e.EffectiveDate,sm.date
insert into @tTableAlias([Name]) values('data.notes.PrepayAdjustment')



Select e.DealID
,CONVERT(VARCHAR, e.EffectiveDate,101) as EffectiveDate_Prepay
,CONVERT(VARCHAR, sm.date,101) [Date]
,ISNULL(sm.MinMultAmount,0) as MinMultAmount
from [CORE].MinMultSchedule sm
inner join core.PrepaySchedule ps on sm.PrepayScheduleID = ps.PrepayScheduleID
INNER JOIN [CORE].[EventDeal] e on e.EventDealID = ps.EventDealID
inner join cre.deal d on d.dealid =e.dealid
where e.StatusID = 1  
and sm.IsDeleted <> 1
and e.dealid = @DealID
order by e.DealID,e.EffectiveDate,sm.date
insert into @tTableAlias([Name]) values('data.notes.MinMultSchedule')



Select e.DealID
,CONVERT(VARCHAR, e.EffectiveDate,101) as EffectiveDate_Prepay
,iSNULL(f.FeeTypeNameText,'') as FeeType
,ISNULL(sm.FeeCreditOverride,0) as OverrideFeeAmount
,iSNULL(UseActualFees,0) as UseActualFees
from [CORE].FeeCredits sm
inner join core.PrepaySchedule ps on sm.PrepayScheduleID = ps.PrepayScheduleID
INNER JOIN [CORE].[EventDeal] e on e.EventDealID = ps.EventDealID
inner join cre.deal d on d.dealid =e.dealid
left join [CRE].[FeeSchedulesConfig] f on f.[FeeTypeNameID] = sm.FeeType
where e.StatusID = 1  and sm.IsDeleted <> 1
and iSNULL(UseActualFees,0) <> 1
and e.dealid = @DealID
order by e.DealID,e.EffectiveDate
insert into @tTableAlias([Name]) values('data.notes.FeeCredits')




select @DealID as DealID,eff.CRENoteID
,eff.NoteID
,CONVERT(VARCHAR,eff.EffectiveDate,101) EffectiveDate
,CAST(ROUND(ISNULL(x.NoteAdjustedTotalCommitment,0),2) as decimal(28,2)) noteadjustedtotalcommitment
,CAST(ROUND(ISNULL(x.NoteTotalCommitment,0),2) as decimal(28,2)) totalcmt
from #tNoteEffectiveDates eff
Outer Apply (
	Select top 1 dealid,credealid,CRENoteID,Date,NoteAdjustedTotalCommitment,NoteTotalCommitment
	From(			
		SELECT d.dealid,d.CREDealID
		,n.CRENoteID
		,Date as Date
		,nd.Type as Type
		,NoteAdjustedTotalCommitment
		,NoteTotalCommitment
		,nd.NoteID
		,ROW_NUMBER() OVER (PARTITION BY nd.NoteID order by nd.NoteID,nd.RowNo desc ,Date) as rno,
		nd.Rowno
		from cre.NoteAdjustedCommitmentMaster nm
		left join cre.NoteAdjustedCommitmentDetail nd on nd.NoteAdjustedCommitmentMasterID = nm.NoteAdjustedCommitmentMasterID
		right join cre.deal d on d.DealID=nm.DealID
		Right join cre.note n on n.NoteID = nd.NoteID
		inner join core.account acc on acc.AccountID = n.Account_AccountID
		where d.IsDeleted<>1 and acc.IsDeleted<>1		
		and n.dealid = @DealID
	)a
	where a.date <= eff.EffectiveDate
	order by rno
)x
order by eff.CRENoteID,eff.EffectiveDate 
insert into @tTableAlias([Name]) values('data.notes.NoteAdjustedCommitment')
--===================================================================================


Declare @ScenarioId UNIQUEIDENTIFIER = @Analysis_ID  ---'C10F3372-0FC2-4861-A9F5-148F1F80804F'


IF OBJECT_ID('tempdb..#tblTr ') IS NOT NULL             
	DROP TABLE #tblTr

CREATE TABLE #tblTr
(
crenoteid nvarchar(256),
NoteID	UNIQUEIDENTIFIER,
[Date]	Date,
Amount	decimal(28,15),
[Type]	nvarchar(256),
LIBORPercentage	decimal(28,15),
PIKInterestPercentage	decimal(28,15),
SpreadPercentage	decimal(28,15),
FeeName	nvarchar(256),
TransactionDateByRule	Date,
DueDate	 Date,
RemitDate	Date,
TransactionCategory	nvarchar(256),
Comment nvarchar(256),
FeeTypeName nvarchar(256)
)

Declare @tblTranType as Table(
TransType nvarchar(256)
)

INSERT INTO @tblTranType(TransType)
Select TransType from(
	Select [Name] as TransType from core.Lookup where ParentID = 94
	UNION ALL
	Select 'InterestPaid' as TransType
	UNION ALL
	Select 'FloatInterest' as TransType
	UNION ALL
	Select 'PIKInterestPaid' as TransType
)a


INSERT INTO #tblTr(crenoteid,NoteID,Date,Amount,Type,LIBORPercentage,PIKInterestPercentage,SpreadPercentage,FeeName,TransactionDateByRule,DueDate,RemitDate,TransactionCategory,Comment,FeeTypeName)

Select crenoteid,NoteID,Date,Amount,Type,LIBORPercentage,PIKInterestPercentage,SpreadPercentage,FeeName,TransactionDateByRule,DueDate,RemitDate,TransactionCategory,Comment ,FeeTypeName
From
(
	Select n.crenoteid,
	n.NoteID, 
	(CASE WHEN (Select Count(TransType) from @tblTranType where CHARINDEX(Replace(TransType,' ',''),Replace(tt.[Type],' ','')) = 1) > 0 
		THEN ISNULL(TransactionDateByRule,tt.[Date])
		ELSE tt.[Date]
	END) AS [Date],
	tt.Amount,
	tt.Type,	
	/*(case 
	when tt.[Type] = 'InterestPaid' then tblTr.LIBORPercentage 
	when tt.[Type] = 'StubInterest' then n.InitialIndexValueOverride --n.StubInterestRateOverride 
	when tt.[Type] in ('PIKInterest','PIKInterestPaid') then tblTr.PIKLiborPercentage  
	else null end) as LIBORPercentage,
	(case when tt.[Type] = 'PIKInterest' then tblTr.PIKInterestPercentage else null end) as PIKInterestPercentage,
	(case when tt.[Type] in ('InterestPaid','StubInterest') then tblTr.SpreadPercentage 
		when tt.[Type] in ('PIKInterest','PIKInterestPaid') then tblTr.PIKInterestPercentage 
		else null 
		end
	) as SpreadPercentage,
	*/
	tt.IndexValue as LIBORPercentage,
	NULL as PIKInterestPercentage,
	tt.SpreadValue as SpreadPercentage,
	FeeName,
	tt.TransactionDateServicingLog as TransactionDateByRule,
	tt.[Date] as DueDate,
	tt.RemitDate as RemitDate,
	tym.TransactionCategory,
	tt.comment,
	tt.FeeTypeName
	from cre.transactionentry tt
	Inner join cre.note n on n.Account_accountid = tt.accountid
	/*
	LEFT JOIN
	(
		Select Noteid,Date,LIBORPercentage,PIKInterestPercentage,SpreadPercentage,PIKLiborPercentage
		from(
			select  n.Noteid,te.[Date] ,te.Amount,te.[Type] ValueType
			from  CRE.TransactionEntry te
			left join cre.note n on n.Account_accountid = te.accountid
			where te.analysisID= @ScenarioId and n.dealid =  @DealID


			AND te.type in ('LIBORPercentage','PIKInterestPercentage','SpreadPercentage','PIKLiborPercentage')
		)a
		PIVOT (
		SUM(Amount)
		FOR ValueType in (LIBORPercentage,PIKInterestPercentage,SpreadPercentage,PIKLiborPercentage)
		) pvt
	)tblTr on tblTr.noteid = n.noteid and tblTr.[Date] = tt.[Date]
	*/
	left join cre.transactiontypes tym on LOWER(tym.TransactionName) = LOWER(tt.[Type])
	where tt.analysisID= @ScenarioId and n.dealid =  @DealID
	AND tt.Type IN ('StubInterest','InterestPaid','PIKInterest','PIKInterestPaid','OriginationFeeExcludedFromLevelYield','UnusedFeeExcludedFromLevelYield')	 
)a


Select crenoteid,
CONVERT(VARCHAR, Date,101) [Date],
ISNULL(Amount,0) as Amount,
[Type],
ISNULL(LIBORPercentage,0) as LIBORPercentage,
ISNULL(PIKInterestPercentage,0) as PIKInterestPercentage,
ISNULL(SpreadPercentage,0) as SpreadPercentage,
ISNULL(FeeName,'') as FeeName,
ISNULL(FeeTypeName,'') as FeeTypeName
from #tblTr
where [Type] not in ('EndingGAAPBookValue','EndingPVGAAPBookValue')

insert into @tTableAlias([Name]) values('data.notes.cashflow')


Select noteid
,CRENoteID
,CONVERT(VARCHAR, periodenddate,101) as [Date]
,ISNULL(EndingBalance,0) as EndingBalance
from(
	select n.noteid,n.CRENoteID,np.periodenddate,EndingBalance ,ROW_NUMBER() OVER(Partition by n.noteid order by n.noteid,np.periodenddate desc) rno
	from  cre.note n 
	inner join [CRE].[NotePeriodicCalc] np  on n.Account_accountid = np.accountid and np.analysisid = @ScenarioId
	inner join core.account acc on acc.AccountID = n.Account_AccountID
	where acc.IsDeleted <> 1 and np.periodenddate <= @prepaydate ----cast(getdate() as date)
	and np.analysisid = @ScenarioId
	and n.dealid = @DealID
)a where rno = 1
insert into @tTableAlias([Name]) values('data.notes.notebalance')


Select CRENoteID,[Date],[type],Typetext,Amount,TotalCommitmentAdjustment,TotalCommitment
From( 
	SELECT n.CRENoteID
	,CONVERT(VARCHAR, [Date],101) as [Date]
	,ISNULL(nm.Type,0) as [type]
	,ISNULL(l.name,'') as Typetext
	,ISNULL(nd.Value,0) as Amount
	,ISNULL(nd.NoteAdjustedTotalCommitment,0) as TotalCommitmentAdjustment
	--,ISNULL(NoteAggregatedTotalCommitment,0) as NoteAggregatedTotalCommitment
	,ISNULL(NoteTotalCommitment,0) as TotalCommitment
	,ROW_NUMBER() Over(Partition by n.noteid,[date] order by n.noteid,[date],nd.Rowno desc) rno
	from cre.NoteAdjustedCommitmentMaster nm
	left join cre.NoteAdjustedCommitmentDetail nd on nd.NoteAdjustedCommitmentMasterID = nm.NoteAdjustedCommitmentMasterID
	left join core.lookup l on l.LookupID=nm.Type
	left join cre.note n on n.noteid = nd.noteid
	WHERE n.dealid = @DealID
	--order by n.CRENoteID,nd.Rowno
)a where rno = 1
insert into @tTableAlias([Name]) values('data.notes.notecommitment')



Select crenoteid,NoteID,CONVERT(VARCHAR, [EffectiveDate],101) as [EffectiveDate],CONVERT(VARCHAR, initmatdt,101) as initmatdt
From(
	Select Distinct crenoteid,NoteID,[EffectiveDate],initmatdt
	From(

		Select Distinct crenoteid,NoteID,[MaturityType],MIN([EffectiveDate]) as [EffectiveDate],[MaturityDate] as initmatdt
		From(
			Select n.crenoteid,n.NoteID,e.EffectiveStartDate  as [EffectiveDate],
			lMaturityType.name as [MaturityType],
			(CASE WHEN e.EffectiveStartDate = n.actualPayoffdate THEN n.actualPayoffdate ELSE mat.MaturityDate END)  as [MaturityDate],
			---ISNULL(n.ActualPayoffDate,mat.MaturityDate) as [MaturityDate],
			lApproved.name as Approved
			from [CORE].Maturity mat  
			INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
			Left JOin Core.lookup lMaturityType on lMaturityType.lookupid = mat.MaturityType
			Left JOin Core.lookup lApproved on lApproved.lookupid = mat.Approved
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
			where e.StatusID = 1
			and lMaturityType.name  = @mat_Type
			and lApproved.name = 'Y'					
			and n.dealid = @DealID

			UNION ALL

			Select crenoteid,noteid,effectivestartdate as [EffectiveDate], MaturityType,MaturityDate,Approved
			from (
				Select n.crenoteid,n.noteid,e.effectivestartdate,'Current Maturity Date' as [MaturityType],
				--ISNULL(n.ActualPayOffdate, mat.MaturityDate) as [MaturityDate],
				(CASE WHEN e.EffectiveStartDate = n.actualPayoffdate THEN n.actualPayoffdate ELSE mat.MaturityDate END)  as [MaturityDate],
				lApproved.name as Approved,
				ROW_NUMBER() Over(Partition by noteid,effectivestartdate order by noteid,(CASE WHEN lMaturityType.name = 'Initial' THEN 0 WHEN lMaturityType.name = 'Fully extended' THEN 9999 ELSE 1 END) ASC, mat.MaturityDate) rno
				from [CORE].Maturity mat  
				INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId 			
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 	
				Left JOin Core.lookup lMaturityType on lMaturityType.lookupid = mat.MaturityType
				Left JOin Core.lookup lApproved on lApproved.lookupid = mat.Approved	
				where mat.MaturityDate > getdate()
				and lApproved.name = 'Y'
				and n.dealid = @DealID
				and e.StatusID = 1
			)a 	
			where a.rno = 1
			and MaturityType = @mat_Type


			UNION ALL

			---Expected Maturity date
			Select n.crenoteid,n.noteid,n.closingdate as [EffectiveDate], 'Expected Maturity Date' as MaturityType,ISNULL(n.ExpectedMaturityDate,n.FullyExtendedMaturityDate) as MaturityDate,'Y' as Approved
			from cre.Note n 
			inner join core.Account acc on acc.AccountID = n.Account_AccountID
			where acc.IsDeleted <> 1
			and n.dealid = @DealID

		)a
		group by crenoteid,NoteID,[MaturityDate],[MaturityType]

		UNION
	

		Select Distinct crenoteid,NoteID,'ActualPayoffdate' as [MaturityType],n.ActualPayoffdate as [EffectiveDate],n.ActualPayoffdate as initmatdt
		from cre.note n
		inner join core.account acc on acc.accountid = n.account_accountid 
		where acc.isdeleted <> 1
		and n.ActualPayoffdate is not null
		and n.dealid = @DealID
	)y

)z
Order by z.crenoteid,z.[EffectiveDate]

insert into @tTableAlias([Name]) values('data.notes.maturity')
 
---===================================================================

--prepay note setup

select distinct pn.GroupID from [CRE].[PrepaymentNoteAllocationSetup] pn
where pn.DealID = @DealID
order by GroupID

insert into @tTableAlias([Name]) values('data.notes.setup.noteallocationsetup.groups')


select GroupId,AttributeName as nm,AttributeValue as val from cre.prepaymentgroupsetup where DealID=@DealID
and GroupId in 
(
select  pn.GroupID from [CRE].[PrepaymentNoteAllocationSetup] pn
Left Join cre.Note n on n.NoteID = pn.NoteID
Left Join [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
Left Join core.lookup lExclude on lExclude.lookupid = pn.Exclude
Left Join core.lookup lLienPosition on lLienPosition.lookupid = n.lienposition
where pn.DealID = @DealID	
)
order by GroupId	

insert into @tTableAlias([Name]) values('data.notes.setup.noteallocationsetup.groups.attr')



select distinct GroupPriority from [CRE].[PrepaymentNoteAllocationSetup]
where DealID = @DealID
order by GroupPriority

insert into @tTableAlias([Name]) values('data.notes.setup.noteallocationsetup.groups.priority')

--insert into @tTableAlias([Name]) values('data.notes.notebalance.noteallocationsetup.groups.priority')

select Acc.Name, GroupPriority from [CRE].[PrepaymentNoteAllocationSetup] pn
Left Join cre.Note n on n.NoteID = pn.NoteID
Left Join [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
where pn.DealID = @DealID
order by GroupPriority

insert into @tTableAlias([Name]) values('data.notes.setup.noteallocationsetup.groups.priorityNotes')


select distinct acc.Name,n.CRENoteID,n.lienposition

from [CRE].[PrepaymentNoteAllocationSetup] pn
Left Join cre.Note n on n.NoteID = pn.NoteID
Left Join [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
Left Join core.lookup lExclude on lExclude.lookupid = pn.Exclude
Left Join core.lookup lLienPosition on lLienPosition.lookupid = n.lienposition
where pn.DealID = @DealID
order by n.lienposition

insert into @tTableAlias([Name]) values('data.notes.setup.noteallocationsetup.notes')

select acc.Name,n.CRENoteID, p.AttributeName as nm,p.AttributeValue as val

from [CRE].[PrepaymentNoteAllocationSetup] pn
Left Join cre.Note n on n.NoteID = pn.NoteID
Left Join cre.prepaymentNotesetup p on p.NoteID=pn.NoteID
Left Join [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
Left Join core.lookup lExclude on lExclude.lookupid = pn.Exclude
Left Join core.lookup lLienPosition on lLienPosition.lookupid = n.lienposition
where pn.DealID = @DealID
order by n.lienposition
insert into @tTableAlias([Name]) values('data.notes.setup.noteallocationsetup.notes.attr')
--

--JsonTemplate table
--select [Id],[Key],[Value],[Type],[FileName] 
--from CRE.JsonTemplate jt
--left join [Core].[AnalysisParameter] ap on ap.JsonTemplateMasterID = jt.JsonTemplateMasterID
--WHERE [Type] <> 'non_BalanceAware'
--and ap.AnalysisID = @Analysis_ID
--insert into @tTableAlias([Name]) values('JsonTemplate')

Declare @BalanceAware bit = 0;
Declare @CalcType int;

SET @BalanceAware = (Select top 1 ISNULL(BalanceAware,0) BalanceAware from cre.deal where DealID = @DealID)

SET @CalcType = @CalcTypeID;  ---(Select top 1 CalcType from Core.CalculationRequests where dealid = @DealID and AnalysisID = @Analysis_ID )

Declare @JsonTemplate as table (
Id	int,
[Key]	nvarchar(256),
[Value]	nvarchar(256),
[Type]	nvarchar(256),
[FileName]	nvarchar(256),
DBFileName nvarchar(256)
)

IF EXISTS(Select 1 from [CRE].[DealNoteRuleTypeSetup] where AnalysisID = @Analysis_ID and dealid = @DealID)
BEGIN
	--IF(@BalanceAware = 1)
	--BEGIN
		INSERT INTO @JsonTemplate (Id,[Key],[Value],[Type],[FileName],DBFileName)
		Select Id,[Key],[Value],[Type],[FileName],DBFileName 
		From(
			Select c.RuleTypeMasterID as [Id],LOWER(c.RuleTypeName) as [Key],b.Content as [Value],b.[Type] as [Type],b.FileName as [FileName] ,b.[DBFileName]
			from [CRE].[DealNoteRuleTypeSetup] a  
			inner join [CRE].[RuleTypeDetail] b on a.RuleTypeDetailID=b.RuleTypeDetailID  
			inner join [CRE].[RuleTypeMaster] c on a.RuleTypeMasterID=c.RuleTypeMasterID  
			where c.GroupName = 'Asset Calculator'
			and a.AnalysisID=@Analysis_ID
			and a.dealid = @DealID

			UNION

			Select c.RuleTypeMasterID as [Id],LOWER(c.RuleTypeName) as [Key],b.Content as [Value],b.[Type] as [Type],b.FileName as [FileName] ,b.[DBFileName]
			from [CRE].[AnalysisRuleTypeSetup] a  
			inner join [CRE].[RuleTypeDetail] b on a.RuleTypeDetailID=b.RuleTypeDetailID  
			inner join [CRE].[RuleTypeMaster] c on a.RuleTypeMasterID=c.RuleTypeMasterID  
			where c.GroupName = 'Asset Calculator'
			and a.AnalysisID=@Analysis_ID
			and c.RuleTypeMasterID not in (Select RuleTypeMasterID from [CRE].[DealNoteRuleTypeSetup] where AnalysisID = @Analysis_ID and dealid = @DealID and RuleTypeDetailID is not null)
		)a

	
	

END
ELSE
BEGIN
	INSERT INTO @JsonTemplate (Id,[Key],[Value],[Type],[FileName],DBFileName)
	Select c.RuleTypeMasterID as [Id],LOWER(c.RuleTypeName) as [Key],b.Content as [Value],b.[Type] as [Type],b.FileName as [FileName] ,b.[DBFileName]
	from [CRE].[AnalysisRuleTypeSetup] a  
	inner join [CRE].[RuleTypeDetail] b on a.RuleTypeDetailID=b.RuleTypeDetailID  
	inner join [CRE].[RuleTypeMaster] c on a.RuleTypeMasterID=c.RuleTypeMasterID  
	where c.GroupName = 'Asset Calculator'
			and a.AnalysisID=@Analysis_ID

END


IF(@CalcType = 776)
BEGIN
	Select Id,
	LOWER( 
		CASE WHEN @CalcType = 776 THEN (CASE WHEN [Key] = 'prepay' THEN 'Rules' ELSE [Key] END)
		ELSE (CASE WHEN [Key] = 'CashFlow' THEN 'Rules' ELSE [Key] END)
		END
	) [Key],
	[Value],[Type],[FileName],DBFileName 
	from @JsonTemplate
	where [Key] <> 'rules'
END
ELSE
BEGIN
	Select Id,
	LOWER( 
		CASE WHEN @CalcType = 776 THEN (CASE WHEN [Key] = 'prepay' THEN 'Rules' ELSE [Key] END)
		ELSE (CASE WHEN [Key] = 'CashFlow' THEN 'Rules' ELSE [Key] END)
		END
	) [Key],
	[Value],[Type],[FileName],DBFileName 
	from @JsonTemplate
	where [Key] <> 'prepay'
END

insert into @tTableAlias([Name]) values('JsonTemplate')

Select [Type],[Key],Position,DataType,IsActive from [CRE].[JsonFormatCalcV1]
insert into @tTableAlias([Name]) values('JsonFormat')

--all table alias names
select [Name] as table_name,GroupName from @tTableAlias order by ID

drop table #tNoteEffectiveDates


	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
GO

