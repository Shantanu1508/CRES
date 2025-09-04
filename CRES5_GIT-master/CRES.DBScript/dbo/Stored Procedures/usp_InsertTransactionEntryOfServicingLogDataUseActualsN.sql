CREATE PROCEDURE [dbo].[usp_InsertTransactionEntryOfServicingLogDataUseActualsN]   
@NoteId UNIQUEIDENTIFIER, 
@AnalysisID UNIQUEIDENTIFIER, 
@CreatedBy  nvarchar(256) ,
@MaturityUsedInCalc Date
  
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

Declare @AccountID UNIQUEIDENTIFIER;
SET @AccountID = (Select Account_AccountID from cre.note where noteid = @NoteId)


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
	RemitDate 	date null     ,
	ServicerMasterID   int ,
	AccountID	UNIQUEIDENTIFIER null,
)  
INSERT INTO [#TempServicingLog] (noteid,TransactionTypeText,TransactionDate,Amount,[Status],TransactionDateByRule,TransactionDateServicingLog,RemitDate,ServicerMasterID,AccountID)

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
,AccountID
From(
	Select NoteTransactionDetailid,ntd.noteid,
	TransactionTypeText as TransactionTypeText,
	Cast(RelatedtoModeledPMTDate as datetime) TransactionDate,	
	
	(CASE 
	---WHEN (ty.Calculated = 4 and ntd.ServicerMasterID <> @ServicerManual) THEN ntd.CalculatedAmount	
	---WHEN (ty.Calculated = 4 and ntd.ServicerMasterID = @ServicerManual) THEN (Case When (isnull(ntd.OverrideValue,0) <> 0 ) Then ntd.OverrideValue When (isnull(ntd.M61Value,0) <> 0 ) Then ntd.CalculatedAmount	When (isnull(ntd.ServicerValue,0) <>0 ) Then ntd.ServicingAmount	When (isnull(ntd.Ignore,0) <>0 ) Then ntd.OverrideValue	ELSE ntd.CalculatedAmount END) 
	WHEN (ty.Calculated = 4) THEN ntd.CalculatedAmount
	ELSE
		(Case When (isnull(ntd.OverrideValue,0) <> 0 ) Then ntd.OverrideValue
		When (isnull(ntd.M61Value,0) <> 0 ) Then ntd.CalculatedAmount
		When (isnull(ntd.ServicerValue,0) <>0 ) Then ntd.ServicingAmount
		When (isnull(ntd.Ignore,0) <>0 ) Then ntd.OverrideValue
		ELSE ntd.CalculatedAmount END) 
	END)
	as Amount,

	'insert' as [Status],
	
	--(CASE 
	--WHEN (TransactionTypeText = 'ManagementFee' or TransactionTypeText like 'AcoreOriginationFee%') THEN Cast(RelatedtoModeledPMTDate as datetime)
	--ELSE
	--	(Cast((Case WHEN RemittanceDate <= dbo.Fn_GetnextWorkingDays(Cast(RelatedtoModeledPMTDate as datetime),5,'PMT Date') THEN Cast(RelatedtoModeledPMTDate as datetime)
	--	WHEN RemittanceDate > dbo.Fn_GetnextWorkingDays(Cast(RelatedtoModeledPMTDate as datetime),5,'PMT Date') THEN RemittanceDate
	--	ELSE RelatedtoModeledPMTDate END) as datetime) )
	--END)	
	--as TransactionDateByRule,
	
	(Cast((Case WHEN RemittanceDate <= dbo.Fn_GetnextWorkingDays(Cast(RelatedtoModeledPMTDate as datetime),(case when TransactionTypeText = 'ScheduledPrincipalPaid' then 10 else 5 end),'PMT Date') THEN Cast(RelatedtoModeledPMTDate as datetime)
	WHEN RemittanceDate > dbo.Fn_GetnextWorkingDays(Cast(RelatedtoModeledPMTDate as datetime),(case when TransactionTypeText = 'ScheduledPrincipalPaid' then 10 else 5 end),'PMT Date') THEN RemittanceDate
	ELSE RelatedtoModeledPMTDate END) as datetime) ) as TransactionDateByRule,

	ntd.TransactionDate as TransactionDateServicingLog,
	ntd.RemittanceDate,
	ntd.ServicerMasterID,
	n.Account_AccountID as AccountID

	from cre.NoteTransactionDetail ntd
	left join cre.TransactionTypes ty on ty.TransactionName = ntd.TransactionTypeText
	inner join cre.note n on n.noteid = ntd.noteid
	where ntd.NoteID = @NoteId

	and ((ty.Calculated = 3 and ty.AllowCalculationOverride = 3 and ntd.ServicerMasterID = @ServicerModifiedID ) or (ty.Calculated = 4))
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
	---'PrepaymentFeeExcludedFromLevelYield',
	--'UnusedFeeExcludedFromLevelYield',
	'ScheduledPrincipalPaid')

	/*
	--global = N
	--(calculated =Y and AllowCalculationOverride =Y) or (calculated = N)

	--use overrde amount if availble
	--if overrdie  not availabl and allow override = Y' dont send anything 
	--if calc = N then use calculate amount
	*/


)a
group by 
noteid,AccountID,
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
	inner join cre.transactionEntry te on te.AccountID = a.AccountID and a.TransactionDate = te.[Date] and a.TransactionTypeText = te.[Type] and te.AnalysisID = @AnalysisID
)b
where 
[#TempServicingLog].noteid = b.noteid
and [#TempServicingLog].TransactionTypeText = b.TransactionTypeText
and [#TempServicingLog].TransactionDate = b.TransactionDate

--[#TempServicingLog].NoteTransactionDetailid = b.NoteTransactionDetailid
--=================================================================================


Update [#TempServicingLog] set TransactionDateServicingLog = null,RemitDate = null where ServicerMasterID = 5 and TransactionTypeText in ('PIKPrincipalPaid','PIKInterestPaid','PrepaymentFeeExcludedFromLevelYield','UnusedFeeExcludedFromLevelYield')


  
INSERT INTO [CRE].[TransactionEntry]  
(  
	--NoteID  
	[Date]  
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
	,AccountID
)  
 Select  
  --noteid  
 TransactionDate  
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
 ,AccountID
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
	,AccountID
	FROM [#TempServicingLog] where [Status] = 'update' 
)a
where [CRE].[TransactionEntry].AccountID = a.AccountID 
and [CRE].[TransactionEntry].[Date] = a.TransactionDate 
and [CRE].[TransactionEntry].[Type] = a.TransactionTypeText 
and [CRE].[TransactionEntry].AnalysisID = @AnalysisID

--================================================
--Update Transaction date = current maturity if it beyond the current maturity date.
Declare @currentmaturity date;
Declare @ClosingDate date;

SET @currentmaturity = @MaturityUsedInCalc;



--SET @currentmaturity = (
--	Select isnull(n1.ActualPayoffDate,
--		ISNULL(
--			(CASE WHEN Scenario.MaturityScenarioOverride ='Initial or Actual Payoff Date' then n1.ActualPayoffDate   
--			WHEN Scenario.MaturityScenarioOverride ='Expected Maturity Date' then n1.ExpectedMaturityDate   
--			WHEN Scenario.MaturityScenarioOverride ='Extended Maturity Date' then n1.ExtendedMaturityCurrent 
--			WHEN Scenario.MaturityScenarioOverride ='Open Prepayment Date' then n1.OpenPrepaymentDate   
--			WHEN Scenario.MaturityScenarioOverride ='Fully Extended Maturity Date' then n1.FullyExtendedMaturityDate 
--			Else ISNULL(n1.ActualPayOffDate,ISNULL(currMat.MaturityDate,n1.FullyExtendedMaturityDate))  end) 
--		,tblInitialMaturity.InitialMaturityDate)
--	)as maturity

--from cre.note n1
--Inner join core.account acc1 on acc1.Accountid = n1.Account_Accountid
--Left Join(
--	Select noteid,MaturityType,MaturityDate,Approved
--	from (
--			Select n.noteid,lMaturityType.name as [MaturityType],mat.MaturityDate as [MaturityDate],lApproved.name as Approved,
--			ROW_NUMBER() Over(Partition by noteid order by noteid,(CASE WHEN lMaturityType.name = 'Initial' THEN 0 WHEN lMaturityType.name = 'Fully extended' THEN 9999 ELSE 1 END) ASC, mat.MaturityDate) rno
--			from [CORE].Maturity mat  
--			INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
--			INNER JOIN   
--			(          
--				Select   
--				(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
--				MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
--				INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
--				INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
--				where EventTypeID = 11 and eve.StatusID = 1
--				and n.noteid = @NoteId
--				and acc.IsDeleted = 0  
--				GROUP BY n.Account_AccountID,EventTypeID    
--			) sEvent    
--			ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  and e.StatusID = 1
--			INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
--			INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 	
--			Left JOin Core.lookup lMaturityType on lMaturityType.lookupid = mat.MaturityType
--			Left JOin Core.lookup lApproved on lApproved.lookupid = mat.Approved	
--			where mat.MaturityDate > getdate()
--			and lApproved.name = 'Y'
--			and n.noteid = @NoteId
--	)a where a.rno = 1
--)currMat on currMat.noteid = n1.noteid

--Left JOin(
--	Select n.noteid,mat.MaturityDate as InitialMaturityDate
--	from [CORE].Maturity mat  
--	INNER JOIN [CORE].[Event] e on e.EventID = mat.EventId  
--	INNER JOIN   
--	(          
--		Select   
--		(Select AccountID from [CORE].[Account] ac where ac.AccountID = n.Account_AccountID) AccountID ,  
--		MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID from [CORE].[Event] eve  
--		INNER JOIN [CRE].[Note] n ON n.Account_AccountID = eve.AccountID  
--		INNER JOIN [CORE].[Account] acc ON acc.AccountID = n.Account_AccountID  
--		where EventTypeID = 11  and eve.StatusID = 1
--		and acc.IsDeleted = 0  
--		and n.noteid = @NoteId
--		GROUP BY n.Account_AccountID,EventTypeID    
--	) sEvent    
--	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID  and e.StatusID = 1
--	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
--	INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID 	
--	where mat.MaturityType = 708 and mat.Approved = 3
--)tblInitialMaturity on tblInitialMaturity.noteid = n1.noteid
--,
--	(
--		Select a.AnalysisID,a.name,l.name as MaturityScenarioOverride from core.Analysis a
--		inner join core.analysisparameter am on am.AnalysisID = a.AnalysisID
--		left join core.lookup l on l.lookupid = am.MaturityScenarioOverrideID
--		where a.AnalysisID = @AnalysisID
--	)Scenario
--where acc1.IsDeleted <> 1
--and n1.noteid = @NoteId

--)




Update cre.transactionEntry set [Date] = @currentmaturity  
From(
	Select TransactionEntryAutoID from cre.transactionEntry where AccountID = @AccountID and AnalysisID = @AnalysisID  and [Date] > @currentmaturity and [Type] <> 'ManagementFee'
)a
where cre.transactionEntry.TransactionEntryAutoID = a.TransactionEntryAutoID


Update cre.transactionEntry set TransactionDateByRule = @currentmaturity
From(
	Select TransactionEntryAutoID from cre.transactionEntry where AccountID = @AccountID and AnalysisID = @AnalysisID  and TransactionDateByRule > @currentmaturity and [Type] <> 'ManagementFee'
)a
where cre.transactionEntry.TransactionEntryAutoID = a.TransactionEntryAutoID




--Update cre.transactionEntry set [Date] = @currentmaturity,TransactionDateByRule = @currentmaturity
--From(
--	Select TransactionEntryAutoID from cre.transactionEntry where noteid = @NoteId and AnalysisID = @AnalysisID  and [Date] > @currentmaturity
--	UNION ALL
--	Select TransactionEntryAutoID from cre.transactionEntry where noteid = @NoteId and AnalysisID = @AnalysisID  and TransactionDateByRule > @currentmaturity
--)a
--where cre.transactionEntry.TransactionEntryAutoID = a.TransactionEntryAutoID



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






END
GO

