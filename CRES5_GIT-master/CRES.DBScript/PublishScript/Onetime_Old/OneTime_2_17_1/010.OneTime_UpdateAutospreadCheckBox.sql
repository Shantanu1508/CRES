
Print('Set AutoSpreading enabled by default for all active deals.')

Update cre.deal set EnableAutoSpreadRepayments = 1 where dealid in (
	select distinct d.dealid
	from cre.deal d
	left join cre.note n on n.dealid=d.dealid
	where isdeleted <> 1 and status = 323
	and n.actualpayoffdate is null
)

go

Print('For use rule Y deal enable the note level feature by default.')

Update cre.deal set ApplyNoteLevelPaydowns = 1 where dealid in (
	select distinct d.dealid
	from cre.deal d
	left join cre.note n on n.dealid=d.dealid
	where isdeleted<>1 and n.UseRuletoDetermineNoteFunding = 3 and status=323
	and n.actualpayoffdate is null
)


--Print('For use rule Y deal enable the AutoUpdateFromUnderwriting feature by default.')

--Update cre.deal set AutoUpdateFromUnderwriting = 1 where dealid in (
--	select distinct d.dealid
--	from cre.deal d
--	left join cre.note n on n.dealid=d.dealid
--	where isdeleted<>1 and n.UseRuletoDetermineNoteFunding = 3 and status=323
--	and n.actualpayoffdate is null
--)