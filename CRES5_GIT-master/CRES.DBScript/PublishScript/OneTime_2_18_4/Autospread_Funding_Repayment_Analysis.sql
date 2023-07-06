--Enable Funding
Update cre.deal set enableautospread = 1 where dealid in (
	Select Distinct d.dealid
	from cre.Note n
	inner join core.account acc on acc.accountid = n.account_accountid
	inner join cre.Deal d on n.DealID = d.DealID
	inner join [CRE].[DealFunding] df on d.dealid = df.dealid
	left join(
		Select d.dealid,isnull(SUM(n.TotalCommitment),0) TotalCommitment,isnull(SUM(InitialFundingAmount),0) InitialFundingAmount  
		from cre.note n
		inner join core.Account acc on acc.accountid = n.Account_AccountID
		inner join cre.deal d on d.dealid = n.DealID
		where acc.IsDeleted <> 1 and n.ActualPayoffDate is null
		group by d.dealid
	)a on a.DealID = d.DealID
	where acc.IsDeleted <> 1 and d.isdeleted <> 1
	and n.ActualPayoffdate is null
	and UseRuletoDetermineNoteFunding = 3	
	and d.Status = 323	
	and d.dealid not in (Select dealid from cre.deal where enableautospread = 1)
	--and df.PurposeID in (Select lookupid from core.lookup where parentid = 50 and Value = 'Positive')
	--and d.dealid not in (Select distinct dealid from [CRE].[DealFunding] where PurposeID = 630) --FullPayOff
	and a.TotalCommitment <> a.InitialFundingAmount
)

----=========================
----Enable autospread Repayment
Select Distinct d.credealid,d.dealname,'exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '''+d.CREDealID+''',''B0E6697B-3534-4C09-BE0A-04473401AB93'''
from cre.Note n
inner join core.account acc on acc.accountid = n.account_accountid
inner join cre.Deal d on n.DealID = d.DealID
where n.ActualPayoffdate is null 
and acc.IsDeleted <> 1 and d.isdeleted <> 1
and d.Status = 323
and d.dealid not in (Select distinct dealid from [CRE].[DealFunding] where PurposeID = 630) --FullPayOff
order by dealname


go

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



go
----Get repayment data from backshop for phantom which is not linked
Update cre.deal set linkeddealid = null where CREDealID = '19-0806IC'

EXEC [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction_ForPhantom] '166ACA82-19E2-4B62-8454-EA2EEB283A7D','B0E6697B-3534-4C09-BE0A-04473401AB93',325
EXEC [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction_ForPhantom] '141F0BCB-7CE1-4C02-B60F-36415582D076','B0E6697B-3534-4C09-BE0A-04473401AB93',325
EXEC [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction_ForPhantom] '81572FF9-442D-4D16-AAF4-05046E3A4151','B0E6697B-3534-4C09-BE0A-04473401AB93',325

Update cre.deal set linkeddealid = '19-0806I' where CREDealID = '19-0806IC'


---Enable ApplyNoteLevelPaydowns - Phntom not linked
Update cre.deal set ApplyNoteLevelPaydowns = 1 where dealid in (
	select distinct d.dealid
	from cre.deal d
	left join cre.note n on n.dealid=d.dealid
	where isdeleted<>1 and n.UseRuletoDetermineNoteFunding = 3 and status=325
	and n.actualpayoffdate is null
	and d.credealid in ('17-0255IC','19-1362IC','19-0806IC')
)

go




