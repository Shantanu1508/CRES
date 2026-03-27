
CREATE PROCEDURE [dbo].[usp_GetAllTransactionUsingoldLogic]  
     
AS
BEGIN
      SET NOCOUNT ON;	 
        

declare @NoteId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000',
@DealId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000'



IF OBJECT_ID('tempdb..#tblNoteMaturity') IS NOT NULL       
	DROP TABLE #tblNoteMaturity
CREATE TABLE #tblNoteMaturity
(
	NoteID uniqueidentifier,
	AccountID uniqueidentifier,
	CurrentMaturity Date null
) 

INSERT INTO #tblNoteMaturity (NoteID,AccountID,CurrentMaturity)
Select n1.noteid,acc1.Accountid,ISNULL(n1.ActualPayOffDate,ISNULL(currMat.MaturityDate,n1.FullyExtendedMaturityDate)) as currMaturityDate
from cre.note n1
Inner join core.account acc1 on acc1.Accountid = n1.Account_Accountid
Left Join(
	Select noteid,MaturityType,MaturityDate,Approved
	from (
	Select n.noteid,lMaturityType.name as [MaturityType],mat.MaturityDate as [MaturityDate],lApproved.name as Approved,
	ROW_NUMBER() Over(Partition by noteid order by noteid,(CASE WHEN lMaturityType.name = 'Initial' THEN 0 WHEN lMaturityType.name = 'Fully extended' THEN 9999 ELSE 1 END) ASC, mat.MaturityDate) rno
	from [CORE].Maturity mat
	INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
	INNER JOIN
	(
		Select
		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
		where EventTypeID = 11 and eve.statusID = 1

		and n.Account_AccountID = acc.AccountID

		and acc.IsDeleted = 0
		GROUP BY n.Account_AccountID,EventTypeID
	) sEvent
	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate and e.EventTypeID = sEvent.EventTypeID and e.statusID = 1
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	Left JOin Core.lookup lMaturityType on lMaturityType.lookupid = mat.MaturityType
	Left JOin Core.lookup lApproved on lApproved.lookupid = mat.Approved

	where n.Account_AccountID = acc.AccountID

	and mat.MaturityDate > getdate()
	and lApproved.name = 'Y'
	)a where a.rno = 1
)currMat on currMat.noteid = n1.noteid
where acc1.IsDeleted <> 1

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	--select 
	--n.CRENoteID Noteid,
	--acc.Name NoteName,
	--LEFT(CONVERT(VARCHAR, te.[Date], 101), 10) AS [Date],
	--te.Amount Value,
	--te.[Type] ValueType
	-- from  CRE.TransactionEntry te 
	--inner join Cre.Note n on n.NoteID=te.NoteID
	--inner join core.Account acc on acc.AccountID=n.Account_AccountID
	--where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	--AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1


	--PREVIOUS CASHFLOW DOWNLOAD SCRIPT-----

	CREATE TABLE #Tempnoteperiodiccalc
	(
	  NoteID uniqueidentifier,
	  periodenddate date,
	  principalpaid [decimal](28, 15) NULL, 
	  balloonpayment [decimal](28, 15) NULL,
	  interestpaidonpaymentdate [decimal](28, 15) NULL,
	  ExitFeeIncludedInLevelYield [decimal](28, 15) NULL,
	  ExitFeeExcludedFromLevelYield [decimal](28, 15) NULL,
	  AdditionalFeesIncludedInLevelYield [decimal](28, 15) NULL,
	  AdditionalFeesExcludedFromLevelYield [decimal](28, 15) NULL, 
	  OriginationFeeStripping [decimal](28, 15) NULL,
	  ExitFeeStrippingIncldinLevelYield [decimal](28, 15) NULL,
	  ExitFeeStrippingExcldfromLevelYield [decimal](28, 15) NULL,
	  AddlFeesStrippingIncldinLevelYield [decimal](28, 15) NULL,
	  AddlFeesStrippingExcldfromLevelYield [decimal](28, 15) NULL,
	  EndingGAAPBookValue [decimal](28, 15) NULL
	  --TotalGAAPIncomeforthePeriod [decimal](28, 15) NULL	 
	);



INSERT INTO #Tempnoteperiodiccalc
   (	
      NoteID,
	  periodenddate,
	  principalpaid, 
	  balloonpayment,
	  interestpaidonpaymentdate,
	  ExitFeeIncludedInLevelYield ,
	  ExitFeeExcludedFromLevelYield ,
	  AdditionalFeesIncludedInLevelYield,
	  AdditionalFeesExcludedFromLevelYield, 
	  OriginationFeeStripping,
	  ExitFeeStrippingIncldinLevelYield,
	  ExitFeeStrippingExcldfromLevelYield,
	  AddlFeesStrippingIncldinLevelYield,
	  AddlFeesStrippingExcldfromLevelYield,
	  EndingGAAPBookValue
	  --TotalGAAPIncomeforthePeriod	
)
 SELECT n.NoteID,
 periodenddate,
	  principalpaid, 
	  balloonpayment,
	  interestpaidonpaymentdate,
	  ExitFeeIncludedInLevelYield ,
	  ExitFeeExcludedFromLevelYield ,
	  AdditionalFeesIncludedInLevelYield,
	  AdditionalFeesExcludedFromLevelYield, 
	  OriginationFeeStripping,
	  ExitFeeStrippingIncldinLevelYield,
	  ExitFeeStrippingExcldfromLevelYield,
	  AddlFeesStrippingIncldinLevelYield,
	  AddlFeesStrippingExcldfromLevelYield,
	  EndingGAAPBookValue
	  --TotalGAAPIncomeforthePeriod	
  FROM CRE.noteperiodiccalc np WITH (NOLOCK) 
  Inner Join core.Account acc on acc.AccountID =np.AccountID
  Inner Join cre.note n on n.Account_AccountID = acc.AccountID
  Where acc.IsDeleted<>1
  --where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN np.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 



DECLARE @Lookup_PrincipalReceived INT; -- = 263;
DECLARE @Lookup_InterestReceived INT; -- = 262;
Declare @Column nvarchar(256)=(select top 1 l.Name from core.Lookup  l inner join core.AnalysisParameter ap on l.lookupid=ap.MaturityScenarioOverrideID 
inner join core.Analysis a on a.AnalysisID=ap.AnalysisID where a.StatusID=(select LookupID from core.Lookup where ParentID =2 and  Name = 'Y'))

select @Lookup_PrincipalReceived = LookupID from core.Lookup where ParentID=39 and Name='Interest Received'
select @Lookup_InterestReceived = LookupID from core.Lookup where ParentID=39 and Name='Principal Received'



------------------------------------------------------------



select Noteid, NoteName, LEFT(CONVERT(VARCHAR, TransDate, 101), 10) AS [Date], Value, ValueType from 
(SELECT --n.NoteID
	--,n.Account_AccountID
	n.NoteID nID,
	n.CRENoteID NoteID
	,acc.name NoteName
	,fs.[Date] AS [TransDate]
	,-fs.Value Value
	,'FundingOrRepayment' as ValueType
	from [CORE].[FundingSchedule] fs INNER JOIN [CORE].[Event] eve ON eve.EventID = fs.EventId
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and eve.EffectiveStartDate=(select max(EffectiveStartDate) from [CORE].[Event] where  AccountID = eve.AccountID 
	and StatusID = (Select lookupid from Core.Lookup where parentid = 1 and name='Active') and eventTypeid = (Select lookupid from Core.Lookup where parentid = 3 and name='FundingSchedule'))
	--and fs.[Date] between  (CASE WHEN @StartDate IS NULL or @StartDate=''THEN (select min([Date])FROM [CORE].[FundingSchedule]) ELSE @StartDate END )
	--and   (CASE WHEN @EndDate IS NULL or @EndDate='' THEN (select max([Date])FROM [CORE].[FundingSchedule]) ELSE @EndDate END )
	and isnull(fs.Value,0)<>0 and eve.statusid=1
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1
	and fs.[Date] <= (	
			Select CurrentMaturity from #tblNoteMaturity where AccountID = acc.AccountID

	--select
	-- isnull(n.ActualPayoffDate, isnull(
	--		case when @Column='Initial or Actual Payoff Date' then n.ActualPayoffDate 
	--		when @Column='Expected Maturity Date' then n.ExpectedMaturityDate 
	--		when @Column='Extended Maturity Date #1' then n.ExtendedMaturityScenario1 
	--		when @Column='Extended Maturity Date #2' then n.ExtendedMaturityScenario2 
	--		when @Column='Extended Maturity Date #3' then n.ExtendedMaturityScenario3 
	--		when @Column='Open Prepayment Date' then n.OpenPrepaymentDate 
	--		when @Column='Fully Extended Maturity Date' then n.FullyExtendedMaturityDate end,

	--	(Select TOP 1 mat.[SelectedMaturityDate]
	--		from [CORE].Maturity mat
	--		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
	--		INNER JOIN (Select 
	--		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
	--		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
	--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
	--		INNER JOIN [CORE].[Account] accSub ON accSub.AccountID = n.Account_AccountID
	--		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'Maturity')
	--		and accSub.AccountID = acc.AccountID
	--		GROUP BY n.Account_AccountID,EventTypeID
	--	) sEvent
	--	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID)
	--	))
	)


 Union All
 
	select 
	n.NoteID nID,
	n.crenoteid NoteID
	,acc.name NoteName
	,n.closingdate  AS [TransDate]
	,-n.initialfundingamount Value
	,'InitialFunding' as ValueType
	from 
	[CORE].[Account] acc 
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and isnull(n.initialfundingamount,0)<>0
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1
	and n.closingdate <= (
		Select CurrentMaturity from #tblNoteMaturity where AccountID = acc.AccountID
	--select
	-- isnull(n.ActualPayoffDate, isnull(
	--		case when @Column='Initial or Actual Payoff Date' then n.ActualPayoffDate 
	--		when @Column='Expected Maturity Date' then n.ExpectedMaturityDate 
	--		when @Column='Extended Maturity Date #1' then n.ExtendedMaturityScenario1 
	--		when @Column='Extended Maturity Date #2' then n.ExtendedMaturityScenario2 
	--		when @Column='Extended Maturity Date #3' then n.ExtendedMaturityScenario3 
	--		when @Column='Open Prepayment Date' then n.OpenPrepaymentDate 
	--		when @Column='Fully Extended Maturity Date' then n.FullyExtendedMaturityDate end,

	--	(Select TOP 1 mat.[SelectedMaturityDate]
	--		from [CORE].Maturity mat
	--		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
	--		INNER JOIN (Select 
	--		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
	--		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
	--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
	--		INNER JOIN [CORE].[Account] accSub ON accSub.AccountID = n.Account_AccountID
	--		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'Maturity')
	--		and accSub.AccountID = acc.AccountID
	--		GROUP BY n.Account_AccountID,EventTypeID
	--	) sEvent
	--	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID)
	--	))
	)


 Union All
 
	select 
	n.NoteID nID, 
	n.crenoteid NoteID
	,acc.name NoteName
	,n.closingdate  AS [TransDate]
	,-n.discount Value
	,'Discount/Premium' as ValueType
	from 
	[CORE].[Account] acc 
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and isnull(n.discount,0)<>0
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1
	and n.closingdate <= (
			Select CurrentMaturity from #tblNoteMaturity where AccountID = acc.AccountID

	--select
	-- isnull(n.ActualPayoffDate, isnull(
	--		case when @Column='Initial or Actual Payoff Date' then n.ActualPayoffDate 
	--		when @Column='Expected Maturity Date' then n.ExpectedMaturityDate 
	--		when @Column='Extended Maturity Date #1' then n.ExtendedMaturityScenario1 
	--		when @Column='Extended Maturity Date #2' then n.ExtendedMaturityScenario2 
	--		when @Column='Extended Maturity Date #3' then n.ExtendedMaturityScenario3 
	--		when @Column='Open Prepayment Date' then n.OpenPrepaymentDate 
	--		when @Column='Fully Extended Maturity Date' then n.FullyExtendedMaturityDate end,

	--	(Select TOP 1 mat.[SelectedMaturityDate]
	--		from [CORE].Maturity mat
	--		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
	--		INNER JOIN (Select 
	--		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
	--		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
	--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
	--		INNER JOIN [CORE].[Account] accSub ON accSub.AccountID = n.Account_AccountID
	--		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'Maturity')
	--		and accSub.AccountID = acc.AccountID
	--		GROUP BY n.Account_AccountID,EventTypeID
	--	) sEvent
	--	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID)
	--	))
	)



 Union All
 
	select 
	n.NoteID nID,
	n.crenoteid NoteID
	,acc.name NoteName
	,n.closingdate  AS [TransDate]
	,n.StubIntOverride Value
	,'StubInterest' as ValueType
	from 
	[CORE].[Account] acc 
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and isnull(n.StubIntOverride,0)<>0
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1
	and n.closingdate <= (
		Select CurrentMaturity from #tblNoteMaturity where AccountID = acc.AccountID
	--select
	-- isnull(n.ActualPayoffDate, isnull(
	--		case when @Column='Initial or Actual Payoff Date' then n.ActualPayoffDate 
	--		when @Column='Expected Maturity Date' then n.ExpectedMaturityDate 
	--		when @Column='Extended Maturity Date #1' then n.ExtendedMaturityScenario1 
	--		when @Column='Extended Maturity Date #2' then n.ExtendedMaturityScenario2 
	--		when @Column='Extended Maturity Date #3' then n.ExtendedMaturityScenario3 
	--		when @Column='Open Prepayment Date' then n.OpenPrepaymentDate 
	--		when @Column='Fully Extended Maturity Date' then n.FullyExtendedMaturityDate end,

	--	(Select TOP 1 mat.[SelectedMaturityDate]
	--		from [CORE].Maturity mat
	--		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
	--		INNER JOIN (Select 
	--		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
	--		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
	--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
	--		INNER JOIN [CORE].[Account] accSub ON accSub.AccountID = n.Account_AccountID
	--		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'Maturity')
	--		and accSub.AccountID = acc.AccountID
	--		GROUP BY n.Account_AccountID,EventTypeID
	--	) sEvent
	--	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID)
	--	))
	)


 Union All
 
	select
	 n.NoteID nID,
	n.crenoteid NoteID
	,acc.name NoteName
	,n.closingdate AS [TransDate]
	,n.OriginationFee Value
	,'OriginationFee' as ValueType
	from 
	[CORE].[Account] acc 
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and isnull(n.OriginationFee,0)<>0
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1
	and n.closingdate <= (
			Select CurrentMaturity from #tblNoteMaturity where AccountID = acc.AccountID
	--select
	-- isnull(n.ActualPayoffDate, isnull(
	--		case when @Column='Initial or Actual Payoff Date' then n.ActualPayoffDate 
	--		when @Column='Expected Maturity Date' then n.ExpectedMaturityDate 
	--		when @Column='Extended Maturity Date #1' then n.ExtendedMaturityScenario1 
	--		when @Column='Extended Maturity Date #2' then n.ExtendedMaturityScenario2 
	--		when @Column='Extended Maturity Date #3' then n.ExtendedMaturityScenario3 
	--		when @Column='Open Prepayment Date' then n.OpenPrepaymentDate 
	--		when @Column='Fully Extended Maturity Date' then n.FullyExtendedMaturityDate end,

	--	(Select TOP 1 mat.[SelectedMaturityDate]
	--		from [CORE].Maturity mat
	--		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
	--		INNER JOIN (Select 
	--		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
	--		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
	--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
	--		INNER JOIN [CORE].[Account] accSub ON accSub.AccountID = n.Account_AccountID
	--		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'Maturity')
	--		and accSub.AccountID = acc.AccountID
	--		GROUP BY n.Account_AccountID,EventTypeID
	--	) sEvent
	--	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID)
	--	))
	)


 Union All
 
	select 
	n.NoteID nID,
	n.crenoteid NoteID
	,acc.name NoteName
	
--	, isnull(n.ActualPayoffDate, isnull(
--case when @Column='Initial or Actual Payoff Date' then n.ActualPayoffDate 
--when @Column='Expected Maturity Date' then n.ExpectedMaturityDate 
--when @Column='Extended Maturity Date #1' then n.ExtendedMaturityScenario1 
--when @Column='Extended Maturity Date #2' then n.ExtendedMaturityScenario2 
--when @Column='Extended Maturity Date #3' then n.ExtendedMaturityScenario3 
--when @Column='Open Prepayment Date' then n.OpenPrepaymentDate 
--when @Column='Fully Extended Maturity Date' then n.FullyExtendedMaturityDate end,

--(Select TOP 1 mat.[SelectedMaturityDate]
--		from [CORE].Maturity mat
--		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
--		INNER JOIN (Select 
--		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
--		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
--		INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
--		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'Maturity')
--		and acc.AccountID = acc.AccountID
--		GROUP BY n.Account_AccountID,EventTypeID
--		) sEvent
--		ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID)

--)) AS [TransDate]

,mat.CurrentMaturity AS [TransDate]

	,np.balloonpayment Value
	,'Balloon' as ValueType
	from 
	[CORE].[Account] acc 
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	inner join #Tempnoteperiodiccalc np on np.noteid = n.noteid
	Left JOin  #tblNoteMaturity mat on mat.AccountID = acc.AccountID
	
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and isnull(np.balloonpayment,0)<>0
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1

 Union All
 
	select 
	n.NoteID nID,
	n.crenoteid NoteID
	,acc.name NoteName
	,dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1))  AS [TransDate]
	,np.principalpaid Value
	,'ScheduledPrincipalPaid' as ValueType
	from 
	[CORE].[Account] acc 
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	inner join #Tempnoteperiodiccalc np on np.noteid = n.noteid
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and isnull(np.principalpaid,0)<>0 
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1
	and  eomonth(dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1))) not in(
	select  eomonth(TransactionDate) from cre.NoteTransactionDetail nt where nt.NoteID=n.NoteID 
	and TransactionType=(select LookupID from core.Lookup where ParentID=39 and Name='Principal Received')
	)
	and dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1))  <= (
		Select CurrentMaturity from #tblNoteMaturity where AccountID = acc.AccountID
	--select
	-- isnull(n.ActualPayoffDate, isnull(
	--		case when @Column='Initial or Actual Payoff Date' then n.ActualPayoffDate 
	--		when @Column='Expected Maturity Date' then n.ExpectedMaturityDate 
	--		when @Column='Extended Maturity Date #1' then n.ExtendedMaturityScenario1 
	--		when @Column='Extended Maturity Date #2' then n.ExtendedMaturityScenario2 
	--		when @Column='Extended Maturity Date #3' then n.ExtendedMaturityScenario3 
	--		when @Column='Open Prepayment Date' then n.OpenPrepaymentDate 
	--		when @Column='Fully Extended Maturity Date' then n.FullyExtendedMaturityDate end,

	--	(Select TOP 1 mat.[SelectedMaturityDate]
	--		from [CORE].Maturity mat
	--		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
	--		INNER JOIN (Select 
	--		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
	--		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
	--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
	--		INNER JOIN [CORE].[Account] accSub ON accSub.AccountID = n.Account_AccountID
	--		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'Maturity')
	--		and accSub.AccountID = acc.AccountID
	--		GROUP BY n.Account_AccountID,EventTypeID
	--	) sEvent
	--	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID)
	--	))
	)

 Union All
 
	select
	 n.NoteID nID,
	n.crenoteid NoteID
	,acc.name NoteName
	,dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)) AS [TransDate]
	,np.interestpaidonpaymentdate Value
	,'InterestPaid' as ValueType
	from 
	[CORE].[Account] acc 
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	inner join #Tempnoteperiodiccalc np on np.noteid = n.noteid
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and isnull(np.interestpaidonpaymentdate,0)<>0 
	and dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)) > closingdate
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1
	and  eomonth(dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)))  not in(
	select  eomonth(TransactionDate) from cre.NoteTransactionDetail nt where nt.NoteID=n.NoteID 
	and TransactionType=(select LookupID from core.Lookup where ParentID=39 and Name='Interest Received')
	)
	and dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1))  <= (
		Select CurrentMaturity from #tblNoteMaturity where AccountID = acc.AccountID
	--select
	-- isnull(n.ActualPayoffDate, isnull(
	--		case when @Column='Initial or Actual Payoff Date' then n.ActualPayoffDate 
	--		when @Column='Expected Maturity Date' then n.ExpectedMaturityDate 
	--		when @Column='Extended Maturity Date #1' then n.ExtendedMaturityScenario1 
	--		when @Column='Extended Maturity Date #2' then n.ExtendedMaturityScenario2 
	--		when @Column='Extended Maturity Date #3' then n.ExtendedMaturityScenario3 
	--		when @Column='Open Prepayment Date' then n.OpenPrepaymentDate 
	--		when @Column='Fully Extended Maturity Date' then n.FullyExtendedMaturityDate end,

	--	(Select TOP 1 mat.[SelectedMaturityDate]
	--		from [CORE].Maturity mat
	--		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
	--		INNER JOIN (Select 
	--		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
	--		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
	--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
	--		INNER JOIN [CORE].[Account] accSub ON accSub.AccountID = n.Account_AccountID
	--		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'Maturity')
	--		and accSub.AccountID = acc.AccountID
	--		GROUP BY n.Account_AccountID,EventTypeID
	--	) sEvent
	--	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID)
	--	))
	)


Union All

select
    n.NoteID nID,
     n.crenoteid NoteID
	,acc.name NoteName
	,nt.TransactionDate AS [TransDate] 
	,-nt.Amount Value
	,'ScheduledPrincipalPaid' as ValueType
	from 
	[CORE].[Account] acc 
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	inner join cre.NoteTransactionDetail nt on nt.noteid = n.noteid
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and isnull(nt.Amount,0)<>0
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1
	and TransactionType=(select LookupID from core.Lookup where ParentID=39 and Name='Principal Received')
	and nt.TransactionDate <= (
			Select CurrentMaturity from #tblNoteMaturity where AccountID = acc.AccountID
	--select
	-- isnull(n.ActualPayoffDate, isnull(
	--		case when @Column='Initial or Actual Payoff Date' then n.ActualPayoffDate 
	--		when @Column='Expected Maturity Date' then n.ExpectedMaturityDate 
	--		when @Column='Extended Maturity Date #1' then n.ExtendedMaturityScenario1 
	--		when @Column='Extended Maturity Date #2' then n.ExtendedMaturityScenario2 
	--		when @Column='Extended Maturity Date #3' then n.ExtendedMaturityScenario3 
	--		when @Column='Open Prepayment Date' then n.OpenPrepaymentDate 
	--		when @Column='Fully Extended Maturity Date' then n.FullyExtendedMaturityDate end,

	--	(Select TOP 1 mat.[SelectedMaturityDate]
	--		from [CORE].Maturity mat
	--		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
	--		INNER JOIN (Select 
	--		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
	--		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
	--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
	--		INNER JOIN [CORE].[Account] accSub ON accSub.AccountID = n.Account_AccountID
	--		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'Maturity')
	--		and accSub.AccountID = acc.AccountID
	--		GROUP BY n.Account_AccountID,EventTypeID
	--	) sEvent
	--	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID)
	--	))
	)


 Union All
 
	select
	 n.NoteID nID,
	  n.crenoteid NoteID
	,acc.name NoteName
	,nt.TransactionDate AS [TransDate] 
	,nt.Amount Value
	,'InterestPaid' as ValueType
	from 
	[CORE].[Account] acc 
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	inner join cre.NoteTransactionDetail nt on nt.noteid = n.noteid
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and isnull(nt.Amount,0)<>0  
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1
	and TransactionType=(select LookupID from core.Lookup where ParentID=39 and Name='Interest Received')
	and nt.TransactionDate <= (
		Select CurrentMaturity from #tblNoteMaturity where AccountID = acc.AccountID
	--select
	-- isnull(n.ActualPayoffDate, isnull(
	--		case when @Column='Initial or Actual Payoff Date' then n.ActualPayoffDate 
	--		when @Column='Expected Maturity Date' then n.ExpectedMaturityDate 
	--		when @Column='Extended Maturity Date #1' then n.ExtendedMaturityScenario1 
	--		when @Column='Extended Maturity Date #2' then n.ExtendedMaturityScenario2 
	--		when @Column='Extended Maturity Date #3' then n.ExtendedMaturityScenario3 
	--		when @Column='Open Prepayment Date' then n.OpenPrepaymentDate 
	--		when @Column='Fully Extended Maturity Date' then n.FullyExtendedMaturityDate end,

	--	(Select TOP 1 mat.[SelectedMaturityDate]
	--		from [CORE].Maturity mat
	--		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
	--		INNER JOIN (Select 
	--		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
	--		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
	--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
	--		INNER JOIN [CORE].[Account] accSub ON accSub.AccountID = n.Account_AccountID
	--		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'Maturity')
	--		and accSub.AccountID = acc.AccountID
	--		GROUP BY n.Account_AccountID,EventTypeID
	--	) sEvent
	--	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID)
	--	))
	)

 Union All
 
	select 
	n.NoteID nID,
	n.crenoteid NoteID
	,acc.name NoteName
	,dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)) AS [TransDate]
	,np.ExitFeeIncludedInLevelYield Value
	,'ExitFeeIncludedInLevelYield' as ValueType
	from 
	[CORE].[Account] acc 
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	inner join #Tempnoteperiodiccalc np on np.noteid = n.noteid
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and isnull(np.ExitFeeIncludedInLevelYield,0)<>0
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1
	and dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)) <= (
		Select CurrentMaturity from #tblNoteMaturity where AccountID = acc.AccountID
	--select
	-- isnull(n.ActualPayoffDate, isnull(
	--		case when @Column='Initial or Actual Payoff Date' then n.ActualPayoffDate 
	--		when @Column='Expected Maturity Date' then n.ExpectedMaturityDate 
	--		when @Column='Extended Maturity Date #1' then n.ExtendedMaturityScenario1 
	--		when @Column='Extended Maturity Date #2' then n.ExtendedMaturityScenario2 
	--		when @Column='Extended Maturity Date #3' then n.ExtendedMaturityScenario3 
	--		when @Column='Open Prepayment Date' then n.OpenPrepaymentDate 
	--		when @Column='Fully Extended Maturity Date' then n.FullyExtendedMaturityDate end,

	--	(Select TOP 1 mat.[SelectedMaturityDate]
	--		from [CORE].Maturity mat
	--		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
	--		INNER JOIN (Select 
	--		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
	--		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
	--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
	--		INNER JOIN [CORE].[Account] accSub ON accSub.AccountID = n.Account_AccountID
	--		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'Maturity')
	--		and accSub.AccountID = acc.AccountID
	--		GROUP BY n.Account_AccountID,EventTypeID
	--	) sEvent
	--	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID)
	--	))
	)


 Union All
 
	select 
	n.NoteID nID,
	n.crenoteid NoteID
	,acc.name NoteName
	,dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)) AS [TransDate]
	,np.ExitFeeExcludedFromLevelYield Value
	,'ExitFeeExcludedFromLevelYield' as ValueType
	from 
	[CORE].[Account] acc 
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	inner join #Tempnoteperiodiccalc np on np.noteid = n.noteid
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and isnull(np.ExitFeeExcludedFromLevelYield,0)<>0
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1
	and dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)) <= (
		Select CurrentMaturity from #tblNoteMaturity where AccountID = acc.AccountID
	--select
	-- isnull(n.ActualPayoffDate, isnull(
	--		case when @Column='Initial or Actual Payoff Date' then n.ActualPayoffDate 
	--		when @Column='Expected Maturity Date' then n.ExpectedMaturityDate 
	--		when @Column='Extended Maturity Date #1' then n.ExtendedMaturityScenario1 
	--		when @Column='Extended Maturity Date #2' then n.ExtendedMaturityScenario2 
	--		when @Column='Extended Maturity Date #3' then n.ExtendedMaturityScenario3 
	--		when @Column='Open Prepayment Date' then n.OpenPrepaymentDate 
	--		when @Column='Fully Extended Maturity Date' then n.FullyExtendedMaturityDate end,

	--	(Select TOP 1 mat.[SelectedMaturityDate]
	--		from [CORE].Maturity mat
	--		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
	--		INNER JOIN (Select 
	--		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
	--		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
	--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
	--		INNER JOIN [CORE].[Account] accSub ON accSub.AccountID = n.Account_AccountID
	--		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'Maturity')
	--		and accSub.AccountID = acc.AccountID
	--		GROUP BY n.Account_AccountID,EventTypeID
	--	) sEvent
	--	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID)
	--	))
	)


 Union All
 
	select 
	n.NoteID nID,
	n.crenoteid NoteID
	,acc.name NoteName
	,dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1))  AS [TransDate]  
	,np.AdditionalFeesIncludedInLevelYield Value
	,'AdditionalFeesIncludedInLevelYield' as ValueType
	from 
	[CORE].[Account] acc 
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	inner join #Tempnoteperiodiccalc np on np.noteid = n.noteid
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and isnull(np.AdditionalFeesIncludedInLevelYield,0)<>0
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1
	and dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)) <= (
		Select CurrentMaturity from #tblNoteMaturity where AccountID = acc.AccountID
	--select
	-- isnull(n.ActualPayoffDate, isnull(
	--		case when @Column='Initial or Actual Payoff Date' then n.ActualPayoffDate 
	--		when @Column='Expected Maturity Date' then n.ExpectedMaturityDate 
	--		when @Column='Extended Maturity Date #1' then n.ExtendedMaturityScenario1 
	--		when @Column='Extended Maturity Date #2' then n.ExtendedMaturityScenario2 
	--		when @Column='Extended Maturity Date #3' then n.ExtendedMaturityScenario3 
	--		when @Column='Open Prepayment Date' then n.OpenPrepaymentDate 
	--		when @Column='Fully Extended Maturity Date' then n.FullyExtendedMaturityDate end,

	--	(Select TOP 1 mat.[SelectedMaturityDate]
	--		from [CORE].Maturity mat
	--		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
	--		INNER JOIN (Select 
	--		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
	--		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
	--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
	--		INNER JOIN [CORE].[Account] accSub ON accSub.AccountID = n.Account_AccountID
	--		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'Maturity')
	--		and accSub.AccountID = acc.AccountID
	--		GROUP BY n.Account_AccountID,EventTypeID
	--	) sEvent
	--	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID)
	--	))
	)

 Union All
 
	select 
	n.NoteID nID,
	n.crenoteid NoteID
	,acc.name NoteName
	 ,dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1))  AS [TransDate]
	,np.AdditionalFeesExcludedFromLevelYield Value
	,'AdditionalFeesExcludedFromLevelYield' as ValueType
	from 
	[CORE].[Account] acc 
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	inner join #Tempnoteperiodiccalc np on np.noteid = n.noteid
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and isnull(np.AdditionalFeesExcludedFromLevelYield,0)<>0
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1
	and dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)) <= (
		Select CurrentMaturity from #tblNoteMaturity where AccountID = acc.AccountID
	--select
	-- isnull(n.ActualPayoffDate, isnull(
	--		case when @Column='Initial or Actual Payoff Date' then n.ActualPayoffDate 
	--		when @Column='Expected Maturity Date' then n.ExpectedMaturityDate 
	--		when @Column='Extended Maturity Date #1' then n.ExtendedMaturityScenario1 
	--		when @Column='Extended Maturity Date #2' then n.ExtendedMaturityScenario2 
	--		when @Column='Extended Maturity Date #3' then n.ExtendedMaturityScenario3 
	--		when @Column='Open Prepayment Date' then n.OpenPrepaymentDate 
	--		when @Column='Fully Extended Maturity Date' then n.FullyExtendedMaturityDate end,

	--	(Select TOP 1 mat.[SelectedMaturityDate]
	--		from [CORE].Maturity mat
	--		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
	--		INNER JOIN (Select 
	--		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
	--		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
	--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
	--		INNER JOIN [CORE].[Account] accSub ON accSub.AccountID = n.Account_AccountID
	--		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'Maturity')
	--		and accSub.AccountID = acc.AccountID
	--		GROUP BY n.Account_AccountID,EventTypeID
	--	) sEvent
	--	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID)
	--	))
	)

 Union All
 
	select 
	n.NoteID nID,
	n.crenoteid NoteID
	,acc.name NoteName
	,dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)) AS [TransDate]
	,(np.OriginationFeeStripping *-1) Value
	,'OriginationFeeStripping' as ValueType
	from 
	[CORE].[Account] acc 
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	inner join #Tempnoteperiodiccalc np on np.noteid = n.noteid
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and isnull(np.OriginationFeeStripping,0)<>0
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1
	and dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)) <= (
			Select CurrentMaturity from #tblNoteMaturity where AccountID = acc.AccountID
	--select
	-- isnull(n.ActualPayoffDate, isnull(
	--		case when @Column='Initial or Actual Payoff Date' then n.ActualPayoffDate 
	--		when @Column='Expected Maturity Date' then n.ExpectedMaturityDate 
	--		when @Column='Extended Maturity Date #1' then n.ExtendedMaturityScenario1 
	--		when @Column='Extended Maturity Date #2' then n.ExtendedMaturityScenario2 
	--		when @Column='Extended Maturity Date #3' then n.ExtendedMaturityScenario3 
	--		when @Column='Open Prepayment Date' then n.OpenPrepaymentDate 
	--		when @Column='Fully Extended Maturity Date' then n.FullyExtendedMaturityDate end,

	--	(Select TOP 1 mat.[SelectedMaturityDate]
	--		from [CORE].Maturity mat
	--		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
	--		INNER JOIN (Select 
	--		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
	--		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
	--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
	--		INNER JOIN [CORE].[Account] accSub ON accSub.AccountID = n.Account_AccountID
	--		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'Maturity')
	--		and accSub.AccountID = acc.AccountID
	--		GROUP BY n.Account_AccountID,EventTypeID
	--	) sEvent
	--	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID)
	--	))
	)

 Union All
 
	select 
	n.NoteID nID,
	n.crenoteid NoteID
	,acc.name NoteName
	,dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1))  AS [TransDate]
	,np.ExitFeeStrippingIncldinLevelYield Value
	,'ExitFeeStrippingIncldinLevelYield' as ValueType
	from 
	[CORE].[Account] acc 
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	inner join #Tempnoteperiodiccalc np on np.noteid = n.noteid
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and isnull(np.ExitFeeStrippingIncldinLevelYield,0)<>0
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1
	and dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)) <= (
		Select CurrentMaturity from #tblNoteMaturity where AccountID = acc.AccountID
	--select
	-- isnull(n.ActualPayoffDate, isnull(
	--		case when @Column='Initial or Actual Payoff Date' then n.ActualPayoffDate 
	--		when @Column='Expected Maturity Date' then n.ExpectedMaturityDate 
	--		when @Column='Extended Maturity Date #1' then n.ExtendedMaturityScenario1 
	--		when @Column='Extended Maturity Date #2' then n.ExtendedMaturityScenario2 
	--		when @Column='Extended Maturity Date #3' then n.ExtendedMaturityScenario3 
	--		when @Column='Open Prepayment Date' then n.OpenPrepaymentDate 
	--		when @Column='Fully Extended Maturity Date' then n.FullyExtendedMaturityDate end,

	--	(Select TOP 1 mat.[SelectedMaturityDate]
	--		from [CORE].Maturity mat
	--		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
	--		INNER JOIN (Select 
	--		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
	--		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
	--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
	--		INNER JOIN [CORE].[Account] accSub ON accSub.AccountID = n.Account_AccountID
	--		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'Maturity')
	--		and accSub.AccountID = acc.AccountID
	--		GROUP BY n.Account_AccountID,EventTypeID
	--	) sEvent
	--	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID)
	--	))
	)

 Union All
 
	select 
	n.NoteID nID,
	n.crenoteid NoteID
	,acc.name NoteName
	,dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1))  AS [TransDate]
	,(np.ExitFeeStrippingExcldfromLevelYield * -1) Value
	,'ExitFeeStrippingExcldfromLevelYield' as ValueType
	from 
	[CORE].[Account] acc 
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	inner join #Tempnoteperiodiccalc np on np.noteid = n.noteid
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and isnull(np.ExitFeeStrippingExcldfromLevelYield,0)<>0
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1
	and dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)) <= (
		Select CurrentMaturity from #tblNoteMaturity where AccountID = acc.AccountID
	--select
	-- isnull(n.ActualPayoffDate, isnull(
	--		case when @Column='Initial or Actual Payoff Date' then n.ActualPayoffDate 
	--		when @Column='Expected Maturity Date' then n.ExpectedMaturityDate 
	--		when @Column='Extended Maturity Date #1' then n.ExtendedMaturityScenario1 
	--		when @Column='Extended Maturity Date #2' then n.ExtendedMaturityScenario2 
	--		when @Column='Extended Maturity Date #3' then n.ExtendedMaturityScenario3 
	--		when @Column='Open Prepayment Date' then n.OpenPrepaymentDate 
	--		when @Column='Fully Extended Maturity Date' then n.FullyExtendedMaturityDate end,

	--	(Select TOP 1 mat.[SelectedMaturityDate]
	--		from [CORE].Maturity mat
	--		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
	--		INNER JOIN (Select 
	--		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
	--		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
	--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
	--		INNER JOIN [CORE].[Account] accSub ON accSub.AccountID = n.Account_AccountID
	--		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'Maturity')
	--		and accSub.AccountID = acc.AccountID
	--		GROUP BY n.Account_AccountID,EventTypeID
	--	) sEvent
	--	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID)
	--	))
	)


 Union All
 
	select 
	n.NoteID nID,
	n.crenoteid NoteID
	,acc.name NoteName
	,dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1))  AS [TransDate] 
	,np.AddlFeesStrippingIncldinLevelYield Value
	,'AddlFeesStrippingIncldinLevelYield' as ValueType
	from 
	[CORE].[Account] acc 
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	inner join #Tempnoteperiodiccalc np on np.noteid = n.noteid
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and isnull(np.AddlFeesStrippingIncldinLevelYield,0)<>0
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1
	and dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)) <= (
		Select CurrentMaturity from #tblNoteMaturity where AccountID = acc.AccountID
	--select
	-- isnull(n.ActualPayoffDate, isnull(
	--		case when @Column='Initial or Actual Payoff Date' then n.ActualPayoffDate 
	--		when @Column='Expected Maturity Date' then n.ExpectedMaturityDate 
	--		when @Column='Extended Maturity Date #1' then n.ExtendedMaturityScenario1 
	--		when @Column='Extended Maturity Date #2' then n.ExtendedMaturityScenario2 
	--		when @Column='Extended Maturity Date #3' then n.ExtendedMaturityScenario3 
	--		when @Column='Open Prepayment Date' then n.OpenPrepaymentDate 
	--		when @Column='Fully Extended Maturity Date' then n.FullyExtendedMaturityDate end,

	--	(Select TOP 1 mat.[SelectedMaturityDate]
	--		from [CORE].Maturity mat
	--		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
	--		INNER JOIN (Select 
	--		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
	--		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
	--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
	--		INNER JOIN [CORE].[Account] accSub ON accSub.AccountID = n.Account_AccountID
	--		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'Maturity')
	--		and accSub.AccountID = acc.AccountID
	--		GROUP BY n.Account_AccountID,EventTypeID
	--	) sEvent
	--	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID)
	--	))
	)

 Union All
 
	select 
	n.NoteID nID,
	n.crenoteid NoteID
	,acc.name NoteName
	,dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1))  AS [TransDate]
	,(np.AddlFeesStrippingExcldfromLevelYield * -1) Value
	,'AddlFeesStrippingExcldfromLevelYield' as ValueType
	from 
	[CORE].[Account] acc 
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	inner join #Tempnoteperiodiccalc np on np.noteid = n.noteid
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and isnull(np.AddlFeesStrippingExcldfromLevelYield,0)<>0
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1
	and dateadd(d,day(firstpaymentdate),eomonth(periodenddate,-1)) <= (
		Select CurrentMaturity from #tblNoteMaturity where AccountID = acc.AccountID
	--select
	-- isnull(n.ActualPayoffDate, isnull(
	--		case when @Column='Initial or Actual Payoff Date' then n.ActualPayoffDate 
	--		when @Column='Expected Maturity Date' then n.ExpectedMaturityDate 
	--		when @Column='Extended Maturity Date #1' then n.ExtendedMaturityScenario1 
	--		when @Column='Extended Maturity Date #2' then n.ExtendedMaturityScenario2 
	--		when @Column='Extended Maturity Date #3' then n.ExtendedMaturityScenario3 
	--		when @Column='Open Prepayment Date' then n.OpenPrepaymentDate 
	--		when @Column='Fully Extended Maturity Date' then n.FullyExtendedMaturityDate end,

	--	(Select TOP 1 mat.[SelectedMaturityDate]
	--		from [CORE].Maturity mat
	--		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
	--		INNER JOIN (Select 
	--		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
	--		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
	--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
	--		INNER JOIN [CORE].[Account] accSub ON accSub.AccountID = n.Account_AccountID
	--		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'Maturity')
	--		and accSub.AccountID = acc.AccountID
	--		GROUP BY n.Account_AccountID,EventTypeID
	--	) sEvent
	--	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID)
	--	))
	)

Union All

	select 
	n.NoteID nID,
	n.crenoteid NoteID
	,acc.name NoteName
	,periodenddate AS [TransDate] 
	,np.EndingGAAPBookValue Value
	,'EndingGAAPBookValue' as ValueType
	from 
	[CORE].[Account] acc 
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	inner join #Tempnoteperiodiccalc np on np.noteid = n.noteid
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and isnull(np.EndingGAAPBookValue,0)<>0
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1
	and periodenddate <= (
		Select CurrentMaturity from #tblNoteMaturity where AccountID = acc.AccountID
	--select
	-- isnull(n.ActualPayoffDate, isnull(
	--		case when @Column='Initial or Actual Payoff Date' then n.ActualPayoffDate 
	--		when @Column='Expected Maturity Date' then n.ExpectedMaturityDate 
	--		when @Column='Extended Maturity Date #1' then n.ExtendedMaturityScenario1 
	--		when @Column='Extended Maturity Date #2' then n.ExtendedMaturityScenario2 
	--		when @Column='Extended Maturity Date #3' then n.ExtendedMaturityScenario3 
	--		when @Column='Open Prepayment Date' then n.OpenPrepaymentDate 
	--		when @Column='Fully Extended Maturity Date' then n.FullyExtendedMaturityDate end,

	--	(Select TOP 1 mat.[SelectedMaturityDate]
	--		from [CORE].Maturity mat
	--		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
	--		INNER JOIN (Select 
	--		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
	--		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
	--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
	--		INNER JOIN [CORE].[Account] accSub ON accSub.AccountID = n.Account_AccountID
	--		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'Maturity')
	--		and accSub.AccountID = acc.AccountID
	--		GROUP BY n.Account_AccountID,EventTypeID
	--	) sEvent
	--	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID)
	--	))
	)

Union All

	select 
	n.NoteID nID,
	n.crenoteid NoteID
	,acc.name NoteName
	,periodenddate AS [TransDate]
	,null Value
	,'TotalGAAPIncomeforthePeriod' as ValueType
	from 
	[CORE].[Account] acc 
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	inner join #Tempnoteperiodiccalc np on np.noteid = n.noteid
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	--and isnull(np.TotalGAAPIncomeforthePeriod,0)<>0
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1

Union All

	select n.NoteID nID,
	n.crenoteid NoteID
	,a.name NoteName
	,dateadd(d,day(firstpaymentdate),eomonth(transactiondate,-1)) AS [TransDate]
	,amount Value
	,replace(l.name,' ','') + 'Receivable' as ValueType
	from cre.note n inner join core.account a on n.account_accountid=a.accountid inner join 
	cre.payruledistributions p on p.receivernoteid=n.noteid inner join core.lookup l on p.ruleid=l.lookupid
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and isnull(amount,0)<>0
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1
	and dateadd(d,day(firstpaymentdate),eomonth(transactiondate,-1))  <= (
	Select CurrentMaturity from #tblNoteMaturity where AccountID = acc.AccountID
	--select
	-- isnull(n.ActualPayoffDate, isnull(
	--		case when @Column='Initial or Actual Payoff Date' then n.ActualPayoffDate 
	--		when @Column='Expected Maturity Date' then n.ExpectedMaturityDate 
	--		when @Column='Extended Maturity Date #1' then n.ExtendedMaturityScenario1 
	--		when @Column='Extended Maturity Date #2' then n.ExtendedMaturityScenario2 
	--		when @Column='Extended Maturity Date #3' then n.ExtendedMaturityScenario3 
	--		when @Column='Open Prepayment Date' then n.OpenPrepaymentDate 
	--		when @Column='Fully Extended Maturity Date' then n.FullyExtendedMaturityDate end,

	--	(Select TOP 1 mat.[SelectedMaturityDate]
	--		from [CORE].Maturity mat
	--		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
	--		INNER JOIN (Select 
	--		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
	--		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
	--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
	--		INNER JOIN [CORE].[Account] accSub ON accSub.AccountID = n.Account_AccountID
	--		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'Maturity')
	--		and accSub.AccountID = a.AccountID
	--		GROUP BY n.Account_AccountID,EventTypeID
	--	) sEvent
	--	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID)
	--	))
	)


Union All

	select n.NoteID nID,
	n.crenoteid NoteID
	,acc.name NoteName
	,ClosingDate AS [TransDate]
	,-(n.PurchasedInterestOverride) Value
	,'PurchasedInterest' as ValueType
	from 
	[CORE].[Account] acc 
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and isnull(n.PurchasedInterestOverride,0)<>0
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1
	and ClosingDate <= (
		Select CurrentMaturity from #tblNoteMaturity where AccountID = acc.AccountID
	--select
	-- isnull(n.ActualPayoffDate, isnull(
	--		case when @Column='Initial or Actual Payoff Date' then n.ActualPayoffDate 
	--		when @Column='Expected Maturity Date' then n.ExpectedMaturityDate 
	--		when @Column='Extended Maturity Date #1' then n.ExtendedMaturityScenario1 
	--		when @Column='Extended Maturity Date #2' then n.ExtendedMaturityScenario2 
	--		when @Column='Extended Maturity Date #3' then n.ExtendedMaturityScenario3 
	--		when @Column='Open Prepayment Date' then n.OpenPrepaymentDate 
	--		when @Column='Fully Extended Maturity Date' then n.FullyExtendedMaturityDate end,

	--	(Select TOP 1 mat.[SelectedMaturityDate]
	--		from [CORE].Maturity mat
	--		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
	--		INNER JOIN (Select 
	--		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
	--		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
	--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
	--		INNER JOIN [CORE].[Account] accSub ON accSub.AccountID = n.Account_AccountID
	--		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'Maturity')
	--		and accSub.AccountID = acc.AccountID
	--		GROUP BY n.Account_AccountID,EventTypeID
	--	) sEvent
	--	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID)
	--	))
	)

Union All

	select n.NoteID nID,
	 n.crenoteid NoteID
	,acc.name NoteName
	,ClosingDate AS [TransDate]
	,-CapitalizedClosingCosts Value
	,'CapitalizedClosingCost' as ValueType
	from 
	[CORE].[Account] acc 
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
	where ( CASE WHEN @NoteId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.NoteID = @NoteId  THEN 1 ELSE 0 END ) = 1 
	and isnull(n.CapitalizedClosingCosts,0)<>0
	AND (CASE WHEN @DealId = '00000000-0000-0000-0000-000000000000' THEN 1 WHEN n.DealID = @DealId  THEN 1 ELSE 0 END ) = 1
	and ClosingDate <= (
		Select CurrentMaturity from #tblNoteMaturity where AccountID = acc.AccountID
	--select
	-- isnull(n.ActualPayoffDate, isnull(
	--		case when @Column='Initial or Actual Payoff Date' then n.ActualPayoffDate 
	--		when @Column='Expected Maturity Date' then n.ExpectedMaturityDate 
	--		when @Column='Extended Maturity Date #1' then n.ExtendedMaturityScenario1 
	--		when @Column='Extended Maturity Date #2' then n.ExtendedMaturityScenario2 
	--		when @Column='Extended Maturity Date #3' then n.ExtendedMaturityScenario3 
	--		when @Column='Open Prepayment Date' then n.OpenPrepaymentDate 
	--		when @Column='Fully Extended Maturity Date' then n.FullyExtendedMaturityDate end,

	--	(Select TOP 1 mat.[SelectedMaturityDate]
	--		from [CORE].Maturity mat
	--		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId
	--		INNER JOIN (Select 
	--		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
	--		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve
	--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
	--		INNER JOIN [CORE].[Account] accSub ON accSub.AccountID = n.Account_AccountID
	--		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'Maturity')
	--		and accSub.AccountID = acc.AccountID
	--		GROUP BY n.Account_AccountID,EventTypeID
	--	) sEvent
	--	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID)
	--	))
	)

) a 
where a.TransDate is not null
and  a.nID not in ( select distinct ObjectID from core.Exceptions ex where objectTypeID= (select lookupid from core.Lookup where name='Note' and ParentID=27) 
and ActionLevelID=(select lookupid from core.Lookup where name='Critical' and ParentID=46))
and  a.nID  in (select NoteID from core.calculationRequests where StatusID=266 and CalcType = 775)

order by Noteid,Transdate asc
	

DROP TABLE #Tempnoteperiodiccalc

-- Set isolation level to original isolation level
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	









 
	
    
END      


