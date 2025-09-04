Select Distinct d.credealid,d.dealname,'exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '''+d.CREDealID+''',''B0E6697B-3534-4C09-BE0A-04473401AB93'''
from cre.Note n
inner join core.account acc on acc.accountid = n.account_accountid
inner join cre.Deal d on n.DealID = d.DealID
where n.ActualPayoffdate is null 
and acc.IsDeleted <> 1 and d.isdeleted <> 1
and d.Status = 323
and d.dealid not in (Select distinct dealid from [CRE].[DealFunding] where PurposeID = 630) --FullPayOff
--and d.EnableAutoSpreadRepayments = 1
order by dealname

--update cre.deal set AutoUpdateFromUnderwriting = 0 



---Enable ApplyNoteLevelPaydowns for active
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




----Get repayment data from backshop for phantom which is not linked
--Update cre.deal set linkeddealid = null where CREDealID = '19-0806IC'
EXEC [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction_ForPhantom] '166ACA82-19E2-4B62-8454-EA2EEB283A7D','B0E6697B-3534-4C09-BE0A-04473401AB93',325
--------------------------


---Enable ApplyNoteLevelPaydowns - Phntom not linked
Update cre.deal set ApplyNoteLevelPaydowns = 1 where dealid in (
	select distinct d.dealid
	from cre.deal d
	left join cre.note n on n.dealid=d.dealid
	where isdeleted<>1 and n.UseRuletoDetermineNoteFunding = 3 and status=325
	and n.actualpayoffdate is null
	and d.credealid in ('17-0255IC')
)