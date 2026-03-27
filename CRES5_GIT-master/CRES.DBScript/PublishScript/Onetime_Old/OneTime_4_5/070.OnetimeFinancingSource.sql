----alter table cre.FinancingSourceMaster add [FinancingSourceName_old]     NVARCHAR (256) NULL
------for revert
-----update cre.FinancingSourceMaster set FinancingSourceName = [FinancingSourceName_old] 



--update cre.FinancingSourceMaster set [FinancingSourceName_old] = FinancingSourceName

--go


--update cre.FinancingSourceMaster set FinancingSourceName = 'ACP I' where FinancingSourceMasterID = 	2
--update cre.FinancingSourceMaster set FinancingSourceName = 'ACP I - Axos NoN' where FinancingSourceMasterID = 	67
--update cre.FinancingSourceMaster set FinancingSourceName = 'ACP I - Axos O/S NoN' where FinancingSourceMasterID = 	68
--update cre.FinancingSourceMaster set FinancingSourceName = 'ACP I - DB Repo' where FinancingSourceMasterID = 	30
--update cre.FinancingSourceMaster set FinancingSourceName = 'ACP I - DB O/S Repo' where FinancingSourceMasterID = 	33
--update cre.FinancingSourceMaster set FinancingSourceName = 'ACP I - GS 2018' where FinancingSourceMasterID = 	3
--update cre.FinancingSourceMaster set FinancingSourceName = 'ACP I - GS 2018 Offshore' where FinancingSourceMasterID = 	34
--update cre.FinancingSourceMaster set FinancingSourceName = 'ACP I - MS Repo' where FinancingSourceMasterID = 	4
--update cre.FinancingSourceMaster set FinancingSourceName = 'ACP I - MS O/S Repo' where FinancingSourceMasterID = 	35
--update cre.FinancingSourceMaster set FinancingSourceName = 'ACP I - Offshore' where FinancingSourceMasterID = 	5
--update cre.FinancingSourceMaster set FinancingSourceName = 'ACP I - WF Repo' where FinancingSourceMasterID = 	31
--update cre.FinancingSourceMaster set FinancingSourceName = 'ACP I - WF O/S Repo' where FinancingSourceMasterID = 	36
--update cre.FinancingSourceMaster set FinancingSourceName = 'ACP I - Sunwest NoN' where FinancingSourceMasterID = 	72
--update cre.FinancingSourceMaster set FinancingSourceName = 'ACP I - Prime Mort' where FinancingSourceMasterID = 	73
--update cre.FinancingSourceMaster set FinancingSourceName = 'ACP I - O/S Prime Mort' where FinancingSourceMasterID = 	74
--update cre.FinancingSourceMaster set FinancingSourceName = 'AOC I' where FinancingSourceMasterID = 	38
--update cre.FinancingSourceMaster set FinancingSourceName = 'AOC I - Axos NoN' where FinancingSourceMasterID = 	64
--update cre.FinancingSourceMaster set FinancingSourceName = 'AOC I - Churchill Repo' where FinancingSourceMasterID = 	69
--update cre.FinancingSourceMaster set FinancingSourceName = 'AOC I - Customers NoN' where FinancingSourceMasterID = 	71
--update cre.FinancingSourceMaster set FinancingSourceName = 'ACP II' where FinancingSourceMasterID = 	45
--update cre.FinancingSourceMaster set FinancingSourceName = 'ACP II - WF Repo' where FinancingSourceMasterID = 	60
--update cre.FinancingSourceMaster set FinancingSourceName = 'ACP II - MS Repo' where FinancingSourceMasterID = 	61
--update cre.FinancingSourceMaster set FinancingSourceName = 'ACP II - Axos NoN' where FinancingSourceMasterID = 	63
--update cre.FinancingSourceMaster set FinancingSourceName = 'ACP II - Customer NoN' where FinancingSourceMasterID = 	65
--update cre.FinancingSourceMaster set FinancingSourceName = 'ACP II TRS, LLC' where FinancingSourceMasterID = 	70
--update cre.FinancingSourceMaster set FinancingSourceName = 'ACP I - Note Repo' where FinancingSourceMasterID = 	41
--update cre.FinancingSourceMaster set FinancingSourceName = 'ACP I - O/S Note Repo' where FinancingSourceMasterID = 	59


--go


--Update dw.notebi set dw.notebi.FinancingSourcebi = a.FinancingSourceName_New
--from(
--	select noteid,FinancingSourceID,FinancingSourcebi ,f.FinancingSourceName as FinancingSourceName_New
--	from dw.notebi n
--	left join cre.FinancingSourceMaster f on f.FinancingSourceMasterID = n.FinancingSourceID
--)a
--where dw.notebi.NoteID = a.NoteID and dw.notebi.FinancingSourceID = a.FinancingSourceID