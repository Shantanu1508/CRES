-- Procedure
---[dbo].[usp_GetCalcJsonByFundName] 'ACORE Credit Partners II','c10f3372-0fc2-4861-a9f5-148f1f80804f'
---[dbo].[usp_GetCalcJsonByFundName] 'ACORE Opportunistic Credit I','c10f3372-0fc2-4861-a9f5-148f1f80804f'
---[dbo].[usp_GetCalcJsonByFundName] 'ACORE Opportunistic Credit II','c10f3372-0fc2-4861-a9f5-148f1f80804f'

CREATE PROCEDURE [dbo].[usp_GetCalcJsonByFundName]   
(  	
	@FundIdOrName NVARCHAR(256),  
	@AnalysisID UNIQUEIDENTIFIER 	
)   
  
AS  
BEGIN  
 SET NOCOUNT ON; 



SET @AnalysisID = (Select top 1 AnalysisID from cre.LiabilityCashflowConfig)  

Declare @gCalcAsOfDate date --= (Select top 1 isnull(CalcAsOfDate,'01/24/2024') from [CRE].[LiabilityCashflowConfig])
Declare @getdate date = (Select Cast(getdate() as date));
Declare @AnalysisName nvarchar(256) = (Select name from core.analysis where AnalysisID = @AnalysisID)



declare @fundAccountID uniqueidentifier;	
 
IF((SELECT 1 WHERE @FundIdOrName LIKE REPLACE('00000000-0000-0000-0000-000000000000', '0', '[0-9a-fA-F]')) = 1)  
BEGIN   
	SET @fundAccountID = @FundIdOrName  
END  
ELSE  
BEGIN  
	SET @fundAccountID = (Select acc.accountid from cre.Equity eq Inner Join core.Account acc on acc.AccountID = eq.AccountID where acc.name = @FundIdOrName)  
END 


----------------------------------------------
Declare @tblliabilityNoteAccountID as table(
	liabilityNoteAccountID UNIQUEIDENTIFIER
)

INSERT INTO @tblliabilityNoteAccountID(liabilityNoteAccountID)

SELECT Distinct ln.AccountID
FROM cre.liabilitynote ln
INNER JOIN cre.liabilitynoteassetmapping la ON ln.AccountID = la.LiabilityNoteAccountId
INNER JOIN (
    SELECT am.AssetAccountId AS assetnotesid
    FROM cre.liabilitynote l
    INNER JOIN cre.liabilitynoteassetmapping am ON l.AccountID = am.LiabilityNoteAccountId
    WHERE l.LiabilityTypeID = @fundAccountID
) sub ON la.AssetAccountId = sub.assetnotesid
LEFT JOIN core.Account a on ln.LiabilityTypeID = a.AccountID
where a.IsDeleted <> 1
----------------------------------------------

Declare @tbl_all_liabilityType_OfFund as table(
	liabilityTypeID UNIQUEIDENTIFIER,
	liabilityTypeName nvarchar(256)
)

INSERT INTO @tbl_all_liabilityType_OfFund(liabilityTypeID,liabilityTypeName)
SELECT distinct(ln.LiabilityTypeID) as liabilityTypeID, a.Name as liabilityTypeName 
FROM cre.liabilitynote ln
INNER JOIN cre.liabilitynoteassetmapping la ON ln.AccountID = la.LiabilityNoteAccountId
INNER JOIN (
	SELECT am.AssetAccountId AS assetnotesid
	FROM cre.liabilitynote l
	INNER JOIN cre.liabilitynoteassetmapping am ON l.AccountID = am.LiabilityNoteAccountId
	WHERE l.LiabilityTypeID = @fundAccountID
) sub ON la.AssetAccountId = sub.assetnotesid
LEFT JOIN core.Account a on ln.LiabilityTypeID = a.AccountID
--where  ln.LiabilityTypeID in (Select AccountID from cre.Debt)
-------------------------------------------------


SET @gCalcAsOfDate = ISNULL((Select Dateadd(day,1,MAX(TransactionDate)) 
from CRE.LiabilityFundingScheduleAggregate 
where Applied = 1 and AccountID in (
	Select distinct ln.LiabilitytypeID
	from cre.LiabilityNote ln  
	Inner Join core.Account acc on acc.AccountID = ln.AccountID  
	Where acc.IsDeleted <> 1  
	and ln.AssetAccountID  in (
		Select ln.AssetAccountID
		from cre.LiabilityNote ln  
		Inner Join core.Account acc on acc.AccountID = ln.AccountID  
		Where acc.IsDeleted <> 1  
		and ln.LiabilityTypeID  = @fundAccountID	
	)
	and ln.LiabilitytypeID not in (Select accountid from cre.cash)
	and ln.Accountid in (Select liabilityNoteAccountID from @tblliabilityNoteAccountID)
)
),getdate())



----=============================
---EXEC [dbo].[usp_CalculateLiabilityNoteBalanceAsofCalcDate] @fundAccountID
----==============================


----======================================
IF OBJECT_ID('tempdb..#tblLiabilityNoteAssetMapping') IS NOT NULL         
	DROP TABLE #tblLiabilityNoteAssetMapping

CREATE TABLE #tblLiabilityNoteAssetMapping(  
	LiabilityNoteAssetMappingID INT,
   DealAccountId UNIQUEIDENTIFIER,
   LiabilityNoteAccountId UNIQUEIDENTIFIER,
   AssetAccountId UNIQUEIDENTIFIER,
   CreatedBy NVARCHAR(256),
   CreatedDate DATE,
   UpdatedBy NVARCHAR(256),
   UpdatedDate   DATE         
 ) 


INSERT INTO #tblLiabilityNoteAssetMapping(LiabilityNoteAssetMappingID,DealAccountId,LiabilityNoteAccountId,AssetAccountId,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate)
SELECT LiabilityNoteAssetMappingID,DealAccountId,LiabilityNoteAccountId,AssetAccountId,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate
FROM(
	SELECT LiabilityNoteAssetMappingID,DealAccountId,LiabilityNoteAccountId,AssetAccountId,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate
	FROM cre.LiabilityNoteAssetMapping
	Where LiabilityNoteAccountId in (Select liabilityNoteAccountID from @tblliabilityNoteAccountID)

	UNION ALL

	SELECT 
	1 AS LiabilityNoteAssetMappingID
	,ln.DealAccountID as DealAccountId	
	,ln.AccountID as LiabilityNoteAccountId	
	,n.Account_AccountID as AssetAccountId
	,ln.CreatedBy
	,ln.CreatedDate
	,ln.UpdatedBy
	,ln.UpdatedDate
	from cre.LiabilityNote ln  
	Inner Join core.Account accln on accln.AccountID = ln.AssetAccountID
	Left Join cre.LiabilityNoteAssetMapping lnam on lnam.LiabilityNoteAccountId = ln.AccountID	
	inner join cre.Deal d on d.AccountID = ln.DealAccountID
	inner Join cre.Note n on n.DealID = d.DealID
	Where accln.AccountTypeID = 10
	and LiabilityNoteAssetMappingid is null
	and ln.AccountId in (Select liabilityNoteAccountID from @tblliabilityNoteAccountID)
)A
---=======================================


Declare @tblDealWiseCalcAsOfDate as Table (DealID UNIQUEIDENTIFIER,DealAccountID UNIQUEIDENTIFIER,CalcAsOfDate Date)

INSERT INTO @tblDealWiseCalcAsOfDate(DealID,DealAccountID,CalcAsOfDate)
select d.dealid,d.accountid,ISNULL(df.date,CAST(getdate() as Date)) as [Date]
from cre.deal d 
left JOin (
	Select dealid,MAX(date) as [date] 
	from cre.DealFunding 
	Where (applied = 1 or comment is not null) 
	group by dealid
) df on d.dealid = df.dealid
Where d.IsDeleted <> 1


--Declare @g_CalcAsOfDate date = (Select MAX(CalcAsOfDate) from @tblDealWiseCalcAsOfDate)


Declare @tblFundNotes as Table (NoteID UNIQUEIDENTIFIER,CRENoteID nvarchar(256),LiabilityAccountID UNIQUEIDENTIFIER,LiabilityNoteID nvarchar(256))

INSERT INTO @tblFundNotes(NoteID,CRENoteID,LiabilityAccountID,LiabilityNoteID)
Select NoteID,CRENoteID,LiabilityAccountID,LiabilityNoteID
From(
	--AssetID as Deal
	SELECT n.noteid,n.crenoteid,ln.AccountID as LiabilityAccountID,LiabilityNoteID
	from cre.LiabilityNote ln  
	Inner Join core.Account accln on accln.AccountID = ln.AssetAccountID
	inner Join #tblLiabilityNoteAssetMapping lnam on lnam.LiabilityNoteAccountId = ln.AccountID
	Inner Join core.Account acc on acc.AccountID = lnam.AssetAccountId
	inner Join cre.Note n on n.account_accountid = acc.AccountID
	inner join cre.Deal d on d.dealid = n.dealid
	Where acc.IsDeleted <> 1  
	and accln.AccountTypeID = 10
	and ln.LiabilityTypeID  = @fundAccountID

	UNION ALL

	--AssetID as Note
	SELECT n.noteid,n.crenoteid,ln.AccountID as LiabilityAccountID,LiabilityNoteID
	from cre.LiabilityNote ln  
	Inner Join core.Account accln on accln.AccountID = ln.AssetAccountID
	Inner Join core.Account acc on acc.AccountID = ln.AssetAccountId
	inner Join cre.Note n on n.account_accountid = acc.AccountID
	inner join cre.Deal d on d.dealid = n.dealid
	Where accln.IsDeleted <> 1   and acc.IsDeleted <> 1  
	and accln.AccountTypeID = 1
	and ln.LiabilityTypeID  = @fundAccountID
)z


Declare @tblAssetNoteList as Table(
	AssetAccountID UNIQUEIDENTIFIER
)

INSERT INTO @tblAssetNoteList(AssetAccountID)
Select ln.AssetAccountID
from cre.LiabilityNote ln  
Inner Join core.Account acc on acc.AccountID = ln.AccountID  
Where acc.IsDeleted <> 1  
and ln.LiabilityTypeID  = @fundAccountID
and ln.AccountId in (Select liabilityNoteAccountID from @tblliabilityNoteAccountID)

--============================================
Declare @tbldebtAssociateWithEquity as Table(
	LiabilityTypeID UNIQUEIDENTIFIER
)

INSERT INTO @tbldebtAssociateWithEquity(LiabilityTypeID)
Select distinct ln.LiabilitytypeID
from cre.LiabilityNote ln  
Inner Join core.Account acc on acc.AccountID = ln.AccountID  
Where acc.IsDeleted <> 1  
and ln.AssetAccountID  in (select AssetAccountID from @tblAssetNoteList)
and ln.AccountId in (Select liabilityNoteAccountID from @tblliabilityNoteAccountID)


INSERT INTO @tbldebtAssociateWithEquity(LiabilityTypeID)
Select distinct ln.AccountID
from cre.Debt ln  
Inner Join core.Account acc on acc.AccountID = ln.AccountID  
left join core.AccountCategory ac on ac.AccountCategoryID = acc.AccountTypeID
Where acc.IsDeleted <> 1  
and ln.AccountID  not in (select LiabilityTypeID from @tbldebtAssociateWithEquity)
and ac.Name= 'Cash'
--============================================

----================================
--declare @tblAddTran as table(
--AccountID uniqueidentifier,
--[Date] date,
--EndingBalance decimal(28,15)
--)

--insert into @tblAddTran(AccountID,[Date],EndingBalance )
--select distinct AccountID,[Date],EndingBalance 
--from [CRE].[AdditionalTransactionEntry] 
--where AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'

Declare @tblLiabilityBalance as table(
LiabilityAccountID uniQueiDENtiFIER,
LiabilityTypeName nvarchar(256),
EndingBalance decimal(28,15)
)

INSERT INTO @tblLiabilityBalance(LiabilityAccountID,LiabilityTypeName,EndingBalance)
Select LiabilityAccountID,LiabilityTypeName,EndingBalance
From(
	Select 
	tblLibtype.AccountID as LiabilityAccountID
	,tblLibtype.[Text] as LiabilityTypeName
	,lfs.TransactionDate
	,lfs.TransactionAmount
	,lfs.EndingBalance
	,ROW_NUMBER() Over (Partition by lfs.accountid order by lfs.accountid ,lfs.TransactionDate desc) as rno
	from CRE.LiabilityFundingScheduleAggregate lfs
	Left Join(
		Select acc.AccountID as AccountID,acc.name as [Text] ,'Debt' as [Type]
		from cre.Debt d 
		Inner Join core.Account acc on acc.AccountID =  d.AccountID 
		where IsDeleted<> 1
		and d.accountid in (Select liabilitytypeid from @tbl_all_liabilityType_OfFund)
	

		UNION ALL
		
		Select acc.AccountID as AccountID,acc.name as [Text] ,'Equity' as [Type]
		from cre.Equity d 
		Inner Join core.Account acc on acc.AccountID =  d.AccountID 
		where IsDeleted<> 1
		and d.accountid = @fundAccountID
 
	)tblLibtype on tblLibtype.AccountID = lfs.AccountID

	where TransactionDate <= @gCalcAsOfDate
)a
where rno = 1

UNION ALL
---Cash accoiunt
Select LiabilityAccountID,LiabilityTypeName,EndingBalance
From(
	Select tr.Accountid as LiabilityAccountID,acc.name as LiabilityTypeName ,tr.Date,tr.Amount as endingbalance ,
	ROW_NUMBER() Over(Partition By tr.Accountid Order by tr.Accountid,Date desc) rno
	from CRE.Transactionentry tr
	Inner join cre.cash ch on ch.accountid = tr.accountid
	Inner join core.account acc on acc.accountid = ch.accountid
	Where tr.accountid in (Select liabilitytypeid from @tbl_all_liabilityType_OfFund)
)a Where rno = 1

-----===============================================================


--Declare @tblNoteWiseBls as Table (DealID UNIQUEIDENTIFIER,Noteid UNIQUEIDENTIFIER,PeriodEndDate Date,EndingBalance decimal(28,15))
--INSERT INTO @tblNoteWiseBls(DealID,noteid,PeriodEndDate,EndingBalance)
--Select n.dealid,n.noteid,nc.PeriodEndDate,nc.EndingBalance		  
--from cre.NotePeriodicCalc nc
--Inner join core.account acc on acc.accountid = nc.AccountID
--Inner join cre.note n on n.account_accountid = acc.accountid
--where acc.isdeleted <> 1  and acc.AccounttypeID = 1
--and nc.Analysisid = @AnalysisID
--and nc.EndingBalance is not null
--and n.noteid in (Select noteid from @tblFundNotes)
----=========================================================


DECLARE @tTableAlias as table  
(  
	ID int identity(1,1),  
	[Name] NVARCHAR(100)
) 

--============================================
Declare @AnalysisID_Default UNIQUEIDENTIFIER;
Declare @AnalysisName_Default nvarchar(256);

Select @AnalysisID_Default = AnalysisID
,@AnalysisName_Default = name 
from core.analysis where AnalysisID = 'C10F3372-0FC2-4861-A9F5-148F1F80804F'
--============================================

--Select @AnalysisName as Scenario,@AnalysisID as AnalysisID,@gCalcAsOfDate as  CalcAsOfDate
Select @AnalysisName_Default as Scenario,@AnalysisID_Default as AnalysisID,@gCalcAsOfDate as  CalcAsOfDate
Insert into @tTableAlias([Name]) values('root') 


Select 
acc.accountid as EquityAccountID
,acc.Name  as EquityName
,ac.name as EquityType
,acc.BaseCurrencyID as Currency
,ln.[InvestorCapital] as InvestorCapital
,ln.[CapitalReserveRequirement] as CapitalReserveReq
,ln.[ReserveRequirement] as ReserveReq
,ln.CapitalCallNoticeBusinessDays as CapitalCallNoticeBusinessDays
,ln.[InceptionDate] as InceptionDate
,ln.[LastDatetoInvest] as LastDatetoInvest
,ln.[LinkedShortTermBorrowingFacility] as LinkedShortTermBorrowingFacility
,bls.EndingBalance as BalanceAsofCalcDate  ---'376028413.46'
,@gCalcAsOfDate as LastLockedTransactionDate

,FundDelay	
,FundingDay
,ln.PortfolioAccountid as PortfolioAccountID
,cash_acc.name as PortfolioAccountName
,Cashbls.EndingBalance as PortfolioBalanceAsofCalcDate
from cre.Equity ln
Inner Join core.Account acc on acc.AccountID = ln.AccountID
Left Join core.lookup lStatus on lstatus.lookupid = acc.StatusID
Left Join core.lookup lcurr on lcurr.lookupid = acc.BaseCurrencyID
Left Join Core.AccountCategory ac on ac.AccountCategoryID = acc.AccountTypeID
Left JOIN(
	Select LiabilityAccountID,LiabilityTypeName,EndingBalance from @tblLiabilityBalance
)bls on bls.LiabilityAccountID = ln.AccountID
Left Join core.account cash_acc on cash_acc.accountid = ln.PortfolioAccountid

Left JOIN(
	Select LiabilityAccountID,LiabilityTypeName,EndingBalance from @tblLiabilityBalance
)Cashbls on Cashbls.LiabilityAccountID = ln.PortfolioAccountid

where acc.IsDeleted <> 1 
and acc.accountid = @fundAccountID

Insert into @tTableAlias([Name]) values('root.Fund') 



Select 
acc.accountid as EquityAccountID
,gsetupEq.EffectiveStartDate as EffectiveDate
,gsetupEq.Commitment as Commitment
,gsetupEq.InitialMaturityDate as InitialMaturityDate
from cre.Equity ln
Inner Join core.Account acc on acc.AccountID = ln.AccountID
Left Join core.lookup lStatus on lstatus.lookupid = acc.StatusID
Left Join core.lookup lcurr on lcurr.lookupid = acc.BaseCurrencyID
Left Join Core.AccountCategory ac on ac.AccountCategoryID = acc.AccountTypeID
left Join (
	Select acc.AccountID,e.EffectiveStartDate,Commitment,InitialMaturityDate
	from [CORE].GeneralSetupDetailsEquity gslia
	INNER JOIN [CORE].[Event] e on e.EventID = gslia.EventId
	INNER JOIN 
	(						
		Select eve.AccountID,MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
		from [CORE].[Event] eve	
		INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
		where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'GeneralSetupDetailsEquity')
		and acc.IsDeleted <> 1
		and eve.StatusID = 1
		GROUP BY eve.AccountID,EventTypeID,eve.StatusID

	) sEvent
	ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	where e.StatusID = 1 and acc.IsDeleted <> 1
)gsetupEq on gsetupEq.AccountID = ln.AccountID
Where acc.IsDeleted <> 1
and acc.accountid = @fundAccountID

Insert into @tTableAlias([Name]) values('root.Fund.FundUpdates')

---============================

IF OBJECT_ID('tempdb..#tblnoteCommitment') IS NOT NULL         
	DROP TABLE #tblnoteCommitment

CREATE TABLE #tblnoteCommitment(	
	NoteID UNIQUEIDENTIFIER,
	CRENoteID NVARCHAR(256),
	NoteAdjustedTotalCommitment decimal(28,15),
	NoteTotalCommitment   decimal(28,15),
) 

 INSERT INTO #tblnoteCommitment(NoteID,CRENoteID,NoteAdjustedTotalCommitment,NoteTotalCommitment)
 Select NoteID,CRENoteID,NoteAdjustedTotalCommitment,NoteTotalCommitment    
	From(       
		SELECT d.CREDealID    
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
		and d.[status] = 323  
		and date <= @getdate
		and n.noteid in (Select noteid from @tblFundNotes)
	)a    
	where rno =  1  


IF OBJECT_ID('tempdb..#tblnoteBalance') IS NOT NULL         
	DROP TABLE #tblnoteBalance

CREATE TABLE #tblnoteBalance(	
	NoteID UNIQUEIDENTIFIER,
	EndingBalance decimal(28,15)
)

INSERT INTO #tblnoteBalance(noteid,EndingBalance)
Select noteid,ISNULL(EndingBalance,0) as EndingBalance from(  
	Select n.noteid,nc.PeriodEndDate,nc.EndingBalance
	,ROW_NUMBER() Over(Partition by nc.Accountid order by nc.Accountid,PeriodEndDate desc) rno     
	from cre.NotePeriodicCalc nc
	Inner join core.account acc on acc.accountid = nc.AccountID
	Inner join cre.note n on n.account_accountid = acc.accountid
	where acc.isdeleted <> 1  and acc.AccounttypeID = 1
	and nc.Analysisid = @AnalysisID
	--and nc.EndingBalance is not null
	and nc.periodenddate <= @gCalcAsOfDate
	and n.noteid in (Select noteid from @tblFundNotes)
)a where rno = 1 
---============================

Select 
n.account_accountid as AssetAccountID
,n.crenoteid as CreNoteID
,n.ClosingDate as ClosingDate
,tblNtAdjusted.NoteAdjustedTotalCommitment as AdjCommitment
--,tblbls.EndingBalance as BalanceAsofCalcDate
--,@getdate as LastLockedTransactionDate

,ISNULL(tblbls.EndingBalance,n.InitialFundingAmount) as BalanceAsofCalcDate
,@gCalcAsOfDate as LastLockedTransactionDate   ---cd.CalcAsOfDate 

,fs.FinancingSourceName
,fs.ParentClient
,(CASE WHEN fs.ParentClient = 'ACP II' THEN 1 ELSE 0 END) as Owned

From cre.Note n 
Inner Join core.Account acc on acc.AccountID = n.Account_AccountID
left join cre.FinancingSourceMaster fs on fs.FinancingSourceMasterID = n.FinancingSourceID
Left Join #tblnoteCommitment tblNtAdjusted on tblNtAdjusted.NoteID = n.NoteID 
Left Join #tblnoteBalance tblbls on tblbls.NoteID = n.NoteID 
where acc.IsDeleted <> 1
and n.noteid in (Select noteid from @tblFundNotes)
order by n.crenoteid
Insert into @tTableAlias([Name]) values('root.AssetNotes')


Select tr.TransactionEntryID,n.account_accountid as AssetAccountID,n.crenoteid,tr.Date,tr.Amount,tr.[Type]
from cre.TransactionEntry tr
inner join core.account acc on acc.accountid = tr.AccountID
inner join cre.note n on n.Account_AccountID = acc.AccountID
Where tr.[Type] in ('InitialFunding','FundingOrRepayment','Balloon','ScheduledPrincipalPaid','PIKPrincipalFunding','PIKPrincipalPaid','NetPropertyIncomeOrLoss')
and acc.isdeleted<>1
and tr.Analysisid = @AnalysisID
and n.noteid in (Select noteid from @tblFundNotes)
order by tr.date
Insert into @tTableAlias([Name]) values('root.AssetNotes.Transactions')



Select   
ln.accountid as LiabilityNoteAccountId
--,ln.LiabilityNoteID + '_' +cast(LiabilityNoteAssetMappingID as nvarchar(256)) as LiabilityNoteID  
,ln.LiabilityNoteID + '_' +cast(n.crenoteID as nvarchar(256)) as LiabilityNoteID
,tblLibtype.Text as LiabilityID 
,n.crenoteID as AssetID
--,ln.TempBalanceAsofCalcDate as BalanceAsofCalcDate
,ISNULL(tblBalance.EndingBalance,0) as BalanceAsofCalcDate
,@gCalcAsOfDate  as LastLockedTransactionDate
--,fs.FinancingSourceName
,tblLibtype.[Type]
from cre.LiabilityNote ln  
Inner Join (
	Select lm.LiabilityNoteAssetMappingID,lm.DealAccountID,lm.LiabilityNoteAccountId,lm.AssetAccountID 
	from #tblLiabilityNoteAssetMapping lm
	Inner Join cre.LiabilityNote ln1 on ln1.AccountID = lm.LiabilityNoteAccountId
	Inner Join core.Account acc on acc.AccountID = ln1.AccountID
	Where acc.IsDeleted <> 1 
	and ln1.AssetAccountID in (Select AssetAccountID from @tblAssetNoteList)

	UNION ALL

	Select 1 as LiabilityNoteAssetMappingID,ln.DealAccountID,ln.AccountID as liabilitynoteaccountid,ln.AssetAccountID
	from cre.LiabilityNote ln
	Inner Join core.Account accln on accln.AccountID = ln.AssetAccountID
	Where accln.IsDeleted <> 1  
	and accln.AccountTypeID = 1
	and ln.AssetAccountID in (Select AssetAccountID from @tblAssetNoteList)

)lnam on lnam.LiabilityNoteAccountId = ln.AccountID

Inner Join core.Account acc on acc.AccountID = ln.AccountID  
Left Join core.lookup lStatus on lstatus.lookupid = acc.StatusID  
Left Join(  
	Select acc.AccountID as AccountID,acc.name as [Text] ,ac.name as [Type]
	from cre.Debt d 
	Inner Join core.Account acc on acc.AccountID =  d.AccountID 
	Left Join core.accountCategory ac on ac.accountCategoryID = acc.accountTypeId
	where IsDeleted<> 1
	and d.accountid in (Select liabilitytypeid from @tbl_all_liabilityType_OfFund)

	UNION ALL

	Select acc.AccountID as AccountID,acc.name as [Text] ,ac.name as [Type]
	from cre.Equity d 
	Inner Join core.Account acc on acc.AccountID =  d.AccountID 
	Left Join core.accountCategory ac on ac.accountCategoryID = acc.accountTypeId
	where IsDeleted<> 1
	and d.accountid = @fundAccountID

	UNION ALL

	Select acc.AccountID as AccountID,acc.name as [Text] ,ac.name as [Type]
	from cre.CASH ch 
	Inner Join core.Account acc on acc.AccountID =  ch.AccountID 
	Left Join core.accountCategory ac on ac.accountCategoryID = acc.accountTypeId
	where IsDeleted<> 1
	and ch.accountid in (Select liabilitytypeid from @tbl_all_liabilityType_OfFund)

)tblLibtype on tblLibtype.AccountID = ln.LiabilityTypeID  
Left Join CORE.Account acca on acca.AccountID = ln.AssetAccountID
left join cre.note n on n.account_accountid = lnam.AssetAccountId
Left Join cre.FinancingSourceMaster fs on fs.FinancingSourceMasterID = n.FinancingSourceID
LEFT JOIN(
	Select LiabilityNoteAccountID,AssetAccountID,SUM(rOUND(TransactionAmount,2)) as EndingBalance 
	from(
		Select lfs.LiabilityNoteAccountID 
		,ln.LiabilityNoteID
		,lfs.TransactionDate,lfs.TransactionAmount,lfs.AssetAccountID
		from CRE.LiabilityFundingSchedule lfs
		inner Join cre.LiabilityNote ln on ln.Accountid = lfs.LiabilityNoteAccountID
		where TransactionDate <= @gCalcAsOfDate
	)a
	group by LiabilityNoteAccountID,AssetAccountID
)tblBalance on tblBalance.LiabilityNoteAccountID = ln.AccountID and tblBalance.AssetAccountID = lnam.AssetAccountID


Where acc.IsDeleted <> 1  
--and ISNULL(fs.IsThirdParty,0) <> 1
--and ln.LiabilityTypeID  = @fundAccountID
and ln.AssetAccountID in (Select AssetAccountID from @tblAssetNoteList)
and ln.Accountid in (Select liabilityNoteAccountID from @tblliabilityNoteAccountID) 
and ln.LiabilityNoteID is not null
order by ln.LiabilityNoteID

Insert into @tTableAlias([Name]) values('root.LiabilityNotes')



Select ln.accountid as LiabilityNoteAccountId,ln.LiabilityNoteid
,e.EffectiveStartDate as EffectiveDate
--,e.EffectiveStartDate as PledgeDate
,gslia.PledgeDate as PledgeDate
,gslia.TargetAdvanceRate
,gslia.PaydownAdvanceRate
,gslia.FundingAdvanceRate
,gslia.MaturityDate
from [CORE].GeneralSetupDetailsLiabilityNote gslia
INNER JOIN [CORE].[Event] e on e.EventID = gslia.EventId
--INNER JOIN 
--(						
--	Select eve.AccountID,MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
--	from [CORE].[Event] eve	
--	INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
--	where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'GeneralSetupDetailsLiabilityNote')
--	and acc.IsDeleted <> 1
--	and eve.StatusID = 1
--	GROUP BY eve.AccountID,EventTypeID,eve.StatusID

--) sEvent
--ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
inner Join cre.LiabilityNote ln on ln.accountid = acc.accountid

Left Join CORE.Account acca on acca.AccountID = ln.AssetAccountID
left join cre.note n on n.account_accountid = acca.accountid

Left Join cre.FinancingSourceMaster fs on fs.FinancingSourceMasterID = n.FinancingSourceID
where e.StatusID = 1 and acc.IsDeleted <> 1
and ISNULL(fs.IsThirdParty,0) <> 1
--and ln.LiabilityTypeID  = @fundAccountID
and ln.AssetAccountID in (Select AssetAccountID from @tblAssetNoteList)
and ln.Accountid in (Select liabilityNoteAccountID from @tblliabilityNoteAccountID) 

Insert into @tTableAlias([Name]) values('root.LiabilityNotes.LiabilityNoteUpdates')








select
dt.AccountID as DebtAccountID
,acc.Name as LiabilityID
,ac.name as [Type]
,lMatchTerm.name as MatchTerm
,lIsRevolving.name as IsRevolving
,lcurr.name as Currency
,dt.FundingNoticeBD as FundingNoticeBusinessDays
,dt.InitialFundingDelay
,dt.MaxAdvanceRate
,dt.OriginationDate
,dt.PaydownDelay
,bls.EndingBalance as BalanceAsofCalcDate
,@gCalcAsOfDate as LastLockedTransactionDate
,FundDelay	
,FundingDay
,dt.PortfolioAccountid as PortfolioAccountID
,cash_acc.name as PortfolioAccountName
,Cashbls.EndingBalance as PortfolioBalanceAsofCalcDate
from cre.Debt dt
inner Join core.account acc on acc.accountid = dt.accountid
Inner Join core.accountCategory ac on ac.accountCategoryID = acc.accountTypeId
Left Join core.lookup lMatchTerm on lMatchTerm.lookupid = dt.MatchTerm
Left Join core.lookup lIsRevolving on lIsRevolving.lookupid = dt.IsRevolving
Left Join core.lookup lcurr on lcurr.lookupid = acc.BaseCurrencyID
Left JOIN(
	Select LiabilityAccountID,LiabilityTypeName,EndingBalance from @tblLiabilityBalance
)bls on bls.LiabilityAccountID = dt.AccountID

Left Join core.account cash_acc on cash_acc.accountid = dt.PortfolioAccountid
Left JOIN(
	Select LiabilityAccountID,LiabilityTypeName,EndingBalance from @tblLiabilityBalance
)Cashbls on Cashbls.LiabilityAccountID = dt.PortfolioAccountid

Where acc.isdeleted <> 1
--and dt.AccountID in (select distinct LiabilitytypeID from @tbldebtAssociateWithEquity)
and dt.accountid in (Select liabilitytypeid from @tbl_all_liabilityType_OfFund)

Insert into @tTableAlias([Name]) values('root.LiabilityLines')


Select 
ln.AccountID as DebtAccountID
,gsetupEq.EffectiveStartDate as EffectiveDate
,gsetupEq.Commitment as Commitment
,gsetupEq.InitialMaturityDate as InitialMaturityDate
from cre.Debt ln
Inner Join core.Account acc on acc.AccountID = ln.AccountID
Left Join core.lookup lStatus on lstatus.lookupid = acc.StatusID
Left Join core.lookup lcurr on lcurr.lookupid = acc.BaseCurrencyID
Left Join Core.AccountCategory ac on ac.AccountCategoryID = acc.AccountTypeID
left Join (
	Select acc.AccountID,e.EffectiveStartDate,Commitment,InitialMaturityDate
	from [CORE].GeneralSetupDetailsDebt gslia
	INNER JOIN [CORE].[Event] e on e.EventID = gslia.EventId
	--INNER JOIN 
	--(						
	--	Select eve.AccountID,MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
	--	from [CORE].[Event] eve	
	--	INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
	--	where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'GeneralSetupDetailsDebt')
	--	and acc.IsDeleted <> 1
	--	and eve.StatusID = 1
	--	GROUP BY eve.AccountID,EventTypeID,eve.StatusID

	--) sEvent
	--ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
	where e.StatusID = 1 and acc.IsDeleted <> 1
)gsetupEq on gsetupEq.AccountID = ln.AccountID
Where acc.IsDeleted <> 1
--and ln.AccountID in (select distinct LiabilitytypeID from @tbldebtAssociateWithEquity)
and ln.accountid in (Select liabilitytypeid from @tbl_all_liabilityType_OfFund)

Insert into @tTableAlias([Name]) values('root.LiabilityLines.LiabilityLineUpdates')


---=======================


select
dt.AccountID as DebtAccountID
,acc.Name as LiabilityID
,ac.name as [Type]
,lMatchTerm.name as MatchTerm
,lIsRevolving.name as IsRevolving
,lcurr.name as Currency
,dt.FundingNoticeBD as FundingNoticeBusinessDays
,dt.InitialFundingDelay
,dt.MaxAdvanceRate
,dt.OriginationDate
,dt.PaydownDelay
,bls.EndingBalance as BalanceAsofCalcDate
,@gCalcAsOfDate as LastLockedTransactionDate
from cre.Debt dt
inner Join core.account acc on acc.accountid = dt.accountid
Inner Join core.accountCategory ac on ac.accountCategoryID = acc.accountTypeId
Left Join core.lookup lMatchTerm on lMatchTerm.lookupid = dt.MatchTerm
Left Join core.lookup lIsRevolving on lIsRevolving.lookupid = dt.IsRevolving
Left Join core.lookup lcurr on lcurr.lookupid = acc.BaseCurrencyID
Left JOIN(
	Select LiabilityAccountID,LiabilityTypeName,EndingBalance from @tblLiabilityBalance
)bls on bls.LiabilityAccountID = dt.AccountID
Where acc.isdeleted <> 1
and dt.AccountID in (SELECT LinkedShortTermBorrowingFacility FROM [CRE].[Equity] Where AccountID=@fundAccountID)

Insert into @tTableAlias([Name]) values('root.SubLines')


Select 
ln.AccountID as DebtAccountID
,gsetupEq.EffectiveStartDate as EffectiveDate
,gsetupEq.Commitment as Commitment
,gsetupEq.InitialMaturityDate as InitialMaturityDate
from cre.Debt ln
Inner Join core.Account acc on acc.AccountID = ln.AccountID
Left Join core.lookup lStatus on lstatus.lookupid = acc.StatusID
Left Join core.lookup lcurr on lcurr.lookupid = acc.BaseCurrencyID
Left Join Core.AccountCategory ac on ac.AccountCategoryID = acc.AccountTypeID
left Join (
	Select acc.AccountID,e.EffectiveStartDate,Commitment,InitialMaturityDate
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
)gsetupEq on gsetupEq.AccountID = ln.AccountID
Where acc.IsDeleted <> 1
and ln.AccountID in (SELECT LinkedShortTermBorrowingFacility FROM [CRE].[Equity] Where AccountID=@fundAccountID)


Insert into @tTableAlias([Name]) values('root.SubLines.LiabilityLineUpdates')




Select Distinct lf.LiabilityNoteAccountID,ln.LiabilityNoteID + '_' +n.CRENoteID as LiabilityNoteID,n.CRENoteID as AssetID,lf.AssetAccountID,lf.TransactionDate,lf.TransactionTypes,lf.TransactionAmount,lf.OriginalAmount,(ISNULL(lf.TransactionAmount,0) - ISNULL(lf.OriginalAmount,0)) as Delta
,tblLibtype.[Type]
from cre.LiabilityFundingSchedule lf
inner join cre.LiabilityNote ln on ln.AccountID = lf.LiabilityNoteAccountID
Inner join cre.note n on n.Account_AccountID = lf.AssetAccountID
Left Join(  
	Select acc.AccountID as AccountID,acc.name as [Text] ,ac.name as [Type]
	from cre.Debt d 
	Inner Join core.Account acc on acc.AccountID =  d.AccountID 
	Left Join core.accountCategory ac on ac.accountCategoryID = acc.accountTypeId
	where IsDeleted<> 1
	

	UNION ALL

	Select acc.AccountID as AccountID,acc.name as [Text] ,ac.name as [Type]
	from cre.Equity d 
	Inner Join core.Account acc on acc.AccountID =  d.AccountID 
	Left Join core.accountCategory ac on ac.accountCategoryID = acc.accountTypeId
	where IsDeleted<> 1
	and d.accountid = @fundAccountID

	UNION ALL

	Select acc.AccountID as AccountID,acc.name as [Text] ,ac.name as [Type]
	from cre.CASH ch 
	Inner Join core.Account acc on acc.AccountID =  ch.AccountID 
	Left Join core.accountCategory ac on ac.accountCategoryID = acc.accountTypeId
	where IsDeleted<> 1
	

)tblLibtype on tblLibtype.AccountID = ln.LiabilityTypeID 
where Applied <> 1 --and lf.Comments is not null
and [Status] = 943
and ln.Accountid in (Select liabilityNoteAccountID from @tblliabilityNoteAccountID) 
Insert into @tTableAlias([Name]) values('root.LiabilityNoteTransactionOverride')


Select Distinct 
lf.AccountID as LiabilityAccountID
,tblLibtype.Text as LiabilityID
,tblLibtype.Type
,tblLibtype.PortfolioAccountID
,tblLibtype.PortfolioAccountName
,lf.TransactionDate
,lf.TransactionTypes
,lf.TransactionAmount
,lf.OriginalAmount
,(ISNULL(lf.TransactionAmount,0) - ISNULL(lf.OriginalAmount,0)) as Delta

from cre.LiabilityFundingScheduleAggregate lf
Left Join(  
	Select acc.AccountID as AccountID,acc.name as [Text] ,ac.name as [Type],d.PortfolioAccountID,acPort.name as PortfolioAccountName
	from cre.Debt d 
	Inner Join core.Account acc on acc.AccountID =  d.AccountID 
	Left Join core.accountCategory ac on ac.accountCategoryID = acc.accountTypeId
	Left Join core.account acPort on acPort.accountid = d.PortfolioAccountID
	where acc.IsDeleted<> 1
	

	UNION ALL

	Select acc.AccountID as AccountID,acc.name as [Text] ,ac.name as [Type],d.PortfolioAccountID,acPort.name as PortfolioAccountName
	from cre.Equity d 
	Inner Join core.Account acc on acc.AccountID =  d.AccountID 
	Left Join core.accountCategory ac on ac.accountCategoryID = acc.accountTypeId
	Left Join core.account acPort on acPort.accountid = d.PortfolioAccountID
	where acc.IsDeleted<> 1
	and d.accountid = @fundAccountID

)tblLibtype on tblLibtype.AccountID = lf.AccountID
where Applied <> 1 --and lf.Comments is not null
and [Status] = 943
and lf.Accountid in (Select liabilitytypeid from @tbl_all_liabilityType_OfFund) 
Insert into @tTableAlias([Name]) values('root.LiabilityTransactionOverride')



select OperationMode
,EqDelayMonths
,FinDelayMonths
,MinEqBalForFinStart
,SublineEqApplyMonths
,SublineFinApplyMonths
,RebalanceMethod
From  [CRE].[LiabilityCashflowConfig]
Insert into @tTableAlias([Name]) values('root.CashflowConfig')

select * from(
--Select 1 as [col]
--union all
--Select 5 as [col]
select DebtCallDaysOfTheMonth as [col] From  [CRE].[LiabilityCashflowConfig]

)a
Insert into @tTableAlias([Name]) values('root.CashflowConfig.DebtCallDaysOfTheMonth')


select * from(
	---Select 1 as [col]
	select CapitalCallDaysOfTheMonth as [col] From  [CRE].[LiabilityCashflowConfig]
)a
Insert into @tTableAlias([Name]) values('root.CashflowConfig.CapitalCallDaysOfTheMonth')




Select   jm.JournalEntryMasterID as ManualEntryID,
tem.AccountId,   
tblLibtype.Text as AccountName,
tem.Date as TransactionDate,   
tem.Type as TransactionType,   
tem.Amount as TransactionAmount,   
tem.Comment as Comments
 
FROM  
[Cre].[JournalEntryMaster] as jm  
Inner Join Cre.TransactionEntryManual tem ON jm.JournalEntryMasterID = tem.JournalEntryMasterId 
inner join App.[User] u on jm.UpdatedBy = u.UserID
Left Join(
	Select acc.AccountID as AccountID,acc.name as [Text] ,'Debt' as [Type]
	from cre.Debt d 
	Inner Join core.Account acc on acc.AccountID =  d.AccountID 
	where IsDeleted<> 1
	and d.accountid in (Select liabilitytypeid from @tbl_all_liabilityType_OfFund)


	UNION ALL
	Select acc.AccountID as AccountID,acc.name as [Text] ,'Equity' as [Type]
	from cre.Equity d 
	Inner Join core.Account acc on acc.AccountID =  d.AccountID 
	where IsDeleted<> 1
	and d.accountid =@fundAccountID

	UNION ALL
	Select acc.AccountID as AccountID,acc.name as [Text] ,'Cash' as [Type]
	from cre.Cash d 
	Inner Join core.Account acc on acc.AccountID =  d.AccountID 
	where IsDeleted<> 1
	and d.accountid in (Select liabilitytypeid from @tbl_all_liabilityType_OfFund)

)tblLibtype on tblLibtype.AccountID = tem.accountid

Insert into @tTableAlias([Name]) values('root.ManualEntry')



Select * from @tTableAlias


END
GO

