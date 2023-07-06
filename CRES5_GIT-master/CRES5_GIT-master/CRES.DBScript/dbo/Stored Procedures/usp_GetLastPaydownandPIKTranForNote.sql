
--[dbo].[usp_GetLastPaydownandPIKTranForNote] '0F813461-56CF-48B8-B666-3D1F779A2D94', 'c10f3372-0fc2-4861-a9f5-148f1f80804f'

CREATE PROCEDURE [dbo].[usp_GetLastPaydownandPIKTranForNote]  
(
    @DealID UNIQUEIDENTIFIER,
	@AnalysisID UNIQUEIDENTIFIER
)
	
AS
BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--DECLARE @AnalysisID UNIQUEIDENTIFIER =  'c10f3372-0fc2-4861-a9f5-148f1f80804f'

Declare @ExcludedForcastedPrePayment int;

SET @ExcludedForcastedPrePayment = (Select ExcludedForcastedPrePayment from core.analysisParameter where AnalysisID = @AnalysisID)


Declare @tblFundingdataWithPIK as table
(
dealid UNIQUEIDENTIFIER,
noteid UNIQUEIDENTIFIER,
credealid nvarchar(256),
crenoteid nvarchar(256),
lastPayDown_Date date,
lastPayDown_Amount decimal(28,15),
Purposeid int,
PurposeTypeText nvarchar(256),
Lastest_EffectiveDate	 date,
PIKFunding_afterLastPyDn decimal(28,15)
)


IF (@ExcludedForcastedPrePayment = 4)
BEGIN

	Declare @mat_Type nvarchar(256)

	SET @mat_Type = (
		Select MaturityType from(
			Select a.AnalysisID,a.name,l.name as MaturityScenarioOverride,
			(CASE WHEN l.name ='Initial or Actual Payoff Date' then 'Initial'
			WHEN l.name ='Expected Maturity Date' then 'ExpectedMaturityDate'  
			WHEN l.name ='Extended Maturity Date' then 'Extension'
			WHEN l.name ='Open Prepayment Date' then 'OpenPrepaymentDate'
			WHEN l.name ='Fully Extended Maturity Date' then 'Fully extended'
			WHEN l.name ='Current Maturity Date' then 'Current Maturity Date'
			end)  MaturityType
			from core.Analysis a
			inner join core.analysisparameter am on am.AnalysisID = a.AnalysisID
			left join core.lookup l on l.lookupid = am.MaturityScenarioOverrideID
			where a.AnalysisID = @AnalysisID
		)a
	)

	---------------------------------------------------
	declare @tblDealMaturity as Table
	(
		DealID UNIQUEIDENTIFIER,
		deal_MatDate date
	)

	INSERT INTO @tblDealMaturity(DealID,deal_MatDate)
	Select dealid,MAX([MaturityDate]) as [MaturityDate]
	From(
		Select n.dealid,n.crenoteid,n.NoteID,e.EffectiveStartDate  as [EffectiveDate],
		lMaturityType.name as [MaturityType],
		mat.MaturityDate as [MaturityDate],
		---ISNULL(n.ActualPayoffDate,mat.MaturityDate) as [MaturityDate],
		lApproved.name as Approved
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

			and n.dealid = @DealID

			GROUP BY n.Account_AccountID,EventTypeID    
		) sEvent    
		ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  and e.StatusID = 1
		Left JOin Core.lookup lMaturityType on lMaturityType.lookupid = mat.MaturityType
		Left JOin Core.lookup lApproved on lApproved.lookupid = mat.Approved
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID  
		where e.StatusID = 1
		and lMaturityType.name  = @mat_Type
		and lApproved.name = 'Y'					
	
		and n.dealid = @DealID

		UNION ALL

		Select dealid,crenoteid,noteid,effectivestartdate as [EffectiveDate], MaturityType,MaturityDate,Approved
		from (
			Select n.dealid,n.crenoteid,n.noteid,e.effectivestartdate,'Current Maturity Date' as [MaturityType],
			--ISNULL(n.ActualPayOffdate, mat.MaturityDate) as [MaturityDate],
			mat.MaturityDate as [MaturityDate],
			lApproved.name as Approved,
			ROW_NUMBER() Over(Partition by noteid,e.effectivestartdate order by noteid,(CASE WHEN lMaturityType.name = 'Initial' THEN 0 WHEN lMaturityType.name = 'Fully extended' THEN 9999 ELSE 1 END) ASC, mat.MaturityDate) rno
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

				and n.dealid = @DealID

				GROUP BY n.Account_AccountID,EventTypeID    
			) sEvent    
			ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  and e.StatusID = 1		
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 	
			Left JOin Core.lookup lMaturityType on lMaturityType.lookupid = mat.MaturityType
			Left JOin Core.lookup lApproved on lApproved.lookupid = mat.Approved	
			where mat.MaturityDate > getdate()
			and lApproved.name = 'Y'
		
			and n.dealid = @DealID
		)a 	
		where a.rno = 1
		and MaturityType = @mat_Type

	)z
	group by z.dealid

	--==========================================

	declare @tblDeal as Table
	(
		DealID UNIQUEIDENTIFIER,
		DealMatDate date,
		AsOfDate date,
		CumulativeProbability int	
	)

	INSERT INTO @tblDeal(DealID,DealMatDate,AsOfDate,CumulativeProbability)

	Select distinct n.DealID,dm.deal_MatDate,tbluw.AsOfDate,tbluw.CumulativeProbability
	from cre.note n
	inner join cre.deal d on n.dealid = d.dealid
	inner join core.account acc on acc.accountid = n.account_accountid
	inner join(
		Select dealid,AsOfDate,CumulativeProbability 
		from [CRE].[DealProjectedPayOffAccounting] 
		where CumulativeProbability = 1

		and dealid = @DealID

	)as tbluw on tbluw.dealid = d.dealid

	left join @tblDealMaturity dm on dm.dealid = d.dealid

	where acc.IsDeleted <> 1 
	and d.EnableAutoSpreadRepayments = 1
	and tbluw.CumulativeProbability = 1
	and tbluw.AsOfDate <= dm.deal_MatDate

	--==========================================
	Declare @tblFundingdata as table
	(
	dealid UNIQUEIDENTIFIER,
	noteid UNIQUEIDENTIFIER,
	credealid nvarchar(256),
	crenoteid nvarchar(256),
	lastPayDown_Date date,
	lastPayDown_Amount decimal(28,15),
	Purposeid int,
	PurposeTypeText nvarchar(256),
	Lastest_EffectiveDate	 date
	)


	INSERT INTO @tblFundingdata (dealid,noteid,credealid,crenoteid,lastPayDown_Date,lastPayDown_Amount,Purposeid,PurposeTypeText,Lastest_EffectiveDate)
	Select dealid,noteid,credealid,crenoteid,date,value,Purposeid,PurposeTypeText,Lastest_EffectiveDate	
	From(

		Select  n.dealid,n.noteid,d.credealid,n.crenoteid,fs.date,fs.value,fs.Purposeid,LPurposeID.name as PurposeTypeText,e.EffectiveStartDate as Lastest_EffectiveDate,
		rOW_NUMBER() OVER (Partition BY n.dealid,n.noteid Order by n.dealid,n.noteid,fs.date desc) as rno
		from [CORE].FundingSchedule fs
		INNER JOIN [CORE].[Event] e on e.EventID = fs.EventId
		INNER JOIN 
		(						
			Select 
				(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,
				MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
				from [CORE].[Event] eve
				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID
				INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID
				where EventTypeID = 10
				and acc.IsDeleted = 0
				and eve.StatusID = 1
				and n.dealid in (Select distinct dealid from @tblDeal)
				GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID
		) sEvent
		ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
		left JOIN [CORE].[Lookup] LEventTypeID ON LEventTypeID.LookupID = e.EventTypeID
		left JOIN [CORE].[Lookup] LPurposeID ON LPurposeID.LookupID = fs.PurposeID 
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
		inner join cre.deal d on n.dealid = d.dealid
		where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0

		and n.dealid in (Select distinct dealid from @tblDeal)
		and fs.PurposeID = 631
	)a where rno = 1





	INSERT INTO @tblFundingdataWithPIK (dealid,noteid,credealid,crenoteid,lastPayDown_Date,lastPayDown_Amount,Purposeid,PurposeTypeText,Lastest_EffectiveDate,PIKFunding_afterLastPyDn)

	select fs.dealid,fs.noteid,credealid,crenoteid,lastPayDown_Date,lastPayDown_Amount,Purposeid,PurposeTypeText,Lastest_EffectiveDate,ISNULL(tblPIKTr.PIKFunding_afterLastPyDn,0) as PIKFunding_afterLastPyDn
	from @tblFundingdata fs
	outer Apply(
		Select n.noteid,(CASE WHEN SUM(tr.Amount) < 0 THEN SUM(tr.Amount) * -1 ELSE SUM(tr.Amount) END) as PIKFunding_afterLastPyDn
		from cre.TransactionEntry tr
		inner join cre.note n on n.noteid = tr.noteid
		inner join cre.deal d on d.dealid = n.dealid
		where tr.AnalysisID = @AnalysisID
		and [type] in ('PIKPrincipalFunding','PIKPrincipalPaid','ScheduledPrincipalPaid')
	
		and n.noteid = fs.noteid	
		and tr.date > fs.lastPayDown_Date
	
		group by n.noteid
	)tblPIKTr


END


Select dealid,noteid,credealid,crenoteid,lastPayDown_Date,lastPayDown_Amount,Purposeid,PurposeTypeText,Lastest_EffectiveDate,PIKFunding_afterLastPyDn from @tblFundingdataWithPIK


	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END