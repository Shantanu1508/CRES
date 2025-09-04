CREATE PROCEDURE [dbo].[usp_CalculateLiabilityNoteBalanceAsofCalcDate]  --'08064F3A-DE16-4009-AA93-7C665766EEAB'  
 @EquityAccountID nvarchar(256)   
AS  
BEGIN  

Declare @tblAssetNoteList as Table(
	AssetAccountID UNIQUEIDENTIFIER
)

INSERT INTO @tblAssetNoteList(AssetAccountID)
Select ln.AssetAccountID
from cre.LiabilityNote ln  
Inner Join core.Account acc on acc.AccountID = ln.AccountID  
Where acc.IsDeleted <> 1  
and ln.LiabilityTypeID  = @EquityAccountID ----(Select acc.accountid from cre.Equity eq Inner Join core.Account acc on acc.AccountID = eq.AccountID where acc.name = 'ACP II')
---=============================================================

Declare @tblGeneralSetupDetailsLiabilityNote as Table(
LiabilityNoteAccountId	UNIQUEIDENTIFIER,
LiabilityNoteid	nvarchar(256),
EffectiveDate	 date,
PledgeDate	date,
TargetAdvanceRate decimal(28,15),	
PaydownAdvanceRate	decimal(28,15),	
FundingAdvanceRate	decimal(28,15),	
MaturityDate date
)

Insert into @tblGeneralSetupDetailsLiabilityNote(LiabilityNoteAccountId,LiabilityNoteid,EffectiveDate,PledgeDate,TargetAdvanceRate,PaydownAdvanceRate,FundingAdvanceRate,MaturityDate)
Select ln.accountid as LiabilityNoteAccountId
,ln.LiabilityNoteid
,e.EffectiveStartDate as EffectiveDate
,e.EffectiveStartDate as PledgeDate
,gslia.TargetAdvanceRate
,gslia.PaydownAdvanceRate
,gslia.FundingAdvanceRate
,gslia.MaturityDate
from [CORE].GeneralSetupDetailsLiabilityNote gslia
INNER JOIN [CORE].[Event] e on e.EventID = gslia.EventId
INNER JOIN 
(						
	Select eve.AccountID,MAX(EffectiveStartDate) EffectiveStartDate,EventTypeID ,eve.StatusID
	from [CORE].[Event] eve	
	INNER JOIN [CORE].[Account] acc ON acc.AccountID = eve.AccountID
	where EventTypeID = (Select LookupID from CORE.[Lookup] where Name = 'GeneralSetupDetailsLiabilityNote')
	and acc.IsDeleted <> 1
	and eve.StatusID = 1
	GROUP BY eve.AccountID,EventTypeID,eve.StatusID

) sEvent
ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
inner Join cre.LiabilityNote ln on ln.accountid = acc.accountid
Left Join CORE.Account acca on acca.AccountID = ln.AssetAccountID
left join cre.note n on n.account_accountid = acca.accountid
Left Join cre.FinancingSourceMaster fs on fs.FinancingSourceMasterID = n.FinancingSourceID
where e.StatusID = 1 and acc.IsDeleted <> 1
and ISNULL(fs.IsThirdParty,0) <> 1
and ln.AssetAccountID in (Select AssetAccountID from @tblAssetNoteList)
---=======================================================================

declare @tblff as table(
	NoteId UNIQUEIDENTIFIER,
	LatestEffectiveDate Date,
	[Date] date,
	[Value] decimal(28,15)
)

INSERT INTO @tblff (NoteId,LatestEffectiveDate,[Date],[Value])
select n.noteid,e.effectivestartdate,fs.date,fs.value
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
	GROUP BY n.Account_AccountID,EventTypeID,eve.StatusID
) sEvent
ON sEvent.AccountID = e.AccountID and e.EffectiveStartDate = sEvent.EffectiveStartDate  and e.EventTypeID = sEvent.EventTypeID
INNER JOIN [CORE].[Account] acc ON acc.AccountID = e.AccountID
INNER JOIN [CRE].[Note] n ON n.Account_AccountID = acc.AccountID
where sEvent.StatusID = e.StatusID  and acc.IsDeleted = 0
and fs.applied = 1
--and n.Account_Accountid in (Select AssetAccountID from @tblAssetNoteList)


---=============================================================
Update cre.LiabilityNote SET cre.LiabilityNote.TempBalanceAsofCalcDate = z.BalanceAsofCalcDate
From(

Select LiabilityNoteAccountId
,LastLockedTransactionDate
,sum(FF_Amount) as Sum_FF_Amount
,TargetAdvanceRate
,(ISNULL(sum(FF_Amount),0) * TargetAdvanceRate) as BalanceAsofCalcDate
from(
	Select   
	ln.accountid as LiabilityNoteAccountId
	--,ln.LiabilityNoteID + '_' +cast(LiabilityNoteAssetMappingID as nvarchar(256)) as LiabilityNoteID  
	--,tblLibtype.Text as LiabilityID 
	,n.noteid
	,n.crenoteID as AssetID
	,'01/10/2024' as LastLockedTransactionDate
	,ISNULL(ff.FF_Amount,0) as FF_Amount
	,gs.TargetAdvanceRate
	from cre.LiabilityNote ln  
	Inner Join (
		Select lm.LiabilityNoteAssetMappingID,lm.DealAccountID,lm.LiabilityNoteAccountId,lm.AssetAccountID 
		from cre.LiabilityNoteAssetMapping lm
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
		Select acc.AccountID as AccountID,acc.name as [Text] ,'Debt' as [Type]
		from cre.Debt d 
		Inner Join core.Account acc on acc.AccountID =  d.AccountID where IsDeleted<> 1
		UNION ALL
		Select acc.AccountID as AccountID,acc.name as [Text] ,'Equity' as [Type]
		from cre.Equity d 
		Inner Join core.Account acc on acc.AccountID =  d.AccountID where IsDeleted<> 1
	)tblLibtype on tblLibtype.AccountID = ln.LiabilityTypeID  
	Left Join CORE.Account acca on acca.AccountID = ln.AssetAccountID
	left join cre.note n on n.account_accountid = lnam.AssetAccountId
	Left Join cre.FinancingSourceMaster fs on fs.FinancingSourceMasterID = n.FinancingSourceID

	OUTER APPLY(
		Select NoteId,sum([Value]) as FF_Amount from @tblff fs
		where fs.noteid = n.noteid
		and [Date] <= '01/10/2024'
		group by NoteId
	)ff
	Left Join @tblGeneralSetupDetailsLiabilityNote gs on gs.LiabilityNoteAccountId = ln.accountid 

	Where acc.IsDeleted <> 1  
	and ISNULL(fs.IsThirdParty,0) <> 1
	and ln.AssetAccountID in (Select AssetAccountID from @tblAssetNoteList)
)a
group by LiabilityNoteAccountId
,LastLockedTransactionDate
,TargetAdvanceRate

)z
where z.LiabilityNoteAccountId = cre.LiabilityNote.AccountID



end