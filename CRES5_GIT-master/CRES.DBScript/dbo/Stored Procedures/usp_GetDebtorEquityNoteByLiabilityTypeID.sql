CREATE PROCEDURE [dbo].[usp_GetDebtorEquityNoteByLiabilityTypeID]  --'05a96b38-8b22-47b2-aa06-6c84f63c9c67'  
 @LiabilityTypeID nvarchar(256)   
AS  
BEGIN  

IF OBJECT_ID('tempdb..#tblliabilityNoteAccountID') IS NOT NULL         
	DROP TABLE #tblliabilityNoteAccountID
 
 
CREATE table #tblliabilityNoteAccountID(
	liabilityNoteAccountID UNIQUEIDENTIFIER,
	LiabilityNoteID nvarchar(256),
	liabilityTypeID UNIQUEIDENTIFIER,
	LibFlag nvarchar(256),
	LiabilityTypeName nvarchar(256),
	AssetAccountID UNIQUEIDENTIFIER,
	LiabilityNoteAssetMappingGuid  UNIQUEIDENTIFIER,

)
 
INSERT INTO #tblliabilityNoteAccountID(liabilityNoteAccountID,LiabilityNoteID,liabilityTypeID,LibFlag,LiabilityTypeName,AssetAccountID,LiabilityNoteAssetMappingGuid)
 
SELECT Distinct ln.AccountID,ln.LiabilityNoteID,ln.LiabilityTypeID,tblLibtype.LibFlag,tblLibtype.[LiabilityTypeName],la.AssetAccountId,tblLibtype.LiabilityNoteAssetMappingGuid
FROM cre.liabilitynote ln
INNER JOIN cre.liabilitynoteassetmapping la ON ln.AccountID = la.LiabilityNoteAccountId
INNER JOIN (
    SELECT am.AssetAccountId AS assetnotesid
    FROM cre.liabilitynote l
    INNER JOIN cre.liabilitynoteassetmapping am ON l.AccountID = am.LiabilityNoteAccountId
    WHERE l.LiabilityTypeID = @LiabilityTypeID
) sub ON la.AssetAccountId = sub.assetnotesid
LEFT JOIN core.Account a on ln.LiabilityTypeID = a.AccountID
 
Left Join(  
	Select acc.AccountID as AccountID,acc.name as [LiabilityTypeName] ,'Debt' as LibFlag,ac.name as [Type],DebtGUID as LiabilityNoteAssetMappingGuid
	from cre.Debt d 
	Inner Join core.Account acc on acc.AccountID =  d.AccountID 
	Left Join core.accountCategory ac on ac.accountCategoryID = acc.accountTypeId
	where IsDeleted<> 1
	UNION ALL
 
	Select acc.AccountID as AccountID,acc.name as [LiabilityTypeName] ,'Equity' as LibFlag,ac.name as [Type], EquityGUID as LiabilityNoteAssetMappingGuid
	from cre.Equity d 
	Inner Join core.Account acc on acc.AccountID =  d.AccountID 
	Left Join core.accountCategory ac on ac.accountCategoryID = acc.accountTypeId
	where IsDeleted<> 1
	UNION ALL
 
	Select acc.AccountID as AccountID,acc.name as [LiabilityTypeName] ,'Cash' as LibFlag,ac.name as [Type], CashGUID as LiabilityNoteAssetMappingGuid
	from cre.CASH ch 
	Inner Join core.Account acc on acc.AccountID =  ch.AccountID 
	Left Join core.accountCategory ac on ac.accountCategoryID = acc.accountTypeId
	where IsDeleted<> 1

 
)tblLibtype on tblLibtype.AccountID = ln.LiabilityTypeID  
where a.IsDeleted <> 1
and tblLibtype.LibFlag in ('debt','equity')
and tblLibtype.[Type] <> 'Subline'

----=======================================================

Declare @LibTypFlag nvarchar(256);
IF(@LiabilityTypeID in (Select AccountID from cre.equity))
BEGIN
	SET @LibTypFlag = 'Debt';
END
Else IF(@LiabilityTypeID in (Select AccountID from cre.debt))
BEGIN
	SET @LibTypFlag = 'Equity';
END

Select Distinct 
 ln.AccountID  
,ln.DealAccountID  
,d.DealID
,ln.LiabilityNoteID  
,ln.LiabilityNoteAutoID
,ln.LiabilityNoteGUID
,acc.Name as LiabilityNoteName  
,acc.StatusID as [Status]  
,lStatus.name as StatusText  
,ln.LiabilityTypeID  
,tblLibtype.Text as LiabilityTypeText  

,ln.AssetAccountID  
,acca.AssetName as AssetName


,gsetupLia.EffectiveStartDate as PledgeDate
,gsetupLia.MaturityDate
,gsetupLia.PaydownAdvanceRate
,gsetupLia.FundingAdvanceRate
,gsetupLia.TargetAdvanceRate

,ln.CurrentAdvanceRate as CurrentAdvanceRate
--,ln.TargetAdvanceRate as TargetAdvanceRate
,ln.CurrentBalance as CurrentBalance
,ln.UndrawnCapacity as UndrawnCapacity

,ln.[CreatedBy]  
,ln.[CreatedDate]  
,ln.[UpdatedBy]  
,ln.[UpdatedDate]  
,tbldebteqname.AssociatedLiabilityTypeText
,tbldebteqname.LiabilityNoteAssetMappingGuid
from cre.LiabilityNote ln  
Inner Join core.Account acc on acc.AccountID = ln.AccountID  
Inner Join cre.deal d on d.AccountID = ln.DealAccountID
Left Join core.lookup lStatus on lstatus.lookupid = acc.StatusID  
Left Join(  
 Select acc.AccountID as AccountID,acc.name as [Text] from cre.Debt d Inner Join core.Account acc on acc.AccountID =  d.AccountID where IsDeleted<> 1  
 UNION ALL  
 Select acc.AccountID as AccountID,acc.name as [Text] from cre.Equity d Inner Join core.Account acc on acc.AccountID =  d.AccountID where IsDeleted<> 1  
)tblLibtype on tblLibtype.AccountID = ln.LiabilityTypeID 

left join cre.[LiabilityNoteAssetMapping] lnam on lnam.[LiabilityNoteAccountId] = ln.accountid
left join(
	Select AssetAccountID,LibFlag,LiabilityTypeName as AssociatedLiabilityTypeText	,LiabilityNoteAssetMappingGuid
	from #tblliabilityNoteAccountID where LibFlag = @LibTypFlag
)tbldebteqname on tbldebteqname.AssetAccountID = lnam.AssetAccountId

Left Join(
	Select AssetAccountID,AssetName
	From(
		SELECT d.DealName as AssetName,acc.AccountID as AssetAccountID
		FROM CRE.Deal AS d
		INNER JOIN Core.Account AS acc ON acc.AccountID = d.AccountID
		WHERE acc.IsDeleted <> 1 --and acc.AccountID = @DealAccountID

		UNION ALL

		SELECT n.CRENoteID as AssetName,acc.AccountID as AssetAccountID
		FROM CRE.Note AS n
		INNER JOIN Core.Account AS acc ON acc.AccountID = n.Account_AccountID
		WHERE acc.IsDeleted <> 1
		--and n.DealID = (Select dealid from cre.deal where AccountID= @DealAccountID)
	)z
)acca on acca.AssetAccountID = ln.AssetAccountID  

left Join (
	Select acc.AccountID,e.EffectiveStartDate,PaydownAdvanceRate,FundingAdvanceRate,TargetAdvanceRate,MaturityDate
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
	where e.StatusID = 1 and acc.IsDeleted <> 1
)gsetupLia on gsetupLia.AccountID = ln.AccountID

Where acc.IsDeleted <> 1  
and LiabilityTypeID = @LiabilityTypeID

END