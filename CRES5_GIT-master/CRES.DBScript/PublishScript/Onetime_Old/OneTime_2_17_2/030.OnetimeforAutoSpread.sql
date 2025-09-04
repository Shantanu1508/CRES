

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

GO


exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '15-0365','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '15-0461','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '15-0618','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '16-0024','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '16-0426','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '16-0868','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '16-1024','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '16-1411','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '16-1585','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-0010','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-0044','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-0149','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-0191','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-0255','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-0349','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-0443','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-0542','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-0670','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-0727','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-0851','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-0888','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-0916','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-0951','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-1036','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-1097','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-1123','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-1439','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-1453','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-1464','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-1643','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-1714','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-1810','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '17-1834','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-0058','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-0099','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-0163','B0E6697B-3534-4C09-BE0A-04473401AB93'
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
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-0564','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-0572','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-0578','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-0581','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-0602','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-0615','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-0695','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-0792','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-0841','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-0866','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-0911','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-0923','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-0989','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-1043','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-1059','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '18-1064','B0E6697B-3534-4C09-BE0A-04473401AB93'
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
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0012','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0033','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0036','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0039','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0090','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0172','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0182','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0293','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0349','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0369','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0378','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0400','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0413','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0422','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0463','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0532','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-0582','B0E6697B-3534-4C09-BE0A-04473401AB93'
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
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-1172','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-1182','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-1208','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-1211','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-1259','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-1265','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-1293','B0E6697B-3534-4C09-BE0A-04473401AB93'
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
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-2208','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '19-2243','B0E6697B-3534-4C09-BE0A-04473401AB93'
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
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '20-1009','B0E6697B-3534-4C09-BE0A-04473401AB93'
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
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '20-1553','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '20-1589','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '20-1649','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '20-1672','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '20-1680','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '21-0033','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '21-0055','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '21-0089','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '21-0117','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '21-0122','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '21-0408','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '21-0595','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '21-0724','B0E6697B-3534-4C09-BE0A-04473401AB93'
exec [dbo].[usp_UpdateAutoRepayDataFromBackshopProduction] '21-1163','B0E6697B-3534-4C09-BE0A-04473401AB93'


go



Update cre.deal set ApplyNoteLevelPaydowns = 1 where dealid in (
	select distinct d.dealid
	from cre.deal d
	left join cre.note n on n.dealid=d.dealid
	where isdeleted<>1 and n.UseRuletoDetermineNoteFunding = 3 and status=323
	and n.actualpayoffdate is null
)

go

--OLD
--Select credealid,dealname,LinkedDealID ,'exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '''+LinkedDealID+''''
--from cre.deal where Status = 325 and  NULLIF(LinkedDealID,'') is not null

----New

--Select Distinct credealid,dealname,LinkedDealID ,'exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '''+LinkedDealID+''''
--from cre.deal d
--inner join cre.note n on n.dealid = d.dealid
--inner join core.Account acc on acc.accountid = n.account_accountid
--where Status = 325 
--and d.isdeleted <> 1 
--and acc.isdeleted <> 1 
--and n.ActualPayoffDate is null
--and  NULLIF(LinkedDealID,'') is not null
--order by dealname

Go


--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '18-1739'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '16-0504'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '19-2314'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '16-1585'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '18-0431'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '16-1408'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '16-0006'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '18-0432'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '17-1287'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '16-0587'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '17-1867'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '16-1162'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '15-0349'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '15-0183'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '16-1249'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '19-0604'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '19-1571'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '18-0293'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '16-0024'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '17-1036'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '16-0051'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '17-0242'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '15-0192'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '16-1081'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '18-0099'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '17-0648'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '16-0426'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '17-0107'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '17-1810'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '16-1294'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '16-0804'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '18-1499'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '16-0196'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '18-0911'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '19-0958'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '18-2204'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '16-1024'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '15-0468'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '18-0107'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '16-0144'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '18-0331'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '17-1242'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '16-0582'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '15-0006'
--exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '18-0415'

exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '18-2204'
exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '18-0331'
exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '19-1571'
exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '18-0293'
exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '19-2314'
exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '16-1585'
exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '18-1499'
exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '18-0911'
exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '18-1739'
exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '17-1810'
exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '17-1036'
exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '19-0604'
exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '16-0024'
exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '16-0426'
exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '18-0099'
exec [dbo].[usp_CopyAutoSpreadDataFromLegalToPhantom] '16-1024'


go

---Remove the Latest Possible repayment date and Earliest possible repayment date and re – run

Update CRE.Deal SET EarliestPossibleRepaymentDate = null,LatestPossibleRepaymentDate = null


go

--For Deal with Full Payoff populate the Expected maturity date with Full Payoff date 

Update cre.note set cre.note.ExpectedMaturityDate = a.[FullPayOffDate]
From(
	
	Select n1.dealid,n1.noteid,fullpayoffdeal.date  as [FullPayOffDate]
	from cre.note n1
	inner join cre.deal d1 on d1.dealid = n1.dealid
	Inner join(
		Select Distinct d.dealid,credealid,dealname ,l.name as Purpose,df.date --,n.noteid,n.crenoteid,ExpectedMaturityDate
		from cre.dealfunding df
		inner join cre.Deal d on d.dealid = df.dealid
		inner join cre.note n on n.dealid = d.dealid
		inner join core.Account acc on acc.accountid = n.account_accountid
		left join core.lookup l on l.lookupid = df.Purposeid and ParentID = 50
		where 
		d.isdeleted <> 1 
		and acc.isdeleted <> 1 
		and n.ActualPayoffDate is null
		and Purposeid = 630

	)fullpayoffdeal on fullpayoffdeal.dealid = d1.dealid
	
)a
where cre.note.noteid = a.noteid