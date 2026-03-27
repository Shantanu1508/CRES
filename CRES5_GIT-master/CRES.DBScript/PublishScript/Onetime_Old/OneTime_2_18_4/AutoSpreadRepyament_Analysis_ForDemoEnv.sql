
----=====For Legal=====
Select Distinct d.credealid,d.dealname,'exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '''+d.CREDealID+''',''B0E6697B-3534-4C09-BE0A-04473401AB93'''
from cre.Note n
inner join core.account acc on acc.accountid = n.account_accountid
inner join cre.Deal d on n.DealID = d.DealID
where n.ActualPayoffdate is null 
and acc.IsDeleted <> 1 and d.isdeleted <> 1
and d.Status = 323
and d.dealid not in (Select distinct dealid from [CRE].[DealFunding] where PurposeID = 630) --FullPayOff
order by dealname


---Enable ApplyNoteLevelPaydowns
Update cre.deal set ApplyNoteLevelPaydowns = 1 where dealid in (
	select distinct d.dealid
	from cre.deal d
	left join cre.note n on n.dealid=d.dealid
	where isdeleted<>1 and n.UseRuletoDetermineNoteFunding = 3 and status=323
	and n.actualpayoffdate is null
	and d.credealid in (
		Select Distinct d.credealid
		from cre.Note n
		inner join core.account acc on acc.accountid = n.account_accountid
		inner join cre.Deal d on n.DealID = d.DealID
		where n.ActualPayoffdate is null 
		and acc.IsDeleted <> 1 and d.isdeleted <> 1
		and d.Status = 323
		and d.dealid not in (Select distinct dealid from [CRE].[DealFunding] where PurposeID = 630) --FullPayOff		
	)
)


----=====For Phantom=====
Select Distinct d.credealid,d.dealname,d.linkeddealid,'exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '''+d.linkeddealid+''' '
from cre.Note n
inner join core.account acc on acc.accountid = n.account_accountid
inner join cre.Deal d on n.DealID = d.DealID
where n.ActualPayoffdate is null 
and acc.IsDeleted <> 1 and d.isdeleted <> 1
and d.Status = 325
and d.dealid not in (Select distinct dealid from [CRE].[DealFunding] where PurposeID = 630) --FullPayOff
and NULLIF(d.LinkedDealID,'') is not null
order by dealname


---Enable ApplyNoteLevelPaydowns
Update cre.deal set ApplyNoteLevelPaydowns = 1 where dealid in (
	select distinct d.dealid
	from cre.deal d
	left join cre.note n on n.dealid=d.dealid
	where isdeleted<>1 and n.UseRuletoDetermineNoteFunding = 3 and status=325
	and n.actualpayoffdate is null
	and d.credealid in (
		Select Distinct d.credealid
		from cre.Note n
		inner join core.account acc on acc.accountid = n.account_accountid
		inner join cre.Deal d on n.DealID = d.DealID
		where n.ActualPayoffdate is null 
		and acc.IsDeleted <> 1 and d.isdeleted <> 1
		and d.Status = 325
		and d.dealid not in (Select distinct dealid from [CRE].[DealFunding] where PurposeID = 630) --FullPayOff		
	)
)


----=====For Phantom with no linked=====
Select Distinct d.credealid,d.dealname,d.linkeddealid,'[dbo].[usp_UpdateAutoRepayDataFromBackshopProduction_ForPhantom] '''+CAST(d.DealID as nvarchar(256))+''',''B0E6697B-3534-4C09-BE0A-04473401AB93'',325'
from cre.Note n
inner join core.account acc on acc.accountid = n.account_accountid
inner join cre.Deal d on n.DealID = d.DealID
where n.ActualPayoffdate is null 
and acc.IsDeleted <> 1 and d.isdeleted <> 1
and d.Status = 325
and d.dealid not in (Select distinct dealid from [CRE].[DealFunding] where PurposeID = 630) --FullPayOff
and NULLIF(d.LinkedDealID,'') is null
order by dealname





