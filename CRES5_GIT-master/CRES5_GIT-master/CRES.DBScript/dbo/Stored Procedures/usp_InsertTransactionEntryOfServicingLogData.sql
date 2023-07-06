  
CREATE PROCEDURE [dbo].[usp_InsertTransactionEntryOfServicingLogData]   
@NoteId UNIQUEIDENTIFIER, 
@AnalysisID UNIQUEIDENTIFIER, 
@CreatedBy  nvarchar(256)  
  
AS  
BEGIN  
    SET NOCOUNT ON;  

--==========================================
Declare @StrCreatedBy nvarchar(256);
IF(@CreatedBy like REPLACE('00000000-0000-0000-0000-000000000000', '0', '[0-9a-fA-F]'))
BEGIN
	SET @StrCreatedBy = (Select top 1 [Login] from app.[user] where userid = @CreatedBy)
END
ELSE
BEGIN
	SET @StrCreatedBy =  @CreatedBy
END


Declare @ServicerMasterID int;
SET @ServicerMasterID = (Select ServicerMasterID from cre.servicermaster where ServicerName = 'M61Addin')

Declare @ServicerModifiedID int;
SET @ServicerModifiedID = (Select ServicerMasterID from cre.servicermaster where ServicerName = 'Modified')

Declare @ServicerManual int;
SET @ServicerManual = (Select ServicerMasterID from cre.servicermaster where ServicerName = 'ManualTransaction')
--====================================

IF OBJECT_ID('tempdb..[#TempServicingLog]') IS NOT NULL                                         
 DROP TABLE [#TempServicingLog]  

Create table [#TempServicingLog]
(   
	--NoteTransactionDetailid UNIQUEIDENTIFIER null,
	noteid	UNIQUEIDENTIFIER null,
	TransactionTypeText	nvarchar(255) null,
	TransactionDate	Date null,
	Amount  decimal(28,15) null,
	[Status]	nvarchar(255) null,   
	TransactionDateByRule   Date null,  
	TransactionDateServicingLog Date null  ,
	RemitDate 	date null  ,
	ServicerMasterID   int 
)  
INSERT INTO [#TempServicingLog] (noteid,TransactionTypeText,TransactionDate,Amount,[Status],TransactionDateByRule,TransactionDateServicingLog,RemitDate,ServicerMasterID)

Select 
noteid,
TransactionTypeText,
TransactionDate	,
SUM(Amount) as Amount	,
Status	
,MAX(TransactionDateByRule) as TransactionDateByRule
,MAX(TransactionDateServicingLog) as TransactionDateServicingLog
,MAX(RemittanceDate) RemittanceDate
,ServicerMasterID
From(
	Select NoteTransactionDetailid,noteid,
	TransactionTypeText as TransactionTypeText,
	Cast(RelatedtoModeledPMTDate as datetime) TransactionDate,

	--(CASE WHEn ty.Calculated = 4 THEN ntd.CalculatedAmount 
	--ELSE
	--	(Case When (isnull(ntd.OverrideValue,0) <> 0 ) Then ntd.OverrideValue
	--	When (isnull(ntd.M61Value,0) <> 0 ) Then ntd.CalculatedAmount
	--	When (isnull(ntd.ServicerValue,0) <>0 ) Then ntd.ServicingAmount
	--	When (isnull(ntd.Ignore,0) <>0 ) Then ntd.OverrideValue
	--	ELSE ntd.CalculatedAmount END) 
	--END)
	--as Amount,

	--Based on Transactin type config
	(CASE	
	--WHEN (Calculated = 3 and IncludeServicingReconciliation = 3) THEN (Case When (isnull(ntd.OverrideValue,0) <> 0 ) Then ntd.OverrideValue When (isnull(ntd.M61Value,0) <> 0 ) Then ntd.CalculatedAmount	When (isnull(ntd.ServicerValue,0) <>0 ) Then ntd.ServicingAmount	When (isnull(ntd.Ignore,0) <> 0 ) Then ntd.OverrideValue	ELSE ntd.CalculatedAmount END) 
	WHEN (Calculated = 3 and IncludeServicingReconciliation = 3) THEN (Case When ntd.OverrideValue > 0 then ntd.OverrideValue When (isnull(ntd.M61Value,0) = 0 and isnull(ntd.ServicerValue,0) = 0 ) then ntd.OverrideValue When (isnull(ntd.M61Value,0) <> 0 ) Then ntd.CalculatedAmount	When (isnull(ntd.ServicerValue,0) <>0 ) Then ntd.ServicingAmount	When (isnull(ntd.Ignore,0) <> 0 ) Then ntd.OverrideValue	ELSE ntd.CalculatedAmount END) 
	WHEN (Calculated = 3 and AllowCalculationOverride = 3) THEN ntd.CalculatedAmount
	WHEN (Calculated = 4 and ServicerMasterID <> @ServicerManual) THEN ntd.CalculatedAmount	
	--WHEN (Calculated = 4 and ServicerMasterID = @ServicerManual) THEN (Case When (isnull(ntd.OverrideValue,0) <> 0 ) Then ntd.OverrideValue When (isnull(ntd.M61Value,0) <> 0 ) Then ntd.CalculatedAmount	When (isnull(ntd.ServicerValue,0) <>0 ) Then ntd.ServicingAmount	When (isnull(ntd.Ignore,0) <>0 ) Then ntd.OverrideValue	ELSE ntd.CalculatedAmount END) 
	WHEN (Calculated = 4 and ServicerMasterID = @ServicerManual) THEN (Case When ntd.OverrideValue > 0 then ntd.OverrideValue When (isnull(ntd.M61Value,0) = 0 and isnull(ntd.ServicerValue,0) = 0 ) then ntd.OverrideValue When (isnull(ntd.M61Value,0) <> 0 ) Then ntd.CalculatedAmount	When (isnull(ntd.ServicerValue,0) <>0 ) Then ntd.ServicingAmount	When (isnull(ntd.Ignore,0) <> 0 ) Then ntd.OverrideValue	ELSE ntd.CalculatedAmount END) 
	ELSE ntd.CalculatedAmount END) as Amount,

	'insert' as [Status],

	--(CASE 
	--WHEN (TransactionTypeText = 'ManagementFee' or TransactionTypeText like 'AcoreOriginationFee%') THEN Cast(RelatedtoModeledPMTDate as datetime)
	--ELSE
	--	(Cast((Case WHEN RemittanceDate <= dbo.Fn_GetnextWorkingDays(Cast(RelatedtoModeledPMTDate as datetime),5,'PMT Date') THEN Cast(RelatedtoModeledPMTDate as datetime)
	--	WHEN RemittanceDate > dbo.Fn_GetnextWorkingDays(Cast(RelatedtoModeledPMTDate as datetime),5,'PMT Date') THEN RemittanceDate
	--	ELSE RelatedtoModeledPMTDate END) as datetime) )
	--END)	
	--as TransactionDateByRule,

	(Cast(	
	(Case WHEN RemittanceDate <= dbo.Fn_GetnextWorkingDays(Cast(RelatedtoModeledPMTDate as datetime), (case when TransactionTypeText = 'ScheduledPrincipalPaid' then 10 else 5 end)  ,'PMT Date') THEN Cast(RelatedtoModeledPMTDate as datetime) 
	WHEN RemittanceDate > dbo.Fn_GetnextWorkingDays(Cast(RelatedtoModeledPMTDate as datetime),(case when TransactionTypeText = 'ScheduledPrincipalPaid' then 10 else 5 end),'PMT Date') THEN RemittanceDate 
	ELSE RelatedtoModeledPMTDate END) 	
	as datetime)  ) as TransactionDateByRule,

	ntd.TransactionDate as TransactionDateServicingLog,
	ntd.RemittanceDate,
	ntd.ServicerMasterID
	from cre.NoteTransactionDetail ntd
	left join cre.TransactionTypes ty on ty.TransactionName = ntd.TransactionTypeText
	where NoteID = @NoteId
	
	and ((Calculated = 3 and IncludeServicingReconciliation = 3) 
			or (Calculated = 3 and AllowCalculationOverride = 3 and ntd.ServicerMasterID = @ServicerModifiedID) 
			or (Calculated = 4))
	
	--and ntd.TransactionTypeText <> 'PIKInterest'

	and ntd.TransactionTypeText not in (
	'PIKInterest',

	'ExitFeeExcludedFromLevelYield',
	'ExitFeeIncludedInLevelYield',
	'ExitFeeStrippingExcldfromLevelYield',
	'ExitFeeStripReceivable',
	'ExtensionFeeExcludedFromLevelYield',
	'ExtensionFeeIncludedInLevelYield',
	'ExtensionFeeStrippingExcldfromLevelYield',
	'ExtensionFeeStripReceivable',
	'PrepaymentFeeExcludedFromLevelYield',
	'UnusedFeeExcludedFromLevelYield',
	'ScheduledPrincipalPaid')

	/*
	--global = Y
	--((Calculated = y and IncludeServicingReconciliation = 'Y') or (Calculated = 'Y' and AllowCalculationOverride = 'Y')
	--or (Calculated = N  - everything))

	--Select servecer recon whenever avaialble
	--servecer recon if not avaialble use overrde amount if availble
	--if overrdie  not availabl and allow override = Y'' dont send anything 
	--if calc = N then use calculate amount
	*/

)a
group by 
noteid,
TransactionTypeText,
TransactionDate	,Status,ServicerMasterID
--=================================================================================

Update [#TempServicingLog] set [#TempServicingLog].[Status] = 'update'
from(
	
	Select 
	--a.NoteTransactionDetailid,
	a.noteid,
	a.TransactionTypeText,
	a.TransactionDate,
	a.Amount
	from [#TempServicingLog] a
	inner join cre.transactionEntry te on te.noteid = a.noteid and a.TransactionDate = te.[Date] and a.TransactionTypeText = te.[Type] and te.AnalysisID = @AnalysisID
)b
where 
[#TempServicingLog].noteid = b.noteid
and [#TempServicingLog].TransactionTypeText = b.TransactionTypeText
and [#TempServicingLog].TransactionDate = b.TransactionDate

--[#TempServicingLog].NoteTransactionDetailid = b.NoteTransactionDetailid
--=================================================================================


Update [#TempServicingLog] set TransactionDateServicingLog = null,RemitDate = null where ServicerMasterID = 5 and TransactionTypeText in ('PIKPrincipalPaid','PIKInterestPaid')

  
INSERT INTO [CRE].[TransactionEntry]  
(  
	NoteID  
	,[Date]  
	,Amount  
	,[Type]  
	,CreatedBy  
	,CreatedDate  
	,UpdatedBy  
	,UpdatedDate
	,AnalysisID  
	,FeeName
	,StrCreatedBy
	,GeneratedBy
	,TransactionDateByRule
	,TransactionDateServicingLog
	,RemitDate
)  
 Select  
  noteid  
 ,TransactionDate  
 ,Amount  
 ,TransactionTypeText 
 ,@CreatedBy  
 ,GETDATE()  
 ,@CreatedBy  
 ,GETDATE() 
 ,@AnalysisID 
 ,null as FeeName
 ,@StrCreatedBy
 ,'ManualTransaction' as GeneratedBy
 ,TransactionDateByRule
 ,TransactionDateServicingLog
 ,RemitDate
 FROM [#TempServicingLog] where [Status] = 'insert' 
  
 
 
Update [CRE].[TransactionEntry]  set 
[CRE].[TransactionEntry].Amount = a.Amount,
[CRE].[TransactionEntry].UpdatedBy  = @CreatedBy,
[CRE].[TransactionEntry].UpdatedDate = getdate(),
[CRE].[TransactionEntry].GeneratedBy = 'ManualTransaction',
[CRE].[TransactionEntry].TransactionDateByRule = a.TransactionDateByRule,
[CRE].[TransactionEntry].TransactionDateServicingLog = a.TransactionDateServicingLog,
[CRE].[TransactionEntry].RemitDate = a.RemitDate

from(
	Select  
	noteid  
	,TransactionDate  
	,Amount  
	,TransactionTypeText  
	,TransactionDateByRule 
	,TransactionDateServicingLog
	,RemitDate
	FROM [#TempServicingLog] where [Status] = 'update' 
)a
where [CRE].[TransactionEntry].noteid = a.noteid 
and [CRE].[TransactionEntry].[Date] = a.TransactionDate 
and [CRE].[TransactionEntry].[Type] = a.TransactionTypeText 
and [CRE].[TransactionEntry].AnalysisID = @AnalysisID

--================================================
--Update Transaction date = current maturity if it beyond the current maturity date.
Declare @currentmaturity date;
Declare @ClosingDate date;

--SET @currentmaturity = (
--	Select isnull(n.ActualPayoffDate,
--		ISNULL(
--		(CASE WHEN Scenario.MaturityScenarioOverride ='Initial or Actual Payoff Date' then n.ActualPayoffDate   
--		WHEN Scenario.MaturityScenarioOverride ='Expected Maturity Date' then n.ExpectedMaturityDate   
--		WHEN Scenario.MaturityScenarioOverride ='Extended Maturity Date #1' then n.ExtendedMaturityScenario1   
--		WHEN Scenario.MaturityScenarioOverride ='Extended Maturity Date #2' then n.ExtendedMaturityScenario2   
--		WHEN Scenario.MaturityScenarioOverride ='Extended Maturity Date #3' then n.ExtendedMaturityScenario3   
--		WHEN Scenario.MaturityScenarioOverride ='Open Prepayment Date' then n.OpenPrepaymentDate   
--		WHEN Scenario.MaturityScenarioOverride ='Fully Extended Maturity Date' then n.FullyExtendedMaturityDate 
--		Else (
--			ISNULL(n.ActualPayoffDate,
--			ISNULL((CASE WHEN InitialMaturity.SelectedMaturityDate > getdate() THEN InitialMaturity.SelectedMaturityDate
--			WHEN n.ExtendedMaturityScenario1 > getdate() THEN n.ExtendedMaturityScenario1
--			WHEN n.ExtendedMaturityScenario2 > getdate() THEN n.ExtendedMaturityScenario2
--			WHEN n.ExtendedMaturityScenario3 > getdate() THEN n.ExtendedMaturityScenario3
--			ELSE n.FullyExtendedMaturityDate END),InitialMaturity.SelectedMaturityDate)) 
--		)end) ,InitialMaturity.[SelectedMaturityDate])
--	)as maturity

--	from cre.Note n
--	left join(
--		Select n.noteid,mat.[SelectedMaturityDate]  
--		from [CORE].Maturity mat  
--		INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
--		inner join core.account acc on acc.accountid = e.accountid
--		inner join cre.note n on n.account_accountid =acc.accountid 
--		INNER JOIN (Select   
--			(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
--			MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
--			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
--			INNER JOIN [CORE].[Account] accSub ON accSub.AccountID = n.Account_AccountID  
--			where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'Maturity')  
--			--and n.crenoteid = '2230'
--			GROUP BY n.Account_AccountID,EventTypeID  
--		) sEvent  
--		ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID

--	)InitialMaturity on InitialMaturity.noteid = n.noteid
--	,
--	(
--		Select a.AnalysisID,a.name,l.name as MaturityScenarioOverride from core.Analysis a
--		inner join core.analysisparameter am on am.AnalysisID = a.AnalysisID
--		left join core.lookup l on l.lookupid = am.MaturityScenarioOverrideID
--		where a.AnalysisID = @AnalysisID
--	)Scenario
--	where n.noteid = @NoteId

--)



SET @currentmaturity = (
	Select isnull(n1.ActualPayoffDate,
		ISNULL(
			(CASE WHEN Scenario.MaturityScenarioOverride ='Initial or Actual Payoff Date' then n1.ActualPayoffDate   
			WHEN Scenario.MaturityScenarioOverride ='Expected Maturity Date' then n1.ExpectedMaturityDate   
			WHEN Scenario.MaturityScenarioOverride ='Extended Maturity Date' then n1.ExtendedMaturityCurrent 
			WHEN Scenario.MaturityScenarioOverride ='Open Prepayment Date' then n1.OpenPrepaymentDate   
			WHEN Scenario.MaturityScenarioOverride ='Fully Extended Maturity Date' then n1.FullyExtendedMaturityDate 
			Else ISNULL(n1.ActualPayOffDate,ISNULL(currMat.MaturityDate,n1.FullyExtendedMaturityDate))  end) 
		,tblInitialMaturity.InitialMaturityDate)
	)as maturity

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
				where EventTypeID = 11 and eve.StatusID = 1
				and n.noteid = @NoteId
				and acc.IsDeleted = 0  
				GROUP BY n.Account_AccountID,EventTypeID    
			) sEvent    
			ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  and e.StatusID = 1
			INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 	
			Left JOin Core.lookup lMaturityType on lMaturityType.lookupid = mat.MaturityType
			Left JOin Core.lookup lApproved on lApproved.lookupid = mat.Approved	
			where mat.MaturityDate > getdate()
			and lApproved.name = 'Y'
			and n.noteid = @NoteId
	)a where a.rno = 1
)currMat on currMat.noteid = n1.noteid

Left JOin(
	Select n.noteid,mat.MaturityDate as InitialMaturityDate
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
		and n.noteid = @NoteId
		GROUP BY n.Account_AccountID,EventTypeID    
	) sEvent    
	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  and e.StatusID = 1
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 	
	where mat.MaturityType = 708 and mat.Approved = 3
)tblInitialMaturity on tblInitialMaturity.noteid = n1.noteid
,
	(
		Select a.AnalysisID,a.name,l.name as MaturityScenarioOverride from core.Analysis a
		inner join core.analysisparameter am on am.AnalysisID = a.AnalysisID
		left join core.lookup l on l.lookupid = am.MaturityScenarioOverrideID
		where a.AnalysisID = @AnalysisID
	)Scenario
where acc1.IsDeleted <> 1
and n1.noteid = @NoteId

)


Update cre.transactionEntry set [Date] = @currentmaturity  
From(
	Select TransactionEntryAutoID from cre.transactionEntry where noteid = @NoteId and AnalysisID = @AnalysisID  and [Date] > @currentmaturity and [Type] <> 'ManagementFee'
)a
where cre.transactionEntry.TransactionEntryAutoID = a.TransactionEntryAutoID


Update cre.transactionEntry set TransactionDateByRule = @currentmaturity
From(
	Select TransactionEntryAutoID from cre.transactionEntry where noteid = @NoteId and AnalysisID = @AnalysisID  and TransactionDateByRule > @currentmaturity and [Type] <> 'ManagementFee'
)a
where cre.transactionEntry.TransactionEntryAutoID = a.TransactionEntryAutoID



--Update cre.transactionEntry set [Date] = @currentmaturity  ,TransactionDateByRule = @currentmaturity
--From(
--	Select TransactionEntryAutoID from cre.transactionEntry where noteid = @NoteId and AnalysisID = @AnalysisID  and [Date] > @currentmaturity
--	UNION ALL
--	Select TransactionEntryAutoID from cre.transactionEntry where noteid = @NoteId and AnalysisID = @AnalysisID  and TransactionDateByRule > @currentmaturity
--)a
--where cre.transactionEntry.TransactionEntryAutoID = a.TransactionEntryAutoID


--=============================================


--SET @ClosingDate = (Select ClosingDate from cre.note where noteid = @NoteId)

--Update cre.transactionEntry set [Date] = @ClosingDate,TransactionDateByRule = @ClosingDate
--From(
--	Select TransactionEntryAutoID from cre.transactionEntry where noteid = @NoteId and AnalysisID = @AnalysisID  and [Date] < @ClosingDate
--	UNION ALL
--	Select TransactionEntryAutoID from cre.transactionEntry where noteid = @NoteId and AnalysisID = @AnalysisID  and TransactionDateByRule < @ClosingDate
--)a
--where cre.transactionEntry.TransactionEntryAutoID = a.TransactionEntryAutoID
----===========================================================================




--------Update Remit date 5 business day logic for ('PIKInterestPaid','PIKPrincipalFunding')-------
--IF EXISTS(Select noteid from cre.NoteTransactionDetail where NoteID = @NoteId and TransactionTypeText in ('PIKInterestPaid','PIKPrincipalFunding')	)
--BEGIN
--	Update [CRE].[TransactionEntry]  set 
--	[CRE].[TransactionEntry].UpdatedBy  = @CreatedBy,
--	[CRE].[TransactionEntry].UpdatedDate = getdate(),
--	--[CRE].[TransactionEntry].GeneratedBy = 'ManualTransaction',
--	[CRE].[TransactionEntry].TransactionDateByRule = z.TransactionDateByRule,
--	[CRE].[TransactionEntry].TransactionDateServicingLog = z.TransactionDateServicingLog,
--	[CRE].[TransactionEntry].RemitDate = z.RemittanceDate
--	from(
--		Select 
--		noteid,
--		TransactionTypeText,
--		TransactionDate	,
--		MAX(TransactionDateByRule) as TransactionDateByRule,
--		MAX(TransactionDateServicingLog) as TransactionDateServicingLog,
--		MAX(RemittanceDate) RemittanceDate
--		From(
--			Select NoteTransactionDetailid,noteid,
--			TransactionTypeText as TransactionTypeText,
--			Cast(RelatedtoModeledPMTDate as datetime) TransactionDate,
--			(Case 
--				When (isnull(ntd.OverrideValue,0) <> 0 ) Then ntd.OverrideValue
--				When (isnull(ntd.M61Value,0) <> 0 ) Then ntd.CalculatedAmount
--				When (isnull(ntd.ServicerValue,0) <>0 ) Then ntd.ServicingAmount
--				When (isnull(ntd.Ignore,0) <>0 ) Then ntd.OverrideValue
--				ELSE ntd.CalculatedAmount
--			END) as Amount,
--			'update' as [Status],	
--			Cast((Case WHEN RemittanceDate <= dbo.Fn_GetnextWorkingDays(Cast(RelatedtoModeledPMTDate as datetime),5,'PMT Date') THEN Cast(RelatedtoModeledPMTDate as datetime)
--			WHEN RemittanceDate > dbo.Fn_GetnextWorkingDays(Cast(RelatedtoModeledPMTDate as datetime),5,'PMT Date') THEN RemittanceDate
--			ELSE RelatedtoModeledPMTDate END) as datetime) as TransactionDateByRule,
--			ntd.TransactionDate as TransactionDateServicingLog,
--			ntd.RemittanceDate
--			from cre.NoteTransactionDetail ntd
--			where NoteID = @NoteId
--			and TransactionTypeText in ('PIKInterestPaid','PIKPrincipalFunding')		
--		)a
--		group by noteid,TransactionTypeText,TransactionDate	,Status

--	)z
--	where [CRE].[TransactionEntry].noteid = z.noteid 
--	and [CRE].[TransactionEntry].[Date] = z.TransactionDate 
--	and [CRE].[TransactionEntry].[Type] = z.TransactionTypeText 
--	and [CRE].[TransactionEntry].AnalysisID = @AnalysisID
--END




--and (TransactionTypeText not in ('Exit Fee Received','Fees Received','PIKInterest','PIKPrincipalFunding','PIKInterestPaid') --,'PIKInterestPaid'
	--		or TransactionTypeText  in (Select TransactionName from cre.TransactionTypes where (Calculated = 4) )  --and AllowCalculationOverride = 3
	--	)
		
	--and TransactionTypeText not in (Select TransactionName from cre.TransactionTypes where (Calculated = 4 and AllowCalculationOverride = 3) )
	----and ntd.ServicerMasterID <> @ServicerMasterID


END  
