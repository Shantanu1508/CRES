


--Select Distinct d.CREDealID,dealname,(CASE WHEN tblPIK.CREDealID is not null THEn 1 Else 0 end) IsPIKDeal,(CASE WHEN tbl_Y_Deal.dealid is not null THEn 'Y' Else 'N' end) UseRuletoDetermineNoteFunding
--,'exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '''+d.CREDealID+''',''B0E6697B-3534-4C09-BE0A-04473401AB93'''
--from cre.Note n
--inner join cre.Deal d on n.DealID = d.DealID
--inner join core.Account acc on acc.accountid = n.account_accountid
--left join core.lookup l on l.lookupid = d.Status
--left JOin(

--Select Distinct credealid from(
--		Select Distinct d.CREDealID,dealname,
--		(CASE WHEN tblPIKNotes.credealid is not null then 1 else 0 end) as IsPIKDeal
--		from cre.Note n
--		inner join cre.Deal d on n.DealID = d.DealID
--		inner join core.Account acc on acc.accountid = n.account_accountid
--		left join core.lookup l on l.lookupid = d.Status
--		LEFT JOIN(
--			Select Distinct dealid,credealid 
--			from(
--				Select n.crenoteid,d.dealid,d.credealid,
--				(Select count(piks.StartDate) from Core.[PIKSchedule] piks
--				inner join core.Event e on e.EventID = piks.EventId
--				inner join core.Account acc on acc.AccountID = e.AccountID
--				where e.EventTypeID = 12 
--				and acc.AccountID = n.account_accountid) PIKScheduleCnt
--				from cre.Note n
--				inner join cre.Deal d on n.DealID = d.DealID
--				inner join core.Account acc on acc.accountid = n.account_accountid
--				where acc.isdeleted <> 1
--			)a
--			where PIKScheduleCnt > 0

--		)tblPIKNotes on tblPIKNotes.dealid = d.dealid
--		where d.isdeleted <> 1 and acc.IsDeleted <> 1 and n.ActualPayoffDate is null
--		and l.name = 'Active'
--	)z where z.IsPIKDeal = 1

--)tblPIK on tblPIK.CREDealID = d.credealid
--Left Join(

--Select Distinct d.dealid
--from cre.Note n
--inner join cre.Deal d on n.DealID = d.DealID
--where UseRuletoDetermineNoteFunding = 3
--)tbl_Y_Deal on tbl_Y_Deal.DealID = d.DealID

--where d.isdeleted <> 1 and acc.IsDeleted <> 1 and n.ActualPayoffDate is null
--and l.name = 'Active'
--and d.dealid not in (Select distinct dealid from [CRE].[DealFunding] where PurposeID = 630) --FullPayOff


go
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '15-0461','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '15-0618','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '16-1024','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '16-1411','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '16-1585','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-0010','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-0044','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-0149','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-0191','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-0255','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-0542','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-0670','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-0727','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-0851','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-0888','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-0916','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-0951','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-1123','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-1439','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-1453','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-1714','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-1810','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-1834','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-0058','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-0262','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-0284','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-0293','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-0296','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-0331','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-0344','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-0345','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-0358','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-0409','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-0414','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-0441','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-0572','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-0578','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-0602','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-0792','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-0866','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-0923','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-0989','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-1043','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-1059','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-1108','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-1109','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-1210','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-1313','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-1387','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-1499','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-1536','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-1739','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-1743','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-1747','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-1770','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-1818','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-1833','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-1854','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-1871','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-1911','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-2011','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-2034','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-2131','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-2132','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-2204','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-2286','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-2385','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-2463','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-2472','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-2538','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-2555','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0033','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0036','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0039','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0172','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0182','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0293','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0349','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0369','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0378','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0422','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0463','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0532','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0583','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0604','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0633','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0747','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0782','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0806','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0835','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0837','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0839','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0869','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0870','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0946','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0988','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-1036','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-1050','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-1056','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-1087','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-1088','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-1131','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-1133','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-1166','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-1182','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-1208','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-1211','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-1259','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-1265','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-1324','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-1336','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-1362','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-1391','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-1429','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-1433','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-1471','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-1478','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-1555','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-1571','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-1596','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-1635','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-1647','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-1655','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-1662','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-1714','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-1827','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-1853','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-1890','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-1980','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-2132','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-2141','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-2171','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-2269','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-2314','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-2361','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-2636','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-2668','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '20-0108','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '20-0188','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '20-0429','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '20-0432','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '20-0512','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '20-0514','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '20-0687','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '20-0748','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '20-0846','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '20-0884','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '20-0921','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '20-0980','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '20-0992','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '20-1044','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '20-1081','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '20-1152','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '20-1167','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '20-1170','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '20-1194','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '20-1255','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '20-1259','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '20-1319','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '20-1357','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '20-1361','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '20-1401','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '20-1525','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '20-1553','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '20-1649','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '20-1672','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '20-1680','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '20-1687','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '20-1700','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '21-0033','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '21-0055','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '21-0089','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '21-0093','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '21-0117','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '21-0122','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '21-0218','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '21-0370','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '21-0381','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '21-0408','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '21-0434','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '21-0526','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '21-0595','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '21-0635','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '21-0724','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '21-0754','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '21-0811','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '21-0891','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '21-0990','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '21-1144','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '21-1163','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '21-1226','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '21-1290','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '21-1318','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '21-1400','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '21-1484','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '21-1529','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '21-1562','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '21-1799','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '21-1812','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '21-2277','B0E6697B-3534-4C09-BE0A-04473401AB93'


go

Update cre.deal set ApplyNoteLevelPaydowns = 1 where dealid in (
	select distinct d.dealid
	from cre.deal d
	left join cre.note n on n.dealid=d.dealid
	where isdeleted<>1 and n.UseRuletoDetermineNoteFunding = 3 and status=323
	and n.actualpayoffdate is null
	and d.credealid in (
	'15-0461','15-0618','16-1024','16-1411','16-1585','17-0010','17-0044','17-0149','17-0191','17-0255','17-0542','17-0670','17-0727','17-0851','17-0888','17-0916','17-0951','17-1123','17-1439','17-1453','17-1714','17-1810','17-1834','18-0058','18-0262','18-0284','18-0293','18-0296','18-0331','18-0344','18-0345','18-0358','18-0409','18-0414','18-0441','18-0572','18-0578','18-0602','18-0792','18-0866','18-0923','18-0989','18-1043','18-1059','18-1108','18-1109','18-1210','18-1313','18-1387','18-1499','18-1536','18-1739','18-1743','18-1747','18-1770','18-1818','18-1833','18-1854','18-1871','18-1911','18-2011','18-2034','18-2131','18-2132','18-2204','18-2286','18-2385','18-2463','18-2472','18-2538','18-2555','19-0033','19-0036','19-0039','19-0172','19-0182','19-0293','19-0349','19-0369','19-0378','19-0422','19-0463','19-0532','19-0583','19-0604','19-0633','19-0747','19-0782','19-0806','19-0835','19-0837','19-0839','19-0869','19-0870','19-0946','19-0988','19-1036','19-1050','19-1056','19-1087','19-1088','19-1131','19-1133','19-1166','19-1182','19-1208','19-1211','19-1259','19-1265','19-1324','19-1336','19-1362','19-1391','19-1429','19-1433','19-1471','19-1478','19-1555','19-1571','19-1596','19-1635','19-1647','19-1655','19-1662','19-1714','19-1827','19-1853','19-1890','19-1980','19-2132','19-2141','19-2171','19-2269','19-2314','19-2361','19-2636','19-2668','20-0108','20-0188','20-0429','20-0432','20-0512','20-0514','20-0687','20-0748','20-0846','20-0884','20-0921','20-0980','20-0992','20-1044','20-1081','20-1152','20-1167','20-1170','20-1194','20-1255','20-1259','20-1319','20-1357','20-1361','20-1401','20-1525','20-1553','20-1649','20-1672','20-1680','20-1687','20-1700','21-0033','21-0055','21-0089','21-0093','21-0117','21-0122','21-0218','21-0370','21-0381','21-0408','21-0434','21-0526','21-0595','21-0635','21-0724','21-0754','21-0811','21-0891','21-0990','21-1144','21-1163','21-1226','21-1290','21-1318','21-1400','21-1484','21-1529','21-1562','21-1799','21-1812','21-2277'

	)
)

go

----Added repayment for PIK deals

INSERT INTO [CRE].[FundingRepaymentSequence]
           ([NoteID]
           ,[SequenceNo]
           ,[SequenceType]
           ,[Value]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate])

Select
n.[NoteID]
,tblSequenceNo.NextSequenceNo + 1 [SequenceNo]
,259 as [SequenceType]
,ISNULL((CASE WHEN tr.SumPikAmount > 0 THEN tr.SumPikAmount ELSE (tr.SumPikAmount * -1) END),0)  as [Value]
,'B0E6697B-3534-4C09-BE0A-04473401AB93' as CreatedBy
,Getdate() as CreatedDate
,'B0E6697B-3534-4C09-BE0A-04473401AB93' as UpdatedBy
,Getdate() as UpdatedDate

from cre.Note n
inner join core.account acc on acc.accountid = n.account_accountid
inner join cre.deal d on d.dealid = n.dealid
Left Join(
	Select noteid,MAX(SequenceNo)  as NextSequenceNo
	from [CRE].[FundingRepaymentSequence] 
	where SequenceType = 259
	group by noteid
)tblSequenceNo on tblSequenceNo.noteid = n.noteid

left join(
	Select tr.noteid,SUM(tr.Amount) as SumPikAmount
	from cre.transactionEntry Tr
	inner join cre.note n on n.noteid=tr.noteid 
	where tr.analysisID =  'C10F3372-0FC2-4861-A9F5-148F1F80804F' and tr.[Type] in ('PikPrincipalPaid','PIKPrincipalFunding')
	--and tr.date <= CAST(getdate() as date)
	group by tr.noteid
)tr on tr.noteid = n.noteid

where acc.IsDeleted <> 1

and d.credealid in (
	'15-0461','15-0618','16-1024','16-1411','16-1585','17-0010','17-0044','17-0149','17-0191','17-0255','17-0542','17-0670','17-0727','17-0851','17-0888','17-0916','17-0951','17-1123','17-1439','17-1453','17-1714','17-1810','17-1834','18-0058','18-0262','18-0284','18-0293','18-0296','18-0331','18-0344','18-0345','18-0358','18-0409','18-0414','18-0441','18-0572','18-0578','18-0602','18-0792','18-0866','18-0923','18-0989','18-1043','18-1059','18-1108','18-1109','18-1210','18-1313','18-1387','18-1499','18-1536','18-1739','18-1743','18-1747','18-1770','18-1818','18-1833','18-1854','18-1871','18-1911','18-2011','18-2034','18-2131','18-2132','18-2204','18-2286','18-2385','18-2463','18-2472','18-2538','18-2555','19-0033','19-0036','19-0039','19-0172','19-0182','19-0293','19-0349','19-0369','19-0378','19-0422','19-0463','19-0532','19-0583','19-0604','19-0633','19-0747','19-0782','19-0806','19-0835','19-0837','19-0839','19-0869','19-0870','19-0946','19-0988','19-1036','19-1050','19-1056','19-1087','19-1088','19-1131','19-1133','19-1166','19-1182','19-1208','19-1211','19-1259','19-1265','19-1324','19-1336','19-1362','19-1391','19-1429','19-1433','19-1471','19-1478','19-1555','19-1571','19-1596','19-1635','19-1647','19-1655','19-1662','19-1714','19-1827','19-1853','19-1890','19-1980','19-2132','19-2141','19-2171','19-2269','19-2314','19-2361','19-2636','19-2668','20-0108','20-0188','20-0429','20-0432','20-0512','20-0514','20-0687','20-0748','20-0846','20-0884','20-0921','20-0980','20-0992','20-1044','20-1081','20-1152','20-1167','20-1170','20-1194','20-1255','20-1259','20-1319','20-1357','20-1361','20-1401','20-1525','20-1553','20-1649','20-1672','20-1680','20-1687','20-1700','21-0033','21-0055','21-0089','21-0093','21-0117','21-0122','21-0218','21-0370','21-0381','21-0408','21-0434','21-0526','21-0595','21-0635','21-0724','21-0754','21-0811','21-0891','21-0990','21-1144','21-1163','21-1226','21-1290','21-1318','21-1400','21-1484','21-1529','21-1562','21-1799','21-1812','21-2277'
)
and d.credealid in (
	--PIK Deals
	Select Distinct credealid from(
		Select Distinct d.CREDealID,dealname,
		(CASE WHEN tblPIKNotes.credealid is not null then 1 else 0 end) as IsPIKDeal
		from cre.Note n
		inner join cre.Deal d on n.DealID = d.DealID
		inner join core.Account acc on acc.accountid = n.account_accountid
		left join core.lookup l on l.lookupid = d.Status
		LEFT JOIN(
			Select Distinct dealid,credealid 
			from(
				Select n.crenoteid,d.dealid,d.credealid,
				(Select count(piks.StartDate) from Core.[PIKSchedule] piks
				inner join core.Event e on e.EventID = piks.EventId
				inner join core.Account acc on acc.AccountID = e.AccountID
				where e.EventTypeID = 12 
				and acc.AccountID = n.account_accountid) PIKScheduleCnt
				from cre.Note n
				inner join cre.Deal d on n.DealID = d.DealID
				inner join core.Account acc on acc.accountid = n.account_accountid
				where acc.isdeleted <> 1
			)a
			where PIKScheduleCnt > 0

		)tblPIKNotes on tblPIKNotes.dealid = d.dealid
		where d.isdeleted <> 1 and acc.IsDeleted <> 1 and n.ActualPayoffDate is null
		and l.name = 'Active'
	)z where z.IsPIKDeal = 1
)




--Compare repayment added as pik bls

--select *,([Value] - current_maxRepayValue) as delta from(


--Select d.dealname,
--n.[NoteID]
--,tblSequenceNo.NextSequenceNo + 1 [SequenceNo]
--,259 as [SequenceType]
--,ISNULL((CASE WHEN tr.SumPikAmount > 0 THEN tr.SumPikAmount ELSE (tr.SumPikAmount * -1) END),0)  as [Value]
--,z.current_maxRepayValue
--,'B0E6697B-3534-4C09-BE0A-04473401AB93' as CreatedBy
--,Getdate() as CreatedDate
--,'B0E6697B-3534-4C09-BE0A-04473401AB93' as UpdatedBy
--,Getdate() as UpdatedDate

--from cre.Note n
--inner join core.account acc on acc.accountid = n.account_accountid
--inner join cre.deal d on d.dealid = n.dealid
--Left Join(
--	Select noteid,MAX(SequenceNo)  as NextSequenceNo
--	from [CRE].[FundingRepaymentSequence] 
--	where SequenceType = 259
--	group by noteid
--)tblSequenceNo on tblSequenceNo.noteid = n.noteid

--left join(
--	Select tr.noteid,SUM(tr.Amount) as SumPikAmount
--	from cre.transactionEntry Tr
--	inner join cre.note n on n.noteid=tr.noteid 
--	where tr.analysisID =  'C10F3372-0FC2-4861-A9F5-148F1F80804F' and tr.[Type] in ('PikPrincipalPaid','PIKPrincipalFunding')
--	--and tr.date <= CAST(getdate() as date)
--	group by tr.noteid
--)tr on tr.noteid = n.noteid
--left join(
--	Select fs.noteid,fs.Value current_maxRepayValue
--	from [CRE].[FundingRepaymentSequence] fs
--	inner join(
--		Select noteid,MAX(SequenceNo)  as MaxSequenceNo
--		from [CRE].[FundingRepaymentSequence] 
--		where SequenceType = 259 
--		group by noteid
--	)tblNoteRepay on tblNoteRepay.NoteID = fs.NoteID and tblNoteRepay.MaxSequenceNo = fs.SequenceNo
--	where SequenceType = 259 
--	--and fs.noteid ='0E03F418-ED3B-4FD1-9314-BD9B359BAC21'
--)z on z.NoteID = n.NoteID

--where acc.IsDeleted <> 1

--and d.credealid in (
-- '21-0117','18-2204','20-0108','21-0861','21-1514','19-1555','21-1163','18-0331','18-1108','19-0369','19-1662','20-0188','17-0916','19-0422','19-1571','19-2269','18-0344','19-1596','20-1361','18-0572','21-1290','19-1853','19-1827','19-0837','21-3025','19-1056','19-1182','18-1536','19-2141','21-1123','18-2034','17-0191','17-0951','20-1687','18-1387','19-1208','21-0122','19-0870','20-1319','18-0358','18-1854','19-0988','15-0461','21-1144','19-1980','21-0635','19-0532','18-1833','21-1219','21-0891','19-2361','21-0033','19-1890','19-0378','18-0414','19-1324','18-1770','19-0172','17-0670','18-1043','18-2538','16-1411','19-0747','20-1357','21-1529','20-0921','21-0381','18-0293','19-2314','17-1453','18-2011','18-2286','21-1812','19-0036','18-2132','16-1585','20-1167','21-1871','19-1478','18-0296','21-2958','20-0514','19-2668','19-0293','18-1499','17-1834','18-2131','20-1680','19-2132','17-1123','18-0262','19-0182','17-0255','19-0349','21-0754','20-1170','21-1562','19-1133','19-0463','21-0526','20-0992','18-2555','21-1226','18-2463','21-0724','15-0618','19-1714','21-0990','20-0687','20-1401','19-1336','18-1739','21-1400','19-1655','19-1471','21-2277','20-1044','19-0039','18-1059','21-0093','21-0218','21-0647','21-0370','18-1818','18-0989','17-0727','21-1817','20-1194','21-1432','20-1672','21-2356','17-1810','20-0429','18-1747','19-1362','19-0782','18-1871','18-1109','19-0869','19-1391','20-0980','18-0866','18-2385','21-0408','19-0604','20-1649','19-0633','18-0923','20-0884','21-1609','18-0578','19-1635','19-1036','19-1166','20-0512','19-0806','19-1131','20-1255','19-1211','18-1743','19-0033','21-0055','20-1525','19-2636','20-0748','21-1799','20-1081','20-1553','21-0434','19-1259','17-0149','21-2566','19-1050','19-1433','19-0583','20-0432','21-1318','19-1429','21-1484','20-0846','17-1714','18-0441','21-0595','20-1152','21-0089','20-1700','21-0811','17-0010','18-0058','19-1088','19-1087','16-1024','19-1647','19-1265','18-1313','15-0365'
--)
--and d.credealid in (
--	--PIK Deals
--	Select Distinct credealid from(
--		Select Distinct d.CREDealID,dealname,
--		(CASE WHEN tblPIKNotes.credealid is not null then 1 else 0 end) as IsPIKDeal
--		from cre.Note n
--		inner join cre.Deal d on n.DealID = d.DealID
--		inner join core.Account acc on acc.accountid = n.account_accountid
--		left join core.lookup l on l.lookupid = d.Status
--		LEFT JOIN(
--			Select Distinct dealid,credealid 
--			from(
--				Select n.crenoteid,d.dealid,d.credealid,
--				(Select count(piks.StartDate) from Core.[PIKSchedule] piks
--				inner join core.Event e on e.EventID = piks.EventId
--				inner join core.Account acc on acc.AccountID = e.AccountID
--				where e.EventTypeID = 12 
--				and acc.AccountID = n.account_accountid) PIKScheduleCnt
--				from cre.Note n
--				inner join cre.Deal d on n.DealID = d.DealID
--				inner join core.Account acc on acc.accountid = n.account_accountid
--				where acc.isdeleted <> 1
--			)a
--			where PIKScheduleCnt > 0

--		)tblPIKNotes on tblPIKNotes.dealid = d.dealid
--		where d.isdeleted <> 1 and acc.IsDeleted <> 1 and n.ActualPayoffDate is null
--		and l.name = 'Active'
--	)z where z.IsPIKDeal = 1
--)



--)y
--where ([Value] - current_maxRepayValue) <> 0