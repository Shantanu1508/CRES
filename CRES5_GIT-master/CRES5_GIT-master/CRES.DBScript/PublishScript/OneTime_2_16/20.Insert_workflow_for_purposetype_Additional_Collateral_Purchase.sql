
--Select * from core.lookup where parentid = 50
--Select * from CRE.WFStatusPurposeMapping where PurposeTypeId=317

if not exists(select 1 from CRE.WFStatusPurposeMapping where PurposeTypeId=317)
begin
	INSERT INTO  CRE.WFStatusPurposeMapping(WFStatusMasterID,PurposeTypeId,OrderIndex,IsEnable)
	Select 
	WFStatusMasterID,
	317 as PurposeTypeId,
	(
	Case 
	when StatusName = 'Projected' then 10
	when StatusName = 'Under Review' then 20
	when StatusName = '1st Approval' then 30
	when StatusName = '2nd Approval' then 40
	when StatusName = 'Completed' then 50
	else 0
	end
	) as OrderIndex,
	1
	from CRE.WFStatusMaster
	where StatusName in ('Projected','Under Review','1st Approval','2nd Approval','Completed')
end

